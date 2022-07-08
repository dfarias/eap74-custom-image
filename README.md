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

1. Logar no Openshift via `cli`
1. Executar o script `set_configmap_volume.sh`
   ```shell
   $ ./set_configmap_volume.sh
   ```
## Validando se deu tudo certo
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
