#!/bin/sh
curl -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/ha/install.yaml -o /tmp/argohainstall.yaml
INSTALLFILE="/tmp/argohainstall.yaml"
MATCHSTRING="quay.io\/argoproj\/argocd"
VERSION=$(grep -m 1 "$MATCHSTRING" "$INSTALLFILE" | awk -F':' '{print $3}')

#if directory does not exist
if [ ! -d "base/ha/${VERSION}" ]; then
  #make new version base_dir
  mkdir base/ha/${VERSION}
  #move temp download file to version path
  mv $INSTALLFILE base/ha/${VERSION}/ha-install.yaml
  #create additional stub files

  cat > base/ha/${VERSION}/kustomization.yaml<< EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argocd
resources:
- namespace.yaml
- ha-install.yaml
EOF

  cat > base/ha/${VERSION}/namespace.yaml<< EOF
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    operator.1password.io/auto-restart: "true"
  name: argocd
EOF

# touch overlay to bump
sed -i '' 's|\(base/ha\).*|base/ha/'"${VERSION}"'|g' overlays/prod/kustomization.yaml

elif [ -d "base/ha/${VERSION}" ]; then
  echo "Directory for base/ha/${VERSION} already exists. No actions performed."
  rm $INSTALLFILE
fi

