locals {
  # 고정 Private IP 주소 정의
  server_private_ip  = "10.0.1.10"  # Public Subnet (10.0.1.0/24)
  mongodb_private_ip = "10.0.2.20"  # Private Subnet (10.0.2.0/24)
  es_private_ip      = "10.0.2.30"  # Private Subnet (10.0.2.0/24)
  nlp_private_ip     = "10.0.2.40"  # Private Subnet (10.0.2.0/24)
}
