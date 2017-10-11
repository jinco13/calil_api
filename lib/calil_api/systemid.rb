module CalilApi
  class Systemid
    attr_reader :id, :status, :url, :libkey, :total, :available
    
    STATUS_AVAILABLE = "貸出可"
    STATUS_ONRENTAL = "貸出中"

    def initialize(id, status, url, libkey)
      @id = id
      @status = status
      @url = url
      @libkey = libkey
      @total = 0
      if libkey != nil
        @total = libkey.size
        load_libkey(libkey)
      end
    end

    def available?
      available > 0
    end

    def load_libkey(libs)
      @available = 0
      libs.each do |key,val|
        @available += 1 if val == STATUS_AVAILABLE
      end
    end

  end
end
