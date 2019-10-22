# typed: strong

module Net
  class HTTP
    class << self
      sig do
        params(
          address: String, arg: T.untyped,
          block: T.proc.params(arg0: HTTP).void
        ).void
      end
      def start(address, *arg, &block); end
    end

    sig do
      params(
        req: HTTPRequest,
        body: String,
        block: T.proc.params(arg0: HTTPResponse).void
      ).void
    end
    def request(req, body = T.unsafe(nil), &block); end
  end

  class HTTPRequest
    sig { returns(URI::Generic) }
    def uri; end

    sig { params(user: T.nilable(String), password: T.nilable(String)).void }
    def basic_auth(user, password); end
  end

  class HTTPResponse
    sig { returns(Integer) }
    def code; end

    sig { params(dest: IO, block: T.proc.params(arg0: String).void).void }
    def read_body(dest = T.unsafe(nil), &block); end
  end
end
