locals {
  /* Volumes */
  pyrmont_root_vol_size = 20
  pyrmont_data_vol_size = 150
  pyrmont_data_vol_type = "io1"
  pyrmont_data_vol_iops = 2500
  /* Instances */
  pyrmont_large_instance_type = "z1d.large"
  pyrmont_small_instance_type = "t3a.medium"
}
