variable PUBLIC_KEY_FILE {}
variable PRIVATE_KEY_FILE {}
variable TARGET_URL {}

provider "digitalocean" {
  # token = "..." via env var
}

resource "digitalocean_ssh_key" "default" {
  name       = "do-default"
  public_key = file(var.PUBLIC_KEY_FILE)
}

resource "digitalocean_droplet" "jitsi-ubuntu" {
  name     = "jitsi-tf"
  image    = "ubuntu-18-04-x64"
  region   = "fra1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]

  connection {
    type        = "ssh"
    user        = "root"
    host        = digitalocean_droplet.jitsi-ubuntu.ipv4_address
    private_key = file(var.PRIVATE_KEY_FILE)
  }

  provisioner "remote-exec" {

    inline = [
      "echo '127.0.0.1 localhost ${var.TARGET_URL}' >> /etc/hosts",
      "wget -qO - https://download.jitsi.org/jitsi-key.gpg.key | sudo apt-key add -",
      "echo 'deb https://download.jitsi.org stable/' > /etc/apt/sources.list.d/jitsi-stable.list",
      "apt-get -y update"
    ]
  }
}

resource "digitalocean_project" "jitsi" {
  name        = "jitsi"
  description = "Jitsi video conferencing"
  purpose     = "Jitsi conferencing"
  resources   = [digitalocean_droplet.jitsi-ubuntu.urn]
}
