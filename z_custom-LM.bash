echo "NON LANCIARE!"
exit 0
#SCARICO CLOUDCTL
wget https://github.com/IBM/cloud-pak-cli/releases/download/v3.23.5/cloudctl-linux-amd64.tar.gz
#SCARICO cpd-CLI
wget https://github.com/IBM/cpd-cli/releases/download/v13.0.0/cpd-cli-linux-SE-13.0.0.tgz
wget https://github.com/IBM/cpd-cli/releases/download/v12.0.6/cpd-cli-linux-SE-12.0.6.tgz
#LOGIN
${CLI} manage login-to-ocp --token=${OCP_TOKEN} --server=${OCP_URL}
# APPLY-CRIO
${CLI} manage apply-crio \
  --openshift_type=${OPENSHIFT_TYPE}
  --force=true
# OPTIONAL (Updating the global image pull secret) 
${CLI} manage add-icr-cred-to-global-pull-secret \
${IBM_ENTITLEMENT_KEY}
#APPLY-OLM
${CLI} manage apply-olm \
--release=${VERSION} \
--components=${COMPONENTS} \
--cpd_operator_ns=${PROJECT_CPD_OPS} \
--cs_ns=${PROJECT_CPFS_OPS}
#VERIFY operators
${CLI} manage get-olm-artifacts \
--subscription_ns=${PROJECT_CPFS_OPS}
#SETUP NS
${CLI} manage setup-instance-ns \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE} \
--cpd_operator_ns=${PROJECT_CPD_OPS} \
--cs_ns=${PROJECT_CPFS_OPS}
# Create the SCC for Watson Knowledge Catalog
${CLI} manage apply-crio \
  --openshift_type=${OPENSHIFT_TYPE} --components=wkc \
  --force
#Custom WKC apply-scc
${CLI}  manage apply-scc \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE} \
--components=wkc
#APPLY CR
${CLI} manage apply-cr \
--components=${COMPONENTS} \
--release=${VERSION} \
--cs_ns=${PROJECT_CPFS_OPS} \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE} \
--block_storage_class=${STG_CLASS_BLOCK} \
--file_storage_class=${STG_CLASS_FILE} \
--license_acceptance=true \
--cs_ns=${PROJECT_CPFS_OPS}
#License Server
${CLI} manage apply-entitlement \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE} \
--entitlement=cpd-enterprise
#VERIFY Components
${CLI} manage get-cr-status \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE}
#FINALIZE
${CLI} manage get-cpd-instance-details \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE} \
--get_admin_initial_credentials=true
