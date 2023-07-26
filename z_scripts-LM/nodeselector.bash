#!/bin/bash

# List of nodes
nodes=(
  "compute-1-ru10.ocp-psa-01.gbbper.priv"
  "compute-1-ru11.ocp-psa-01.gbbper.priv"
  "compute-1-ru12.ocp-psa-01.gbbper.priv"
  "compute-1-ru13.ocp-psa-01.gbbper.priv"
  "compute-1-ru5.ocp-psa-01.gbbper.priv"
  "compute-1-ru6.ocp-psa-01.gbbper.priv"
  "compute-1-ru7.ocp-psa-01.gbbper.priv"
  "compute-1-ru8.ocp-psa-01.gbbper.priv"
  "compute-1-ru8.ocp-psa-01.gbbper.priv"
)

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

# Print the available nodes
echo "Available nodes:"
for ((i=0; i<${#nodes[@]}; i++)); do
  echo "$(($i+1)). ${nodes[$i]}"
done

# Ask the user to select a node
read -p "Enter the number of the node on which you want to run the traffic: " selected_index

# User input validation
if [[ ! $selected_index =~ ^[0-9]+$ ]] || ((selected_index < 1 || selected_index > ${#nodes[@]})); then
  echo "Invalid input. Please enter a number between 1 and ${#nodes[@]}"
  exit 1
fi

# Index of the array is selected_index - 1
selected_node="${nodes[$(($selected_index - 1))]}"

# Cordon all nodes except the selected one
for node in "${nodes[@]}"; do
  if [[ "$node" != "$selected_node" ]]; then
    cordon_node "$node"
  fi
done

# Uncordon the selected node
uncordon_node "$selected_node"

echo "Operation completed."

