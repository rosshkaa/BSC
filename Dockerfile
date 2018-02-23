FROM tknerr/baseimage-ubuntu:16.04

# Install ruby / set user
RUN apt-get update && apt-get install make && apt-get --assume-yes install zip && apt-get --assume-yes install unzip && apt-get --assume-yes install ruby -f && apt-get --assume-yes install gcc
RUN useradd -ms /bin/bash user 

# Install java
RUN apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:webupd8team/java \
    && apt-get update
#RUN apt-get install openjdk-8-jdk

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 \
    select true | /usr/bin/debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# Install Deps
RUN dpkg --add-architecture i386 && apt-get update \
    && apt-get install -y --force-yes expect wget \
    libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1

# Install Android SDK
RUN cd /opt && mkdir android && cd android && wget --output-document=android-sdk.zip --quiet \
    https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip \
    && unzip android-sdk.zip && rm -f android-sdk.zip \
    && chown -R root.root /opt/android

# Setup environment
ENV ANDROID_HOME /opt/android
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV ANDROID_SDK /opt/android
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/platform-tools

# Install sdk elements
COPY tools /opt/tools
COPY MyApplication /opt/MyApplication

ENV PATH ${PATH}:/opt/tools
RUN y | /opt/android/tools/bin/sdkmanager "platform-tools" "platforms;android-27" "tools" "build-tools;27.0.3" "system-images;android-27;google_apis;x86"
RUN yes | /opt/android/tools/bin/sdkmanager --licenses
RUN y | /opt/android/tools/bin/sdkmanager "platform-tools" "platforms;android-27" "tools" "build-tools;27.0.3" "system-images;android-27;google_apis;x86"
RUN cd /opt/MyApplication && ./gradlew

# Create emulator
RUN /opt/android/tools/bin/avdmanager list
RUN echo "no" | /opt/android/tools/bin/avdmanager create avd -n test -k "system-images;android-27;google_apis;x86"

CMD emulator -avd test -force-32bit
ENV JAVA_OPTS -Xms256m -Xmx512m

# Install Kotlin / Gradle
RUN wget -O sdk.install.sh 'https://get.sdkman.io' --quiet 
RUN	bash sdk.install.sh \
	source "/root/.sdkman/bin/sdkman-init.sh"\
	sdk install kotlin \
	sdk install gradle 4.4


# Cleaning
RUN apt-get clean

# Go to workspace
RUN mkdir -p /opt/workspace
WORKDIR /opt/workspace
