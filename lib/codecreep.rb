$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pry'

require 'codecreep/init_db'
require 'codecreep/github'
require 'codecreep/version'
require 'codecreep/user'

USERNAME = ['vsedach', 'eudoxia0', 'whalliburton', 'equus12', 'pwood1284', 
           'jbcrail', 'jb55', 'GGMethos', 'miguelmota', 'augustdaze']


module Codecreep
  class App
    def initialize
      @github = Github.new
      @user = User.new
    end

    def get_user(username)
      response = @github.get_user(username)
      user = ''
      if response['message'].nil?
        user = @user.create_user(response)
      else
        user = "You have reached your API limit for Github. This occurred on 
                the user: #{username}. This name and any usernames given 
                afterward will not be included in the search."
      end
      user
    end

    def fetch(username_array)
      fetch_array = []
      username_array.each do |n|
        response = get_user(n)
        if response.instance_of?(User)
          fetch_array << response
        else
          fetch_array << response
          break
        end
      end
      fetch_array
    end

    def print_fetch_users(fetch_array)
      fetch_array.each do |u|
        if u.instance_of?(User)
          puts "Name: #{u.name}"
          puts "Follower Count: #{u.follower_count}"
          puts "Friend Count: #{u.following_count}"
          puts "Repo Count: #{u.repo_count}"
          puts "Company: #{u.company}"
          puts "Homepage: #{u.homepage}"
          puts
          puts '-----------------------------------------'
          puts
        else
          puts u
        end
      end
    end

    def print_popular_analysis
      fetch_array = User.order('follower_count DESC').limit(10)
      fetch_array.each do |u|
        puts "Name: #{u.name}"
        puts "Homepage: #{u.homepage}"
        puts "Follower Count: #{u.follower_count}"
        puts
        puts '-----------------------------------------'
        puts
      end
    end

    def print_friendly_analysis
      fetch_array = User.order('following_count DESC').limit(10)
      fetch_array.each do |u|
        puts "Name: #{u.name}"
        puts "Homepage: #{u.homepage}"
        puts "Friend Count: #{u.following_count}"
        puts
        puts '-----------------------------------------'
        puts
      end
    end

    def print_networked_analysis
      fetch_array = User.all.sort_by{|n| n.follower_count + 
                    n.following_count}.reverse.first(10)
      fetch_array.each do |u|
        puts "Name: #{u.name}"
        puts "Homepage: #{u.homepage}"
        puts "Networking Count: #{u.following_count + u.follower_count}"
        puts
        puts '-----------------------------------------'
        puts
      end
    end

    def welcome_user
      puts 'Would you like to fetch or analyze?'
      answer = gets.chomp
      while answer.downcase != 'fetch' && answer.downcase != 'analyze'
        puts 'Please enter a valid selection.'
        answer = gets.chomp
      end

      if answer.downcase == 'fetch'
        puts 'Enter a comma separated string of usernames to fetch:'
        username_str = gets.chomp
        username_array = username_str.split(',').map{|s| s.strip}
        fetch_array = fetch(username_array)
        puts
        print_fetch_users(fetch_array)
      else
        puts
        puts 'Most Popular Category:'
        puts
        print_popular_analysis
        puts 'Most Friendly Catgory:'
        puts
        print_friendly_analysis
        puts 'Most Networked Category'
        puts
        print_networked_analysis
      end

    end
  end
end

app = Codecreep::App.new
app.welcome_user
