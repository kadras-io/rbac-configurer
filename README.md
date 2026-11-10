# RBAC Configurer

![Test Workflow](https://github.com/kadras-io/rbac-configurer/actions/workflows/test.yml/badge.svg)
![Release Workflow](https://github.com/kadras-io/rbac-configurer/actions/workflows/release.yml/badge.svg)
[![The SLSA Level 3 badge](https://slsa.dev/images/gh-badge-level3.svg)](https://slsa.dev/spec/v1.0/levels)
[![The Apache 2.0 license badge](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Follow us on Bluesky](https://img.shields.io/static/v1?label=Bluesky&message=Follow&color=1DA1F2)](https://bsky.app/profile/kadras.bsky.social)

A Carvel package providing the roles that grant the supply chains of the Kadras [Engineering Platform](https://github.com/kadras-io/engineering-platform) the permissions they need in each workspace.

## ✨&nbsp; What's Included

* **Supply chain roles**. The `supply-chain-workload` and `supply-chain-deliverable` ClusterRoles, bound to the supply chain ServiceAccount in each workspace by the [Workspace Provisioner](https://github.com/kadras-io/workspace-provisioner) package.
* **Aggregation**. The roles have no rules of their own. Each platform package contributes the permissions its resources need with a ClusterRole carrying the role's aggregation label.

| ClusterRole | Aggregation label |
|-------------|-------------------|
| `supply-chain-workload` | `platform.kadras.io/aggregate-to-supply-chain-workload: "true"` |
| `supply-chain-deliverable` | `platform.kadras.io/aggregate-to-supply-chain-deliverable: "true"` |

## 🚀&nbsp; Getting Started

### Prerequisites

* Kubernetes 1.35+
* Carvel [`kctrl`](https://carvel.dev/kapp-controller/docs/latest/install/#installing-kapp-controller-cli-kctrl) CLI.
* Carvel [kapp-controller](https://carvel.dev/kapp-controller) deployed in your Kubernetes cluster. You can install it with Carvel [`kapp`](https://carvel.dev/kapp/docs/latest/install) (recommended choice) or `kubectl`.

```shell
kapp deploy -a kapp-controller -y \
  -f https://github.com/carvel-dev/kapp-controller/releases/latest/download/release.yml
```

### Installation

Add the Kadras [package repository](https://github.com/kadras-io/kadras-packages) to your Kubernetes cluster:

```shell
kctrl package repository add -r kadras-packages \
  --url ghcr.io/kadras-io/kadras-packages \
  -n kadras-system --create-namespace
```

<details><summary>Installation without package repository</summary>
The recommended way of installing the RBAC Configurer package is via the Kadras <a href="https://github.com/kadras-io/kadras-packages">package repository</a>. If you prefer not using the repository, you can add the package definition directly using <a href="https://carvel.dev/kapp/docs/latest/install"><code>kapp</code></a> or <code>kubectl</code>.

```shell
kubectl create namespace kadras-system
kapp deploy -a rbac-configurer-package -n kadras-system -y \
  -f https://github.com/kadras-io/rbac-configurer/releases/latest/download/metadata.yml \
  -f https://github.com/kadras-io/rbac-configurer/releases/latest/download/package.yml
```
</details>

Install the RBAC Configurer package:

```shell
kctrl package install -i rbac-configurer \
  -p rbac-configurer.packages.kadras.io \
  -v ${VERSION} \
  -n kadras-system
```

> **Note**
> You can find the `${VERSION}` value by retrieving the list of package versions available in the Kadras package repository installed on your cluster.
> 
> ```shell
> kctrl package available list -p rbac-configurer.packages.kadras.io -n kadras-system
> ```

Verify the installed packages and their status:

```shell
kctrl package installed list -n kadras-system
```

### Try It Out

Contribute a permission to the `supply-chain-workload` role with a ClusterRole carrying its aggregation label:

```shell
kubectl apply -f - <<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: supply-chain-workload-configmaps
  labels:
    platform.kadras.io/aggregate-to-supply-chain-workload: "true"
rules:
  - apiGroups: [""]
    resources: ["configmaps"]
    verbs: ["get", "list", "watch"]
EOF
```

Check that the permission has been aggregated into the role:

```shell
kubectl get clusterrole supply-chain-workload -o jsonpath='{.rules}'
```

## 📙&nbsp; Documentation

Documentation, tutorials and examples for this package are available in the [docs](docs) folder.
For documentation specific to the Kadras Engineering Platform, check out [kadras.io](https://kadras.io).

* [Roles and aggregation](docs/roles.md)
* [Configuration and ytt overlays](docs/configuration.md)
* [Upgrading and uninstalling](docs/upgrade.md)
* [Verifying the release](docs/verify-release.md)

## 🎯&nbsp; Configuration

The RBAC Configurer package has no configurable values. The generated resources can be customized via ytt overlays. See [configuration.md](docs/configuration.md).

## 🛠️&nbsp; Development

The development environment is defined with [devenv](https://devenv.sh). Enter it with `devenv shell`, or automatically with [direnv](https://direnv.net) after running `direnv allow`. Run `task --list` to see all the available tasks.

```shell
# Run the unit tests, which render the package and check the result without a cluster.
task test:config

# Create a local kind cluster and run the integration tests on it.
task cluster:setup
task test:integration

# Deploy the package from the local sources to the current cluster.
task dev
```

The unit tests are described in [test/unit/README.md](test/unit/README.md).

## 🛡️&nbsp; Security

The security process for reporting vulnerabilities is described in [SECURITY.md](SECURITY.md).

## 🖊️&nbsp; License

This project is licensed under the **Apache License 2.0**. See [LICENSE](LICENSE) for more information.
