FROM tomcat:9

ENV DEBIAN_FRONTEND noninteractive

COPY script.sh /opt/
RUN chmod +x /opt/script.sh

RUN sed -i '2i/opt/script.sh' /usr/local/tomcat/bin/catalina.sh

EXPOSE 8080 8443