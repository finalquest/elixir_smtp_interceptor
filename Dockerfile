ARG ELIXIR_VERSION=1.16.0
ARG OTP_VERSION=24.3.4.15
ARG DEBIAN_VERSION=bullseye-20231009-slim
ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-debian-${DEBIAN_VERSION}"
ARG RUNNER_IMAGE="debian:${DEBIAN_VERSION}"

FROM ${BUILDER_IMAGE} as builder
# install build dependencies
RUN apt-get update -y && apt-get install -y build-essential git nodejs npm curl \
  && apt-get clean && rm -f /var/lib/apt/lists/*_*
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs
# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
  mix local.rebar --force
ENV PATH=~/.mix:$PATH
# set build ENV
ENV MIX_ENV="prod"
# install mix dependencies
COPY mix.exs ./
RUN mix deps.get
RUN mkdir config
# copy compile-time config files before we compile dependencies

# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile
COPY priv priv
COPY lib lib
COPY assets assets
WORKDIR assets
RUN node --version
RUN npm i -g yarn; yarn set version stable
RUN yarn install
WORKDIR ../
# compile assets
RUN mix assets.deploy
# Compile the release
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/
COPY rel rel
RUN mix release



