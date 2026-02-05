variable "aws_region" {
  default     = "us-east-1"
  description = "Região onde o projeto foi criado"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true
}

variable "db_name" {
  default     = "database-silvio-luiz"
  description = "Nome do banco RDS"
}

variable "bucket_name" {
  default     = "site-cadastro-silvio-luiz"
  description = "Nome do Bucket S3 para o seu HTML"
}
