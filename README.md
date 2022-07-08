# Executando comandos cli em uma imagem do EAP

## Estratégia 1
Gerando uma imagem customizada onde o arquivo de cli está contida na imagem, para isso:

1. Logar no Openshift via `cli`
1. Executar o script `gen_custom_image.sh`
   ```shell
   $ ./gen_custom_image.sh
   ```
1. Para validar que deu certo, entre no container provisionado:
   ```shell
   $ oc rsh <POD_NAME>
   ```
1. Valide o conteúdo do arquivo `standalone-openshift.xml`
   ```shell
   $ cat /opt/eap/standalone/configuration/standalone-openshift.xml
   ```
1. No bloco de `system-properties`, deve existir a seguinte entrada
   ```xml
   <system-properties>
     <property name="cliente" value="nome-cliente"/>
   </system-properties>
   ```

## Estratégia 2
Criar um configmap que contenha o arquivo de cli e monta-lo, para isso:

1. Garantir que se tem a imagem do EAP o Openshift
   ```shell
   oc import-image jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
      --from=registry.redhat.io/jboss-eap-7/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
      --confirm -n openshift
   ```
1. Realizar o deployment do EAP
   ```shell
   $ oc new-app --image-stream=openshift/eap74-openjdk11-openshift-rhel8:7.4.5-3 \
       --name=${APP_NAME} \
       -n ${NAME_SPACE}
   ```
1. Para o pod do EAP para aplicar algumas alterações no deployment
   ```shell
   $ oc scale deploy/${APP_NAME} \
       --replicas=0 \
       -n ${NAME_SPACE}
   ```
1. Criar o configmap `jboss-cli`
   ```shell
   $ oc create configmap jboss-cli \
       --from-file=extensions/actions.cli \
       --from-file=extensions/postconfigure.sh \
       -n=${NAME_SPACE}
   ```
1. Montar o configmap `jboss-cli` do arquivo `actions.cli`
   ```shell
   oc set volume deploy/${APP_NAME} --add \
       --name=jboss-cli-actions-cli \
       --type=configmap \
       --configmap-name=jboss-cli \
       --mount-path=/opt/eap/extensions/actions.cli \
       --sub-path=actions.cli \
       --default-mode=0774 \
       --overwrite \
       -n=${NAME_SPACE}
   ```
1. Montar o configmap `jboss-cli` do arquivo `postconfigure.sh`
   ```shell
   oc set volume deploy/${APP_NAME} --add \
       --name=jboss-cli-postconfigure-sh \
       --type=configmap \
       --configmap-name=jboss-cli \
       --mount-path=/opt/eap/extensions/postconfigure.sh \
       --sub-path=postconfigure.sh \
       --default-mode=0774 \
       --overwrite \
       -n=${NAME_SPACE}
   ```
1. Devido a mudança no deployment, um novo deploy será provisionado
1. Para validar que deu certo, entre no container provisionado:
    ```
    $ oc rsh <POD_NAME>
    ```
1. Valide o conteúdo do arquivo `standalone-openshift.xml`
    ```shell
    $ cat /opt/eap/standalone/configuration/standalone-openshift.xml
    ```
1. No bloco de `system-properties`, deve existir a seguinte entrada
    ```xml
    <system-properties>
      <property name="cliente" value="nome-cliente"/>
    </system-properties>
