locals {
  folder_id  = var.folder_id
  network_id = yandex_vpc_network.descheduler.id

  subnet_b_id   = yandex_vpc_subnet.descheduler-b.id
  subnet_d_id   = yandex_vpc_subnet.descheduler-d.id
  subnet_e_id   = yandex_vpc_subnet.descheduler-e.id
  subnet_b_zone = yandex_vpc_subnet.descheduler-b.zone
  subnet_d_zone = yandex_vpc_subnet.descheduler-d.zone
  subnet_e_zone = yandex_vpc_subnet.descheduler-e.zone

  # Публичный IP балансировщика Traefik → FQDN Grafana через sslip.io
  ingress_ip   = yandex_vpc_address.ingress.external_ipv4_address[0].address
  grafana_fqdn = "grafana.${local.ingress_ip}.sslip.io"
}
