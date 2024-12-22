function chaves = geradorChaves(n,imin, imax, caract, probCaract)
%Gerador de chaves aleatorias
%  Gera n chaves aleatorias, com comprimento entre imin e imax , com os
%  caracteres em caract em que a probabilidade de cada caracter está em
%  probCaract

%TODO NAO PODE REPETIR
switch nargin()
    case 4
        prob = 1/length(caract);
        probCaract = zeros(1, length(caract)) + prob;
end

for i = 2:length(probCaract)
    probCaract(i) = probCaract(i) + probCaract(i-1);
end

%% determinar tamanho da chave
tamanhos = randi([imin, imax], 1, n);
%% gerar uma chave
% gerar cada um dos caracteres

chaves = cell(1, n);
for i = 1:n
    %indice = randi(length(caract) , 1, tamanhos(i));
    indiceAux = rand( 1, tamanhos(i));
    
    for j = 1:length(indiceAux)
        aux = indiceAux(j);
        caracteres(j) = caract(1);
        for k = 2:length(probCaract)
            if( probCaract(k-1) < aux && aux < probCaract(k))
                caracteres(j) = caract(k);
            end
        end
    end

    %caracteres = caract(indice);
    chaves{i} = caracteres;
end
end