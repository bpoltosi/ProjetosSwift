# Arquitetura gratuita — SwiftUI + Docker

## Objetivo

Manter o app **iOS nativo em SwiftUI**. O Windows serve para editar o repositório e administrar os containers; a compilação iOS acontece em um runner macOS do GitHub Actions. O servidor doméstico hospeda a API Node-RED, não o compilador iOS.

```text
PC Windows (VS Code + Git)
        | push / pull request
        v
GitHub: bpoltosi/ProjetosSwift
        |
        v
GitHub Actions (macOS + Xcode + XcodeGen)
        | gera ProjetosSwift.xcodeproj e compila
        v
Build para iOS Simulator (sem assinatura)
        
iPhone / simulador
        | HTTP na rede local
        v
Servidor doméstico (Docker)
        └── Node-RED :1880
              └── GET /getJogos -> JSON
```

## O que foi configurado no repositório

- `project.yml`: define o app iOS `JogosTabuleiro` usando os dois arquivos Swift já existentes no Desafio 05. O XcodeGen gera o projeto Xcode durante o CI; não é necessário manter arquivos gerados no Git.
- `.github/workflows/ios-build.yml`: compila o app em um runner macOS quando há alterações relevantes ou quando o workflow é iniciado manualmente.
- `ContentView.swift`: lê a URL base da API da chave `API_BASE_URL` no Info.plist. Se a chave não existir, usa `http://127.0.0.1:1880` como fallback local.
- Nenhum fluxo Node-RED ou banco de dados existente é sobrescrito.

## Configurar o endereço da API

Edite `INFOPLIST_KEY_API_BASE_URL` em `project.yml` e use o endereço acessível do host Docker na sua rede local, por exemplo:

```yaml
INFOPLIST_KEY_API_BASE_URL: http://192.168.1.50:1880
```

O IP acima é apenas um exemplo. Descubra o IP LAN real do servidor e confirme que o roteador não muda o endereço (reserva DHCP é recomendada). O endpoint final deve responder em:

```text
http://IP-DO-SERVIDOR:1880/getJogos
```

Teste essa URL no navegador do iPhone conectado ao mesmo Wi-Fi antes de testar o app. `127.0.0.1` sempre significa o próprio dispositivo: no iPhone, não aponta para o servidor Docker.

## Docker / Node-RED

Se o Node-RED já está funcionando em Docker, mantenha o container e os volumes atuais. Confirme apenas:

1. A porta `1880` está publicada para a rede local.
2. O fluxo tem um nó HTTP In para `GET /getJogos` e termina em HTTP Response.
3. A resposta tem Content-Type `application/json` e JSON compatível com o modelo em `ContentView.swift`.
4. O serviço não está exposto diretamente à internet. Para acesso externo, use HTTPS por proxy reverso e autenticação; não faça port-forward público de 1880.
5. Faça backup do volume de dados do Node-RED antes de alterar flows ou atualizar containers.

Não é necessário colocar o Node-RED e o app iOS no mesmo container. O app é instalado no iPhone; ele chama a API pela rede.

## Como usar

1. Abra um Pull Request ou envie uma alteração nos arquivos do Desafio 05.
2. Em **Actions**, abra **iOS - build SwiftUI**.
3. Aguarde o passo **Compilar SwiftUI para iOS Simulator**. O sucesso confirma compilação, não teste visual nem instalação em iPhone.
4. Para compilar manualmente, abra Actions e execute o workflow com **Run workflow**.
5. Depois de alterar o endereço da API em `project.yml`, faça commit e envie as alterações para disparar nova compilação.

## Limites importantes

- A compilação iOS acontece no macOS hospedado pelo GitHub; o Docker doméstico em Windows/Linux não substitui o Xcode.
- O workflow compila para o simulador e não assina nem instala o app em um iPhone físico.
- Teste visual, permissões de rede local e comportamento real do app ainda precisam ser verificados no simulador ou iPhone com Xcode.
- Como o projeto atual usa HTTP para a API local, a política App Transport Security pode precisar de uma exceção apropriada no projeto iOS. Prefira HTTPS quando possível e não adicione exceções globais permissivas sem necessidade.
- Os runners macOS padrão são gratuitos e ilimitados para repositórios públicos segundo a documentação do GitHub. Se a visibilidade do repositório mudar, revise as cotas aplicáveis.
