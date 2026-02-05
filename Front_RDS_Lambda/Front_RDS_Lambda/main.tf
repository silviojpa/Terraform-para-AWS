provider "aws" {
  region = var.aws_region
}

# 1. Bucket S3 para o seu HTML 
resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "upload_index" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "index.html"
  source       = "./index.html" 
  content_type = "text/html"
}

# 2. Security Group (Porta 5432)
# Mantido para facilitar a liberação do banco manual depois
resource "aws_security_group" "rds_sg" {
  name        = "rds-lambda-1"
  description = "Permite acesso ao PostgreSQL"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Função Lambda
# Removida a configuração de VPC para evitar travamento de ENIs
resource "aws_lambda_function" "cadastro_usuario" {
  function_name = "salvar-usuario-postgreSQL"
  handler       = "projeto.lambda_handler" # NOME_DO_ARQUIVO.NOME_DA_FUNCAO
  runtime       = "python3.12"
  role          = aws_iam_role.lambda_exec.arn
  timeout       = 30
}

# 4. IAM Role para a Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_v2" # Nome alterado para evitar conflito com a anterior
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Permissão para a Lambda gerar logs (ajuda a debugar)
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" # Coloca a sua arn
}