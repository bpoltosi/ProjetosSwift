class Bicicleta {
    let rodas = 2
    var dono: String

    init(dono: String){
        self.dono = dono
    }

    func emprestarPara(para: String, horas: Int){
        print("A bicicleta de \(dono) foi emprestada" +
        "para \(para) por \(horas) horas")
    }

    private func tipoDeBicicleta() -> String{

        var tipo: String = ""

        switch rodas {
            
            case 2:
            tipo = "Comum"

            case 3:
            tipo = "Triciclo"

            case 4:
            tipo = "Quadriciclo"

            default:
            tipo = "Desconhecido"
        }
        return tipo
    }
}