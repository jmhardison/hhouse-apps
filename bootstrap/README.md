# Bootstrap Process

- Perform steps in `00_1password`
- Apply `01_certmanager`, `01a_cloudflareoriginca`, `03_argocd` using:
  - `kubectl kustomize --enable-helm --load-restrictor='LoadRestrictionsNone'`
- Monitor cluster, argo-cd will become healthy and apply the remainder of resources.