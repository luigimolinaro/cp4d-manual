# Catalog Source cpd-platform 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: cpd-platform
spec:
  image: icr.io/cpopen/ibm-cpd-platform-operator-catalog@sha256:9147e737ff029d573ec9aa018f265761caab37e135d09245f0770b3396259a04
  displayName: Cloud Pak for Data
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
 

# Catalog Source ibm-cpd-ccs-operator-catalog 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: ibm-cpd-ccs-operator-catalog
spec:
  image: icr.io/cpopen/ibm-cpd-ccs-operator-catalog@sha256:50a60a82087c478df6a888b277f16995d608b8b74159c6290b3ad5990dd9c333
  displayName: CPD Common Core Services
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
 

# Catalog Source ibm-cpd-datarefinery-operator-catalog 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: ibm-cpd-datarefinery-operator-catalog
spec:
  image: icr.io/cpopen/ibm-cpd-datarefinery-operator-catalog@sha256:90a14beb84082fd65966a367b03f8268ef4569504d72d5828eab4367c99afc15
  displayName: Cloud Pak for Data IBM DataRefinery
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
 

# Catalog Source ibm-cpd-scheduling-catalog 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: ibm-cpd-scheduling-catalog
spec:
  image: icr.io/cpopen/ibm-cpd-scheduler-operator-catalog@sha256:a6f91bb6d1b860fb42062f4944cd32f32f70933d9fb839290402047dfa623826
  displayName: IBM Cloud Pak for Data Scheduler Catalog
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
 

# Catalog Source ibm-cpd-spss-operator-catalog 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: ibm-cpd-spss-operator-catalog
spec:
  image: icr.io/cpopen/ibm-cpd-spss-operator-catalog@sha256:ad0fa33b897de3ec9b60bc33feeb11694634ff77f37702d5376990ec19c7bd54
  displayName: CPD Spss Modeler Services
  publisher: IBM
  sourceType: grpc
 

# Catalog Source ibm-cpd-ws-operator-catalog 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: ibm-cpd-ws-operator-catalog
spec:
  image: icr.io/cpopen/ibm-cpd-ws-operator-catalog@sha256:ea7b7fc8e6a58f55f9fc312eb72aa322d197c4a3d2c2afbd6a68b79a0c150526
  displayName: CPD IBM Watson Studio
  publisher: IBM
  sourceType: grpc
  updateStrategy:
    registryPoll:
      interval: 45m
 

# Catalog Source ibm-cpd-ws-runtimes-operator-catalog 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: ibm-cpd-ws-runtimes-operator-catalog
spec:
  image: icr.io/cpopen/ibm-cpd-ws-runtimes-operator-catalog@sha256:62126781bb37e091487adc4304bba3ded4daf400929b9d70c32c663fa295681f
  displayName: CPD Watson Studio Runtimes
  publisher: IBM
  sourceType: grpc
 

# Catalog Source opencloud-operators 
apiVersion: operators.coreos.com/v1alpha1
kind: CatalogSource
metadata:
  namespace: openshift-marketplace
  name: opencloud-operators
spec:
  image: icr.io/cpopen/ibm-common-service-catalog@sha256:f5d2719f3e558e56fbbd0286a881a5a812e413337ef129d4ddea1285d3339a76
  displayName: IBMCS Operators
  publisher: IBM
  sourceType: grpc
 

# Subscription cpd-operator 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: cpd-operator
  namespace: cp4d
spec:
  channel: v3.8
  installPlanApproval: Automatic
  name: cpd-platform-operator
  source: cpd-platform
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-common-service-operator 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-common-service-operator
  namespace: cp4d
spec:
  channel: v3.23
  installPlanApproval: Automatic
  name: ibm-common-service-operator
  source: opencloud-operators
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-cpd-ccs-operator 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-ccs-operator
  namespace: cp4d
spec:
  channel: v6.5
  installPlanApproval: Automatic
  name: ibm-cpd-ccs
  source: ibm-cpd-ccs-operator-catalog
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-cpd-datarefinery-operator 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-datarefinery-operator
  namespace: cp4d
spec:
  channel: v6.5
  installPlanApproval: Automatic
  name: ibm-cpd-datarefinery
  source: ibm-cpd-datarefinery-operator-catalog
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-cpd-scheduling-catalog-subscription 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-scheduling-catalog-subscription
  namespace: cp4d
spec:
  channel: v1.12
  installPlanApproval: Automatic
  name: ibm-cpd-scheduling-operator
  source: ibm-cpd-scheduling-catalog
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-cpd-spss-operator-catalog-subscription 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-spss-operator-catalog-subscription
  namespace: cp4d
spec:
  channel: v6.5
  installPlanApproval: Automatic
  name: ibm-cpd-spss
  source: ibm-cpd-spss-operator-catalog
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-cpd-ws-operator 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-ws-operator
  namespace: cp4d
spec:
  channel: v6.5
  installPlanApproval: Automatic
  name: ibm-cpd-wsl
  source: ibm-cpd-ws-operator-catalog
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-cpd-ws-runtimes-operator 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-cpd-ws-runtimes-operator
  namespace: cp4d
spec:
  channel: v6.5
  installPlanApproval: Automatic
  name: ibm-cpd-ws-runtimes
  source: ibm-cpd-ws-runtimes-operator-catalog
  sourceNamespace: openshift-marketplace
 

# Subscription ibm-namespace-scope-operator 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: ibm-namespace-scope-operator
  namespace: cp4d
spec:
  channel: v3.23
  installPlanApproval: Automatic
  name: ibm-namespace-scope-operator
  source: opencloud-operators
  sourceNamespace: openshift-marketplace
 

# Subscription operand-deployment-lifecycle-manager-app 
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  name: operand-deployment-lifecycle-manager-app
  namespace: cp4d
spec:
  channel: v3.23
  installPlanApproval: Automatic
  name: ibm-odlm
  source: opencloud-operators
  sourceNamespace: openshift-marketplace
 

