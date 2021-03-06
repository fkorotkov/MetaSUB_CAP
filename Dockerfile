FROM continuumio/miniconda3



RUN apt-get update \
    && apt-get install -y locales git python3-dev python3-pip libyaml-dev \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && useradd -ms /bin/bash metasub

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

ADD cap_env.yml /tmp/environment.yml
WORKDIR /home/metasub
RUN conda env create -f=/tmp/environment.yml

RUN mkdir /opt/metasub/ \
    && cd /opt/metasub/

ENTRYPOINT [ "/bin/bash", "-c" ]
RUN /bin/bash -c "source activate cap \
    && pip install --ignore-installed PyYAML moduleultra==0.1.5"


USER metasub
RUN cd /home/metasub \
    && /bin/bash -c "source activate cap \
    && mkdir base_repo \
    && mkdir repo \
    && cd /home/metasub/base_repo \
    && moduleultra init \
    && echo y | moduleultra install https://github.com/MetaSUB/MetaSUB_QC_Pipeline.git \
    && echo y | moduleultra install https://github.com/MetaSUB/MetaSUB_CAP \
    && moduleultra add pipeline metasub_cap \
    && moduleultra add pipeline metasub_qc_cap"


WORKDIR /home/metasub/repo
RUN /bin/bash -c "source activate cap"