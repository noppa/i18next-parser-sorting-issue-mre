FROM node:18-bullseye

RUN apt update -q \
  && apt purge locales -y \
	&& apt install -yq locales \
	&& echo "en_US.UTF-8" > /etc/locale.gen \
	&& echo "fi_FI.UTF-8" >> /etc/locale.gen 
ENV LC_ALL=fi_FI.UTF-8
