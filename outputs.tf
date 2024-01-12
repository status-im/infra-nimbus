output "hosts" {
  value = merge(
    module.nimbus_dashboard.hosts,
    module.nimbus_log_store.hosts,
    module.nimbus_geth_mainnet.hosts,
    module.nimbus_geth_goerli_innova.hosts,
    module.nimbus_nodes_fluffy_innova.hosts,
    module.nimbus_eth1_node_innova.hosts,
    module.nimbus_nodes_mainnet_innova.hosts,
    module.nimbus_nodes_mainnet_stable_small.hosts,
    module.nimbus_nodes_prater_stable_large.hosts,
    module.nimbus_nodes_prater_testing_large.hosts,
    module.nimbus_nodes_prater_unstable_large.hosts,
    module.nimbus_nodes_prater_innova.hosts,
    module.nimbus_nodes_prater_windows_innova.hosts,
    module.nimbus_nodes_prater_macm1_innova.hosts,
    module.nimbus_nodes_sepolia_innova.hosts,
    module.nimbus_nodes_holesky_innova_geth.hosts,
    module.nimbus_nodes_holesky_innova_erigon.hosts,
    module.nimbus_nodes_holesky_innova_neth.hosts,
  )
}
