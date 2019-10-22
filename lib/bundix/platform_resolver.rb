# typed: strong
# frozen_string_literal: true
require('bundix')

module Bundix
  # PlatformResolver resolves a list of "platform names", such as `['ruby_26']`
  # to a list of platform specifications, such as
  # `[{'engine'=>'ruby','version'=>'2.6'},{'engine'=>'rbx','version'=>'2.6'}]
  module PlatformResolver
    extend(T::Sig)

    class << self
      extend(T::Sig)

      sig { params(platform_names: T::Array[String]).returns(T::Array[T_PLATFORM_SPEC]) }
      def resolve(platform_names)
        platforms = T.let(
          platform_names.map { |n| PLATFORM_MAPPING[n.to_s] },
          T::Array[T.nilable(T::Array[T_PLATFORM_SPEC])],
        )

        platforms = T.let(platforms.compact, T::Array[T::Array[T_PLATFORM_SPEC]])
        platforms = T.let(platforms.flatten, T::Array[T_PLATFORM_SPEC])

        platforms
      end

      private

      sig { returns(T::Hash[String, T::Array[T_PLATFORM_SPEC]]) }
      def build_platform_mapping
        map = T.let({}, T::Hash[String, T::Array[T_PLATFORM_SPEC]])
        engines = T.let({
          'ruby' => [{ 'engine' => 'ruby' }, { 'engine' => 'rbx' }, { 'engine' => 'maglev' }],
          'mri' => [{ 'engine' => 'ruby' }, { 'engine' => 'maglev' }],
          'rbx' => [{ 'engine' => 'rbx' }],
          'jruby' => [{ 'engine' => 'jruby' }],
          'mswin' => [{ 'engine' => 'mswin' }],
          'mswin64' => [{ 'engine' => 'mswin64' }],
          'mingw' => [{ 'engine' => 'mingw' }],
          'truffleruby' => [{ 'engine' => 'ruby' }],
          'x64_mingw' => [{ 'engine' => 'mingw' }],
        }, T::Hash[String, T::Array[{ 'engine' => String }]])
        engines.each do |name, list|
          # { 'ruby' => [{'engine'=>'ruby'},...]}
          map[name] = list
          %w(1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6).each do |version|
            versioned_platforms = list.map do |platform| # {'engine'=>'ruby'}
              platform.merge('version' => version) # {'engine'=>'ruby','version'=>'2.6'}
            end
            # {'ruby_26'=>[{'engine'=>'ruby','version'=>'2.6'},...],...}
            map["#{name}_#{version.sub(/[.]/, '')}"] = versioned_platforms
          end
        end

        map
      end
    end

    PLATFORM_MAPPING = T.let(build_platform_mapping, T::Hash[String, T::Array[T_PLATFORM_SPEC]])
    private_constant(:PLATFORM_MAPPING)
  end
end
