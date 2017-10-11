module CalilApi
  class Book
    attr_reader :isbn, :libraries

    def initialize(data=nil,isbn=nil)
      @libraries = []
      data.each do |sid,prop|
        @isbn = isbn
        @libraries << Systemid.new(sid, prop['status'], prop['reserveurl'], prop['libkey'])
      end if data!=nil
    end

    def reservable?
      libraries.any?{|lib| lib.available? }
    end

    def endpoint
      CalilApi::Configuration::URL_BOOK
    end

    def self.client
      @client ||= CalilApi::Client.new(endpoint)
    end

    def self.search(isbns, systemids, params = {})
      params.merge!({
        isbn: isbns.join(","),
        systemid: systemids.join(",")
      })

      session_id = nil
      continue_status = CalilApi::Configuration::STATUS_LOADING
      retry_count = 0
      result = nil

      CalilApi::Configuration::RETRY_LIMIT.times do |count|
        retry_count = count
        result = CalilApi::Book.book_request(params, session_id)
        continue_status = result["continue"]
        session_id = result["session_id"]
        break if continue_status == CalilApi::Configuration::STATUS_FINISHED

        sleep CalilApi::Configuration::RETRY_WAIT_TIME
      end

      # retry limit error
      raise "ERROR: Retry limit exceeded" if continue_status == CalilApi::Configuration::STATUS_LOADING \
                                              and retry_count == (CalilApi::Configuration::RETRY_LIMIT - 1)

      books = []
      result["books"].each do |isbn,h|
        books << CalilApi::Book.new(result["books"][isbn],isbn)
      end
      books
    end

    private

    def self.book_request(params, session_id=nil)
      params.merge!(session_id: session_id) if session_id
      CalilApi::Book.client.get(params)
    end
  end
end
