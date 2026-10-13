func exercicio(n: Int, c: Int) -> Int {

    var resultado, contador: Int;

    contador = c
    resultado = 0

    while (contador > 0){
        resultado = resultado + n % contador
        contador -= 1
    }
    return resultado
}

let exercicio1 = exercicio(n: 6, c: 5)
print(exercicio1)
