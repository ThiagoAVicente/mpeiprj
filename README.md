# Projeto de MPEI: **Análise de Comentários com Técnicas Probabilísticas**

## Objetivo do Projeto  
O objetivo do projeto foi implementar um sistema de análise de comentários utilizando as seguintes ferramentas probabilísticas:  
- **Classificador Naive Bayes**: para categorizar os comentários.
- **MinHash e LSH (opcional)**: para encontrar semelhança entre comentários.
- **Filtro de Bloom**: para verificar a existência de palavras-chave específicas nos comentários.
- **Filtro de Contagem**: para análise estatística e frequência de palavras.

---

## Descrição do Sistema  
O sistema permite:  
1. **Navegação pelos comentários**:
   - Utilizando o **Filtro de Bloom** para verificar a presença de palavras-chave rapidamente.
   - Avaliando a similaridade entre os comentários com **MinHash** e, opcionalmente, **LSH**.
2. **Análise dos Comentários**:
   - Classificação dos comentários com o classificador **Naive Bayes** em categorias (e.g., "Positivo", "Negativo", "Neutro").
   - Apresentação de métricas baseadas em um **Filtro de Contagem**.

---

## Exemplo de Funcionamento  

1. Um comentário é introduzido no sistema.  
2. O Filtro de Bloom verifica se contém palavras previamente adicionadas à estrutura.  
3. A similaridade com outros comentários é avaliada usando MinHash.  
4. O classificador Naive Bayes classifica o tom e a categoria do comentário.  
5. Dados sobre a frequência de palavras são exibidos.

---

## Imagem de Exemplo  

Aqui está uma representação gráfica do fluxo do sistema:

![Exemplo do Sistema de Análise de Comentários](./caminho_para_a_imagem_exemplo.png)

---

## Instruções para Execução  
1. Certifique-se de ter instalado todos os pacotes necessários.
2. Navegue até o diretório do projeto.
3. Execute o arquivo `main_com_interface.m` para iniciar o sistema.
4. Siga as instruções na interface para navegar e analisar os comentários.

---

## Conclusão  
Este projeto demonstrou a aplicação de técnicas probabilísticas para o processamento e análise de dados textuais, destacando sua eficiência e utilidade em sistemas reais.
