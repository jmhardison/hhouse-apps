#!/bin/sh
curl -s https://raw.githubusercontent.com/argoproj/argo-rollouts/master/manifests/install.yaml -o /tmp/argorolloutsinstall.yaml #quay.io/argoproj/argo-rollouts is latest?
INSTALLFILE="/tmp/argorolloutsinstall.yaml"
MATCHSTRING="quay.io\/argoproj\/argo-rollouts"
VERSION=$(grep -m 1 "$MATCHSTRING" "$INSTALLFILE" | awk -F':' '{print $3}')

#if directory does not exist
if [ ! -d "base/non-ha/${VERSION}" ]; then
  #make new version base_dir
  mkdir base/non-ha/${VERSION}
  #move temp download file to version path
  mv $INSTALLFILE base/non-ha/${VERSION}/install.yaml
  #create additional stub files

  cat > base/non-ha/${VERSION}/kustomization.yaml<< EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: argo-rollouts
resources:
- namespace.yaml
- install.yaml
EOF

  cat > base/non-ha/${VERSION}/namespace.yaml<< EOF
apiVersion: v1
kind: Namespace
metadata:
  annotations:
    operator.1password.io/auto-restart: "true"
  name: argo-rollouts
EOF

# touch overlay to bump
sed -i '' 's|\(base/non-ha\).*|base/non-ha/'"${VERSION}"'|g' overlays/prod/kustomization.yaml

elif [ -d "base/non-ha/${VERSION}" ]; then
  echo "Directory for base/non-ha/${VERSION} already exists. No actions performed."
  rm $INSTALLFILE
fi

