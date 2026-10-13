protocol Calculavel{

    func calcula() -> Int
}

class Operacao: Calculavel{

    let x : Int;
    let y : Int;

    init(x:Int, y:Int){
        self.x = x
        self.y = y
    }

    func calcula() -> Int {
        return 0
    }
}

class Soma: Operacao{

    override func calcula() -> Int {
        return x + y
    }
}

class Subtracao: Operacao{

    override func calcula() -> Int {
        return x - y
    }
}

let operacoes = [Soma(x: 10, y: 20), Subtracao(x: 10, y: 20)]

for operacao in operacoes{
    print(operacao.calcula())
}