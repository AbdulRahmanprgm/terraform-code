module "ecr" {
  source = "./modules/ecr"

  repositories         = var.repositories
  keep_last_images     = var.keep_last_images
  image_tag_mutability = var.image_tag_mutability
  default_tags         = var.default_tags
}
