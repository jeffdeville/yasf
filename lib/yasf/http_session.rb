module Yasf
class HttpSession
  def initialize(url, &block)
    uri = URI.parse(url)
    @base = "#{uri.scheme}://#{uri.hostname}"
    @path_and_query = url.gsub("http://www.trulia.com","")
    @faraday_setup = block if block_given?
  end

  def html
    Faraday::Middleware.register_middleware :capybara => lambda { Yasf::CapybaraFaradayAdapter }
    conn = Faraday.new(:url => @base) do |faraday|
      faraday.use CapybaraFaradayAdapter

      if @faraday_setup
        @faraday_setup.call(faraday)
      else
        faraday.request  :url_encoded             # form-encode POST params
        # faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  :capybara # Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
    conn.get(@path_and_query).body
  end
end
end
