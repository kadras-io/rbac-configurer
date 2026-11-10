# The labels set on all the RBAC resources.
def labels():
  return {"app.kubernetes.io/component": "rbac-configurer"}
end

# The ClusterRoles bound to the supply chain ServiceAccount in each workspace.
# Their rules are aggregated from the ClusterRoles with the matching aggregation label.
supply_chain_roles = ["supply-chain-workload", "supply-chain-deliverable"]

# The label marking a ClusterRole whose rules are aggregated into the given role.
def aggregation_label(role):
  return "platform.kadras.io/aggregate-to-" + role
end
