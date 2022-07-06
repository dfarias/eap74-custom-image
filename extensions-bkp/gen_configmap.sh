#!/bin/bash

# Create a configmap
oc create configmap cli-script --from-file=postconfigure.sh=extensions/postconfigure.sh --from-file=my-cli-script.cli=extensions/my-cli-script.cli

# Mounting the volume with the configmap
oc set volumes dc/my-eap --add --name=cli-script --mount-path=/opt/eap/extensions --type=configmap --configmap-name=cli-script --default-mode='0755' --overwrite