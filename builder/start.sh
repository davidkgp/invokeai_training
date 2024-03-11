#!/bin/bash

echo "Container Started"

cd /
jupyter lab --allow-root --no-browser --port=8899 --ip=* \
        --ServerApp.terminado_settings='{"shell_command":["/bin/bash"]}' \
        --ServerApp.token='' --ServerApp.allow_origin=* --ServerApp.preferred_dir=/workspace/invoke-training
echo "Jupyter Lab Started"
