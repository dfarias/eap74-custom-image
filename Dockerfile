# FROM docker-registry.default.svc:5000/openshift/eap74-openjdk11-openshift-rhel8:7.4.5-3
FROM registry.redhat.io/jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3

COPY extensions/* /opt/eap/extensions

USER root
RUN chmod +x /opt/eap/extensions/postconfigure.sh

USER 185
CMD ["/opt/eap/bin/openshift-launch.sh"]
