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

# Privileges Db2U
# https://www.ibm.com/docs/en/cloud-paks/cp-data/4.8.x?topic=data-specifying-privileges-that-db2u-runs
oc apply -f - <<EOF
apiVersion: v1
data:
  DB2U_RUN_WITH_LIMITED_PRIVS: "false"
kind: ConfigMap
metadata:
  name: db2u-product-cm
  namespace: ${PROJECT_CPD_INST_OPERATORS}
EOF

#WKC Customization :
#creare un file "cpd-install-options.yaml" con

custom_spec:
  cpd_platform:
    cloudpakfordata: true
    iamIntegration: True
  wkc:
    install_wkc_core_only: False
    enableKnowledgeGraph: True
    enableDataQuality: True
    enableFactSheet: True

#Install Cloud Pak for Data
cpd-cli manage apply-cr \
--release=${VERSION} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--components=${COMPONENTS} \
--block_storage_class=${STG_CLASS_BLOCK} \
--file_storage_class=${STG_CLASS_FILE} \
--license_acceptance=true

#OPTIONAL Install Cloud Pak for Data With Customization
cpd-cli manage apply-cr \
--release=${VERSION} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--components=${COMPONENTS} \
--block_storage_class=${STG_CLASS_BLOCK} \
--file_storage_class=${STG_CLASS_FILE} \
--license_acceptance=true \
--param-file=/tmp/work/install-options.yml

# GET URL 
cpd-cli manage get-cpd-instance-details \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--get_admin_initial_credentials=true


