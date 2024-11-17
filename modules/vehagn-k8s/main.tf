module "talos" {
  source = "./talos"

  providers = {
    proxmox = proxmox
  }

  cilium = {
    values  = file("${path.module}//talos/inline-manifests/values.yaml")
    install = file("${path.module}//talos/inline-manifests/cilium-install.yaml")
  }

  cluster = var.cluster
  image = var.image
  nodes = var.nodes
}

# TODO: implement remaining modules
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
