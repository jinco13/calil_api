module CalilApi
  class Configuration
    APPKEY = "appkey"
    DEFAULT_FORMAT = "json"
    URL_BOOK = "https://api.calil.jp/check"
    URL_LIBRARY = "https://api.calil.jp/library"

    RETRY_LIMIT = 15
    # http://calil.jp/doc/api_ref.html
    # ポーリングは、かならず2秒以上の間隔をあけて呼び出してください
    RETRY_WAIT_TIME = 2

    STATUS_LOADING = 1
    STATUS_FINISHED = 0
  end
end
