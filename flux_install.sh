#!/bin/bash
# Check if python3 is installed
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3 is required but not installed. Please install it and try again."
    exit 1
fi

# Prompt for W_AI_API_KEY from terminal
read -p "Enter your W_AI_API_KEY: " api_key </dev/tty
if [ -z "$api_key" ]; then
    echo "API key is required. Exiting."
    exit 1
fi

# Export the API key
export W_AI_API_KEY="$api_key"

# Create the wai_runner.py script
cat << 'EOF' > wai_runner.py
#!/usr/bin/env python3
import subprocess
import sys
import re
import time
import signal

proc = None

def signal_handler(sig, frame):
    if proc and proc.poll() is None:
        print("\nStopping the worker...")
        proc.send_signal(signal.SIGINT)
        proc.wait()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

while True:
    print("Starting wai run...")
    proc = subprocess.Popen(["wai", "run"], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True, bufsize=1, universal_newlines=True)
    
    model = None
    while model is None:
        line = proc.stdout.readline()
        if not line:
            break
        sys.stdout.write(line)
        sys.stdout.flush()
        match = re.search(r"Model '([^']+)' loading into memory", line)
        if match:
            model = match.group(1)
    
    if model is None:
        print("No model detected, exiting loop.")
        if proc.poll() is None:
            proc.send_signal(signal.SIGINT)
        proc.wait()
        proc = None
        break
    
    if model == "flux-1-kontext-dev-4bit":
        print(f"Model '{model}' loaded, continuing...")
        # continue piping output in real-time
        while True:
            line = proc.stdout.readline()
            if not line:
                break
            sys.stdout.write(line)
            sys.stdout.flush()
        proc.wait()
        proc = None
        break
    else:
        print(f"Model '{model}' detected, stopping (only 'flux-1-kontext-dev-4bit' is allowed)...")
        proc.send_signal(signal.SIGINT)
        proc.wait()
        proc = None
        print("Restarting...")
        time.sleep(1)  # pause to avoid looping
EOF

# Make the Python script executable
chmod +x wai_runner.py

# Run the Python script
./wai_runner.py
