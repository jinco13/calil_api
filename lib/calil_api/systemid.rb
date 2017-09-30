module CalilApi
  class Systemid
    attr_reader :id, :status, :url, :libkey, :total, :available
    STATUS_AVAILABLE = "貸出可"

    def initialize(id, status, url, libkey)
      @id = id
      @status = status
      @url = url
      @libkey = libkey
      @total = libkey.size
      load_libkey(libkey)
    end

    def available?
      available > 0
    end

    def load_libkey(libkey)
      @available = 0
      libkey.each do |key,val|
        @available += 1 if val == STATUS_AVAILABLE
      end if libkey != nil
    end

  end
end
