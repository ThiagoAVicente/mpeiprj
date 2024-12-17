clear
clc

falsosPositivos = 0;
for notUsed = 1:20
    %wb = waitbar(0, "Creating Bloom Filter");
    
    m = 15000; %quantos elementos vao ser adicionados
    n = 287552; % tamanho do filtro
    
    k = round(n*log10(2) / m); % calcular k otimo (k = funcoes de hash que vao ser usadas)
    filtroBloomUsers = COUNTINGBF_class(n, k); %criar filtro bloom
    
    %waitbar(100);
    %delete(wb)
    %clear wb
    
    caract = ['a':'z' 'A':'Z'];
    chaves = unique(geradorChaves(m, 4, 20, caract)); %gera chaves aleatorias
    chaves = [chaves, chaves]; %faz todas as chaves de repetirem 2 vezes
    
    limiar = 2;
    %wb = waitbar(0, "Add users");
    
    userRepeated = 0; %variavel que guarda quantos nomes repetidos
    counter = 1;
    userRepeatedCell = cell(0);
    for i = 1:m
        
        name = chaves{i};
        
        if isa(name, 'missing') %no dataset pode haver linhas sem user name
            continue            %entao este if faz com que o programa nao "morra"
        end                     %caso haja uma linha sem username
        
        filtroBloomUsers = filtroBloomUsers.addElement(name); %adiciona o userName ao filtro
        %waitbar(i/m);
    end
    
    %delete(wb)
    %clear wb
    
    %wb = waitbar(0, "Checking");
    for i = 1:m
        
        name = chaves{i};
        
        if isa(name, 'missing') %no dataset pode haver linhas sem user name
            continue            %entao este if faz com que o programa nao "morra"
        end                     %caso haja uma linha sem username
        
        if ( filtroBloomUsers.isRepeatedLessThan(name, limiar) == 1 && (ismember(name, userRepeatedCell) == false)) %limiar+1 para testar falsos positivos
    
            userRepeated = userRepeated + 1; %adiciona o userName ao filtro
            userRepeatedCell{userRepeated} = name;
        end
        %waitbar(i/m);
    end
    %delete(wb)
    %clear wb

    falsosPositivos = falsosPositivos + userRepeated;
    clear chaves
end

media = falsosPositivos / 20;
disp("Media falsos positivos = " + media);