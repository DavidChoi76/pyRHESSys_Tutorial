# Copyright (C) Vaclav Petras.
# Distributed under the terms of the BSD 2-Clause License.

FROM jupyter/scipy-notebook:1386e2046833

MAINTAINER Vaclav Petras <wenzeslaus@gmail.com>

USER root

RUN apt-get update && apt-get install -y \
    software-properties-common curl \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
    && apt-get update \
    && apt-get install -y grass grass-dev \
    && apt-get autoremove \
    && apt-get clean

RUN apt-get update && apt-get -y install --no-install-recommends --no-install-suggests \
        ca-certificates software-properties-common gnupg2 gnupg1 \
      && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
      && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' \
      && apt-get install r-base

USER $NB_USER

WORKDIR /home/$NB_USER

WORKDIR /home/$NB_USER/work

COPY notebook/* ./

# there is some problem or bug with permissions
USER root
RUN chown -R $NB_USER:users .
USER $NB_USER
