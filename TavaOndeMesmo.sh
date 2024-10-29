#!/bin/bash


diretorio="./Biblioteca"
diretorioBD="LeP.txt"
livro=""


home () {
    echo "-----O que deseja fazer hoje?-----"
    echo "1 - Adicionar página em leitura."
    echo "2 - Ver página que parou."
    echo "3 - Abrir livro."
    read -p "Escolha uma das possibilidades (1, 2 ou 3): " escolha

    if [ "$escolha" -eq "1" ]; then
        inicial
    elif [ "$escolha" -eq "2" ]; then
        reader
    elif [ "$escolha" -eq "3" ]; then
        openTheCheca
    else
        echo "Você não digitou uma das opções válidas."
    fi
}

# Função para exibir a lista de livros e registrar a escolha do usuário
inicial () {
    contador=1
    echo -e "\n-----Escolha o livro que está lendo-----"
    for arquivo in "$diretorio"/*
    do
        echo "$((contador++)) - $(basename "$arquivo")"
    done
    read -p "Digite o número do livro: " livro

    graber
}

# Função para processar a escolha do usuário
graber () {
    contador=1
    for arquivo in "$diretorio"/*
    do
        if [ "$contador" -eq "$livro" ]; then
            echo "Você escolheu: $(basename "$arquivo")"
            livro_escolhido=$(basename "$arquivo")
            keeper "$livro_escolhido"
        fi
        contador=$((contador + 1))
    done
}

# Função para perguntar ao usuário em qual página ele parou no livro selecionado
keeper () {
    livro_escolhido=$1
    read -p "Em qual página você parou em '$livro_escolhido'? " pagina
    echo "Você parou na página $pagina do livro '$livro_escolhido'."

    # Verifica se o livro já está registrado no arquivo
    if grep -q "^$livro_escolhido:" "$diretorioBD"; then
        # Se o livro já está no arquivo, atualiza a página correspondente
        sed -i "/^$livro_escolhido:/s|:[0-9]*$|:$pagina|" "$diretorioBD"
    else
        # Se o livro não está no arquivo, adiciona a nova entrada
        echo "$livro_escolhido:$pagina" >> "$diretorioBD"
    fi

    echo "Informação salva em '$diretorioBD'."
}

#funcao mostra livro e pagina que o ususario anotara anteriormente
reader () {
    echo -e "\n"
    cat "$diretorioBD"
}

openTheCheca () {
echo -e "\n-----Escolha o livro que deseja abrir-----"

    # Lista todos os arquivos PDF no diretório
    arquivos=("$diretorio"/*.pdf)

    # Verifica se há arquivos PDF no diretório
    if [ ${#arquivos[@]} -eq 0 ]; then
        echo "Não há arquivos PDF no diretório especificado."
        return 1
    fi

    # Exibe a lista de arquivos PDF disponíveis
    for ((i = 0; i < ${#arquivos[@]}; i++)); do
        echo "$((i + 1)) - $(basename "${arquivos[i]}")"
    done

    read -p "Digite o número do livro: " livro

    # Verifica se o número do livro selecionado é válido
    if [ "$livro" -lt 1 ] || [ "$livro" -gt ${#arquivos[@]} ]; then
        echo "Número de livro inválido."
        return 1
    fi

    # Obtém o caminho completo do arquivo PDF escolhido
    arquivo_pdf="${arquivos[livro - 1]}"

    # Verifica se o arquivo PDF existe
    if [ ! -f "$arquivo_pdf" ]; then
        echo "Arquivo PDF não encontrado."
        return 1
    fi

    # Abre o arquivo PDF no Document Viewer (Evince)
    evince "$arquivo_pdf"
}


#inicia o codigo
home
