require 'active_support/core_ext'
require 'active_support/concern'

require "yasf/version"

module Yasf
  autoload :Crawler, 'yasf/crawler'
  autoload :Parser, 'yasf/parser'
  autoload :Parseable, 'yasf/parseable'
  autoload :DSL,  'yasf/dsl'


  class << self
    def crawl(&block)
      klass = Class.new
      klass.send(:include, Yasf::Crawler)
      klass.new.crawl(&block)
    end
  end
end
