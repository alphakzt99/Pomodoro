# Use Ubuntu as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$PATH:/opt/flutter/bin:/opt/android-sdk/platform-tools:/opt/android-sdk/cmdline-tools/latest/bin"

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Android SDK command-line tools
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools \
    && wget -O commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip \
    && unzip commandlinetools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools \
    && mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rm commandlinetools.zip

# Accept Android SDK licenses and install required components
RUN yes | sdkmanager --licenses \
    && sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.3"

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME} \
    && flutter doctor

# Set working directory
WORKDIR /app

# Copy your Flutter project into the container
COPY . .

# Get Flutter dependencies
RUN flutter pub get


CMD ["flutter", "run"]