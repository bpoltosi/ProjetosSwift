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
}