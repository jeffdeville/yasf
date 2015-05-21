require 'active_support/all'
require 'capybara/poltergeist'
require 'faraday'
require 'yasf/version'
require 'yasf/web_socket'

module Yasf
  autoload :Crawler,        'yasf/crawler'
  autoload :DSL,            'yasf/dsl'
  autoload :Parser,         'yasf/parser'
  autoload :Parseable,      'yasf/parseable'
  autoload :Session,        'yasf/session'
  autoload :HttpSession,    'yasf/http_session'
  autoload :CapybaraFaradayAdapter, 'yasf/capybara_faraday_adapter'
  autoload :Configuration,  'yasf/configuration'

  Faraday::Adapter.register_middleware(
    :capybara => lambda { Yasf::CapybaraFaradayAdapter }
  )
  class << self

    def configure
      yield config if block_given?
    end

    def config
      @config ||= Configuration.new
    end

    def crawl(&block)
      klass = Class.new
      klass.send(:include, Yasf::Crawler)
      klass.new.crawl(&block)
    end

  end
end
