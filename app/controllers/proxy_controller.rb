class ProxyController < ApplicationController

  def delete
    headers = extract_headers
    parameters = extract_parameters
    connection = connection_helper.delete(params[:proxy_path], parameters, headers)
    set_headers(connection)
    render json: connection.body, status: connection.response_code
  end

  def put
    headers = extract_headers
    parameters = extract_parameters
    connection = connection_helper.put(params[:proxy_path], parameters, headers)
    set_headers(connection)
    render json: connection.body, status: connection.response_code
  end

  def get
    headers = extract_headers
    parameters = extract_parameters
    connection = connection_helper.get(params[:proxy_path], parameters, headers)
    set_headers(connection)
    render json: connection.body, status: connection.response_code
  end

  def post
    headers = extract_headers
    parameters = extract_parameters
    connection = connection_helper.post(params[:proxy_path], parameters, headers)
    set_headers(connection)
    render json: connection.body, status: connection.response_code
  end

  private

  def connection_helper
    ConnectionHelper::Connection.new
  end

  def extract_headers
    request.headers
                  .to_h
                  .keys
                  .select { |key| key.start_with?("HTTP_") }
                  .reject { |val| %w[HTTP_HOST HTTP_VERSION].include?(val) }
                  .map { |key| {key.sub(/HTTP_/, '') => request.headers[key]} }
                  .inject { |total, value| total.merge(value) }
  end

  def extract_parameters
    params.to_unsafe_h.reject { |key, _value| %w[controller action proxy_path].include?(key) }
  end

  def set_headers(curb)
    curb.header_str
        .scan(/\r\n(.+?)\r\n/)
        .map{ |val| {val[0].split(': ')[0] => val[0].split(': ')[1]} }
        .inject{ |sum, val| sum.merge(val) }
        .reject{ |key, _val| %w[Status X-Cascade X-Runtime Transfer-Encoding].include?(key) }
        .each { |key, val| response.set_header(key, val) }
  end

end
