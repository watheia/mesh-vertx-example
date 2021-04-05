FROM openjdk:11-jdk-slim as builder
RUN apt-get update && apt-get upgrade -y

WORKDIR /wa
ADD . .
RUN ./gradlew assemble --no-daemon --no-build-cache --no-parallel

FROM openjdk:11-slim
RUN apt-get update && apt-get upgrade -y

ARG app_version=0.0.1-SNAPSHOT
COPY --from=builder /wa/build/distributions/vertx-mesh-web-shadow-${app_version}.tar /tmp/vertx-mesh-web.tar

WORKDIR /tmp
RUN tar -xf vertx-mesh-web.tar && \
  mv vertx-mesh-web-shadow-0.0.1-SNAPSHOT/ /wa/ && \
  rm vertx-mesh-web.tar

EXPOSE 5000
CMD [ "/wa/bin/vertx-mesh-web" ]