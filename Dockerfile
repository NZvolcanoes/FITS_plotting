FROM ubuntu:16.04

MAINTAINER Yannik Behr <y.behr@gns.cri.nz>

RUN apt-get update \
 && apt-get -y upgrade || true \
 && apt-get -y install \
    python-numpy \
    python-scipy \
    python-matplotlib \
    python-requests \
    python-pyproj \
    python-pip \
    wget \
 && apt-get clean

# Init mpl fonts
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

# Install Tini
RUN wget --quiet https://github.com/krallin/tini/releases/download/v0.10.0/tini && \
    echo "1361527f39190a7338a0b434bd8c88ff7233ce7b9a4876f3315c22fce7eca1b0 *tini" | sha256sum -c - && \
    mv tini /usr/local/bin/tini && \
chmod +x /usr/local/bin/tini

# pandas >= 0.19* required; ubuntu ships with 0.17*
RUN pip install -U pip && pip install -U pandas

# Configure container startup
ENTRYPOINT ["tini", "--"]


VOLUME ["/output"]
VOLUME ["/workdir"]
WORKDIR /usr/local/bin
COPY *.py /usr/local/bin/
COPY *.cfg /usr/local/bin/
COPY *.sh /usr/local/bin/
