# Desafio 05 — Catálogo de jogos de tabuleiro

Aplicativo SwiftUI para consultar um catálogo de jogos fornecido por uma API local desenvolvida no Node-RED.

## Arquivo principal
- `ContentView.swift`: interface, modelo de leitura e chamada GET da API.

## API Node-RED
- Método: `GET`
- Rota: `/getJogos`
- URL padrão no código: `http://127.0.0.1:1880/getJogos`

O endpoint deve responder com JSON válido contendo jogos com os campos `id`, `nome`, `descricao`, `jogadoresMin`, `jogadoresMax`, `duracaoMinutos`, `idadeMinima`, `categoria`, `dificuldade` e `imagemURL`. O catálogo pode ser um array de jogos ou um objeto cujos valores são os jogos. O campo `categoria` aceita texto ou lista de textos.

## Configuração de rede
- No simulador, `127.0.0.1` aponta para o Mac que executa o simulador.
- Em um iPhone físico, altere a URL base para o endereço IP local do computador que executa o Node-RED.
- O app e o Node-RED precisam estar acessíveis pela mesma rede. Como a URL usa HTTP, talvez seja necessário configurar App Transport Security no projeto para desenvolvimento local.

## Estado atual
O app consome o GET e exibe o catálogo. O endpoint POST ainda não está integrado à interface; o fluxo Node-RED de POST/Split deve ser validado separadamente antes de implementar criação ou persistência de jogos.
