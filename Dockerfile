## rhessys binder
# Copyright (C) Young-Don Choi.
# Distributed under the terms of the BSD 2-Clause License.

#FROM jupyter/scipy-notebook:1386e2046833
<<<<<<< HEAD

=======
#Bootstrap: docker
>>>>>>> cabac933eb567a20f4560f9ec41e0998cede66a2
FROM ubuntu:18.04

MAINTAINER Young-Don Choi <choiyd1115@gmail.com>

USER root

<<<<<<< HEAD
RUN apt-get -y update 
RUN apt -y install vim nano wget software-properties-common apt-transport-https
=======
RUN apt-get update && apt-get install -y \
	vim \
	zip \
	unzip \
	python3.7 \
        python3-pip

RUN pip3 install hs_restclient
>>>>>>> cabac933eb567a20f4560f9ec41e0998cede66a2

# Install Ubuntu package for RHESSysWorkflows
RUN apt -y install build-essential git subversion p7zip-full libxml2-dev libxslt-dev libbsd-dev ffmpeg vlc libudunits2-dev

# Install Ubuntu package for IRkernel
<<<<<<< HEAD
RUN apt -y install libssl-dev libcurl4-openssl-dev

#RUN wget https://repo.continuum.io/archive/Anaconda3-2019.07-Linux-x86_64.sh -O ~/anaconda.sh && \
#    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#    rm ~/Anaconda3-2019.07-Linux-x86_64.sh \
#    export PATH=/opt/conda/bin:$PATH \
#    pip install hs_restclient \
#    pip install --upgrade pip 

# Install Anaconda3
RUN wget https://repo.continuum.io/archive/Anaconda3-2019.03-Linux-x86_64.sh
RUN bash Anaconda3-2019.03-Linux-x86_64.sh -b
RUN rm Anaconda3-2019.03-Linux-x86_64.sh
ENV PATH /root/anaconda3/bin:$PATH

# Updating Anaconda packages
#RUN conda update conda
#RUN conda update anaconda
#RUN conda update --all

# Don't print "debconf: unable to initialize frontend: Dialog" messages
ARG DEBIAN_FRONTEND=noninteractive

# Need this to add R repo
RUN apt-get update && apt-get install -y software-properties-common

# Install R	
#RUN apt-get -y install r-base 
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
    #add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' \
RUN add-apt-repository "deb http://cran.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran35/" 
    #apt-get update \
    #DEBIAN_FRONTEND=noninteractive apt-get -y install r-base
=======
#RUN apt-get install libssl-dev libcurl4-openssl-dev

# Install R
RUN apt-get update && apt-get install -y r-base
    #apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9  \
    #add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/'  \
    #apt-get update  \
    #DEBIAN_FRONTEND=noninteractive apt-get -y install r-base r-base-dev
>>>>>>> cabac933eb567a20f4560f9ec41e0998cede66a2

RUN apt-get update && apt-get install -y \
    r-base \
	r-base-dev \
	locales 

# Configure default locale, see https://github.com/rocker-org/rocker/issues/19	
#RUN apt-get clean && apt-get update && apt-get install -y locales  \
#    locale-gen en_US.UTF-8
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

#RUN R --slave -e 'install.packages("sp")'  \
#    R --slave -e 'install.packages("XML")'  \
#    R --slave -e 'install.packages("rgdal")'  \
#    R --slave -e 'install.packages("https://cran.r-project.org/src/contrib/Archive/rgrass7/rgrass7_0.1-12.tar.gz", repo=NULL, type="source")'  \
#    R --slave -e 'install.packages("units")'  \
#    R --slave -e 'install.packages("sf")'  \
#    R --slave -e 'install.packages("stars")'

# Install required R packages for IRkernel https://github.com/IRkernel/IRkernel
<<<<<<< HEAD
#RUN Rscript -e "install.packages('openssl')" 
#RUN Rscript -e "install.packages('curl')"  
#RUN Rscript -e "install.packages('httr')"  
#RUN Rscript -e "install.packages('devtools')" 
#RUN Rscript -e "devtools::install_github("IRkernel/IRkernel")"  \
#    Rscript -e "IRkernel::installspec()"


#RUN R --slave -e 'install.packages("openssl")'  \
#    R --slave -e 'install.packages("curl")'  \
#    R --slave -e 'install.packages("httr")'  \
#    R --slave -e 'install.packages("devtools")'  \
#    R --slave -e 'devtools::install_github("IRkernel/IRkernel")'  \
#    R --slave -e 'IRkernel::installspec()'	
	
#Add Conda channels
#RUN conda update conda -c conda-canary
#RUN conda config --add channels conda-forge 
#RUN conda config --add channels landlab	

#install cybergis==0.1.0
#RUN conda install pynacl   
#RUN git clone https://github.com/cybergis/jupyterlib   
#RUN cd jupyterlib && python setup.py install

#RUN conda install -c mikesilva simpledbf 
#RUN conda install -c anaconda wget 
#RUN conda install -c anaconda pandas
	
ENV PATH /root/anaconda3/bin:$PATH
ENV GISBASE /usr/lib/grass78
ENV PYTHONPATH ${PYTHON-PATH}:$GISBASE/etc/python/
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:$GISBASE/lib
ENV GIS_LOCK $$
ENV GISRC $HOME/.grass7/rc	
	
=======
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
>>>>>>> cabac933eb567a20f4560f9ec41e0998cede66a2
