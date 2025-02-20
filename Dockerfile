ARG ruby_version=3.4
ARG base_image=ghcr.io/alphagov/govuk-ruby-base:$ruby_version
ARG builder_image=ghcr.io/alphagov/govuk-ruby-builder:$ruby_version


FROM --platform=$TARGETPLATFORM $builder_image AS builder

WORKDIR $APP_HOME
COPY Gemfile* .ruby-version ./
RUN bundle install
COPY . .
RUN bootsnap precompile --gemfile .

# Set mandatory env vars to allow Rails to boot for asset compilation. These are only set for the
# current build stage.
ENV SECRET_KEY_BASE=none
ENV GOVUK_NOTIFY_API_KEY=none
ENV DISCOVERY_ENGINE_DEFAULT_COLLECTION_NAME=none
ENV PUBLISHING_API_BEARER_TOKEN=none
RUN rails assets:precompile && rm -fr log


FROM --platform=$TARGETPLATFORM $base_image

ENV GOVUK_APP_NAME=search-admin

WORKDIR $APP_HOME
COPY --from=builder $BUNDLE_PATH $BUNDLE_PATH
COPY --from=builder $BOOTSNAP_CACHE_DIR $BOOTSNAP_CACHE_DIR
COPY --from=builder $APP_HOME .

USER app
CMD ["puma"]
