FROM sso74-openshift-rhel8:7.4.5-3

COPY  extensions/* /opt/eap/extensions

USER root
RUN chmod +x /opt/eap/extensions/postconfigure.sh

USER 185
CMD ["/opt/eap/bin/openshift-launch.sh"]