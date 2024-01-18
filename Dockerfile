# This file builds a Docker image containing the academic CLI
# https://github.com/wowchemy/hugo-academic-cli/

# Copyright (C) 2021 David Frantz

FROM ubuntu:22.04 as builder

# disable interactive frontends
ENV DEBIAN_FRONTEND=noninteractive 

# Refresh package list & upgrade existing packages 
RUN apt-get -y update && apt-get -y upgrade && \ 
#
# Add PPA for R 4.0
apt -y install software-properties-common dirmngr && \
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -sc)-cran40/" && \
#
# Install libraries
apt-get -y install \
  r-base \
  pandoc \
  libgdal-dev \
  gdal-bin && \
#
# Install R packages
Rscript -e 'install.packages("tidyverse",  repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("rmarkdown",  repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("jsonlite",   repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("RefManageR", repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("plotly",     repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("stringi",    repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("knitr",      repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("terra",      repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("raster",     repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("sp",         repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("rgdal",      repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("sf",         repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("snow",       repos="https://cloud.r-project.org")' && \
Rscript -e 'install.packages("snowfall",   repos="https://cloud.r-project.org")' && \
#
# Clear installation data
apt-get clean && rm -r /var/cache/

# Create a dedicated 'docker' group and user
RUN groupadd docker && \
  useradd -m docker -g docker -p docker && \
  chmod 0777 /home/docker && \
  chgrp docker /usr/local/bin && \
  mkdir -p /home/docker/bin && chown docker /home/docker/bin
# Use this user by default
USER docker

ENV HOME /home/docker
ENV PATH "$PATH:/home/docker/bin"

WORKDIR /home/docker
