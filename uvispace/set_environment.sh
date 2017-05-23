#!/bin/bash
parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

export OLDPYTHONPATH=$PYTHONPATH
export PYTHONPATH=$PYTHONPATH:$parent_path

export UVISPACE_LOG_PATH=$parent_path/log

export UVISPACE_BASE_PORT_POSITION=35000
export UVISPACE_BASE_PORT_SPEED=35010
export UVISPACE_BASE_PORT_GOAL=35020
