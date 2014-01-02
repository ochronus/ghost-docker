# Ghost + syntax highlight + disqus in a Docker container
# VERSION 0.1

FROM stackbrew/ubuntu:13.10
MAINTAINER Csaba Okrona "ochronus@ochronus.com"
WORKDIR /data/ghost

ENV WORKDIR /data/ghost
ENV DEBIAN_FRONTEND noninteractive
# Install dependencies for Node.js installation
RUN apt-get install -y --force-yes python g++ make software-properties-common curl dialog
RUN add-apt-repository ppa:chris-lea/node.js
RUN apt-get update
# Install unzip
RUN apt-get install -y --force-yes unzip
# Install nodejs & npm
RUN apt-get install -y --force-yes rlwrap
RUN apt-get install -y --force-yes nodejs 
RUN curl https://npmjs.org/install.sh | clean=no sh
# Add Ghost zip to image
ADD ./ghost-0.3.3-pimped.zip /tmp/
# Unzip Ghost zip to WORKDIR
RUN unzip -uo /tmp/ghost-0.3.3.zip -d $WORKDIR
# Add custom config js to WORKDIR
ADD ./config.template.js $WORKDIR/config.js
# Install Ghost with NPM
RUN cd /data/ghost/ && npm install --production

RUN sed -i s/VAR_DISQUS_SHORTNAME/$DISQUS_SHORTNAME/g $WORKDIR/content/themes/casper/post.hbs

# Expose port 2368
EXPOSE 2368
# Run Ghost
CMD ["npm","start"]