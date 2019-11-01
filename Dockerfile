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

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository "deb http://cran.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran35/"
ARG DEBIAN_FRONTEND=noninteractive 
RUN apt-get -y install r-base r-base-dev

# Configure default locale, see https://github.com/rocker-org/rocker/issues/19	
RUN apt-get update && apt-get install -y \
    locales

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
RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile  
RUN R -e "install.packages('sp',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('XML',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('rgdal',dependencies=TRUE, repos='http://cran.rstudio.com/')"
#ARG packageUrl = "https://cran.r-project.org/src/contrib/Archive/rgrass7/rgrass7_0.1-12.tar.gz"
#RUN Rscript -e "install.packages("https://cran.r-project.org/src/contrib/Archive/rgrass7/rgrass7_0.1-12.tar.gz", repos=NULL, type="source")"
#RUN R -e "install.packages('rgrass7_0.1-12.tar.gz", repo=NULL, type="source',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('remotes'); \
  remotes::install_version('rgrass7', '0.1-12')"
RUN R -e "install.packages('units',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('sf',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('stars',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('openssl',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('curl',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('httr',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('devtools',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('openssl',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('openssl',dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN Rscript -e "devtools::install_github("IRkernel/IRkernel")" 
RUN Rscript -e "IRkernel::installspec()"

RUN pip3 install --upgrade pip setuptools wheel 
RUN pip3 install --no-cache notebook  && \
    pip3 install --upgrade pip  && \
    pip3 install hs_restclient  && \
    pip3 install simpledbf  && \
    pip3 install wget  && \
    pip3 install pandas

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

COPY notebooks/* ./
