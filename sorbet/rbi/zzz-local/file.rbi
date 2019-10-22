# typed: strong

class File
  class << self
    sig { params(path: String, mode: String, block: T.proc.params(arg0: File).void).void }
    def open(path, mode, &block); end
  end
end
