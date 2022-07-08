#!/bin/bash

NAME_SPACE=dfarias-cm
APP_NAME=eap74-openjdk11-custom-s2i-openshift-rhel8

oc delete project ${NAME_SPACE} --grace-period=0 --force --wait

WAITING=1
while [[ $WAITING -eq 1 ]]; do
  WAITING=$(oc get projects | grep ${NAME_SPACE} | wc -l)
done

oc new-project ${NAME_SPACE}

oc import-image jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
    --from=registry.redhat.io/jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
    --confirm -n ${NAME_SPACE}

oc create configmap jboss-cli \
    --from-file=extensions/actions.cli \
    --from-file=extensions/postconfigure.sh \
    -n ${NAME_SPACE}

oc new-app --image-stream=${NAME_SPACE}/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
    --name=${APP_NAME} \
    -n ${NAME_SPACE}

oc set triggers deploy/${APP_NAME} --manual

oc set volume deploy/${APP_NAME} --add \
    --name=jboss-cli-actions-cli \
    --type=configmap \
    --configmap-name=jboss-cli \
    --mount-path=/opt/eap/extensions/actions.cli \
    --sub-path=actions.cli \
    --default-mode=0774 \
    --overwrite \
    -n=${NAME_SPACE}

oc set volume deploy/${APP_NAME} --add \
    --name=jboss-cli-postconfigure-sh \
    --type=configmap \
    --configmap-name=jboss-cli \
    --mount-path=/opt/eap/extensions/postconfigure.sh \
    --sub-path=postconfigure.sh \
    --default-mode=0774 \
    --overwrite \
    -n=${NAME_SPACE}

oc set triggers deploy/${APP_NAME} --auto