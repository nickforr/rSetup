FROM rocker/verse:latest

MAINTAINER "Nick Forrester" nickforr@me.com

ENV GDAL_VERSION 2.1.3
ENV GEOS_VERSION 3.5.1
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    lbzip2 \
    ## dev packages
    libdap-dev \
    libexpat1-dev \
    libfftw3-dev \
    libfreexl-dev \
    libv8-dev \
#  libgeos-dev \ # Need 3.5, this is 3.3
    libgsl0-dev \
    libglu1-mesa-dev \
    libhdf4-alt-dev \
    libhdf5-dev \
    liblwgeom-dev \
    libkml-dev \
    libnetcdf-dev \
    libproj-dev \
    libsqlite3-dev \
    libssl-dev \
    libtcl8.5 \
    libtk8.5 \
    libtiff5-dev \
    libudunits2-dev \
    libxerces-c-dev \
   ## runtime packages
    netcdf-bin \
    unixodbc-dev \
  && wget http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
  && tar -xf gdal-${GDAL_VERSION}.tar.gz \
  && wget http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 \
  && tar -xf geos-${GEOS_VERSION}.tar.bz2 \
## Install dependencies of gdal-$GDAL_VERSION
## && echo "deb-src http://deb.debian.org/debian jessie main" >> /etc/apt/sources.list \
## Install libgeos \
  && cd /geos* \
  && ./configure \
  && make \
  && make install \
## Configure options loosely based on homebrew gdal2 https://github.com/OSGeo/homebrew-osgeo4mac/blob/master/Formula/gdal2.rb
  && cd /gdal* \
  && ./configure \
    --with-curl \
    --with-dods-root=/usr \
    --with-freexl \
    --with-geos \
    --with-geotiff \
    --with-hdf4 \
    --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/serial \
    --with-libjson-c \
    --with-netcdf \
    --with-odbc \
    ##
    --without-grass \
    --without-libgrass \
  && make \
  && make install \
  && cd .. \
  ## Cleanup gdal & geos installation
  && rm -rf gdal-* geos-* \
  && . /etc/environment \
## Install R packages labeled "core" in Spatial taskview 
  && install2.r --error \
    --repos 'https://cran.rstudio.com/' \
    --repos 'http://www.bioconductor.org/packages/release/bioc' \
    ## from CRAN
    DCluster \
    RColorBrewer \
    RandomFields \
    classInt \
    deldir \
    dggridR \
    gstat \
    lidR \
    maptools \
    ncdf4 \
    proj4 \
    raster \
    rgdal \
    rgeos \
    rlas \
    sf \
    ## my additions
    Hmisc \
    ggiraph \
    ggrepel \
    ggthemes \
    leaflet \
    optimx \
    microbenchmark \
    shiny \
    shinydashboard \
    flexdashboard \
    htmlTable \
    xtable \
    valaddin \
    collapsibleTree \
  && Rscript -e "devtools::install_github( \
    c('hrbrmstr/pluralize', \
    'hrbrmstr/streamgraph', \
    'hrbrmstr/hrbrthemes', \
    'jcheng5/bubbles', \
    'mattflor/chorddiag', \
    'timelyportfolio/rcdimple'))"
  
