require 'faraday'

module Yasf
  class CapybaraFaradayAdapter < Faraday::Adapter
    def call(env)
      super
      setup_capybara_default_driver
      session = Capybara::Session.new(Capybara.default_driver)
      session.visit env[:url].to_s
      save_response(env, session.status_code, session.html)
      @app.call env
    end

    def setup_capybara_default_driver
      Capybara.register_driver Yasf.config.capybara_driver do |app|
        Capybara::Poltergeist::Driver.new(
          app, Yasf.config.capybara_driver_options
        )
      end if Yasf.config.capybara_driver_options
      Capybara.default_driver = Yasf.config.capybara_driver
    end
  end

end
