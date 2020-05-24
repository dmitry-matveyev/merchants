FROM ruby:2.7.1-alpine3.11 as base

RUN apk add --no-cache --virtual .build-deps \
    gcc \
    git \
    g++ \
    linux-headers \
    make \
    musl-dev \
    postgresql-dev
RUN apk add --no-cache \
    nano \
    postgresql-client \
    libpq \
    nodejs \
    yarn \
    tzdata

WORKDIR /app

ADD Gemfile* ./

RUN gem install bundler -v 2.1.4

FROM base as dev
ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV
RUN bundle install --jobs=3
RUN apk del .build-deps
ADD . .
