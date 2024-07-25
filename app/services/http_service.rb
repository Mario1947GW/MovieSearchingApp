class HttpService
  require 'net/http'

  def initialize; end

  def send_request(uri)
    post_url = URI.parse(uri)
    http = Net::HTTP.new(post_url.host, post_url.port)
    http.use_ssl = true
    req = Net::HTTP::Get.new(post_url)
    JSON.parse(http.request(req).body)
  end
end
