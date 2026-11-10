# Upgrading

Upgrade the package with the new version.

```shell
kctrl package installed update -i rbac-configurer -v ${VERSION} -n kadras-system
```

## Uninstalling

```shell
kctrl package installed delete -i rbac-configurer -n kadras-system
```

> **Warning**
> Uninstalling the package deletes the supply chain roles. The RoleBindings referencing them in the workspaces are left in place, but grant no permissions, so the supply chains stop working until the package is installed again.

The ClusterRoles contributing rules to the roles via aggregation are owned by other packages, and they're not deleted.
