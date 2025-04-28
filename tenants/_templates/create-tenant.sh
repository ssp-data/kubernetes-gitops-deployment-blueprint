#!/bin/bash
# Script to create a new tenant from template

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <tenant-name> <owner-name> <owner-email>"
  exit 1
fi

TENANT_NAME=$1
OWNER_NAME=$2
OWNER_EMAIL=${3:-"$OWNER_NAME@example.com"}
CPU_LIMIT="4"
MEMORY_LIMIT="8Gi"
PODS_LIMIT="20"

# Create tenant directory
TENANT_DIR="../domains/$TENANT_NAME"
mkdir -p "$TENANT_DIR/base"
mkdir -p "$TENANT_DIR/overlays/dev"
mkdir -p "$TENANT_DIR/overlays/prod"

# Create tenant manifest
cat tenant-template.yaml | \
  sed "s/\${TENANT_NAME}/$TENANT_NAME/g" | \
  sed "s/\${OWNER_NAME}/$OWNER_NAME/g" | \
  sed "s/\${OWNER_EMAIL}/$OWNER_EMAIL/g" | \
  sed "s/\${CPU_LIMIT}/$CPU_LIMIT/g" | \
  sed "s/\${MEMORY_LIMIT}/$MEMORY_LIMIT/g" | \
  sed "s/\${PODS_LIMIT}/$PODS_LIMIT/g" \
  > "$TENANT_DIR/base/tenant.yaml"

# Create base kustomization
cat > "$TENANT_DIR/base/kustomization.yaml" << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - tenant.yaml
EOF

# Create dev overlay kustomization
cat > "$TENANT_DIR/overlays/dev/kustomization.yaml" << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
EOF

# Create prod overlay kustomization
cat > "$TENANT_DIR/overlays/prod/kustomization.yaml" << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - ../../base
EOF

echo "Tenant $TENANT_NAME created successfully in $TENANT_DIR"