# Roles

RBAC Configurer defines the ClusterRoles granting the Kadras supply chains the permissions they need in each workspace.

| ClusterRole | Granted to | Aggregation label |
|-------------|------------|-------------------|
| `supply-chain-workload` | The supply chains building and running workloads | `platform.kadras.io/aggregate-to-supply-chain-workload: "true"` |
| `supply-chain-deliverable` | The supply chains delivering workloads | `platform.kadras.io/aggregate-to-supply-chain-deliverable: "true"` |

The roles are bound to the supply chain ServiceAccount in each workspace by the [Workspace Provisioner](https://github.com/kadras-io/workspace-provisioner) package.

## Aggregation

The roles have no rules of their own. They're [aggregated ClusterRoles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#aggregated-clusterroles): the Kubernetes controller manager fills their rules with the ones of all the ClusterRoles carrying their aggregation label, and keeps them up to date as those ClusterRoles change.

This way, each package of the Kadras [Engineering Platform](https://github.com/kadras-io/engineering-platform) contributes the permissions its own resources need, and they're granted to the supply chains when the package is installed. For example, to let the supply chains manage Knative Services:

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: supply-chain-workload-knative
  labels:
    platform.kadras.io/aggregate-to-supply-chain-workload: "true"
rules:
  - apiGroups: ["serving.knative.dev"]
    resources: ["services"]
    verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
```

The same works for your own resources: apply a ClusterRole with the aggregation label, and the supply chains are granted its permissions in all the workspaces.

Check the rules aggregated into a role:

```shell
kubectl get clusterrole supply-chain-workload -o yaml
```
