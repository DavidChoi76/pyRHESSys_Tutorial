FROM ubuntu:18.04

MAINTAINER Young-Don Choi <choiyd1115@gmail.com>

# install only the packages that are needed
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \ 
    ca-certificates \
    git \
    apt-transport-https \
    make \
    libnetcdff-dev \
    liblapack-dev \
    vim \
    zip \
    unzip \ 
    wget \
    python3 \
    python3-pip \
    build-essential \
    subversion \
    p7zip-full \
    libxml2-dev \
    libxslt-dev \
    libbsd-dev \
    ffmpeg \
    vlc \
    libudunits2-dev \
    libssl-dev \
    libcurl4-openssl-dev

# Install Anaconda3
RUN wget https://repo.continuum.io/archive/Anaconda3-2019.03-Linux-x86_64.sh
RUN bash Anaconda3-2019.03-Linux-x86_64.sh -b
RUN rm Anaconda3-2019.03-Linux-x86_64.sh
ENV PATH /opt/conda/bin:$PATH

# Install R	
RUN apt-get -y install dirmngr --install-recommends

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb http://cran.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran35/"
RUN add-apt update
ARG DEBIAN_FRONTEND=noninteractive 
RUN apt-get -y install r-base r-base-dev

# Configure default locale, see https://github.com/rocker-org/rocker/issues/19	
RUN locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8

RUN apt-get update && apt-get install -y \
    software-properties-common curl \
    && add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
    && apt-get update \
    && apt-get install -y grass grass-dev libgdal-dev libproj-dev \
    && apt-get autoremove \
    && apt-get clean

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

RUN pip3 install --no-cache --upgrade pip && \
    pip3 install --no-cache notebook  && \
    pip3 install --upgrade pip  && \
    pip3 install hs_restclient  && \
    pip3 install simpledbf  && \
    pip3 install wget  && \
    pip3 install pandas

#RUN apt-get update && apt-get -y install --no-install-recommends --no-install-suggests \
#        ca-certificates software-properties-common gnupg2 gnupg1 \
#      && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
#      && add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu bionic-cran35/' \
#      && apt-get install r-base


# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}
