#!/usr/bin/env bash

# 1) Create a namespace

kubectl apply -f prometheus-namespace.yaml
kubectl config set-context --current --namespace=prometheus

# 2) Add helm repo

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# 3) Check release configuration

#  Check contents of values.yaml

# 4) Install Prometheus using a Helm chart

helm install --namespace prometheus --values ./prometheus-values.yaml prometheus prometheus-community/prometheus

# Take note of the info in: "Get the Prometheus server URL by running these commands in the same shell"
helm get notes prometheus

# 5) Verify Prometheus installation

# 5a) Port forward to prometheus 9090

export POD_NAME=$(kubectl get pods --namespace prometheus -l "app=prometheus,component=server" -o jsonpath="{.items[0].metadata.name}")
kubectl --namespace prometheus port-forward $POD_NAME 9090

# 5b) Open prometheus config in a browser

# Go to: http://127.0.0.1:9090/config

# 6) Verify what got installed
# - Get a list of resources from Helm
helm get manifest prometheus | egrep '^---|^apiVersion:|^kind:|^metadata:|^  name:'

# 7) Describe all the resources created by Helm and tell what are they used for
# 7a) Describe roles of the following resources: Deployment, ConfigMap, Service

kubectl get deployments.apps
kubectl describe deployments.apps prometheus-server

kubectl get configmaps
kubectl describe configmaps prometheus-server

kubectl get services
kubectl describe service prometheus-server

# 7b) Describe roles of the following resources: PersistentVolumeClaim, PersistentVolume

kubectl get persistentvolumeclaims
kubectl describe persistentvolumeclaim prometheus-server

kubectl get persistentvolumes

# 7c) Describe roles of the following resources: ServiceAccount, Secrets, ClusterRole, ClusterRoleBinding

kubectl get serviceaccounts
kubectl describe serviceaccounts prometheus-server

kubectl get secrets

kubectl get clusterrole prometheus-server
kubectl describe clusterrole prometheus-server

kubectl get ClusterRoleBinding prometheus-server
kubectl describe ClusterRoleBinding prometheus-server
