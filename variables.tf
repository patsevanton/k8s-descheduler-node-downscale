variable "folder_id" {
  type        = string
  description = "Yandex Cloud folder id"
}

variable "zone" {
  type        = string
  description = "Зона доступности для подсети, мастера и группы узлов"
  default     = "ru-central1-d"
}
