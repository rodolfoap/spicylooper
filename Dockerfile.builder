FROM node:20-bookworm-slim

# ── System deps ───────────────────────────────────────────────────────────────
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      openjdk-17-jdk-headless wget unzip && \
    rm -rf /var/lib/apt/lists/*

# ── Android SDK ───────────────────────────────────────────────────────────────
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV ANDROID_HOME=/opt/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools

# If this URL breaks, get the latest from:
# https://developer.android.com/studio#command-line-tools-only
RUN mkdir -p $ANDROID_HOME/cmdline-tools && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-11076708_latest.zip \
         -O /tmp/cmdtools.zip && \
    unzip -q /tmp/cmdtools.zip -d $ANDROID_HOME/cmdline-tools && \
    mv $ANDROID_HOME/cmdline-tools/cmdline-tools $ANDROID_HOME/cmdline-tools/latest && \
    rm /tmp/cmdtools.zip

RUN yes | sdkmanager --licenses > /dev/null && \
    sdkmanager "platforms;android-34" "build-tools;34.0.0" "platform-tools"

# ── Capacitor npm packages ────────────────────────────────────────────────────
WORKDIR /build
COPY package.json capacitor.config.json ./
RUN npm install

# ── Pre-warm Gradle (biggest time cost — cached here for all future builds) ───
RUN mkdir -p www && echo "<html><body>warmup</body></html>" > www/index.html
RUN npx cap add android
RUN cd android && ./gradlew assembleDebug --no-daemon -q
