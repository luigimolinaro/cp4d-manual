#!/bin/bash

for i in cp4d cp4s cp4s-cs cs-control; do
  echo
  echo "Namespace: $i"
  oc get sub -n $i
done
