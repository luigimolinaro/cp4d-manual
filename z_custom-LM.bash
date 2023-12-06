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
oc new-project ${PROJECT_SCHEDULING_SERVICE}

#Install Shared components CERT MANAGER : (ETA: 10 minuti)
cpd-cli manage apply-cluster-components \
--release=${VERSION} \
--license_acceptance=true \
--cert_manager_ns=${PROJECT_CERT_MANAGER} \
--licensing_ns=${PROJECT_LICENSE_SERVICE}

#Install Shared components SCHEDULER : (ETA: 10 minuti)
cpd-cli manage apply-scheduler \
--release=${VERSION} \
--license_acceptance=true \
--scheduler_ns=${PROJECT_SCHEDULING_SERVICE}

## INSTALL CLOUD PAK FOR DATA
#Create namespace
oc new-project ${PROJECT_CPD_INST_OPERATORS}
oc new-project ${PROJECT_CPD_INST_OPERANDS}

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

#Applying required permission to project (namespace)
cpd-cli manage authorize-instance-topology \
--cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS}

#Install Fondational Service (ETA : 5 minuti)
cpd-cli manage setup-instance-topology \
--release=${VERSION} \
--cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--license_acceptance=true \
--block_storage_class=${STG_CLASS_BLOCK} 

#Install the operators in the operators project for the instance. (ETA: 10 min)
cpd-cli manage apply-olm \
--release=${VERSION} \
--cpd_operator_ns=${PROJECT_CPD_INST_OPERATORS} \
--components=${COMPONENTS}

#WKC Customization :
#creare un file "install-options.yaml"
cat <<EOF > ./cpd-cli-workspace/olm-utils-workspace/work/install-options.yaml
custom_spec:
  cpd_platform:
    cloudpakfordata: true
    iamIntegration: True
  wkc:
    install_wkc_core_only: False
    enableKnowledgeGraph: True
    enableDataQuality: True
    enableFactSheet: True
EOF

#Install Cloud Pak for Data With Customization (ETA: 20.0
cpd-cli manage apply-cr \
--release=${VERSION} \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--components=${COMPONENTS} \
--block_storage_class=${STG_CLASS_BLOCK} \
--file_storage_class=${STG_CLASS_FILE} \
--license_acceptance=true \
--param-file=/tmp/work/install-options.yaml

# GET URL 
cpd-cli manage get-cpd-instance-details \
--cpd_instance_ns=${PROJECT_CPD_INST_OPERANDS} \
--get_admin_initial_credentials=true


