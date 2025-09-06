# wai-runner
automation script to avoid sdxl model while running wai nodes
runs the `wai` command with model detection so that your node starts with any other model but `sdxl`.

*NOTE: this is community made script, provided as-is; it will be deleted as soon as wai team provides a fix*

## quick start

run this command to automatically download and execute the script; it will check for python and ask for your api key (starts with `wsk-`):

```bash
curl -sSL https://raw.githubusercontent.com/Oxngon/wai-runner/main/install.sh | bash

