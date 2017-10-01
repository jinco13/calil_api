module CalilApi
  class Library
    def initialize(hash=nil)
      atr = %w(systemid systemname libkey libid short formal url_pc address pref city post tel geocode category image distance)
      hash.each do |k,v|
        self.class.send(:define_method, k){ v } if atr.include?(k)
      end if hash != nil
    end

    def endpoint
      CalilApi::Configuration::URL_LIBRARY
    end

    def client
      @client ||= CalilApi::Client.new(endpoint)
    end

    def search(params)
      libraries = []
      result = client.get(params)
      result.each do |hash|
        libraries << CalilApi::Library.new(hash)
      end
      libraries
    end
  end
end
