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


