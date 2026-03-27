# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.3.0
FROM ruby:${RUBY_VERSION}-slim

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development test" \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH="/usr/local/bundle" \
    RAILS_SERVE_STATIC_FILES=true \
    RAILS_LOG_TO_STDOUT=true

WORKDIR /rails

# Dependências de sistema (SQLite + libvips para Active Storage + Node para ExecJS)
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      build-essential \
      libsqlite3-dev \
      libvips \
      curl \
      nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf "${BUNDLE_PATH}/ruby/*/cache"

# Copia o restante da aplicação
COPY . .

# Pré-compila bootsnap
RUN bundle exec bootsnap precompile app/ lib/

# Pré-compila assets (remova se não usar Sprockets)
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Usuário não-root
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

EXPOSE 3000
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]