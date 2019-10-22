# typed: strong

module Gem
  class Specification
    sig { returns(String) }
    def full_name; end

    sig { returns(String) }
    def platform; end
  end

  class SourceList
    class << self
      sig { params(remotes: T::Array[String]).returns(SourceList) }
      def from(remotes); end
    end
  end

  class Dependency
    sig { returns(String) }
    def name; end
  end

  class Platform
    class << self
      sig { params(platform: String).returns(T::Boolean) }
      def match(platform); end
    end
  end

  class SpecFetcher
    sig do
      params(dep: Gem::Dependency, matching_platform: String).returns(
        [T::Array[[Gem::Specification, Gem::Source]], T::Array[Gem::SourceFetchProblem]]
      )
    end
    def spec_for_dependency(dep, matching_platform = T.unsafe(nil)); end
  end
end
