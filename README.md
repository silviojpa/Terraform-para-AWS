# Exemplos de Projetos com Terraform na AWS

Este repositório contém exemplos práticos de como usar o **Terraform** para provisionar infraestrutura na **Amazon Web Services (AWS)**. Os exemplos estão organizados em pastas, cada uma contendo um projeto diferente para que você possa entender e aplicar os conceitos de infraestrutura como código (IaC).

## O que é Terraform?

**Terraform** é uma ferramenta de código aberto para provisionar e gerenciar infraestrutura. Com ele, você pode definir a sua infraestrutura em arquivos de configuração (escritos em HCL - HashiCorp Configuration Language), permitindo que você crie, altere e versiona os recursos de forma segura e eficiente.

## Estrutura do Repositório

* **`Cluster Kubernetes com EKS`**: Demonstra como criar um cluster **Amazon EKS** com um grupo de nós gerenciados, a base para rodar suas aplicações em containers.
* **`Instância EC2 com Acesso a Banco de Dados`**: Mostra a criação de uma **VPC**, **subnets** e uma **instância EC2** configurada para se conectar a um banco de dados, ideal para ambientes de desenvolvimento ou pequenas aplicações.
* **`Serviço Serverless com Lambda e API Gateway`**: Um exemplo prático de arquitetura **serverless**, provisionando uma função **AWS Lambda** e expondo-a via **API Gateway**, tudo com Terraform.
* **`Site Estático com S3 e CloudFront`**: Guia para hospedar um site estático no **S3** e usar o **CloudFront** para entregá-lo globalmente com baixa latência, um caso de uso comum para sites e portfólios.

## Dicas para Começar

Para usar qualquer um dos exemplos, siga estes passos:

1.  **Pré-requisitos**:
    * Tenha o **Terraform** instalado em sua máquina.
    * Configure suas credenciais da **AWS**. A maneira mais simples é usando o AWS CLI.

2.  **Passos para Execução**:
    * Navegue até a pasta do exemplo que você deseja usar (ex: `cd "Serviço Serverless com Lambda e API Gateway"`).
    * **Inicie o projeto**: `terraform init` (Este comando baixa os plugins necessários para se comunicar com a AWS).
    * **Planeje as alterações**: `terraform plan` (Este comando mostra um resumo detalhado dos recursos que serão criados, alterados ou destruídos. **Sempre execute esta etapa para evitar surpresas!**).
    * **Aplique as alterações**: `terraform apply` (Este comando cria os recursos na sua conta da AWS conforme o plano. Digite `yes` para confirmar a criação).

3.  **Para Destruir a Infraestrutura**:
    * Quando não precisar mais dos recursos, você pode destruí-los para evitar custos: `terraform destroy`.

## Dicaa

Arquivo: `terraform.tfvars` (Onde ficam os valores)
Crie este arquivo na mesma pasta. O Terraform lê ele automaticamente. Não envie este arquivo para o GitHub.

```Terraform
aws_access_key = "SUA_ACCESS_KEY_AQUI"
aws_secret_key = "SUA_SECRET_KEY_AQUI"
```
Arquivo: `main.tf` (Atualizado)
No topo do seu `main.tf`, chame as variáveis:

````Terraform
provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
````
1. Como criar a Chave no Console AWS
Para conseguir esses valores acima, siga este caminho no console:

- Busque por IAM na barra de pesquisa.

- Vá em Usuários e clique no seu nome de usuário.

- Clique na aba Credenciais de segurança.

- Desça até Chaves de acesso e clique em Criar chave de acesso.

- Selecione CLI (Interface da Linha de Comando), marque a caixa de confirmação e avance.

- Copie o Access Key e o Secret Key para o seu arquivo terraform.tfvars.

2. Segurança: Você pode adicionar o arquivo terraform.tfvars ao seu .gitignore. Assim, seu código (main.tf) pode ser compartilhado sem expor suas senhas.

- Flexibilidade: Se precisar mudar de região ou de conta, você altera apenas um arquivo.

- Dica de Ouro: A forma mais segura recomendada pela AWS é não colocar as chaves no código, mas sim rodar o comando aws configure no seu terminal. O Terraform é inteligente o suficiente para ler as credenciais diretamente da sua máquina sem você precisar escrever access_key no arquivo .tf

---
## Contribuições

Sinta-se à vontade para explorar os exemplos, sugerir melhorias ou adicionar novos projetos. Qualquer contribuição é bem-vinda!
