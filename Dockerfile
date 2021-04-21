FROM ubuntu:20.10 as builder
ARG PROJECT_DIR=/charisma-dart
ENV PATH=/opt/flutter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# Prerequisites
RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
# Install flutter
RUN curl -L https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_2.0.3-stable.tar.xz | tar -C /opt -xJ
WORKDIR ${PROJECT_DIR}
COPY ./ ./
# Enable web capabilities
RUN flutter config --enable-web
RUN flutter pub get
RUN flutter pub global activate webdev
RUN flutter build web --dart-define=API_BASEURL=http://0.0.0.0:8080

