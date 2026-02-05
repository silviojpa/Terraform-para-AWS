import json
import os
import psycopg2

def lambda_handler(event, context):
    try:
        # 1. Captura os dados do formulário HTML
        body = json.loads(event['body'])
        nome = body.get('nome')
        email = body.get('email')
        idade = body.get('idade')
        endereco = body.get('endereco')

        # 2. Conecta ao seu RDS
        conn = psycopg2.connect(
            host="database-silvio-luiz.c0roumiqaaqr.us-east-1.rds.amazonaws.com",
            database="postgres",
            user="postgres",
            password="19892016"
        )
        
        cur = conn.cursor()
        
        # 3. Insere os dados na tabela que você criou
        sql = "INSERT INTO usuarios (nome, email, idade, endereco) VALUES (%s, %s, %s, %s)"
        cur.execute(sql, (nome, email, idade, endereco))
        
        conn.commit()
        cur.close()
        conn.close()

        return {
            'statusCode': 200,
            'headers': {
                'Access-Control-Allow-Origin': '*',
                'Content-Type': 'application/json'
            },
            'body': json.dumps({'mensagem': f'Usuário {nome} cadastrado com sucesso!'})
        }

    except Exception as e:
        print(f"Erro: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({'erro': 'Falha ao salvar no banco de dados'})
        }
