%% load data
clear
clc
load("save/data.mat")

%% SEARCH
toSearch = 'love this';
% limit of similar itens to show
limit = 10;
threshold = 0.5; % jacard sim
lsh = 1; % 1 para usar lsh
%% MINHASH e BLOOMFILTER
% check if any shingle is in the dataset

[shingles,~] = MINHASH_genSetOfShingles({toSearch},shingle_size);
shingles = shingles{1};

% check if any shingle is in bloom_filter
words = split(lower(toSearch),' ');
words = words(strlength(words) > 0); 
%disp(words)
minimum = 1;
response = false;
count = 0;
for i = 1:length(words)
    if bloom_filter.checkElement(words{i})
        count = count+1;
        if count >= minimum
            response = true;
            break
        end
    end
end

% if exists them find similars using minhash
if response == false
    disp('Filtro bloom: nenhum comentário com essas palavras');
    return
end

if lsh
    similar = LSH_findSimilar(toSearch ...
        ,shingle_size, ...
        MH,threshold,R, ...
        LSH,D);
else
    similar = MINHASH_findSimilar(toSearch,...
        shingle_size,MH, ...
        threshold,R);
end

disp("Similar comments: ")

if isempty(similar)
    return
end
% display similar
last = min(limit,length(similar));
for i = indices(similar(1:last))
    fprintf("%s: %s\n",users{i},reviews{i});

end

%% NAIVE BAYES
line = 1; % selected line
review = reviews{...
            indices( ...
            similar(line) ...
            )};

review = NAIVEBAYES_prepare(review);

% calcular probabilidades
predicted_class = NAIVEBAYES_classify(review,prior,vocabulary,loglikelihood,classes,minSize);
response = "(1,2)";
if predicted_class == classes(2)
    response = "(4,5)";
end
disp("")
fprintf("Naive Bayes: %s.\n",response);

%% COUNTING BLOOM FILTER
user = users{...
            indices( ...
            similar(line) ...
            )};

possibleNumOfComments = counting_bloom_filter.howMany(user);
fprintf("O usuário pode ter %d comentário(s).\n",possibleNumOfComments);
disp("")

% filter users based on number of comments
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

if repeatedUsersCounter > limit
    repeatedUsersCounter = limit;
end
disp("Usuarios repetidos " + limiar + " vezes ou mais: ");
for i = 1:repeatedUsersCounter
    userName = repeatedUsers{i};
    disp(userName);
end