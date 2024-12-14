# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2024-12-14

### Added

- new optional `nodes.[].disk_size` parameter for VM disk size (defaulted to vehagn's `20` GB size)
- new optional `nodes.[].bridge` parameter for network bridge (defaulted to vehagn's `vmbr0`)

### Changed

- hosts are registered in k8s with their FQDN (#15)
  UPGRADE NOTICE: you will need to remove existings hosts registered with their short hostname manually from the (kubernetes) cluster as the FQDN host version will be re-added to the cluster instead of replacing its short hostname counterpart (per `kubectl delete node <node-short-hostname>`)
  <br>
  Otherwise you'll get a stalled 
  `tofu: module.talos.data.talos_cluster_health.this: Still reading... [10m0s elapsed]`

### Dependencies

- update terraform kubernetes v2.33.0 → v2.35.0 (#9, #14)
- update terraform proxmox v0.67.1 → v0.68.1 (#10)

## [0.2.0] - 2024-12-08

### Added

- Keep a Changelog
- proxmox csi role & user get env-specific prefix, default is empty (e.g. `dev-CSI` and default `CSI`)
- CPU configurable (default CPU stays `x86-64-v2-AES`, though not hard-coded any longer)

### Fixed

- treat path to cilium values as file (regression, bootstrapping not working)

### Dependencies

- update dependency cilium/cilium v1.16.2 → v1.16.4 (#13)

## [0.1.0] - 2024-12-04

First 0.1 version which is feature-par with upstream terraform module (plus additions)

### Added

- cilium values configurable: cilium `values.yaml` can be provided as input variable (`cilium_values`); otherwise an inbuilt default will be used (`talos/inline-manifests/cilium-values.default.yaml`), since as v0.0.1 version

## [0.0.3] - 2024-11-23

### Added

- implemented proxmox-csi volumes and sealed secrets
  (leaving remaining feature configuration of cilium values instead of hard-coding)

### Changed

- allow 1 controller node only instead of min. 3

### Dependencies

- update terraform talos to v0.6.1 (#6)
- update terraform kubernetes to v2.33.0 (#7)
- update terraform proxmox to v0.67.1 (#8)

## [0.0.2] - 2024-11-17

### Added

- use variables for node and other env.specific config

### Changed

- change default `nodes.[].datastore_id` back to `local-zfs` (was: `local-enc`)

## [0.0.1] - 2024-11-17

First implementation of [vehagn/homelab/tofu/kubernetes](https://github.com/vehagn/homelab/commit/4e517fa18656a1d112041516b03a0d8164989123) as dedicated terraform module

Notable changes to the upstream version are:

### Added

- optional `nodes.[].vlan_id` parameter for defining VLAN ID
- install gateway api manifests before cilium deployment (cherry-picking [vehagn/homelab PR 78](https://github.com/vehagn/homelab/pull/78/commits))

### Changed

- `nodes.[].datastore_id` defaulted to `local-enc` (was: `local-zfs`)
- `nodes.[].mac_address` optional
- changed CPU model to `x86-64-v2-AES` (was: `host`)
- overwrite existing downloaded file from other module instance, hence limiting clashing with other module instances in the same proxmox cluster
- implemented initial workaround for `schematic_id` issue (see ) by not depending on the `schematic_id` in the resource id by having 2 instances of `proxmox_virtual_environment_download_file` (impl. option 4, cf. https://github.com/vehagn/homelab/issues/106#issuecomment-2481303369)

### Removed

- removed talos extensions:
  - `siderolabs/i915-ucode`
  - `siderolabs/intel-ucode`

### Known Issues

- node configuration hard-coded in module; needs to be moved to input variables in `terragrunt.hcl`
- sealed secrets and subsequent k8s bootstrapping not working yet - though you get a working k8s cluster (w/ cilium even)
- cilium values not configurable
- resources in proxmox clashing with other instances of this module in the same proxmox cluster (due to same name used)
