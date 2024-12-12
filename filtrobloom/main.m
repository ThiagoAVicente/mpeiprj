clear
clc

dic = readcell("save/reduced.csv");
userNames = dic(:, 1);

m = length(userNames); %quantos elementos vao ser adicionados
n = length(userNames) * 100; % tamanho do filtro

k = floor(n*log10(2) / m); % calcular k otimo (k = funcoes de hash que vao ser usadas)
filtroBloomUsers = filtroBloomString(n, k); %criar filtro bloom

userRepeated = 0; %variavel que guarda quantos nomes repetidos
counter = 1;
for i = 1:m
    
    name = userNames{i};
    
    if isa(name, 'missing') %no dataset pode haver linhas sem user name
        continue            %entao este if faz com que o programa nao "morra"
    end                     %caso haja uma linha sem username

    if(filtroBloomUsers.checkElement(name) == 1)  %checa se o userName já está no filtro
        userRepeated = userRepeated + 1;
        repeatedNames{counter} = name;
        counter = counter + 1;
    else
        filtroBloomUsers = filtroBloomUsers.addElement(name); %adiciona o userName ao filtro
    end
end
