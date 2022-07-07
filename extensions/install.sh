#!/usr/bin/env bash
set -x
injected_dir=$1
cp -rf ${injected_dir} $JBOSS_HOME/extensions