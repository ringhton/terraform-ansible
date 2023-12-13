data "digitalocean_ssh_key" "rebrain_key" {
  name = "REBRAIN.SSH.PUB.KEY"
}

data "aws_route53_zone" "selected" {
  name         = "devops.rebrain.srwx.net"
} 
