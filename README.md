# Desafio Bravo

## Objetivo

Desenvolver uma API que realiza a conversão monetária com cotações verdadeiras e atuais

## Exemplos

### Câmbio
Para convertermos uma moeda para outra, é usado `GET /` com os parâmetros `from`, `to`, `amount`. 

 - `from` é a moeda de origem
 - `to` é a moeda de destino
 - `amount`é a quantidade a ser convertida

Ex: Converter 1 Real Brasileiro para Peso Boliviano
````curl -X GET http://127.0.0.1:4567/?from=BRL&to=USD&amount=1````

A resposta seria:
```
{
	"data": {
		"from": "BRL",
		"to": "BOB",
		"amount": 10.0,
		"rate": 13.050601683584112
	}
}
```


### Adicionar Moeda
Para adicionar uma nova moeda, é usado `POST /add` com os parâmetros `initials`e `rate`.

 - `initials` é a sigla da moeda
 - `rate` é o seu valor em dólar

Ex: Adicionar moeda chamada ABC com rate de 2.5
````curl -d "initials=ABC&rate=2.5" -X POST http://localhost:4567/add````


A resposta seria:
```
{
	"data": {
		"name": "ABC",
		"rate": 2.5
	}
}
```



### Deletar Moeda
Para deletar uma moeda, é usado `DELETE /delete/currency`, onde `currency`é a moeda a ser deletada

Ex: Deletar a moeda ABC
```` curl -X DELETE http://localhost:4567/delete/ABC ````

Nesse caso não haveria resposta, e a API retornaria um simples status code `204 No Content`

---

## Descrição dos arquivos do projeto
```
api/
├── app
│   ├── controllers
│   │   └── exchange_contoller.rb			# Controller do câmbio
│   ├── models
│   │   └── currency_model.rb				# Modelo das Moedas
│   └── views
├── config
│   ├── app.rb								# Main da aplicação
│   ├── database.yml						# Configuração do banco
│   └── puma.rb								# Configuração do servidor
├── config.ru								# Configuração do RACK
├── db
│   ├── db.rb								# Configuração da conexão do banco
│   └── seed.rb								# Arquivo que popula o banco 
├── lib
│   └── cache_redis.rb						# Lib do cache usando redis
├── log										# Pasta de Logs
├── Rakefile								# Arquivo onde as tarefas são descritas
├── spec
│   ├── controller
│   │   └── exchange_spec.rb				# Testes do controller Exchange
│   ├── model
│   │   └── currency_spec.rb				# Testes do modelo Currency
│   └── spec_helper.rb						# Configuração dos testes
└── tmp
    ├── pids
    │   ├── puma.pid
    │   └── puma.state
    └── sockets
        └── puma.sock
```

### Tecnologias usadas

 - [Ruby](https://www.ruby-lang.org/pt/)
 - [Sinatra](https://sinatrarb.com/)
 - [Redis](https://redis.io/)
 - [RSpec](https://rspec.info/)
 - [PostgreSQL](https://www.postgresql.org/)
 - [Docker](https://www.docker.com/)
 - [Docker-Compose](https://docs.docker.com/compose/)


## Rodando o projeto

````
# Clone o repositório
https://github.com/fecristovao/challenge-bravo.git

# Entre no diretório da API
cd challenge-bravo

# Inicie os containers
docker-compose up -d
````

## Testes
Após rodar o projeto temos as seguintes possibilidades de testes

### Todos os testes
`docker-compose run web rake test:all`

### Testes de controllers
`docker-compose run web rake test:controllers`

### Testes de models
`docker-compose run web rake test:models`

## ENVs do projeto

Dentro do arquivo .env passamos para alguns valores necessários para o funcionamento da API

 - `PORT`é a porta que o servidor irá escutar novas conexões
 - `POSTGRES_USER`é o usuário do banco de dados
 - `POSTGRES_PASSWORD`é a senha do banco de dados
 - `RACK_ENV`diz ao servidor em qual ambiente ele estará funcionando, podendo ser:
	 - `development`, ambiente de desenvolvimento
	 - `test`, ambiente de teste
	 - `production`, ambiente de produção
 - `WEB_CONCURRENCY` diz o máximo de workers para o servidor
 - `MAX_THREADS`diz o máximo de Threads por worker
 - `CACHE_TIMEOUT`especifica em quanto tempo expira o cache (em segundos)
 - `CACHE_PAGINATION`especifica o tamanho da página do cache inicial
 - `DB_SEED`especifica em quanto tempo o banco relacional será atualizado (em segundos)

