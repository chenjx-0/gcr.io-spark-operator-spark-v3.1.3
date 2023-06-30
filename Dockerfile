#FROM gcr.io/spark-operator/spark-py:v3.1.1
#FROM gcr.io/spark-operator/spark:v3.1.1

FROM openjdk:8-jre

# Presto version will be passed in at build time
#ARG PRESTO_VERSION

# Set the URL to download
ARG PRESTO_BIN=https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.281/presto-server-0.281.tar.gz

# Update the base image OS and install wget and python
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
ADD sources.list /etc/apt/

RUN apt-get update
RUN apt-get install -y wget python less

# Download Presto and unpack it to /opt/presto
RUN wget --quiet ${PRESTO_BIN}
#COPY presto-server-${PRESTO_VERSION}.tar.gz .
RUN mkdir -p /opt
RUN tar -xf presto-server-0.281.tar.gz -C /opt
#RUN rm presto-server-0.281.tar.gz
RUN ln -s /opt/presto-server-0.281 /opt/presto


# Download the Presto CLI and put it in the image
RUN wget --quiet https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.281/presto-cli-0.281-executable.jar
#COPY presto-cli-${PRESTO_VERSION}-executable.jar .
RUN mv presto-cli-0.281-executable.jar /usr/local/bin/presto
RUN chmod +x /usr/local/bin/presto

# Specify the entrypoint to start
ENTRYPOINT /opt/presto/bin/launcher run
