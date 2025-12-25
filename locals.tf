locals {
  # 고정 Private IP 주소 (서브넷 범위: 172.31.48.0/20)
  server_private_ip  = "172.31.48.10"
  mongodb_private_ip = "172.31.48.20"
  es_private_ip      = "172.31.48.30"
  nlp_private_ip     = "172.31.48.40"
}
