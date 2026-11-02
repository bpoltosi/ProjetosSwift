# ProjetosSwift

Repositório de estudos, exercícios e desafios desenvolvidos em **Swift**, com foco em fundamentos da linguagem, interfaces SwiftUI, consumo de APIs e integração com dispositivos.

## Organização

- `Package.swift`, `Sources/` e `Tests/` — pacote Swift Package Manager e estrutura de testes.
- `hackatruck/hackatruck-ead/` — exercícios introdutórios de Swift.
- `hackatruck/presencial/semana01/` — primeiros desafios presenciais, incluindo interfaces e entradas do usuário.
- `hackatruck/presencial/semana02/` — desafios de navegação, listas, mapas, APIs REST, CRUD, sensores e integração com IoT.

## Projetos e temas presentes

- Interfaces declarativas com SwiftUI.
- Navegação, listas, mapas e localização.
- Consumo de API REST e organização em Model, Service e ViewModel.
- Catálogo de jogos de tabuleiro e operações de dados.
- Leitura de sensor de umidade e comunicação via WebSocket/API.
- Aplicação de cardápio com operações de consulta, criação, atualização e exclusão.
- Exemplos de integração entre aplicativo e código para Arduino.

Cada desafio possui arquivos e instruções próprias; consulte o README do respectivo diretório quando disponível.

## Executar

Para os projetos Swift Package Manager na raiz, com Swift instalado:

```bash
swift build
swift test
```

Os desafios SwiftUI presenciais são projetos de aplicativo independentes e devem ser abertos em ambiente Apple compatível, normalmente pelo Xcode. Os exemplos de IoT também podem exigir placa, firmware, rede local e serviços externos.

## Status

Repositório de aprendizagem em evolução. Os desafios documentam atividades e protótipos; a presença de código não significa que todos os fluxos estejam integrados ou validados em hardware real.