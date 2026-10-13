let vetor = [4,2,3,1]

func calculo(i: Int) -> Int {
    return i+2
}

let vetorCalculado = vetor.map(calculo)
print(vetorCalculado)