resource "aws_ecr_repository" "repository" {
    name = var.docker_image_name
}

output "ecr_url" {
    value = aws_ecr_repository.repository.repository_url
}
