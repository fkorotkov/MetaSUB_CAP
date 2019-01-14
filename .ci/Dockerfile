FROM continuumio/miniconda3

RUN apt-get update \
    && apt-get install -y locales git python3-dev python3-pip libyaml-dev \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && useradd -ms /bin/bash metasub
    
USER metasub

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

ADD cap_env.yml /tmp/environment.yml
WORKDIR /home/metasub
RUN conda env create -f=/tmp/environment.yml

RUN pip install --ignore-installed PyYAML moduleultra==0.1.5"
