# typed: strong
# frozen_string_literal: true

module Bundix
  class Nixer
    extend(T::Sig)

    # Sorbet doesn't support recursive types.
    # However, since we know our gemsets only have a relatively low maximum
    # depth, we can fully model our data.
    #
    # T_SER0 contains the serializable scalars
    # T_SER1 through T_SER3 allow nesting via string-keyed hashes or arrays up to
    #   N (1,2,3) elements deep.
    # T_SERIALIZABLE allowed an additional level of nesting -- 4, which is the
    # maximum required to express a gemset.
    #
    # If we introduce additional nesting, just add another constant here.
    #
    # { gemname =     { source =    { remotes =    [       "https://..."]; }; }; }
    # Hash[String,    Hash[String,  Hash[String,   Array[  String]]]]
    # T_SERIALIZABLE  SER3          SER2           SER1    SER0
    T_SERIALIZABLE = T.type_alias do
      T.any(T::Hash[String, T_SER3], T::Array[T_SER3], T_SER0)
    end

    T_SER0 = T.type_alias { T.any(String, Symbol, Pathname, T::Boolean) }
    T_SER1 = T.type_alias { T.any(T::Hash[String, T_SER0], T::Array[T_SER0], T_SER0) }
    T_SER2 = T.type_alias { T.any(T::Hash[String, T_SER1], T::Array[T_SER1], T_SER0) }
    T_SER3 = T.type_alias { T.any(T::Hash[String, T_SER2], T::Array[T_SER2], T_SER0) }
    private_constant(:T_SER0)
    private_constant(:T_SER1)
    private_constant(:T_SER2)
    private_constant(:T_SER3)

    class << self
      extend(T::Sig)

      sig { params(obj: T_SERIALIZABLE).returns(String) }
      def serialize(obj)
        new(obj).serialize
      end

      sig { params(left: T_SERIALIZABLE, right: T_SERIALIZABLE).returns(Integer) }
      def order(left, right)
        if left.class == right.class
          unless (cmp = compare(left, right)).nil?
            return(cmp)
          end
        end

        class_order(left, right)
      end

      sig { params(left: T_SERIALIZABLE, right: T_SERIALIZABLE).returns(T.nilable(Integer)) }
      def compare(left, right)
        if left.is_a?(Hash) && right.is_a?(Hash)
          larray = left.to_a.sort { |l, r| ::Bundix::Nixer.order(l, r) }
          rarray = right.to_a.sort { |l, r| ::Bundix::Nixer.order(l, r) }
          larray <=> rarray
        else
          left <=> right
        end
      end

      private

      sig { params(left: T_SERIALIZABLE, right: T_SERIALIZABLE).returns(Integer) }
      def class_order(left, right)
        lcn = left.class.name
        rcn = right.class.name
        if lcn && rcn
          T.must(lcn <=> rcn)
        else
          raise("Cannot convert to nix: #{left.inspect}")
        end
      end
    end

    sig { returns(String) }
    def serialize
      case (o = T.let(obj, T_SERIALIZABLE))
      when ::Hash
        nixify_set(o)
      when ::Array
        nixify_list(o)
      when ::String
        o.dump
      when ::Symbol
        o.to_s.dump
      when ::Pathname
        str = o.to_s
        if %r{/} !~ str
          './' + str
        else
          str
        end
      when true, false
        o.to_s
      else
        T.absurd(o)
      end
    end

    private

    sig { params(list: T::Array[T_SERIALIZABLE]).returns(String) }
    def nixify_list(list)
      out = +'['
      list
        .sort { |l, r| Nixer.order(l, r) }
        .each_with_index { |o, n| out << (n > 0 ? ' ' : '') << sub(o) }
      out << ']'
    end

    sig { params(set: T::Hash[String, T_SERIALIZABLE]).returns(String) }
    def nixify_set(set)
      out = +"{\n"
      set
        .sort_by { |k, _| k.to_s.downcase }
        .each { |(k, v)| out << indent << serialize_key(k) << ' = ' << sub(v, 2) << ";\n" }
      out << outdent << '}'
    end

    sig { returns(T_SERIALIZABLE) }
    attr_reader(:obj)

    sig { returns(Integer) }
    attr_reader(:level)

    sig { params(obj: T_SERIALIZABLE, level: Integer).void }
    def initialize(obj, level = 0)
      @obj = T.let(obj, T_SERIALIZABLE)
      @level = T.let(level, Integer)
    end

    sig { returns(String) }
    def indent
      ' ' * (level + 2)
    end

    sig { returns(String) }
    def outdent
      ' ' * level
    end

    sig { params(obj: T_SERIALIZABLE, indent: Integer).returns(String) }
    def sub(obj, indent = 0)
      self.class.new(obj, level + indent).serialize
    end

    sig { params(k: String).returns(String) }
    def serialize_key(k)
      if k.to_s =~ /^[a-zA-Z_-]+[a-zA-Z0-9_-]*$/
        k.to_s
      else
        sub(k, 2)
      end
    end
  end
end
