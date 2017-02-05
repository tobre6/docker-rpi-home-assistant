FROM resin/armv7hf-debian-qemu
MAINTAINER Tõnis Tobre <tobre@bitweb.ee>

RUN [ "cross-build-start" ]

RUN apt-get install -y python3-pip

# Uncomment any of the following lines to disable the installation.
#ENV INSTALL_TELLSTICK no
#ENV INSTALL_OPENALPR no
#ENV INSTALL_FFMPEG no
#ENV INSTALL_OPENZWAVE no
#ENV INSTALL_LIBCEC no
#ENV INSTALL_PHANTOMJS no

VOLUME /config

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Copy build scripts
COPY virtualization/Docker/ virtualization/Docker/
RUN virtualization/Docker/setup_docker_prereqs

# Install hass component dependencies
COPY requirements_all.txt requirements_all.txt
RUN pip3 install --no-cache-dir -r requirements_all.txt && \
    pip3 install --no-cache-dir mysqlclient psycopg2 uvloop

# Copy source
COPY . .

CMD [ "python", "-m", "homeassistant", "--config", "/config" ]
