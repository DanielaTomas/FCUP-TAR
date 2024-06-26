provider "google" {

  credentials = file(var.gcp_credentials_path)
  project     = var.gcp_project_id

}

resource "google_compute_firewall" "server-ports" {
  name    = "server-ports"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80","443"]  
  }

  source_ranges = ["0.0.0.0/0"] 

  target_tags = ["server-ports"]
}

resource "google_compute_firewall" "dns-ports" {
  name    = "dns-ports"
  network = "default"

  allow {
    protocol = "udp"
    ports    = ["53"]  
  }

  allow {
    protocol = "tcp"
    ports    = ["53"]  
  }

  source_ranges = ["0.0.0.0/0"] 

  target_tags = ["dns-ports"]
}

resource "google_compute_firewall" "cache-ports" {
  name    = "cache-ports"
  network = "default"

  allow {
    protocol = "udp"
    ports    = ["8080"]  
  }

  allow {
    protocol = "tcp"
    ports    = ["8080"]  
  }

  source_ranges = ["0.0.0.0/0"] 

  target_tags = ["cache-ports"]
}


module "dns" {
  source  = "./modules/dns"


  ssh_pub_key_path = var.ssh_pub_key_path
  gce_ssh_user = var.gce_ssh_user
  gcp_default_machine_type = var.gcp_default_machine_type
  gcp_default_machine_image = var.gcp_default_machine_image
}

module "cache" {
  source               = "./modules/cache"


  ssh_pub_key_path = var.ssh_pub_key_path
  gce_ssh_user = var.gce_ssh_user
  gcp_default_machine_type = var.gcp_default_machine_type
  gcp_default_machine_image = var.gcp_default_machine_image
}


module "server" {
  source               = "./modules/server"


  ssh_pub_key_path = var.ssh_pub_key_path
  gce_ssh_user = var.gce_ssh_user
  gcp_default_machine_type = var.gcp_default_machine_type
  gcp_default_machine_image = var.gcp_default_machine_image
}
