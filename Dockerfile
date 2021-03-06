FROM docker.otenv.com/ot-ubuntu:18-latest

ENV ROOT=/srv
ENV SCRIPTS=${ROOT}/scripts
ENV TIMELINE=${ROOT}/timeline
ENV NGINX=/etc/nginx
ENV DEBIAN_FRONTEND noninteractive

# create directories
RUN mkdir -p ${SCRIPTS} ${TIMELINE}

# install nginx
RUN apt-get update && apt-get install -y --no-install-recommends nginx

# copy files over
COPY scripts ${SCRIPTS}
COPY css ${TIMELINE}/css
COPY js ${TIMELINE}/js
COPY img ${TIMELINE}/img
COPY index.html ${TIMELINE}
COPY bower_components ${TIMELINE}/bower_components

# link the site conf (port 8080)
# remove the default site (port 80)
# link our site
RUN ln -s ${TIMELINE} /var/www/timeline \
 && ln -s ${SCRIPTS}/timeline.conf ${NGINX}/sites-available/timeline.conf \
 && ln -s  ${SCRIPTS}/timeline.conf ${NGINX}/sites-enabled/timeline.conf \
 && rm ${NGINX}/sites-enabled/default \
 && rm ${NGINX}/sites-available/default

ENTRYPOINT [ "/usr/bin/dumb-init", "/srv/scripts/start.sh", "2>&1" ]