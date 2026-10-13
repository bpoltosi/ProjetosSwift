import Foundation

class Pessoa {

    var idade: Int
    var nome: String

    init(i: Int, n: String) {
        idade = i
        nome = n
    }

    func ultimoNome() -> String {
        return nome.components(separatedBy: " ").last!
    }
}

let pessoa = Pessoa(i: 20, n: "João da Silva")
let ultimoNome = pessoa.ultimoNome()

print(ultimoNome)