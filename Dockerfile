FROM ubuntu:22.04

RUN apt-get update -y --fix-missing
RUN apt-get upgrade -y

RUN apt-get install git make gcc zlib1g-dev libbz2-dev liblzma-dev wget time -y

RUN mkdir /blend
RUN mkdir /input
RUN mkdir /output
WORKDIR /blend

RUN git clone https://github.com/CMU-SAFARI/BLEND.git /blend
RUN make
RUN cp /blend/bin/blend /usr/local/bin

# RUN apt-get remove git -y
# RUN apt-get autoremove -y
VOLUME /input
VOLUME /output
ENTRYPOINT ["/usr/local/bin/blend"]

LABEL Name=blend Version=0.9
