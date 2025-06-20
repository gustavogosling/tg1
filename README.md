# Título: Análise regional de compartimentos de relevo a partir da implementação de Gradiente Horizontal Total: Uma proposta de algoritmo 

## Esclarecimentos

Os scripts estão na pasta processamento, com os scripts de "rotina" para ambos os apendices gerando a maior parte das grades processadas de acordo com o algoritmo proposto.

## Código

O algoritmo foi desenvolvido em *shell* utilizando AWK, GMT e um algumas linhas usei bc (problemas com casas decimais ...).

<img src="https://github.com/gustavogosling/tg1/blob/main/figuras/figura01.png" alt="Algoritmo">

Ainda atualizarei melhor o repositório, mas com esta versão é possível gerar boa parte das Figuras do trabalho e a maior parte das grades processadas apresentadas (exceção de algumas grades criadas e apagadas na geração de figuras).

## Como rodar

Basta baixar o repositório (ou clonar) e digitar **make all** no diretório tg1 para gerar as figuras. 

Para o Makefile funcionar todos os scripts tem que ser rodados do diretório tg1, então para rodar um processamento com tamanho de grade 1 x 1, largura
de filtro de 15 km, porcentagem do máximo de GHT de cada subgrade de 40 % e limiar de ruído de GHT de 4 m/km, tem que rodar:

`bash processamento/run.sh 10 15 40 4`

Se quiser usar 0.5 x 0.5 tem que rodar:

`bash processamento/run.sh 5 15 40 4`

## Figuras

As Figuras serão geradas no diretório geral. AS Figuras 1 e 11 estão disponíveis no diretório figuras
