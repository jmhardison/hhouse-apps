# 1Password Controller

Installing the 1Password controller requires the secrets to be created first.
These can be layered together with kustomize, however that will prevent argo from being able to deploy them.


## Secrets (bootstrapped items)

The two secrets are injected outside of the deploy processes, after the deployment is done or namespace is created, inject and create the following secrets. In addition to the secrets, the namespace will be created.

```
kubectl create namespace 1password

op inject -i op-session.tpl -o op-session
kubectl -n 1password create secret generic op-credentials --from-file=1password-credentials.json=op-session

kubectl -n 1password create secret generic onepassword-token --from-literal=token=$(op item get hhk8s-1password --reveal --fields token)
```



## Apply Kustomize

The following is used to apply the bootstrapping for 1password connect.

```
kubectl kustomize --enable-helm --load-restrictor='LoadRestrictionsNone' | kubectl apply -f -
```