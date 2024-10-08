output "hosts" {
  value = merge(
    module.nimbus_dashboard.hosts,
    module.nimbus_eth1_node_innova.hosts,
    module.nimbus_eth1_node_benchmark,
    module.nimbus_geth_holesky.hosts,
    module.nimbus_geth_mainnet.hosts,
    module.nimbus_log_store.hosts,
    module.nimbus_nodes_fluffy_innova.hosts,
    module.nimbus_nodes_holesky_innova_erigon.hosts,
    module.nimbus_nodes_holesky_innova_geth.hosts,
    module.nimbus_nodes_holesky_innova_neth.hosts,
    module.nimbus_nodes_holesky_innova_macm2.hosts,
    module.nimbus_nodes_holesky_innova_windows.hosts,
    module.nimbus_nodes_mainnet_innova_nel.hosts,
    module.nimbus_nodes_mainnet_innova_erigon.hosts,
    module.nimbus_nodes_mainnet_innova_geth.hosts,
    module.nimbus_nodes_mainnet_stable_small.hosts,
    module.nimbus_nodes_sepolia_innova.hosts,
  )
}
