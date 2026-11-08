locals {
  folder_id  = var.folder_id
  network_id = yandex_vpc_network.descheduler.id

  # Стенд размещается в одной зоне: региональный мастер требует три рабочие
  # зоны, а в текущем облаке доступны только ru-central1-a и ru-central1-d.
  zone        = var.zone
  subnet_id   = yandex_vpc_subnet.descheduler.id
  subnet_zone = yandex_vpc_subnet.descheduler.zone

  # Публичный IP балансировщика Traefik → FQDN Grafana через sslip.io
  ingress_ip   = yandex_vpc_address.ingress.external_ipv4_address[0].address
  grafana_fqdn = "grafana.${local.ingress_ip}.sslip.io"
}
