# Fluxo gratuito: SwiftUI no Windows + validação no Mac

Este guia foi preparado para continuar o projeto do HackaTruck em um PC Windows, usando o GitHub para sincronizar o código e o Mac/Xcode durante as aulas para validar o app.

## O que dá para fazer no Windows

- Editar arquivos `.swift`, revisar a estrutura e escrever/refatorar a lógica.
- Trabalhar na API, JSON, Node-RED e documentação.
- Usar Git para criar commits e manter o trabalho sincronizado.
- Compilar e testar pacotes Swift de linha de comando que sejam compatíveis com Windows.

## O que precisa do Mac com Xcode

- Compilar o app iOS/SwiftUI como aplicativo Apple.
- Verificar a interface real, previews e comportamento do app.
- Executar no simulador ou iPhone e corrigir erros específicos de iOS.

A extensão Swift do VS Code ajuda com edição e recursos de linguagem, mas o suporte a projetos Xcode `.xcodeproj` é limitado. Não considere uma edição concluída até validar o projeto no Xcode.

## Configuração inicial no Windows

1. Instale [Visual Studio Code](https://code.visualstudio.com/).
2. Instale [Git for Windows](https://git-scm.com/download/win) ou [GitHub Desktop](https://desktop.github.com/).
3. No VS Code, instale a extensão **Swift** (publisher: `swiftlang`).
4. Clone `https://github.com/bpoltosi/ProjetosSwift.git` usando GitHub Desktop, ou no terminal:
   ```powershell
   git clone https://github.com/bpoltosi/ProjetosSwift.git
   cd ProjetosSwift
   ```
5. Abra a pasta clonada no VS Code. Edite o projeto em `hackatruck/presencial/semana02/Desafio05/`.

A toolchain Swift para Windows é opcional para editar o app. Instale-a apenas se também quiser compilar/testar código Swift de linha de comando: https://www.swift.org/install/windows/

## Ciclo de trabalho recomendado

1. No Windows, faça uma alteração pequena e salve os arquivos.
2. Confira o diff no painel Source Control do VS Code ou no GitHub Desktop.
3. Faça commit com uma mensagem específica, por exemplo `Corrige estado de carregamento do catálogo`.
4. Envie (push) para uma branch de trabalho no GitHub.
5. Na próxima aula, abra/atualize a branch no Mac, abra o projeto no Xcode e valide build, interface e API.
6. Se corrigir algo no Mac, faça commit e push. Depois, no Windows, sincronize antes de continuar.

**Evite editar o mesmo arquivo simultaneamente nos dois computadores.** Sempre sincronize antes de começar e antes de trocar de máquina.

## Atenção à URL da API do Desafio05

O código atual usa `http://127.0.0.1:1880/getJogos`. O endereço `127.0.0.1` significa “este próprio dispositivo”: no iPhone, aponta para o iPhone; no simulador, aponta para o Mac. Não aponta automaticamente para o servidor Node-RED remoto.

Quando for testar no iPhone ou no Mac, configure a URL base para o endereço acessível do seu servidor Node-RED (idealmente HTTPS). Não coloque credenciais, tokens ou segredos no repositório. Se o servidor só estiver acessível pela rede local, o iPhone/Mac precisa estar nessa rede ou usar um acesso remoto seguro.

## Checklist para cada aula no Mac

- [ ] Sincronizei a branch e confirmei que não há alterações locais que serão sobrescritas.
- [ ] Abri o projeto no Xcode.
- [ ] Compilei o app e corrigi os erros de build.
- [ ] Testei a interface no simulador ou iPhone.
- [ ] Testei `GET /getJogos` com a URL real do servidor.
- [ ] Fiz commit e push das correções.

## Links úteis

- [Swift para Windows — documentação oficial](https://www.swift.org/install/windows/)
- [Swift no VS Code — documentação](https://code.visualstudio.com/docs/languages/swift)
- [GitHub Desktop](https://desktop.github.com/)
