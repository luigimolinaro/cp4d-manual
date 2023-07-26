#!/bin/bash

# Function to display help and usage instructions
function display_help() {
  echo "Usage: $0 [--check-all | --help]"
  echo "  --check-all   : Check storage availability on all nodes."
  echo "  --help        : Display this help message."
  exit 0
}

# Function to check if storage is available and functioning on a specific node
function check_storage_on_node() {
  local node="$1"
  echo "Checking storage availability on node $node..."
  if oc get storageclass > /dev/null 2>&1; then
    echo "Storage is available and functioning on node $node."
  else
    echo "Storage is not available or not functioning properly on node $node."
  fi
}

# Function to check storage on all nodes
function check_all_storage() {
  echo "Checking storage on all nodes..."
  nodes=($(oc get nodes --no-headers -o custom-columns=NAME:.metadata.name))
  for node in "${nodes[@]}"; do
    check_storage_on_node "$node"
  done
}

# Function to cordon a node
function cordon_node() {
  local node="$1"
  echo "Cordoning node $node..."
  oc adm cordon "$node"
}

# Function to uncordon a node
function uncordon_node() {
  local node="$1"
  echo "Uncordoning node $node..."
  oc adm uncordon "$node"
}

# Check for the --help option
if [[ "$1" == "--help" ]]; then
  display_help
fi

# Check if the --check-all parameter is provided
if [[ "$1" == "--check-all" ]]; then
  check_all_storage
  exit 0
fi

# Print the available nodes
echo "Available nodes:"
oc get nodes

# Ask the user to select a node
read -p "Enter the number of the node on which you want to run the traffic: " selected_index

# User input validation
if [[ ! $selected_index =~ ^[0-9]+$ ]]; then
  echo "Invalid input. Please enter a valid number."
  exit 1
fi

# Check storage availability before proceeding
check_storage_on_node "$(oc get nodes --no-headers -o custom-columns=NAME:.metadata.name | sed -n "${selected_index}p")"

# Continue with the traffic control operations for the selected node
# ...

echo "Operation completed."

