%% load data
clear
clc
load("save/data.mat")

%% search for comments
toSearch = 'error';

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
    return
end
threshold = 0.7; % jacard distance 
similar = MINHASH_findSimilar(toSearch,...
                shingle_size,MH, ...
                threshold,R);
%% display similar
for i = indices(similar)
    fprintf("%s: %s\n",users{i},reviews{i});

end

%% usar naive bayes para classificar
line = 2;
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