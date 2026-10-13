protocol Clicavel {
    func onClick()
}

class elementoDeInterface: Clicavel{

    func descricao () -> String {
        return "ElementoDeInterface"
    }
    func onClick() {
        print("\(self.descricao()) foi clicado")
    }
}

class Botao: elementoDeInterface{

    override func descricao() -> String {
        return "\(super.descricao()) Botão"
    }
}

class Barra: elementoDeInterface{

    override func descricao() -> String {
        return "\(super.descricao()) Barra"
    }
}

let botao = Botao()
let barra = Barra()
let elementos: Array<elementoDeInterface> = [botao,barra]

for elemento in elementos{
    elemento.onClick()
}