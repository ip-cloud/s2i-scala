# Extend from secure linux base image
FROM centos/s2i-base-centos7

MAINTAINER IP Cloud - Ivo Patty <ivo@ip-cloud.nl>

RUN yum update -y && \
    yum install -y java-1.8.0-openjdk && \
    curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo && \
    yum install -y sbt && \
    set -o pipefail && curl -L https://github.com/openshift/origin/releases/download/v1.5.1/openshift-origin-client-tools-v1.5.1-7b451fc-linux-64bit.tar.gz | \
    tar -zx && \
    mv openshift*/oc /usr/local/bin && \
    rm -rf openshift-origin-client-tools-*

LABEL summary="Source to Image for running SBT based Java 8 Applications" \
      io.k8s.description="Source to Image for running SBT based Java 8 Applications" \
      io.k8s.display-name="SBT with Java 8" \
      io.openshift.expose-services="9000:play-http,8080:akka-http" \
      io.openshift.tags="builder,scala,java8" \
      com.redhat.dev-mode="DEV_MODE:false" \
      com.redhat.dev-mode.port="DEBUG_PORT:5005" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

COPY bin/ /usr/libexec/s2i

USER 1001

EXPOSE 9000 8080

CMD /usr/libexec/s2i/usage