module CalilApi
  class Book
    attr_reader :isbn, :systemid

    def initialize(data=nil,isbn=nil)
      data.each do |sid,prop|
        @isbn = isbn
        @systemid = Systemid.new(sid, prop['status'], prop['reserveurl'], prop['libkey'])
      end if data!=nil
    end

    def endpoint
      CalilApi::Configuration::URL_BOOK
    end

    def client
      @client ||= CalilApi::Client.new(endpoint)
    end

    def search(isbns, systemids, params = {})
      params.merge!({
        isbn: isbns.join(","),
        systemid: systemids.join(","),
        format: CalilApi::Configuration::DEFAULT_FORMAT
      })

      session_id = nil
      continue_status = CalilApi::Configuration::STATUS_LOADING
      retry_count = 0
      result = nil

      CalilApi::Configuration::RETRY_LIMIT.times do |count|
        retry_count = count
        result = book_request(params, session_id)
        continue_status = result["continue"]
        session_id = result["session_id"]
        break if continue_status == CalilApi::Configuration::STATUS_FINISHED

        sleep CalilApi::Configuration::RETRY_WAIT_TIME
      end

      # retry limit error
      raise "ERROR: Retry limit exceeded" if continue_status == CalilApi::Configuration::STATUS_LOADING \
                                              && retry_count == (CalilApi::Configuration::RETRY_LIMIT - 1)

      books = []
      result["books"].each do |isbn,h|
        books << CalilApi::Book.new(result["books"][isbn],isbn)
      end
      books
    end

    def book_request(params, session_id=nil)
      params.merge!(session_id: session_id) if session_id
      client.get(params)
    end
  end
end
