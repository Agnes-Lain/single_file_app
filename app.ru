# frozen_string_literal: true
require 'bundler/inline'

gemfile(true) do
  source 'https://rubygems.org'

  git_source(:github) { |repo| "https://github.com/#{repo}.git" }

  gem 'rails'
  gem 'sqlite3'
end

require 'rails/all'
database = 'development.sqlite3'

ENV['DATABASE_URL'] = "sqlite3:#{database}"
ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: database)
ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Schema.define do
  create_table :posts, force: true do |t|
  end

  create_table :comments, force: true do |t|
    t.integer :post_id
  end
end


class App < Rails::Application
  config.root = __dir__
  config.consider_all_requests_local = true
  config.secret_key_base = 'i_am_a_secret'
  config.active_storage.service_configurations = { 'local' => { 'service' => 'Disk', 'root' => './storage' } }

  routes.append do
    root to: 'welcome#index'
  end
end

class WelcomeController < ActionController::Base
  def index
    render inline: 'Hi!'
  end
end

App.initialize!

run App