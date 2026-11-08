# Ресурс для создания сети VPC в Yandex Cloud
resource "yandex_vpc_network" "descheduler" {
  name = "descheduler-vpc" # Имя сети VPC
}

# Ресурс для создания подсети в зоне из переменной zone
resource "yandex_vpc_subnet" "descheduler" {
  v4_cidr_blocks = ["10.0.1.0/24"]                   # CIDR блок для подсети (IP-диапазон)
  zone           = var.zone                          # Зона, где будет размещена подсеть
  network_id     = yandex_vpc_network.descheduler.id # Сеть, к которой будет привязана подсеть
  route_table_id = yandex_vpc_route_table.rt.id      # Маршрутизация исходящего трафика через NAT-шлюз
}

# Публичный IP-адрес для NAT-шлюза
resource "yandex_vpc_address" "nat" {
  name = "descheduler-nat-pip"
  external_ipv4_address {
    zone_id = yandex_vpc_subnet.descheduler.zone
  }
}

# NAT-шлюз для исходящего трафика из приватной подсети
resource "yandex_vpc_gateway" "nat" {
  name = "descheduler-nat-gw"
  shared_egress_gateway {}
}

# Таблица маршрутизации: весь исходящий трафик (0.0.0.0/0) направляем через NAT-шлюз
resource "yandex_vpc_route_table" "rt" {
  name       = "descheduler-rt-nat"
  network_id = yandex_vpc_network.descheduler.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    gateway_id         = yandex_vpc_gateway.nat.id
  }
}
