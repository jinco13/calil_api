module CalilApi
  class Systemid
    attr_reader :id, :status, :url, :libkey, :total, :available
    def initialize(id, status, url, libkey)
      @id = id
      @status = status
      @url = url
      load_libkey(libkey)
    end

    def load_libkey(libkey)
      @total = libkey.size
      @available = 0
      libkey.each do |k2,v2|
        @available += 1 if v2 == "貸出可"
      end if libkey != nil
    end
  end
end
