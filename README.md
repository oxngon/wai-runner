# wai runner
automation script to avoid sdxl model while running wai nodes
runs the `wai` command with model detection so that your node starts with any other model but `sdxl`.

*NOTE: this is community made script, provided as-is; it will be deleted as soon as wai team provides a fix*

## prerequisites
- python 3 must be installed
- wai app must be installed and available in your PATH
- valid W_AI_API_KEY (the script will ask for your api key, starts with `wsk-`)

## how it works
- checks for python3 installation
- prompts for your W_AI_API_KEY
- creates and runs a python script that:
  - starts the wai run command
  - monitors output for model loading information
  - restarts if the "sdxl" model is detected
  - continues normally for other models

## quick start

run this command to automatically download and execute the script:

```bash
curl -sSL https://raw.githubusercontent.com/Oxngon/wai-runner/main/install.sh | bash

