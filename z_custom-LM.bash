echo "NON LANCIARE!"
exit 0
#SCARICO CLOUDCTL
wget https://github.com/IBM/cloud-pak-cli/releases/download/v3.23.5/cloudctl-linux-amd64.tar.gz
#SCARICO cpd-CLI
wget https://github.com/IBM/cpd-cli/releases/download/v13.1.0/cpd-cli-linux-EE-13.1.0.tgz
tar xvf cpd-cli-linux-EE-13.1.0.tgz


#LOGIN
${CPDM_OC_LOGIN}

#UPDATE IBM Entitled Registry
cpd-cli manage add-icr-cred-to-global-pull-secret \
--entitled_registry_key=${IBM_ENTITLEMENT_KEY}

#Create PROJECT (Shared components)
${OC_LOGIN}
oc new-project ${PROJECT_CERT_MANAGER}
oc new-project ${PROJECT_LICENSE_SERVICE}

#Install Shared components : 
cpd-cli manage apply-cluster-components \
--release=${VERSION} \
--license_acceptance=true \
--cert_manager_ns=${PROJECT_CERT_MANAGER} \
--licensing_ns=${PROJECT_LICENSE_SERVICE}

#SCC che ora si chiama "restricted-v2" dalla versione 4.12 ocp
#https://www.ibm.com/docs/en/cloud-paks/cp-data/4.8.x?topic=services-creating-scc-embedded-db2-databases#scc-restricted-db2__wkc-title

#Change Kernel parameters
#https://www.ibm.com/docs/en/cloud-paks/cp-data/4.8.x?topic=settings-changing-kernel-parameter
cpd-cli manage apply-db2-kubelet

## INSTALL CLOUD PAK FOR DATA
#Create namespace
oc new-project ${PROJECT_CPD_INST_OPERATORS}
oc new-project ${PROJECT_CPD_INST_OPERANDS}

#Applying required permission to project (namespace)
cpd-cli manage authorize-instance-topology \
--cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS}

#Install Fondational Service
cpd-cli manage setup-instance-topology \
--release=${VERSION} \
--cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--license_acceptance=true \
--block_storage_class=${STG_CLASS_BLOCK} 



# APPLY-CRIO
${CLI} manage apply-crio \
  --openshift_type=${OPENSHIFT_TYPE} \
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
#WKC
# Create the SCC for Watson Knowledge Catalog
${CLI} manage apply-crio \
  --openshift_type=${OPENSHIFT_TYPE} --components=wkc \
  --force
#Custom WKC apply-scc
${CLI}  manage apply-scc \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE} \
--components=wkc
# Install WKC apply-CR (https://www.ibm.com/docs/en/cloud-paks/cp-data/4.5.x?topic=catalog-installing)
${CLI} manage apply-cr \
--components=wkc \
--release=${VERSION} \
--cpd_instance_ns=${PROJECT_CPD_INSTANCE} \
--block_storage_class=${STG_CLASS_BLOCK} \
--file_storage_class=${STG_CLASS_FILE} \
--param-file=/tmp/install-options.yml \
--license_acceptance=true
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
