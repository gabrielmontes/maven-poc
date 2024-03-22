# Author: Gabriel Montes

FROM alpine:3.17

# Environment variables:
ENV TZ America/Denver
ENV LANG en_US.UTF-8
ENV LC_COLLATE en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_MONETARY en_US.UTF-8
ENV LC_NUMERIC en_US.UTF-8
ENV LC_TIME en_US.UTF-8

# Install Java 17 and dependencies:
RUN apk update
RUN apk --no-cache add openjdk17 --repository=https://dl-cdn.alpinelinux.org/alpine/v3.17/community    
RUN apk add bash curl
RUN rm -rf /var/cache/apk/*
RUN mkdir /logs/ && chown -R 1001:1001 /logs/ && chmod 777 /logs/ && mkdir -p /app/logs && chown -R 1001:1001 /app/ && find /app/ -type d -exec chmod 755 {} \;
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk
RUN rm /usr/bin/java && ln -s /usr/lib/jvm/java-17-openjdk/bin/java /usr/bin/java

# Copy code to /app:
COPY hello-world-maven-*.jar /opt/helloworld/application.jar

# Add ownership to opt: 
RUN chgrp -R 0 /opt/ && chmod -R g=u /opt/

# Work under the app folder:
WORKDIR /opt/helloworld

# Change to user 1001:
USER 1001

# Run java:
CMD java -jar $JAVA_OPTS /opt/helloworld/application.jar

