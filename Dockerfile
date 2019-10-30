# rhessys binder
# Copyright (C) Young-Don Choi.
# Distributed under the terms of the BSD 2-Clause License.

FROM ubuntu:18.04

MAINTAINER Young-Don Choi <choiyd1115@gmail.com>

USER root

RUN apt-get -y update 
RUN apt -y install vim nano wget software-properties-common apt-transport-https
RUN apt-get update && apt-get install -y \
	vim \
	zip \
	unzip \
	python3.7 \
    python3-pip

RUN pip3 install hs_restclient

# Install Ubuntu package for RHESSysWorkflows
RUN apt -y install build-essential git subversion p7zip-full libxml2-dev libxslt-dev libbsd-dev ffmpeg vlc libudunits2-dev

# Install Ubuntu package for IRkernel
RUN apt -y install libssl-dev libcurl4-openssl-dev

# Install Anaconda3
RUN wget https://repo.continuum.io/archive/Anaconda3-2019.03-Linux-x86_64.sh
RUN bash Anaconda3-2019.03-Linux-x86_64.sh -b
RUN rm Anaconda3-2019.03-Linux-x86_64.sh
ENV PATH /root/anaconda3/bin:$PATH

# Don't print "debconf: unable to initialize frontend: Dialog" messages
ARG DEBIAN_FRONTEND=noninteractive

# Need this to add R repo
RUN apt-get update && apt-get install -y software-properties-common

# Install R	
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb http://cran.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran35/" 

# Install R
RUN apt-get update && apt-get install -y r-base

RUN apt-get update && apt-get install -y \
    r-base \
	r-base-dev \
	locales 

# Configure default locale, see https://github.com/rocker-org/rocker/issues/19	
RUN locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

# Install GRASS 7.8.0	
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable  
    #apt-get update  \
RUN apt-get install -y grass grass-dev 
RUN apt-get install -y libgdal-dev libproj-dev	

# Install required R packages
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile  \
    Rscript -e "install.packages('sp')"  \
    Rscript -e "install.packages('XML')"  \
    Rscript -e "install.packages('rgdal')"  \
    Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/rgrass7/rgrass7_0.1-12.tar.gz", repo=NULL, type="source')"  \
    Rscript -e "install.packages('units')"  \
    Rscript -e "install.packages('sf')"  \
    Rscript -e "install.packages('stars')" \
	Rscript -e "install.packages('openssl')" \
	Rscript -e "install.packages('curl')" \
	Rscript -e "install.packages('httr')" \
	Rscript -e "install.packages('devtools')" \
	Rscript -e "devtools::install_github("IRkernel/IRkernel")"  \
	Rscript -e "IRkernel::installspec()"



ENV PATH /root/anaconda3/bin:$PATH
ENV GISBASE /usr/lib/grass78
#ENV PYTHONPATH ${PYTHON-PATH}:$GISBASE/etc/python/
#ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$GISBASE/lib
ENV GIS_LOCK $$
ENV GISRC $HOME/.grass7/rc	
	

USER $NB_USER

WORKDIR /home/$NB_USER

WORKDIR /home/$NB_USER/work

COPY notebooks/* ./

# there is some problem or bug with permissions
USER root
RUN chown -R $NB_USER:users .
USER $NB_USER
