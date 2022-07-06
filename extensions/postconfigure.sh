echo "Executing script" >> /tmp/test
${JBOSS_HOME}/bin/jboss-cli.sh --file=${JBOSS_HOME}/extensions/cli-script.cli
echo "Finishing script execution" >> /tmp/test