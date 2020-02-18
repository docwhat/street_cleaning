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

gem 'activesupport', '~> 6.0.0'
gem 'chronic', '~> 0.10.2'
gem 'icalendar', '~> 2.3'
gem 'tzinfo'

group :development do
  gem 'rubocop', '~> 0.80.0'
end
