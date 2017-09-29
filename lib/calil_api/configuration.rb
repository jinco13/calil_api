module CalilApi
  class Configuration
    APPKEY = "appkey"
    DEFAULT_FORMAT = "json"
    URL_BOOK = "https://api.calil.jp/check"
    URL_LIBRARY = "https://api.calil.jp/library"

    RETRY_LIMIT = 10
    RETRY_WAIT_TIME = 5

    STATUS_LOADING = 1
    STATUS_FINISHED = 0
  end
end
