import sys
import time

def process_lines(file_path, line_indices):
    """
    Função que lê um arquivo e processa as linhas indicadas pelos índices fornecidos, com um intervalo de 1 segundo entre as leituras.

    :param file_path: Caminho do arquivo a ser lido.
    :param line_indices: Lista de índices das linhas a serem processadas (1-indexed).
    """
    # Abrir o arquivo
    with open(file_path, 'r') as file:
        # Ler todas as linhas do arquivo
        lines = file.readlines()

        # Iterar sobre os índices fornecidos
        for index in line_indices:
            # Verificar se o índice está dentro do número de linhas
            if index > 0 and index <= len(lines):
                # Mostrar ou processar a linha
                print(f"Processando linha {index}: {lines[index - 1].strip()}")
            else:
                print(f"Índice {index} fora do alcance do arquivo.")

            # Esperar 1 segundo
            time.sleep(1)

def parse_indices(indices_str):
    """
    Converte a string de índices no formato '[i1 i2 i3 ...]' para uma lista de inteiros.

    :param indices_str: A string que representa os índices das linhas a serem processadas.
    :return: Lista de índices como inteiros.
    """
    # Remover os colchetes e espaços extras, depois dividir os números
    indices_str = indices_str.strip('[]')
    indices_list = indices_str.split()

    # Converter os índices para inteiros
    return [int(index) for index in indices_list]

if __name__ == "__main__":
    # Verificar se os argumentos estão corretos
    if len(sys.argv) != 3:
        print("Uso: python script.py <caminho_do_ficheiro> <indices>")
        sys.exit(1)

    # Captura os argumentos da linha de comando
    file_path = sys.argv[1]  # Caminho do arquivo
    indices_str = sys.argv[2]  # String com os índices no formato '[i1 i2 i3 ...]'

    # Converter os índices para uma lista de inteiros
    line_indices = parse_indices(indices_str)

    # Chamar a função para processar as linhas
    process_lines(file_path, line_indices)
