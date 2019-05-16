FROM openjdk:8-jdk-alpine

RUN apk add --no-cache \
    bash \
    su-exec \
    python \
    maven \
    && rm -rf /var/cache/apk/*

ENV VERSION=2.0.0

ADD http://apache.mirror.anlx.net/atlas/${VERSION}/apache-atlas-${VERSION}-sources.tar.gz /

RUN set -x \
    && cd / \
    && tar -xzf apache-atlas-${VERSION}-sources.tar.gz \
    && cd apache-atlas-sources-${VERSION} \
    && mvn clean -DskipTests package -Pdist,embedded-cassandra-solr \
    && tar -xzvf distro/target/apache-atlas-${VERSION}-bin.tar.gz \
    && mv apache-atlas-${VERSION} /apache-atlas

WORKDIR /apache-atlas

EXPOSE 21000

ENV PATH=$PATH:/apache-atlas

ENV ATLAS_SERVER_HEAP="-Xms15360m -Xmx15360m -XX:MaxNewSize=5120m -XX:MetaspaceSize=100M -XX:MaxMetaspaceSize=512m"
ENV MANAGE_LOCAL_HBASE=false
ENV MANAGE_LOCAL_SOLR=true
ENV MANAGE_EMBEDDED_CASSANDRA=true
ENV MANAGE_LOCAL_ELASTICSEARCH=false

CMD ["/bin/bash", "-c", "/apache-atlas/bin/atlas_start.py; tail -fF /apache-atlas/logs/application.log"]
