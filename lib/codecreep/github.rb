require 'httparty'

module Codecreep
  class Github
    include HTTParty

    base_uri 'https://api.github.com'
    basic_auth ENV['GH_USER'], ENV['GH_PASS']

    def get_user(username)
      self.class.get("/users/#{username}")
    end

  end
end
