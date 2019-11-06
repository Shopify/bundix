# typed: strong

class OptionParser
  sig { params(banner: String, width: Integer, indent: String, block: T.proc.params(arg0: OptionParser).void).void }
  def initialize(banner = nil, width = 32, indent = ' ' * 4, &block); end

  # This is a reaaaaaaaallly extreme cheat.
  # OptionParser has a crazy amount of variability in the API, but we're using
  # an extremely small part of this surface area.
  sig do
    params(
      opts: String,
      block: T.proc.params(arg0: String).void,
    ).void
  end
  def on(*opts, &block); end

  sig { params(argv: T::Array[String], into: T.nilable(T::Hash[String, T.untyped])).void }
  def parse!(argv = nil, into: nil); end

  sig { returns(String) }
  def help; end
end
