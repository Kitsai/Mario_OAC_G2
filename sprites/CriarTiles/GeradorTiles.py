from lista_de_tiles import lista_tiles
# Importa o mapa em bytes
from mapa import mapa
# Define as dimenssoes do mapa
largura = 3376
altura = 240

# Minha posicao na Matriz
posicao = 0

# Cria a lista de Tiles

# Lista Auxiliar
lista_aux2 = []

# Pula Linha
pulaLinha = largura


# Percorre a matriz pela altura em 16 em 16
for linha in range(int(altura/16)):
    # Vai pular uma coluna de tile para mim
    pulaTile = largura*16*linha
    # Posicao pula uma coluna de Tile
    posicao = pulaTile

    # Percorre Toda a Linha Atual
    for elemento in range(int(largura/16)):
        lista_aux1 = []
        posicao = pulaTile
        posicao = posicao + 16*elemento
        contador2 = 0

        while contador2 < 16:
            contador = 0
            while contador < 16:
                lista_aux1.append(mapa[contador+posicao])
                contador += 1

            posicao = posicao+pulaLinha
            contador2 = contador2+1

        lista_aux2.append(lista_aux1)
        if lista_aux1 not in lista_tiles:
            lista_tiles.append(lista_aux1)

matriz00 = []


for x in lista_aux2:
    for _ in range(len(lista_tiles)):
        if x == lista_tiles[_]:
            matriz00.append(_)

contar = 1


for x in range(len(matriz00)):
    print(f"{matriz00[x]}, ", end="")
    if contar == largura/16:
        print()
        contar = 0
    contar = contar+1


contador = 0
""""
for x in lista_tiles:
    for y in x:
        print(y, end = "")
        print(", ", end = "")
    contador = contador + 1

contador = 0
"""
for x in lista_tiles:

    print(x, end="")
    print(", ")
    print()
    contador = contador+1
print(len(lista_tiles))
