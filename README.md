# hhouse-apps
HHOUSE internal lab cluster ArgoCD and various tools functional examples.

## What this includes

- Random apps I am deploying into my cluster.
- 1Password connect integration, both in cluster and in GitHub actions.
- ArgoCD using ApplicationSets, and merge based "Patch-Sync-Wait" routine. More to come.
- ArgoCD is behind Cloudflare ZeroTrust Access using tunnels. (No ingress ports exposed.)
  - Note: `Bot Fight Mode` must be disabled if you intend to use GitHub hosted runners. Self hosted runners likely won't trigger the bot defenses. The mode cannot be bypassed by source yet, only enabled/disabled for the domain.
- GitHub Actions in use, including Matrix based jobs.
  - Note: There is a limit of 256 jobs that can be spawned in a matrix workflow. Can break out to more workflows if that limit is too low.


## Repository Layout

The layout of this repository is a bit mangled, but borrows from common approaches including RedHats article for structuring a GitOps repository. [Link](https://developers.redhat.com/articles/2022/09/07/how-set-your-gitops-directory-structure#directory_structures) ArgoCD is configured to use ApplicationSets that derive aspects from the layout itself. As noted below:

- `apps`
  - `apps/[namespace]/[application name]`
  - This folder is the main deployment folder for applications not considered core infrastructure related.
- `bootstrap`
  - `bootstrap/[ordernumber_applicationname]`
  - During instatiation of a cluster, the applications in this folder are deployed manually in order. After reconstituting a cluster, continued configuration will be implemented by Argo based on the links from the `core` folder.
- `core`
  - `core/[applicationname]`
  - This folder is the collection of infrastructure components. This builds upon the `bootstrap` folder and kustomize references information from there where required to continue mutation.

## Workflow Routine

The general workflow applied currently bases its actions from merging into main. Upon merging, the workflow will gather what application folders for `apps` and `core` were modified, and build a matrix deployment for each. The matrix jobs will wait for approval before deployment. The approvers are defined on the `environment` for the repository. Additionally, the `seed secret` required to communicate to 1Password and retrieve all other `secrets` is held on the `environment` configuration and released after approval.

## Ingress Access

Access to applications deployed in the cluster is over Cloudflare Argo Tunnels, part of the Zero Trust services. This allows for use of `cloudflared` running multiple instances in the cluster, establishing egress tunnel to Cloudflare Datacenters. Communications to the applications will establish from `client` to `cloudflare`, and cloudflare will route traffice over the established tunnel before being handed off from `cloudflared` to the target `service`. A diagram would be nice, maybe I'll add that some day.