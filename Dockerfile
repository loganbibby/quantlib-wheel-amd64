FROM python:3.8

ENV QUANTLIB_VERSION 1.24
ENV DROPDIR /drop

VOLUME ["/drop"]

WORKDIR /

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y build-essential && \
    apt-get install -y libboost-all-dev && \
    pip install wheel && \
    export CPLUS_INCLUDE_PATH=/usr/local/include && \
    export C_INCLUDE_PATH=/usr/local/include && \
    export DYLD_LIBRARY_PATH=/usr/local/lib

ADD docker/cmd.sh /cmd.sh
RUN chmod +x cmd.sh

RUN mkdir /root_dir

# Fin

CMD /cmd.sh
