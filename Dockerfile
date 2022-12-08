FROM ruby:3.1.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs postgresql-client cron
RUN mkdir /api

WORKDIR /api

ADD Gemfile /api/Gemfile
ADD Gemfile.lock /api/Gemfile.lock
RUN gem update --system
RUN bundle install

COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 4567