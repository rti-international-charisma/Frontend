FROM ubuntu:22.04 as builder

ARG PROJECT_DIR=/charisma-dart
ARG ENVIRONMENT=stage

ENV PATH=/opt/flutter/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# Prerequisites

RUN apt update && apt install -y curl git unzip xz-utils zip libglu1-mesa openjdk-8-jdk wget
RUN apt-get update
RUN apt-get install -y curl git wget unzip libgconf-2-4 libstdc++6 libglu1-mesa  fonts-droid-fallback lib32stdc++6 psmisc
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get  install -y python3
RUN apt-get clean
# Install flutter

RUN curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_2.5.2-stable.tar.xz | tar -C /opt -xJ


# Enable web capabilities
RUN flutter config --enable-web

RUN flutter doctor -v

# Copy the app files to the container
COPY . /usr/local/bin/app

# Set the working directory to the app files within the container
WORKDIR /usr/local/bin/app
# Get App Dependencies
RUN flutter pub get

# Build the app for the web
RUN flutter build web --dart-define=ENV=$ENVIRONMENT --dart-define=FLUTTER_WEB_MAXIMUM_SURFACES=1 --release


# Document the exposed port
EXPOSE 4040

# Set the server startup script as executable
RUN ["chmod", "+x", "/usr/local/bin/app/server/server.sh"]

# Start the web server
ENTRYPOINT [ "/usr/local/bin/app/server/server.sh" ]


