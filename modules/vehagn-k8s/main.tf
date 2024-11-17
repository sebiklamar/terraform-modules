locals {
  env      = "poc"
  vlan_id  = 104
  ctrl_cpu = 2
  ctrl_ram = 4096
  work_cpu = 2
  work_ram = 4096
  domain   = "test.iseja.net"
}

module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  image = {
    version        = "v1.8.1"
    update_version = "v1.8.2" # renovate: github-releases=siderolabs/talos
    schematic      = file("${path.module}/talos/image/schematic.yaml")
  }

  cilium = {
    values  = file("${path.module}//talos/inline-manifests/values.yaml")
    install = file("${path.module}/talos/inline-manifests/cilium-install.yaml")
  }

  cluster = {
    # ToDo resolve redudundant implementation
    talos_version   = "v1.8.2"
    name            = "${local.env}-talos-tg"
    proxmox_cluster = "iseja-lab"
    endpoint        = "10.7.4.111"
    gateway         = "10.7.4.1"
  }

  nodes = {
    "${local.env}-ctrl-01.${local.domain}" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      ip            = "10.7.4.111"
      vm_id         = 7004111
      vlan_id       = "${local.vlan_id}"
      cpu           = "${local.ctrl_cpu}"
      ram_dedicated = "${local.ctrl_ram}"
      # update        = true
    }
    "${local.env}-ctrl-02.${local.domain}" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      ip            = "10.7.4.112"
      vm_id         = 7004112
      vlan_id       = "${local.vlan_id}"
      cpu           = "${local.ctrl_cpu}"
      ram_dedicated = "${local.ctrl_ram}"
      # update        = true
    }
    "${local.env}-ctrl-03.${local.domain}" = {
      host_node     = "pve2"
      machine_type  = "controlplane"
      ip            = "10.7.4.113"
      vm_id         = 7004113
      vlan_id       = "${local.vlan_id}"
      cpu           = "${local.ctrl_cpu}"
      ram_dedicated = "${local.ctrl_ram}"
      # update        = true
    }
    "${local.env}-work-01.${local.domain}" = {
      host_node     = "pve2"
      machine_type  = "worker"
      ip            = "10.7.4.114"
      vm_id         = 7004114
      vlan_id       = "${local.vlan_id}"
      cpu           = "${local.work_cpu}"
      ram_dedicated = "${local.work_ram}"
      # update        = true
    }
    "${local.env}-work-02.${local.domain}" = {
      host_node     = "pve2"
      machine_type  = "worker"
      ip            = "10.7.4.115"
      vm_id         = 7004115
      vlan_id       = "${local.vlan_id}"
      cpu           = "${local.work_cpu}"
      ram_dedicated = "${local.work_ram}"
      # update        = true
    }
  }

}

# module "sealed_secrets" {
#   depends_on = [module.talos]
#   source     = "./bootstrap/sealed-secrets"

#   providers = {
#     kubernetes = kubernetes
#   }

#   // openssl req -x509 -days 365 -nodes -newkey rsa:4096 -keyout sealed-secrets.key -out sealed-secrets.cert -subj "/CN=sealed-secret/O=sealed-secret"
#   cert = {
#     cert = file("${path.module}/bootstrap/sealed-secrets/certificate/sealed-secrets.cert")
#     key  = file("${path.module}/bootstrap/sealed-secrets/certificate/sealed-secrets.key")
#   }
# }

# module "proxmox_csi_plugin" {
#   depends_on = [module.talos]
#   source     = "./bootstrap/proxmox-csi-plugin"

#   providers = {
#     proxmox    = proxmox
#     kubernetes = kubernetes
#   }

#   proxmox = var.proxmox
# }

# module "volumes" {
#   depends_on = [module.proxmox_csi_plugin]
#   source     = "./bootstrap/volumes"

#   providers = {
#     restapi    = restapi
#     kubernetes = kubernetes
#   }
#   proxmox_api = var.proxmox
#   volumes = {
#     pv-test = {
#       node = "pve2"
#       size = "100M"
#       vmid = 9410
#     }
#     # pv-sonarr = {
#     #   node = "cantor"
#     #   size = "4G"
#     # }
#     # pv-radarr = {
#     #   node = "cantor"
#     #   size = "4G"
#     # }
#     # pv-lidarr = {
#     #   node = "cantor"
#     #   size = "4G"
#     # }
#     # pv-prowlarr = {
#     #   node = "euclid"
#     #   size = "1G"
#     # }
#     # pv-torrent = {
#     #   node = "euclid"
#     #   size = "1G"
#     # }
#     # pv-remark42 = {
#     #   node = "euclid"
#     #   size = "1G"
#     # }
#     pv-keycloak = {
#       node = "pve2"
#       size = "2G"
#     }
#     # pv-jellyfin = {
#     #   node = "euclid"
#     #   size = "12G"
#     # }
#     # pv-netbird-signal = {
#     #   node = "abel"
#     #   size = "1G"
#     # }
#     # pv-netbird-management = {
#     #   node = "abel"
#     #   size = "1G"
#     # }
#     # pv-plex = {
#     #   node = "abel"
#     #   size = "12G"
#     # }
#     # pv-prometheus = {
#     #   node = "abel"
#     #   size = "10G"
#     # }
#     # pv-single-database = {
#     #   node = "euclid"
#     #   size = "4G"
#     # }
#   }
# }
