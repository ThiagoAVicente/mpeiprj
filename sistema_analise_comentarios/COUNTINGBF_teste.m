clear
clc

wb = waitbar(0 ,"Load file");

load("save/data.mat")

waitbar(100);
delete(wb)
clear wb

wb = waitbar(0, "Creating Bloom Filter");

limiar = 5; %limiar que o filtroBloomCounter apanha

m = length(users); %quantos elementos vao ser adicionados
n = 287552; % tamanho do filtro

k = round(n*log(2) / m); % calcular k otimo (k = funcoes de hash que vao ser usadas)
filtroBloomUsers = COUNTINGBF_class(n, k); %criar filtro bloom

waitbar(100);
delete(wb)
clear wb

wb = waitbar(0, "Putting users in bloom filter");

isMissing = 0;
userRepeatedMoreThanLimiar = 0; %variavel que guarda quantos nomes repetidos mais vezes que o limiar
for i = 1:m
   
    user = users{i};

    if isa(user, 'missing') %no dataset pode haver linhas sem user name
        isMissing = isMissing + 1; %entao este if faz com que o programa nao "morra"
        continue            %caso haja uma linha sem username
    end                     

    filtroBloomUsers = filtroBloomUsers.addElement(user);
    waitbar(i/m);
end

delete(wb)
clear wb

repeatedUsersCounter = 0;
repeatedUsers = cell(0);
wb = waitbar(0, "Checking repeated users");
for i = 1:m

    user = users{i};

    if isa(user, 'missing') %no dataset pode haver linhas sem user name
        continue            %entao este if faz com que o programa nao "morra"
    end                     %caso haja uma linha sem username
    
    if isa(user, "double")
        user = convertStringsToChars(int2str(user));
    end

    if( filtroBloomUsers.isRepeatedLessThan(user, limiar) == 1 && (ismember(user, repeatedUsers) == false)) %nao contar mais que uma vez os repetidos
        repeatedUsersCounter = repeatedUsersCounter + 1;
        repeatedUsers{repeatedUsersCounter} = user;
    end

    waitbar(i/m);
end

delete(wb)
clear wb
