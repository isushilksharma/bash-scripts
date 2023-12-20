#Bash script that uses kubectl to create a PostgreSQL pod in a Kubernetes cluster using the official PostgreSQL Docker image and then logs into the PostgreSQL database:

#!/bin/bash
set -e

# Set variables
pod_name="psql-pod"
postgres_password="your_password"
database_name="your_database"

# Create PostgreSQL pod
kubectl run "${pod_name}" --image=postgres --env="POSTGRES_PASSWORD=${postgres_password}" --env="POSTGRES_DB=${database_name}" --restart=Never

# Wait for the pod to be ready
kubectl wait --for=condition=ready pod/"${pod_name}" --timeout=60s

# Get pod's container ID
container_id=$(kubectl get pod "${pod_name}" -o jsonpath='{.spec.containers[0].name}')

# Connect to the PostgreSQL database using psql
kubectl exec -it "${pod_name}" -c "${container_id}" -- psql -U postgres -d "${database_name}"

# Cleanup: Delete the pod after connecting to the database
kubectl delete pod "${pod_name}"
