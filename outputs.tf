output "hosts" {
  value = merge(
    module.nimbus_dashboard.hosts,
    module.nimbus_eth1_node_benchmark.hosts,
    module.nimbus_log_store.hosts,
    module.nimbus_nodes_portal_innova.hosts,
    module.nimbus_nodes_hoodi_innova_geth.hosts,
    module.nimbus_nodes_hoodi_innova_nec.hosts,
    module.nimbus_nodes_hoodi_innova_neth.hosts,
    module.nimbus_nodes_hoodi_innova_macm2.hosts,
    module.nimbus_nodes_hoodi_innova_windows.hosts,
    module.nimbus_nodes_mainnet_innova_erigon.hosts,
    module.nimbus_nodes_mainnet_innova_geth.hosts,
    module.nimbus_nodes_mainnet_innova_nec.hosts,
    module.nimbus_nodes_mainnet_stable_small.hosts,
    module.nimbus_nodes_mainnet_innova_archive.hosts,
    module.nimbus_nodes_sepolia_innova.hosts,
    module.obol_hoodi_innova.hosts,
  )
}
