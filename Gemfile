# frozen_string_literal: true

# Helper function to get the version from the Dockerfile
def detect_ruby_version
  if ENV.key? 'RUBY_VERSION'
    ENV['RUBY_VERSION']
  elsif File.exist? 'Dockerfile'
    version = open('Dockerfile')
              .read
              .match(/^FROM ruby:([0-9.]+)/) { |matched| matched[1] }
    "~> #{version}"
  end
end

## Main part of the Gemfile
source 'https://rubygems.org/'

ruby detect_ruby_version

gem 'chronic', '~> 0.10.2'
gem 'icalendar', '~> 2.3'
gem 'tzinfo'

group :development do
  gem 'reek'
  gem 'rubocop', '~> 1.3.0'
  gem 'solargraph'
end
