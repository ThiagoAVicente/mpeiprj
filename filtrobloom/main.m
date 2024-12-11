clear
clc

dic = readcell("save/reduced.csv");
userNames = dic(:, 1);

m = length(userNames); %quantos elementos vao ser adicionados
n = length(userNames) * 100; % tamanho do filtro

k = floor(n*log10(2) / m); % calcular k otimo (k = funcoes de hash que vao ser usadas)
filtroBloomUsers = filtroBloomString(n, k); %criar filtro bloom

userRepeated = 0; %variavel que guarda quantos nomes repetidos
invalidUsers = 0; %variavel que guarda quantas linhas são "invalidas" (serve mais para debug e testes)
for i = 1:m
    
    name = userNames{i};
    
    if isa(name, 'missing') %no dataset pode haver linhas sem user name
        invalidUsers = invalidUsers + 1;
        continue            %entao este if faz com que o programa nao "morra"
    end                     %caso haja uma linha sem username

    if(filtroBloomUsers.checkElement(name) == 1)  %checa se o userName já está no filtro
        userRepeated = userRepeated + 1;
    else
        filtroBloomUsers = filtroBloomUsers.addElement(name); %adiciona o userName ao filtro
    end
end

userRepeated + invalidUsers + sum(filtroBloomUsers.hashTable) %tem que dar igual a m