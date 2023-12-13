resource "digitalocean_ssh_key" "my_key" { 
  name       = "dig_oc_key_1"
  public_key = file(var.my_key)
}

locals {
  count = length (var.devs)
}

locals {
  ipv4 = digitalocean_droplet.do_devops[*].ipv4_address
}

resource "digitalocean_droplet" "do_devops" {
  count  = local.count
  name	  = var.devs[count.index]
  tags	 = [var.tag1,var.tag2]
  size   = "s-1vcpu-1gb"
  image  = "ubuntu-22-04-x64"
  region = var.reg_do
  ssh_keys = [digitalocean_ssh_key.my_key.fingerprint,data.digitalocean_ssh_key.rebrain_key.fingerprint]
}

resource "aws_route53_record" "www" {
  count   = local.count
  zone_id = data.aws_route53_zone.selected.zone_id
  name	  = var.devs[count.index]
  type    = "A"
  ttl     = "300"
  records = [local.ipv4[count.index]]
}

resource "local_file" "ansible_inventory" {
  content  =    templatefile("ansible.tftpl",{
      ansible_connection = "ssh"
      ansible_host = digitalocean_droplet.do_devops[*].ipv4_address
      ansible_port = 22
      ansible_user = var.user
      ansible_ssh_private_key_file = file(var.priv_key)
      })
  filename = "${path.module}/inventory.yaml"
}

resource "null_resource" "ansible_playbook" {
  connection {
    type     = "ssh"
    user     = var.user
    host     = element(digitalocean_droplet.do_devops[*].ipv4_address,0)
    private_key = file(var.priv_key)
    agent = false
  }
  provisioner "local-exec"{
    command = "sleep 60 &&  ansible-playbook nginx.yaml;"
  }
    depends_on = [ digitalocean_droplet.do_devops, aws_route53_record.www, local_file.ansible_inventory ] 
}
