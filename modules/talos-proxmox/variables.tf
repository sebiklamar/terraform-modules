variable "proxmox" {
  type = object({
    name         = string
    cluster_name = string
    endpoint     = string
    insecure     = bool
    username     = string
    api_token    = string
  })
  sensitive = true
}

variable "image" {
  description = "Talos image configuration"
  type = object({
    factory_url       = optional(string, "https://factory.talos.dev")
    version           = string
    update_schematic  = optional(string)
    update_version    = optional(string)
    arch              = optional(string, "amd64")
    platform          = optional(string, "nocloud")
    proxmox_datastore = optional(string, "local")
  })
}

variable "cluster" {
  description = "Cluster configuration"
  type = object({
    name            = string
    endpoint        = string
    gateway         = string
    talos_version   = string
    proxmox_cluster = string
  })
}

variable "nodes" {
  description = "Configuration for cluster nodes"
  type = map(object({
    host_node     = string
    vm_id         = number
    ip            = string
    vlan_id       = optional(number, null)
    machine_type  = optional(string, "q35")
    datastore_id  = optional(string, "local-zfs")
    mac_address   = optional(string, null)
    cpu           = optional(number, 1)
    ram_dedicated = optional(number, 512)
    update        = optional(bool, false)
    igpu          = optional(bool, false)
  }))
}
