# 1Password Controller

Installing the 1Password controller requires the secrets to be created first.
These can be layered together with kustomize, however that will prevent argo from being able to deploy them.

## Secrets (bootstrapped items)

The two secrets are injected outside of the deploy processes, after the deployment is done or namespace is created, inject and create the following secrets.

```
op inject -i op-session.tpl -o op-session
kubectl -n 1password create secret generic op-credentials --from-file=1password-credentials.json=op-session

kubectl -n 1password create secret generic onepassword-token --from-literal=token=$(op item get hhk8s-1password --fields token)
```



## HELM based install of 1password -> extract to kube bases

The following is used to update the base manifests if needed.

```
helm repo add 1password https://1password.github.io/connect-helm-charts
helm fetch --untar --untardir charts 1password/connect
helm template --output-dir base --namespace 1password --values customvalues.yaml connect charts/connect
rm -rf charts
```