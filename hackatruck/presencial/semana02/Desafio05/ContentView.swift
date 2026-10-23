import SwiftUI

private struct JogoTabuleiro: Identifiable {
    let id = UUID()
    let nome: String
    let categoria: String
    let jogadores: String
    let duracao: String
    let dificuldade: String
    let descricao: String
    let simbolo: String
    let cor: Color
}

struct ContentView: View {
    @State private var busca = ""
    @State private var categoriaSelecionada = "Todos"
    @State private var favoritos: Set<String> = []
    @State private var jogoSelecionado: JogoTabuleiro?

    private let categorias = ["Todos", "Estratégia", "Família", "Cartas", "Cooperativo"]

    private let jogos: [JogoTabuleiro] = [
        JogoTabuleiro(
            nome: "Catan",
            categoria: "Estratégia",
            jogadores: "3–4 jogadores",
            duracao: "60–90 min",
            dificuldade: "Média",
            descricao: "Construa povoados, estradas e cidades, troque recursos e expanda sua presença na ilha.",
            simbolo: "hexagon.fill",
            cor: .orange
        ),
        JogoTabuleiro(
            nome: "Ticket to Ride",
            categoria: "Família",
            jogadores: "2–5 jogadores",
            duracao: "30–60 min",
            dificuldade: "Fácil",
            descricao: "Conecte cidades com rotas ferroviárias e cumpra seus objetivos antes dos outros jogadores.",
            simbolo: "tram.fill",
            cor: .blue
        ),
        JogoTabuleiro(
            nome: "Dixit",
            categoria: "Família",
            jogadores: "3–8 jogadores",
            duracao: "30 min",
            dificuldade: "Fácil",
            descricao: "Use a imaginação para dar pistas sobre cartas ilustradas sem revelar tudo aos demais.",
            simbolo: "sparkles",
            cor: .purple
        ),
        JogoTabuleiro(
            nome: "Pandemic",
            categoria: "Cooperativo",
            jogadores: "2–4 jogadores",
            duracao: "45 min",
            dificuldade: "Média",
            descricao: "Trabalhe em equipe, viaje pelo mundo e encontre curas para conter surtos de doenças.",
            simbolo: "cross.case.fill",
            cor: .green
        ),
        JogoTabuleiro(
            nome: "UNO",
            categoria: "Cartas",
            jogadores: "2–10 jogadores",
            duracao: "15–30 min",
            dificuldade: "Fácil",
            descricao: "Combine cores e números, use cartas especiais e seja o primeiro a ficar sem cartas.",
            simbolo: "rectangle.stack.fill",
            cor: .red
        ),
        JogoTabuleiro(
            nome: "Xadrez",
            categoria: "Estratégia",
            jogadores: "2 jogadores",
            duracao: "10–60 min",
            dificuldade: "Desafiadora",
            descricao: "Planeje cada movimento, proteja seu rei e tente dar xeque-mate no adversário.",
            simbolo: "crown.fill",
            cor: .brown
        )
    ]

    private var jogosFiltrados: [JogoTabuleiro] {
        jogos.filter { jogo in
            let correspondeCategoria = categoriaSelecionada == "Todos" || jogo.categoria == categoriaSelecionada
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

                    if jogosFiltrados.isEmpty {
                        ContentUnavailableView.search(text: busca)
                            .frame(maxWidth: .infinity, minHeight: 220)
                    } else {
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
                    RoundedRectangle(cornerRadius: 15)
                        .fill(jogo.cor.gradient)
                        .frame(height: 112)
                        .overlay {
                            Image(systemName: jogo.simbolo)
                                .font(.system(size: 42, weight: .medium))
                                .foregroundStyle(.white.opacity(0.95))
                        }

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
                    RoundedRectangle(cornerRadius: 24)
                        .fill(jogo.cor.gradient)
                        .frame(height: 180)
                        .overlay {
                            Image(systemName: jogo.simbolo)
                                .font(.system(size: 72, weight: .medium))
                                .foregroundStyle(.white)
                        }

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
