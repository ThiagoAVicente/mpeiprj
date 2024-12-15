%% load data
clear
clc
load("save/data.mat")

%% SEARCH
toSearch = 'die ';

%% check if any shingle is in the dataset

[shingles,~] = MINHASH_genSetOfShingles({toSearch},shingle_size);
shingles = shingles{1};

%% check if any shingle is in bloom_filter
response = false;
count = 0;
minimum = 1;
for i =1:length(shingles)
    
    shingle = shingles{i};
    if bloom_filter.checkElement(shingle)
        
        count = count+1;
        if count < minimum
            continue
        end
        
        response = true;
        break
    end

end

%% if exists them find similars using minhash
similar = [];
if response == 0
    disp("Nenhuma dessas palavras encontra-se no dataset")
    return
end
threshold = 0.05; % jacard sim
similar = MINHASH_findSimilar(toSearch,...
                shingle_size,MH, ...
                threshold,R);
%% display similar
for i = indices(similar)
    fprintf("%s: %s\n",users{i},reviews{i});

end

%% NAIVE BAYES
line = 1;
review = reviews{...
            indices( ...
            similar(line) ...
            )};

review = NAIVEBAYES_prepare(review);

%% calcular probabilidades
predicted_class = NAIVEBAYES_classify(review,prior,vocabulary,loglikelihood,classes,minSize);
response = "(1,2)";
if predicted_class == classes(2)
    response = "(4,5)";
end
fprintf("Pedicted class was %s",response);

%% filtro bloom
limiar = input("\nQual o número de comentários quer filtrar? ");
numberOfUserNames = length(users);

n = 287552; %n ótimo calculado
k = 13; % k otimo calculado
filtroBloomUsers = COUNTINGBF_class(n, k);

for i = 1:numberOfUserNames
   
    user = users{i};

    if isa(user, 'missing') %no dataset pode haver linhas sem user name
        isMissing = isMissing + 1; %entao este if faz com que o programa nao "morra"
        continue            %caso haja uma linha sem username
    end                     

    filtroBloomUsers = filtroBloomUsers.addElement(user);
end

repeatedUsersCounter = 0;
repeatedUsers = cell(0);
for i = 1:numberOfUserNames

    user = users{i};

    if isa(user, 'missing') %no dataset pode haver linhas sem user name
        continue            %entao este if faz com que o programa nao "morra"
    end                     %caso haja uma linha sem username
    
    if isa(user, "double")
        user = convertStringsToChars(int2str(user)); %as vezes aparecia um username com um inteiro que matava o codigo
    end

    if( filtroBloomUsers.isRepeatedLessThan(user, limiar) == 1 && (ismember(user, repeatedUsers) == false)) %nao contar mais que uma vez os repetidos
        repeatedUsersCounter = repeatedUsersCounter + 1;
        repeatedUsers{repeatedUsersCounter} = user;
    end

end

disp("Usuarios repetidos " + limiar + " vezes ou mais: ");
for i = 1:repeatedUsersCounter
    userName = repeatedUsers{i};
    disp(userName);
end