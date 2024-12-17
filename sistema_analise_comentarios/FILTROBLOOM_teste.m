clear
clc

wb = waitbar(0, "Creating Bloom Filter");

m = 15000; %quantos elementos vao ser adicionados
n = 287552; % tamanho do filtro

k = floor(n*log10(2) / m); % calcular k otimo (k = funcoes de hash que vao ser usadas)
filtroBloomUsers = FILTROBLOOM_class(n, k); %criar filtro bloom

waitbar(100);
delete(wb)
clear wb

caract = ['a':'z' 'A':'Z'];
chaves = unique(geradorChaves(m, 4, 20, caract)); %gera chaves aleatorias
wb = waitbar(0, "Checking users");

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

    waitbar(i/m);
end

delete(wb)
clear wb

colisoes = userRepeated; %todos os nomos sao unicos

disp("Para 15000 nomes gerados aleatoriamente houve " + colisoes + " falsos positivos");
