class FormaGeometrica{

    func descricao(){
        print("Descricao de uma forma geometrica")
    }

    func area() -> Int {
        return 0
    }

    func imprimeArea(){
        print(area())
    }
}

class Quadrado: FormaGeometrica{
    var tamanho : Int;
    
    init(tamanho: Int){
        self.tamanho = tamanho
    }

    override func descricao() {
        super.descricao()
        print("quadrado da area \(area())")
    }
}

class Retangulo: FormaGeometrica{
    var largura, altura : Int;

    init(altura: Int, largura: Int){
        self.altura = altura
        self.largura = largura
    }

    override func area() -> Int {
        return altura * largura
    }
}

let formas = [Quadrado(tamanho: 10), Retangulo(altura: 10, largura: 10)]

for forma in formas{
    forma.imprimeArea()
}