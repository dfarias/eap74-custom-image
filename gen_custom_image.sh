NAME_SPACE=dfarias
IMG_NAME=eap74-openjdk11-custom-s2i-openshift-rhel8

oc new-project ${NAME_SPACE}

oc import-image jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
    --from=registry.redhat.io/jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
    --confirm -n openshift

oc new-build --name=${IMG_NAME} \
    eap74-openjdk11-openshift-rhel8:7.4.5-3~https://github.com/dfarias/eap74-custom-image.git \
    -n ${NAME_SPACE}

oc start-build bc/${IMG_NAME} \
    --wait --follow \
    -n ${NAME_SPACE}

oc new-app ${IMG_NAME} \
    -n ${NAME_SPACE}