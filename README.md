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
4. [Telecom Grandmaster Configuration](#stsconfig)
5. [Uninstalling Silicom Timesync Operator](#uninstalling)
6. [Wrapup](#conclusion)
7. [References](#refs)

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

### Install from the embedded OperatorHub

<!-- Install steps clearly defined on a FRESH CLUSTER with output-->

### Install from the CLI

<!-- Install steps clearly defined on a FRESH CLUSTER with output-->


## Telecom Grandmaster Configuration <a name="stsconfig"></a>

<!-- Show the user how to place the card in T-GM mode -->

```yaml
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
```

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
