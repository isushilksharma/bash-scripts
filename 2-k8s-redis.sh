#Bash script to create a redis pod in a Kubernetes cluster using the official redis Docker image and then logs into the redis-cli database.

#!/bin/bash
set -e

# Set variables
pod_name="redis-pod"

# Create Redis pod
kubectl run "${pod_name}" --image=redis --restart=Never

# Wait for the pod to be ready
kubectl wait --for=condition=ready pod/"${pod_name}" --timeout=60s

# Get pod's container ID
container_id=$(kubectl get pod "${pod_name}" -o jsonpath='{.spec.containers[0].name}')

# Connect to the Redis server using redis-cli
kubectl exec -it "${pod_name}" -c "${container_id}" -- redis-cli

# Cleanup: Delete the pod after connecting to Redis
kubectl delete pod "${pod_name}"
