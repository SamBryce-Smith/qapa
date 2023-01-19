FROM python:3.10.9-slim

ENV DEBIAN_FRONTEND=noninteractive

# remove --no-install-recommends vs APAeval as get bedtools/pybedtools install error message 
RUN apt-get update && apt-get install -y build-essential r-base python3 python3-setuptools python3-dev python3-pip bedtools

COPY . /qapa
WORKDIR /qapa

RUN Rscript /qapa/scripts/install_packages.R

RUN python3 /qapa/setup.py install

ENTRYPOINT ["qapa"]
