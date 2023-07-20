oc patch CatalogSource ibm-operator-catalog -n openshift-marketplace \
--type=merge \
--patch '{"spec":{"priority":-1}}'
