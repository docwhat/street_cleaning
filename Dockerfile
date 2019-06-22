# Docker multi-stage build file
# Requires docker 17.05 or newer.
FROM ruby:2.6 AS ruby

##
##
FROM ruby AS builder

WORKDIR /app

COPY Gemfile* ./
RUN bundle install --frozen --deployment

COPY *.rb ./
RUN bundle exec rubocop --verbose-version
RUN bundle exec rubocop --format=tap
RUN bundle exec ruby street_cleaning.rb

##
##
FROM nginx:alpine AS release

EXPOSE 80

HEALTHCHECK --interval=5m --timeout=5s CMD wget http://localhost/nginx-health -q -O - > /dev/null 2>&1

# A configuration for serving just our calendar.ics
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Our streetcleaning ics file.
COPY --from=builder /app/calendar.ics /usr/share/nginx/html/

# Remove default index.html file.
RUN rm -f /usr/share/nginx/html/index.html

# vim: ft=dockerfile :
