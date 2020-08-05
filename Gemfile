# frozen_string_literal: true

def detect_ruby_version
  if ENV.key? 'RUBY_VERSION'
    ENV['RUBY_VERSION']
  elsif File.exist? 'Dockerfile'
    '~> ' + open('Dockerfile')
            .read
            .match(/^FROM ruby:([0-9.]+)/) { |matched| matched[1] }
  end
end

source 'https://rubygems.org/'

ruby detect_ruby_version

gem 'chronic', '~> 0.10.2'
gem 'icalendar', '~> 2.3'
gem 'tzinfo'

group :development do
  gem 'reek'
  gem 'rubocop', '~> 0.89.0'
  gem 'solargraph'
end
