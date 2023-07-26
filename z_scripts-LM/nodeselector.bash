#!/bin/bash

# Get the list of nodes from the OpenShift cluster and store them in an array
readarray -t nodes <<< "$(oc get nodes --no-headers -o custom-columns=NAME:.metadata.name)"

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

# Cordon all nodes except

