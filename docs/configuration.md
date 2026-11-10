# Configuration

The package has no configurable values: the roles are the same in every installation, and their permissions are contributed via aggregation. See [roles.md](roles.md). The generated resources can still be customized via ytt overlays.

## ytt overlays

kapp-controller applies the [ytt overlays](https://carvel.dev/ytt/docs/latest/ytt-overlays/) stored in a Secret on top of the package configuration, when the PackageInstall references it with the `ext.packaging.carvel.dev/ytt-paths-from-secret-name.<n>` annotation. See [PackageInstall](https://carvel.dev/kapp-controller/docs/latest/package-install-extensions/).

For example, to add a label to all the roles:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: rbac-configurer-overlays
  namespace: kadras-system
stringData:
  roles.yml: |
    #@ load("@ytt:overlay", "overlay")
    #@overlay/match by=overlay.subset({"kind":"ClusterRole"}), expects="1+"
    ---
    metadata:
      labels:
        #@overlay/match missing_ok=True
        example.com/team: platform
```

Reference the Secret from the PackageInstall:

```shell
kubectl annotate packageinstall rbac-configurer -n kadras-system \
  ext.packaging.carvel.dev/ytt-paths-from-secret-name.0=rbac-configurer-overlays
```

All the generated resources have the `app.kubernetes.io/component: rbac-configurer` label.

> **Note**
> To grant the supply chains more permissions, contribute a ClusterRole with the aggregation label rather than overlaying the roles' rules, which the Kubernetes controller manager overwrites. See [roles.md](roles.md).
