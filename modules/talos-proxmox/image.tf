locals {
  version = var.image.version
  schematic = file("${path.module}/image/schematic.yaml")
  image_id = "${talos_image_factory_schematic.this.id}_${local.version}"

  update_version = coalesce(var.image.update_version, var.image.version)
  update_schematic = coalesce(var.image.update_schematic, local.schematic)
  update_image_id = "${talos_image_factory_schematic.updated.id}_${local.update_version}"
}

resource "talos_image_factory_schematic" "this" {
  schematic = local.schematic
}

resource "talos_image_factory_schematic" "updated" {
  schematic = local.update_schematic
}

resource "proxmox_virtual_environment_download_file" "orig-image" {
  for_each = toset(distinct([for i in var.nodes : "${i.host_node}_no-schematic-id_${local.version}"]))

  node_name    = split("_", each.key)[0]
  content_type = "iso"
  datastore_id = var.image.proxmox_datastore

  file_name               = "talos-${talos_image_factory_schematic.this.id}-${split("_", each.key)[2]}-${var.image.platform}-${var.image.arch}.img"
  url                     = "${var.image.factory_url}/image/${talos_image_factory_schematic.this.id}/${split("_", each.key)[2]}/${var.image.platform}-${var.image.arch}.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}

resource "proxmox_virtual_environment_download_file" "updated-image" {
  for_each = toset(distinct([for i in var.nodes : "${i.host_node}_no-schematic-id_${local.version}"]))

  node_name    = split("_", each.key)[0]
  content_type = "iso"
  datastore_id = var.image.proxmox_datastore

  file_name               = "talos-${talos_image_factory_schematic.updated.id}-${split("_", each.key)[2]}-${var.image.platform}-${var.image.arch}.img"
  url                     = "${var.image.factory_url}/image/${talos_image_factory_schematic.updated.id}/${split("_", each.key)[2]}/${var.image.platform}-${var.image.arch}.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}

# resource "proxmox_virtual_environment_download_file" "this" {
#   # for_each = toset(distinct([for k, v in var.nodes : "${v.host_node}_${v.update == true ? local.update_image_id : local.image_id}"]))
#   for_each = toset(distinct([for k, v in var.nodes : "${v.host_node}_${v.update == true ? local.skl_workaround_orig_key : local.skl_workaround_updated_key}"]))
#   # for_each = toset([ "pve2_${local.image_id}", "pve2_${local.update_image_id}" ])
#   # for_each = toset([ "pve2_orig_1.2.3", "pve2_update_3.2.1}" ])

#   node_name    = split("_", each.key)[0]
#   content_type = "iso"
#   datastore_id = var.image.proxmox_datastore

#   # ex.: talos-ce4c980550dd2ab1b17bbf2b08801c7eb59418eafe8f279833297925d67c7515-v1.8.1-nocloud-amd64.img
#   file_name               = "talos-${split("_", each.key)[1]}-${split("_", each.key)[2]}-${var.image.platform}-${var.image.arch}.img"
#   url                     = "${var.image.factory_url}/image/${split("_", each.key)[1]}/${split("_", each.key)[2]}/${var.image.platform}-${var.image.arch}.raw.gz"
#   decompression_algorithm = "gz"
#   overwrite               = false
# }
