FROM ma314smith/rpi2-python-qemu
MAINTAINER Tõnis Tobre <tobre@bitweb.ee>

RUN [ "cross-build-start" ]

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget git

VOLUME /config

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy build scripts
COPY home-assistant/script/setup_docker_prereqs home-assistant/script/build_python_openzwave home-assistant/script/build_libcec home-assistant/script/install_phantomjs script/
RUN script/setup_docker_prereqs

# Install hass component dependencies
COPY requirements_all.txt requirements_all.txt
RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop

# Copy source
COPY home-assistant .
RUN [ "cross-build-end" ]

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
