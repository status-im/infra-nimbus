output "hosts" {
  value = merge(
    module.nimbus_dashboard.hosts,
    module.nimbus_log_store.hosts,
    module.nimbus_geth_goerli.hosts,
    module.nimbus_geth_mainnet.hosts,
    module.nimbus_nodes_mainnet_hetzner.hosts,
    module.nimbus_nodes_mainnet_stable_small.hosts,
    module.nimbus_nodes_prater_stable_large.hosts,
    module.nimbus_nodes_prater_testing_large.hosts,
    module.nimbus_nodes_prater_unstable_large.hosts,
    module.nimbus_nodes_prater_windows.hosts,
    module.nimbus_nodes_prater_hetzner.hosts,
    module.nimbus_nodes_prater_macos.hosts,
  )
}
