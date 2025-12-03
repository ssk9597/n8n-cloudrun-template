// Network/storage layer: bucket for n8n

resource "random_id" "suffix" {
  byte_length = 4
}

module "storage" {
  source = "../../modules/storage"

  region     = var.region
  project_id = var.project_id
  suffix     = random_id.suffix.hex
}


