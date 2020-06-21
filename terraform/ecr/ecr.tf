resource "aws_ecr_repository" "registry" {
    name = "sallai-chemaxon"
}

output "ecr_url" {
    value = aws_ecr_repository.registry.repository_url
}
