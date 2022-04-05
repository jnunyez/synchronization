# Silicom TimeSync Operator on OpenShift
<!--
We want to publish a blog that contains a guided example of using the STS Operator on OpenShift. This should contain:

-   Operator Overview
-   Pictorial Overview of T-GM, T-BC, T-SC concepts
-   Operator Installation
-   Using T-GM
-->

Boilerplate text
Red Hat® OpenShift® blah blah blah.

## Table of Contents

1. [Pre-requisites](#intro)
2. [Telecom Grandmaster Background](#background)
3. [Installing Silicom Timesync Operator](#installation)
4. [Telecom Grandmaster Provisioning](#stsconfig)
6. [Telecom Grandmaster Operation](#stsops)
7. [Uninstalling Silicom Timesync Operator](#uninstalling)
8. [Wrapup](#conclusion)
9. [References](#refs)

The term *Project* and *namespace* maybe used interchangeably in this guide.

## Pre-requisites <a name="pre-requisites"></a>
- Terminal environment
  - Your terminal has the following commands
    - [oc](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.9/html/cli_tools/openshift-cli-oc) binary
    - [git](https://git-scm.com/downloads) binary
- Physical card itself
  - STS2, STS4
  - Connections including GNSS
- [Authenticate as Cluster Admin inside your environment](https://access.redhat.com/documentation/en-us/openshift_container_platform/4.9/html/cli_tools/openshift-cli-oc#cli-logging-in_cli-developer-commands) of an OpenShift 4.9 Cluster.
- Your cluster meets the minimum requirements for the Operator:
  - 1 worker nodes, with at least:
    - 8 logical CPU
    - 24 GiB memory
    - 1+ storage devices

## Telecom Grandmaster Background <a name="background"></a>

<!-- Background on T-GM with pictures? -->
Precise timing is of paramount importance for 5G RAN. 5G RAN leverage of sophisticated technologies to maximize achieved data rates. These techniques rely on tight synchronization between varius elements of the 5G Radio Access Network (RAN). Not getting timing right means mobile subscribers are likely to suffer a poor user experience. Typically, this requires receivers of a Global Navidation Satellite Syste (GNSS) such as GPS, and protocols to transport efficiently the timing information to where it is needed. 

<!-- T-GM -->
Typically, as you can see in the picture above, in a packet-based network PTP is the protocol of choice to carry time information. The recipient of the GNSS information in a PTP network is referred to as the grandmaster (GM) clock. The GM clock is the source of time for the connected network elements lower in the synchronization hierarcy....

<!-- Silicom -->
We needs cards and timings stack to feed timing sync to other O-RAN network elements.

<!-- operator needed-->
....In what follows, we present a guide to use the Silicom operator to automate the installation, monitoring, and operation of Silicom cards as well as the time sync stack (i.e., the operands). 

## Installing Silicom Timesync Operator <a name="installation"></a>

There two Operands to manipulate here based on HW and SW

#### Silicom Card

* The operator has been tested with STS2 and STS4 cards.

#### Time Sync Stack 

Before you begin. Check you have an OpenShift 4.8/4.9 fresh cluster with NFD and SRO operators installed.
<!-- topology -->

### Install from the embedded OperatorHub

<!-- Install steps clearly defined on a FRESH CLUSTER with output-->

* Alpha and beta: select alpha.

* The only installation mode supported from the operatorhub is for all namespaces in the cluster: operator will be available in all Namespaces. This means that the namespaces this operator can watch are ALL.
      - CSV openshift-operators replace

* Pre-requisites: NodeFeature Discovery operator and Special Resource Operator must be installed. In which namespace?
      - Supported: NFD + SRO MUST be installed in the same namespace as Silicom Operator. The namespace can be selected and by default `openshift-silicom` will be created.
      - However we need the flexibility to select the namespace where the three operators will be located. Next version: 
          * NFD, SRO and Silicom can live in their own namespaces
          * Silicom operand should live in a different namespace than silicom operator.

* The operator gets installed in namespace openshift-silicom or in the namespace specified by the OCP administrator.

### Install from the CLI

<!-- Install steps clearly defined on a FRESH CLUSTER with output-->


## Telecom Grandmaster Provisioning <a name="stsconfig"></a>

<!-- Show the user how to place the card in T-GM mode -->
* Supported: Currently, the administrator must manually set labels in the nodes to identify what worker nodes inside the OCP cluster can get the T-TGM.8275.1 role.
* Not supported: automated discovery of nodes that are directly connected to the GPS signal to add the proper label.

1. Add a node label `gm-1` in the worker node that has GPS cable connected to the (i.e., du3-ldc1).

```console
oc label node du3-ldc1 sts.silicom.com/config="gm-1" 
```

2. Create a StsConfig CR object to provision the desired Telecom PTP profile (i.e., T-GM.8275.1)

```yaml
cat <<EOF | oc apply -f -
apiVersion: sts.silicom.com/v1alpha1
kind: StsConfig
metadata:
  name: gm-1
  namespace: openshift-operators
spec:
  namespace: openshift-operators
  imageRegistry: quay.io/silicom
  nodeSelector:
    sts.silicom.com/config: "gm-1"
  mode: T-GM.8275.1
  twoStep: 0
  esmcMode: 2
  ssmMode: 1
  forwardable: 1
  synceRecClkPort: 3
  syncOption: 1
  gnssSpec:
    gnssSigGpsEn: 1
  interfaces:
    - ethName: enp81s0f2
      holdoff: 500
      synce: 1
      mode: Master
      ethPort: 3
      qlEnable: 1
      ql: 2
EOF                 
```

3. Provision the timing stack in the node labelled with `sts.silicom./config: "gm-1"` 

* Unsupported: Creation of timing sync stack in a different namespace than the operator.

```console
gm-1-du3-ldc1-gpsd-964ch                  2/2     Running   0          49m
gm-1-du3-ldc1-phc2sys-6fv9k               1/1     Running   0          49m
gm-1-du3-ldc1-tsync-pkxwv                 2/2     Running   0          44m
```

* Pods above represent the timing solution for T-GM. Zooming into the pods show picture below with the resulting deployment in node du3-ldc1. 

![Timing Stack](imgs/tgm.png)



<!--
mode: Telecom PTP profiles as defined by the ITU-T. T-GM.8275.1 PTP profile corresponds to the profile for the RAN fronthaul network. 
twoStep and forwardable are PTP parameters.
gnssSigGpsEn:
esmcMode, ssmMode, and synceRecClkPort
syncOption:
interfaces
-->

## Telecom Grandmaster Operation <a name="stsops"></a>

* grpc to show stats etc

## Uninstalling Silicom Timesync Operator <a name="uninstalling"></a>

Show the user helpful output from the pods running on the node, log output from successful assocation with GPS coordinates, etc

### Uninstall from the embedded OperatorHub

<!-- Uninstall steps clearly defined on a FRESH CLUSTER with output-->

### Uninstall from the CLI

* Deleting the subscription and the csv does not delete nfd daemonset or the specialresource daemonsets or the silicom sts-plugin daemonset will not delete the CRs associated to the operator

* If we want to fully delete the set of elements created by the operator we need to delete the stsoperatorconfig CR. The action below will totally delete the stsoperatorconfig daemonset (i.e., the sts-plugin) and the nfd and sro deploment (if used). 
      
<!-- Install steps clearly defined on a FRESH CLUSTER with output-->


## Wrap-up <a name="stsconfig"></a>

## References <a name="refs"></a>
