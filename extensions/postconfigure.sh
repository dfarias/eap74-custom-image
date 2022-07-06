echo "Executing script" >> /tmp/test
${JBOSS_HOME}/bin/jboss-cli.sh --file=${JBOSS_HOME}/extensions/actions.cli
echo "Finishing script execution" >> /tmp/test