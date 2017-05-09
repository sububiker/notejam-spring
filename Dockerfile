FROM openjdk:8-jre-alpine

ENV USER_NAME app-runner

# Support for proxies.
# Values should be passed as build args
# http://docs.docker.com/engine/reference/builder/#arg
ENV http_proxy ${http_proxy:-}
ENV https_proxy ${https_proxy:-}
ENV no_proxy ${no_proxy:-}

# Install dump init
# Read more here https://github.com/Yelp/dumb-init
ENV DUMB_INIT_VER=1.2.0
RUN apk add --no-cache --virtual .tmp-packeges python2 python2-dev py2-pip build-base \
    && echo "dumb-init==1.2.0 --hash sha256:51274b5f8d82846e959b96605a3213eddc462bcb3eaec3bc4ec0b1df5ab14e6d" > requirements.txt \
    && pip install --require-hash -r requirements.txt\
    && apk del .tmp-packeges \
    && rm -f requirements.txt

# Create local user to run container
RUN addgroup -g 1000 ${USER_NAME} && adduser -h /home/${USER_NAME} -D -u 1000 -G ${USER_NAME} -s /bin/sh ${USER_NAME}

# Add app
COPY target/spring-*.jar /home/${USER_NAME}/app.jar
RUN chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}

USER ${USER_NAME}

# Define entry point
ENTRYPOINT dumb-init -- java -jar /home/${USER_NAME}/app.jar
