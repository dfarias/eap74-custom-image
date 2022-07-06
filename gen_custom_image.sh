NAME_SPACE=sefaz-pe
IMG_NAME=eap74-openjdk11-custom-s2i-openshift-rhel8
IMG_TAG=1.0

# oc import-image jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
#     --from=registry.redhat.io/jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
#     --confirm -n openshift

oc new-build --name=${IMG_NAME} --binary -n ${NAME_SPACE}

oc start-build bc/${IMG_NAME} --from-dir=. --wait --follow -n ${NAME_SPACE}

oc tag ${IMG_NAME}:latest ${IMG_NAME}:${IMG_TAG} -n ${NAME_SPACE}