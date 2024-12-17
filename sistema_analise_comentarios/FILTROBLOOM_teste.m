clear
clc

falsosPositivos = 0;
for notUsed = 1:20
    
    m = 15000; %quantos elementos vao ser adicionados
    n = 287552; % tamanho do filtro
    
    k = floor(n*log10(2) / m); % calcular k otimo (k = funcoes de hash que vao ser usadas)
    filtroBloomUsers = FILTROBLOOM_class(n, k); %criar filtro bloom
    
    
    caract = ['a':'z' 'A':'Z'];
    chaves = unique(geradorChaves(m, 4, 20, caract)); %gera chaves aleatorias
    
    userRepeated = 0; %variavel que guarda quantos nomes repetidos
    counter = 1;
    userRepeatedCell = cell(0);
    for i = 1:m
        
        name = chaves{i};
        
        if isa(name, 'missing') %no dataset pode haver linhas sem user name
            continue            %entao este if faz com que o programa nao "morra"
        end                     %caso haja uma linha sem username
    
        if(filtroBloomUsers.checkElement(name) == 1 && ~ismember(name, userRepeatedCell))  %checa se o userName já está no filtro
            userRepeated = userRepeated + 1;
            userRepeatedCell{userRepeated} = name;
            counter = counter + 1;
        else
            filtroBloomUsers = filtroBloomUsers.addElement(name); %adiciona o userName ao filtro
        end
    
    end
    
    colisoes = userRepeated; %todos os nomos sao unicos
    
    falsosPositivos = falsosPositivos + colisoes;
end

media = falsosPositivos/20;

disp("Em media teve " +  media + " falsos positivos");