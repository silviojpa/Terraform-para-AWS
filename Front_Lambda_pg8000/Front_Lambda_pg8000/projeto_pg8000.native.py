import pg8000.native
import json

def lambda_handler(event, context):
    # Cabeçalhos padrão que resolvem 99% dos problemas de CORS
    headers = {
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, OPTIONS",
        "Access-Control-Allow-Headers": "Content-Type, Authorization, X-Amz-Date, X-Api-Key, X-Amz-Security-Token"
    }

    # Detecta o método de várias formas para não ter erro
    method = event.get('requestContext', {}).get('http', {}).get('method', 
             event.get('httpMethod', ''))

    # Se for OPTIONS, retorna 200 OK imediatamente com os headers
    if method == 'OPTIONS':
        return {
            "statusCode": 200,
            "headers": headers,
            "body": ""
        }

    try:
        # Processa o POST real
        body = json.loads(event.get('body', '{}'))
        
        conn = pg8000.native.Connection(
            host="database-1.c0roumiqaaqr.us-east-1.rds.amazonaws.com",
            database="postgres",
            user="postgres",
            password="19892016",
            port=5432
        )
        
        sql = "INSERT INTO usuarios (nome, email, idade, endereco) VALUES (:n, :e, :i, :en)"
        conn.run(sql, n=body.get('nome'), e=body.get('email'), i=body.get('idade'), en=body.get('endereco'))
        
        return {
            "statusCode": 200,
            "headers": headers,
            "body": json.dumps({"message": "Usuario cadastrado com sucesso!"})
        }
        
    except Exception as e:
        return {
            "statusCode": 400,
            "headers": headers,
            "body": json.dumps({"error": str(e)})
        }