# typed: strong

module Bundler
  sig {returns(Pathname)}
  def self.root(); end

  # Of course these are not really the full signatures, but it is how we're
  # using it.
  sig { params(sym: Symbol, val: T.nilable(Pathname)).void }
  def self.instance_variable_set(sym, val); end
  sig { params(sym: Symbol).returns(T.nilable(Pathname)) }
  def self.instance_variable_get(sym); end
end

class Bundler::LazySpecification
  sig {returns(T.nilable(String))}
  def full_name(); end

  sig {returns(T.nilable(String))}
  def name(); end

  sig {returns(T.nilable(String))}
  def platform(); end

  sig {returns(T.nilable(Bundler::Source))}
  def source(); end

  sig {returns(Gem::Version)}
  def version(); end

  sig {returns(T::Array[Gem::Dependency])}
  def dependencies(); end
end

class Bundler::Source
  sig {returns(T::Boolean)}
  def path?(); end
end

class Bundler::Dependency
  sig { returns(T::Array[Symbol]) }
  def groups; end

  # I think...
  sig { returns(T::Array[String]) }
  def platforms; end
end

class Bundler::Source::Git < Bundler::Source::Path
  sig {returns(T::Hash[String, T.untyped])}
  def options(); end

  sig {returns(T.nilable(T::Boolean))}
  def submodules(); end
end

class Bundler::Source::Rubygems < Bundler::Source
  sig {returns(T::Array[T.any(Pathname, String)])}
  def caches(); end

  sig {returns(T::Array[URI::Generic])}
  def remotes(); end
end

class Bundler::LockfileParser
  sig {returns(T::Array[Bundler::LazySpecification])}
  def specs; end

  sig {returns(Gem::Version)}
  def bundler_version; end

  sig {returns(T::Hash[String, Bundler::Dependency])}
  def dependencies(); end
end

class Bundler::Definition
  sig do
    params(gemfile: String, lockfile: String, unlock: T::Boolean).returns(Bundler::Definition)
  end
  def self.build(gemfile, lockfile, unlock); end

  sig {returns(T::Array[Bundler::Dependency])}
  def dependencies(); end
end
