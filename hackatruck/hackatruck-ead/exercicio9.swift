class Sequencia {
    var valores: [Int] = []
    var numeroDeElementos = 0

    func imprimeSequencia() {
        print("Valores = \(valores)")
    }

    func geraSequencia() {
        valores = []
    }
}

class NumerosPares: Sequencia {

    init(tamanho: Int) {
        super.init()
        self.numeroDeElementos = tamanho
        geraSequencia()
    }

    override func geraSequencia() {
        valores = []
        for i in 0 ..< self.numeroDeElementos {
            valores.append(i * 2) 
        }
    }

    override func imprimeSequencia() {
        print("pares = \(valores)")
    }
}

class NumerosImpares: Sequencia {

    init(tamanho: Int) {
        super.init()
        self.numeroDeElementos = tamanho
        geraSequencia()
    }

    override func geraSequencia() {
        valores = []
        for i in 0 ..< self.numeroDeElementos {
            valores.append(i * 2 + 1) 
        }
    }

    override func imprimeSequencia() {
        print("impares = \(valores)")
    }
}

let sequencia1 = NumerosPares(tamanho: 10)
let sequencia2 = NumerosImpares(tamanho: 10)

for sequencia in [sequencia1, sequencia2] {
    sequencia.imprimeSequencia()
}