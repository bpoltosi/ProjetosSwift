class FormaGeometrica {
    
    func descricao(){
        print("Descricao de uma forma geometrica")
        
    }
}

class Quadrado: FormaGeometrica{
    var tamanho: Int

    init(tamanho: Int){
        self.tamanho = tamanho
    }

    func area() {
        return tamanho * tamanho
    }

    override func descricao() {
        super.descricao()
        print("Quadrado da area \(area())")
    }
}

class Retangulo: FormaGeometrica{
    var largura, altura : Int;

    init(altura: Int, largura: Int){
        self.altura = altura
        self.largura = largura
    }

    func area() -> Int{
        return altura * altura
    }
}

let quadrado = Quadrado(tamanho: 10)
let retangulo = Retangulo(altura: 10, largura: 10)

if(quadrado.area() == retangulo.area()){
    retangulo.descricao()
}else{
    print("Areas diferentes")
}