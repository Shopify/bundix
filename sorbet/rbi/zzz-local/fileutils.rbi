# typed: strong

module FileUtils
  class << self
    sig do
      params(
        mode: T.any(Integer, String),
        list: T.any(String, T::Array[String]),
        noop: T.nilable(T::Boolean),
        verbose: T.nilable(T::Boolean),
      ).void
    end
    def chmod(mode, list, noop: nil, verbose: nil); end

    sig do
      params(
        src: String,
        dest: String,
        force: T::Boolean,
        noop: T::Boolean,
        verbose: T::Boolean,
        secure: T::Boolean,
      ).void
    end
    def mv(src, dest, force: T.unsafe(nil), noop: T.unsafe(nil), verbose: T.unsafe(nil), secure: T.unsafe(nil)); end
  end
end

