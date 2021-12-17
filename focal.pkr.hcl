source "vagrant" "ubuntu-focal-amd64" {
  communicator = "ssh"
  source_path  = "ubuntu/focal64"
  provider     = "virtualbox"
}

build {
  sources = ["source.vagrant.ubuntu-focal-amd64"]

  provisioner "file" {
    source      = "files/python-venv.sh"
    destination = "/tmp/python-venv.sh"
  }

  provisioner "file" {
    source      = "files/salt-apply"
    destination = "/tmp/salt-apply"
  }

  provisioner "shell" {
    inline = [
      "sudo mv -v /tmp/python-venv.sh /etc/profile.d/",
      "sudo chown root:root /etc/profile.d/python-venv.sh",
      "sudo chmod 644 /etc/profile.d/python-venv.sh",

      "sudo mv -v /tmp/salt-apply /usr/local/bin/",
      "sudo chown root:root /usr/local/bin/salt-apply",
      "sudo chmod 700 /usr/local/bin/salt-apply",
    ]
  }

  provisioner "shell" {
    scripts         = ["files/bootstrap.sh"]
    execute_command = "chmod +x {{ .Path }}; sudo bash -c '{{ .Vars }} {{ .Path }}'"
  }
}
