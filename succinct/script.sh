mkdir succinct-labs && cd succinct-labs && curl -L https://sp1.succinct.xyz | bash && source $HOME/.bashrc && \
if ! command -v rustc &> /dev/null; then \
    echo "Rust is not installed. Installing Rust..."; \
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; \
    echo "Rust installed. Reconfiguring PATH..."; \
    source $HOME/.cargo/env; \
else \
    echo "Rust is already installed."; \
fi && \
sp1up && \
echo '#!/bin/bash

echo "Starting setup and proof process..."

echo "Installing Git..."
sudo apt update && sudo apt install -y git-all build-essential gcc cargo pkg-config libssl-dev
git --version

echo "Checking if Docker is installed..."
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed. Installing Docker..."
    sudo apt update && sudo apt install -y docker.io
else
    echo "Docker is already installed."
fi
docker --version

echo "Creating new project 'fibonacci'..."
cargo prove new fibonacci
cd fibonacci || { echo "Failed to change directory to "fibonacci""; exit 1; }

echo "Executing Proof..."
if [ -d "script" ]; then
    cd script || { echo "Failed to change directory to "script""; exit 1; }

    echo "Running proof execution..."
    RUST_LOG=info cargo run --release -- --execute
    echo "Proof execution completed successfully."

    echo "Generating Proof..."
    RUST_LOG=info cargo run --release -- --prove
    echo "Proof generated and verified successfully."
else
    echo "Directory "script" not found. Ensure the project was set up correctly."
    exit 1
fi

echo "Process completed successfully."' > succinct.sh && chmod +x succinct.sh && ./succinct.sh
