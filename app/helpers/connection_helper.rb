module ConnectionHelper
  class Connection

    def initialize
      @base_url = ENV['PROXY_HOST'] || 'http://localhost/'
      unless @base_url.end_with?('/')
        @base_url = @base_url + '/'
      end
    end

    def get(path, params, headers)
      url = "#{@base_url}#{path}?#{params.to_query}"
      Curl.get(url) { |curl| curl_data(add_headers(curl, headers)) }
    end

    def post(path, body, headers)
      url = @base_url + path
      data = body.to_json
      Curl.post(url, data) { |curl| curl_data(add_headers(curl, headers))}
    end

    def put(path, body, headers)
      url = @base_url + path
      data = body.to_json
      Curl.put(url, data) { |curl| curl_data(add_headers(curl, headers)) }
    end

    def delete(path, params, headers)
      url = "#{@base_url}#{path}?#{params.to_query}"
      Curl.delete(url) { |curl| curl_data(add_headers(curl, headers)) }
    end

    private

    def add_headers(curl, headers = {})
      headers.each {|key, value| curl.headers[key] = value }
      curl
    end

    def curl_data(curl)
      curl.follow_location = true
      curl.verbose = ENV['RAILS_ENV'].downcase != 'production'
      curl
    end
  end
end