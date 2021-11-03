# syntax=docker/dockerfile:1.3
ARG RUST_VERSION=1.56.1
FROM rust:${RUST_VERSION} as build
COPY . .
RUN --mount=type=cache,target=$CARGO_HOME/registry --mount=type=cache,target=target \
    cargo test
RUN --mount=type=cache,target=$CARGO_HOME/registry --mount=type=cache,target=target \
    cargo build --release && cp target/release/service-foo /service-foo

FROM rust:${RUST_VERSION} as main
WORKDIR /opt/srv
COPY --from=build service-foo service-foo
COPY Rocket.toml Rocket.toml
ENTRYPOINT [ "./service-foo" ]