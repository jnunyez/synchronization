#!/bin/sh
# stsplugin and stsnodes

#roles and clusterroles 
oc delete role sts-plugin
oc delete role sts-tsync
oc delete rolebinding sts-plugin
oc delete rolebinding sts-tsync
oc delete clusterroles stsconfigs.sts.silicom.com-v1alpha1-admin
oc delete clusterroles stsconfigs.sts.silicom.com-v1alpha1-crdview
oc delete clusterroles stsconfigs.sts.silicom.com-v1alpha1-edit
oc delete clusterroles stsconfigs.sts.silicom.com-v1alpha1-view                                   
oc delete clusterroles stsnodes.sts.silicom.com-v1alpha1-admin                                    
oc delete clusterroles stsnodes.sts.silicom.com-v1alpha1-crdview                                  
oc delete clusterroles stsnodes.sts.silicom.com-v1alpha1-edit                                     
oc delete clusterroles stsnodes.sts.silicom.com-v1alpha1-view                                     
oc delete clusterroles stsoperatorconfigs.sts.silicom.com-v1alpha1-admin                          
oc delete clusterroles stsoperatorconfigs.sts.silicom.com-v1alpha1-crdview                        
oc delete clusterroles stsoperatorconfigs.sts.silicom.com-v1alpha1-edit                           
oc delete clusterroles stsoperatorconfigs.sts.silicom.com-v1alpha1-view  