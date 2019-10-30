# Copyright (C) Young-Don Choi.
# Distributed under the terms of the BSD 2-Clause License.

#FROM jupyter/scipy-notebook:1386e2046833
#Bootstrap: docker
FROM ubuntu:18.04

MAINTAINER Young-Don Choi <choiyd1115@gmail.com>

USER root

RUN apt-get update && apt-get install -y \
	vim \
	zip \
	unzip 

RUN pip install hs_restclient

# Install GRASS 7.8.0
RUN apt-get update && apt-get install -y \
    software-properties-common curl \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
    && apt-get update \
    && apt-get install -y grass grass-dev libgdal-dev libproj-dev \
    && apt-get autoremove \
    && apt-get clean

# Install Ubuntu package for IRkernel
RUN apt-get install libssl-dev libcurl4-openssl-dev

# Install R
RUN apt-get update && apt-get install -y r-base
    #apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9  \
    #add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'  \
    #apt-get update  \
    #DEBIAN_FRONTEND=noninteractive apt-get -y install r-base r-base-dev

# Install required R packages
RUN R --slave -e 'install.packages("sp")'  \
    R --slave -e 'install.packages("XML")'  \
    R --slave -e 'install.packages("rgdal")'  \
    R --slave -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rgrass7/rgrass7_0.1-12.tar.gz", repo=NULL, type="source")'  \
    R --slave -e 'install.packages("units")'  \
    R --slave -e 'install.packages("sf")'  \
    R --slave -e 'install.packages("stars")'  

# Install required R packages for IRkernel https://github.com/IRkernel/IRkernel
# RUN R --slave -e 'install.packages("openssl")'  \
#    R --slave -e 'install.packages("curl")'  \
#    R --slave -e 'install.packages("httr")'  \
#    R --slave -e 'install.packages("devtools")' \
#    R --slave -e 'devtools::install_github("IRkernel/IRkernel")'  \
#    R --slave -e 'IRkernel::installspec()' 


USER $NB_USER

WORKDIR /home/$NB_USER

#RUN mkdir -p /home/$NB_USER/grassdata \
#  && curl -SL https://grass.osgeo.org/sampledata/north_carolina/nc_spm_08_grass7.tar.gz > nc_spm_08_grass7.tar.gz \
#  && tar -xvf nc_spm_08_grass7.tar.gz \
#  && mv nc_spm_08_grass7 /home/$NB_USER/grassdata \
#  && rm nc_spm_08_grass7.tar.gz

WORKDIR /home/$NB_USER/work

COPY notebooks/* ./

# there is some problem or bug with permissions
USER root
RUN chown -R $NB_USER:users .
USER $NB_USER
