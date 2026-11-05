import SwiftUI

private struct JogoTabuleiro: Decodable, Identifiable {
    let id: Int
    let nome: String
    let descricao: String
    let jogadoresMin: Int
    let jogadoresMax: Int
    let duracaoMinutos: Int
    let idadeMinima: Int
    let categorias: [String]
    var categoria: String { categorias.joined(separator: " · ") }
    let dificuldade: String
    let imagemURL: String

    var jogadores: String {
        jogadoresMin == jogadoresMax
            ? "\(jogadoresMin) jogador\(jogadoresMin == 1 ? "" : "es")"
            : "\(jogadoresMin)–\(jogadoresMax) jogadores"
    }

    var duracao: String { "\(duracaoMinutos) min" }

    var simbolo: String {
        switch id {
        case 1: return "hexagon.fill"
        case 2: return "tram.fill"
        case 3: return "sparkles"
        case 4: return "cross.case.fill"
        case 5: return "rectangle.stack.fill"
        case 6: return "crown.fill"
        case 7: return "map.fill"
        case 8: return "square.grid.3x3.fill"
        case 9: return "person.3.fill"
        default: return "diamond.fill"
        }
    }

    var cor: Color {
        switch id {
        case 1: return .orange
        case 2: return .blue
        case 3: return .purple
        case 4: return .green
        case 5: return .red
        case 6: return .brown
        case 7: return .mint
        case 8: return .cyan
        case 9: return .indigo
        default: return .pink
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, nome, descricao, jogadoresMin, jogadoresMax
        case duracaoMinutos, idadeMinima, categoria, dificuldade, imagemURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        nome = try container.decode(String.self, forKey: .nome)
        descricao = try container.decode(String.self, forKey: .descricao)
        jogadoresMin = try container.decode(Int.self, forKey: .jogadoresMin)
        jogadoresMax = try container.decode(Int.self, forKey: .jogadoresMax)
        duracaoMinutos = try container.decode(Int.self, forKey: .duracaoMinutos)
        idadeMinima = try container.decode(Int.self, forKey: .idadeMinima)

        if let categoriaTexto = try? container.decode(String.self, forKey: .categoria) {
            categorias = [categoriaTexto]
        } else {
            categorias = try container.decode([String].self, forKey: .categoria)
        }

        dificuldade = try container.decode(String.self, forKey: .dificuldade)
        imagemURL = try container.decodeIfPresent(String.self, forKey: .imagemURL) ?? ""
    }
}

private struct RespostaJogos: Decodable {
    let jogos: [JogoTabuleiro]

    enum CodingKeys: String, CodingKey {
        case jogos
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let array = try? container.decode([JogoTabuleiro].self, forKey: .jogos) {
            jogos = array
        } else {
            let objeto = try container.decode([String: JogoTabuleiro].self, forKey: .jogos)
            jogos = Array(objeto.values)
        }
    }
}

private enum JogosAPI {
    // Configure API_BASE_URL em project.yml com o endereço do host Docker.
    // 127.0.0.1 é apenas fallback local; em um iPhone físico aponta para o próprio iPhone.
    static let baseURL = URL(
        string: Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String
            ?? "http://127.0.0.1:1880"
    )!
    static let endpoint = baseURL.appendingPathComponent("getJogos")

    static func buscarJogos() async throws -> [JogoTabuleiro] {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            throw NSError(
                domain: "JogosAPI",
                code: httpResponse.statusCode,
                userInfo: [NSLocalizedDescriptionKey: "A API respondeu com HTTP \(httpResponse.statusCode)."]
            )
        }

        let decoder = JSONDecoder()

        // Aceita os formatos mais comuns: [ {...} ], { "1": {...} } ou
        // { "jogos": [ {...} ] } / { "jogos": { "1": {...} } }.
        if let array = try? decoder.decode([JogoTabuleiro].self, from: data) {
            return array.sorted { $0.id < $1.id }
        }

        if let envelope = try? decoder.decode(RespostaJogos.self, from: data) {
            return envelope.jogos.sorted { $0.id < $1.id }
        }

        let objeto = try decoder.decode([String: JogoTabuleiro].self, from: data)
        return objeto.values.sorted { $0.id < $1.id }
    }
}

struct ContentView: View {
    @State private var busca = ""
    @State private var categoriaSelecionada = "Todos"
    @State private var favoritos: Set<String> = []
    @State private var jogoSelecionado: JogoTabuleiro?

    private let categorias = ["Todos", "Estratégia", "Negociação", "Família", "Rotas", "Criatividade", "Dedução", "Cooperativo", "Cartas", "Clássico", "Colocação de peças", "Abstrato", "Palavras", "Equipes", "Gestão de recursos"]

    @State private var jogos: [JogoTabuleiro] = []
    @State private var carregando = true
    @State private var erroAPI: String?

    @MainActor
    private func carregarJogos() async {
        carregando = true
        erroAPI = nil
        do {
            jogos = try await JogosAPI.buscarJogos()
        } catch {
            erroAPI = "Verifica se o Node-RED está ativo e se GET /getJogos devolve JSON válido. Detalhe: \(error.localizedDescription)"
        }
        carregando = false
    }

    private var jogosFiltrados: [JogoTabuleiro] {
        jogos.filter { jogo in
            let correspondeCategoria = categoriaSelecionada == "Todos" ||
                jogo.categorias.contains { $0.localizedCaseInsensitiveContains(categoriaSelecionada) }
            let correspondeBusca = busca.isEmpty ||
                jogo.nome.localizedCaseInsensitiveContains(busca) ||
                jogo.categoria.localizedCaseInsensitiveContains(busca)
            return correspondeCategoria && correspondeBusca
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    if carregando {
                        ProgressView("Carregando catálogo da API…")
                            .frame(maxWidth: .infinity, minHeight: 120)
                    } else if let erroAPI {
                        ContentUnavailableView {
                            Label("Não foi possível carregar os jogos", systemImage: "wifi.exclamationmark")
                        } description: {
                            Text(erroAPI)
                        } actions: {
                            Button("Tentar novamente") {
                                Task { await carregarJogos() }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }

                    cabecalho
                    campoBusca
                    filtroCategorias

                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(categoriaSelecionada == "Todos" ? "Explore os jogos" : categoriaSelecionada)
                                .font(.title2.bold())
                            Text("\(jogosFiltrados.count) jogos encontrados")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "square.grid.2x2.fill")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }

                    if !carregando && erroAPI == nil && jogosFiltrados.isEmpty {
                        ContentUnavailableView.search(text: busca)
                            .frame(maxWidth: .infinity, minHeight: 220)
                    } else if !jogosFiltrados.isEmpty {
                        LazyVGrid(
                            columns: [GridItem(.flexible(), spacing: 14), GridItem(.flexible(), spacing: 14)],
                            spacing: 14
                        ) {
                            ForEach(jogosFiltrados) { jogo in
                                cartaoJogo(jogo)
                            }
                        }
                    }

                    rodape
                }
                .padding(20)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Jogos de Tabuleiro")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $jogoSelecionado) { jogo in
                detalheJogo(jogo)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
        .tint(.indigo)
        .task {
            await carregarJogos()
        }
    }

    private var cabecalho: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "dice.fill")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(.indigo, in: RoundedRectangle(cornerRadius: 15))

                VStack(alignment: .leading, spacing: 3) {
                    Text("Noite de jogos")
                        .font(.title.bold())
                    Text("Encontre o próximo favorito da mesa.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }

            HStack(spacing: 12) {
                estatistica(valor: "\(jogos.count)", titulo: "Jogos", icone: "square.grid.2x2")
                estatistica(valor: "\(categorias.count - 1)", titulo: "Categorias", icone: "tag")
                estatistica(valor: "\(favoritos.count)", titulo: "Favoritos", icone: "heart")
            }
            .padding(.top, 6)
        }
    }

    private func estatistica(valor: String, titulo: String, icone: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icone)
                .foregroundStyle(.indigo)
            VStack(alignment: .leading, spacing: 2) {
                Text(valor).font(.headline.bold())
                Text(titulo).font(.caption).foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
    }

    private var campoBusca: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Buscar jogo ou categoria", text: $busca)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            if !busca.isEmpty {
                Button {
                    busca = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .accessibilityLabel("Limpar busca")
            }
        }
        .padding(14)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
    }

    private var filtroCategorias: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(categorias, id: \.self) { categoria in
                    let selecionada = categoriaSelecionada == categoria
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            categoriaSelecionada = categoria
                        }
                    } label: {
                        Text(categoria)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 15)
                            .padding(.vertical, 9)
                            .background(selecionada ? Color.indigo : Color(uiColor: .secondarySystemGroupedBackground), in: Capsule())
                            .foregroundStyle(selecionada ? .white : .primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selecionada ? .isSelected : [])
                }
            }
        }
    }

    private func cartaoJogo(_ jogo: JogoTabuleiro) -> some View {
        Button {
            jogoSelecionado = jogo
        } label: {
            VStack(alignment: .leading, spacing: 12) {
                ZStack(alignment: .topTrailing) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(jogo.cor.gradient)
                        if let url = URL(string: jogo.imagemURL), !jogo.imagemURL.isEmpty {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFill()
                                } else {
                                    Image(systemName: jogo.simbolo)
                                        .font(.system(size: 42, weight: .medium))
                                        .foregroundStyle(.white.opacity(0.95))
                                }
                            }
                            .frame(height: 112)
                            .frame(maxWidth: .infinity)
                            .clipped()
                        } else {
                            Image(systemName: jogo.simbolo)
                                .font(.system(size: 42, weight: .medium))
                                .foregroundStyle(.white.opacity(0.95))
                        }
                    }
                    .frame(height: 112)
                    .clipShape(RoundedRectangle(cornerRadius: 15))

                    Button {
                        alternarFavorito(jogo)
                    } label: {
                        Image(systemName: favoritos.contains(jogo.nome) ? "heart.fill" : "heart")
                            .font(.headline)
                            .foregroundStyle(favoritos.contains(jogo.nome) ? .red : .primary)
                            .padding(8)
                            .background(.regularMaterial, in: Circle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(favoritos.contains(jogo.nome) ? "Remover dos favoritos" : "Adicionar aos favoritos")
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text(jogo.nome)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text(jogo.categoria)
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.indigo)

                    Label(jogo.jogadores, systemImage: "person.2")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Label(jogo.duracao, systemImage: "clock")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(10)
            .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 20))
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.primary.opacity(0.05), lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
    }

    private func detalheJogo(_ jogo: JogoTabuleiro) -> some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(jogo.cor.gradient)
                        if let url = URL(string: jogo.imagemURL), !jogo.imagemURL.isEmpty {
                            AsyncImage(url: url) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFit()
                                } else {
                                    Image(systemName: jogo.simbolo)
                                        .font(.system(size: 72, weight: .medium))
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 180)
                        } else {
                            Image(systemName: jogo.simbolo)
                                .font(.system(size: 72, weight: .medium))
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    Text(jogo.nome)
                        .font(.largeTitle.bold())

                    Text(jogo.descricao)
                        .font(.body)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 12) {
                        detalheInfo(titulo: "Jogadores", valor: jogo.jogadores, icone: "person.2.fill")
                        detalheInfo(titulo: "Duração", valor: jogo.duracao, icone: "clock.fill")
                    }

                    detalheInfo(titulo: "Dificuldade", valor: jogo.dificuldade, icone: "chart.bar.fill")
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Button {
                        alternarFavorito(jogo)
                    } label: {
                        Label(
                            favoritos.contains(jogo.nome) ? "Remover dos favoritos" : "Adicionar aos favoritos",
                            systemImage: favoritos.contains(jogo.nome) ? "heart.slash" : "heart.fill"
                        )
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.indigo)
                }
                .padding(22)
            }
            .navigationTitle("Detalhes do jogo")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func detalheInfo(titulo: String, valor: String, icone: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(titulo, systemImage: icone)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(valor)
                .font(.subheadline.weight(.semibold))
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(uiColor: .secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
    }

    private var rodape: some View {
        Text("Escolha um jogo, reúna a galera e divirta-se.")
            .font(.footnote)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
            .padding(.top, 4)
    }

    private func alternarFavorito(_ jogo: JogoTabuleiro) {
        if favoritos.contains(jogo.nome) {
            favoritos.remove(jogo.nome)
        } else {
            favoritos.insert(jogo.nome)
        }
    }
}

#Preview {
    ContentView()
}
