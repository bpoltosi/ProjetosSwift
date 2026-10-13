var velocidade = 0
let voltas = 5

for i in 0...voltas-1{
    
    if(i + 1 > velocidade){
        velocidade += i*2
    } else {
        velocidade += (velocidade+1)
    }
}

print(velocidade)