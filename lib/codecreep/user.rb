module Codecreep
  class User < ActiveRecord::Base
    def create_user(response)
      user = User.find_or_create_by(name: response['login'])
      user.homepage = response['url']
      user.company = response['company']
      user.follower_count = response['followers']
      user.following_count = response['following']
      user.repo_count = response['public_repos']
      user.save!
      user
    end
  end
end