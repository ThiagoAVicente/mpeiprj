clear
clc
tic

%% DATASET
%dataset = '5000';
dataset = '15000';
p_falsos_positivos = 1e-4;

%% NAIVE BAYES --- likelihood  vocabulary minsizeBoW classes prior

data = readcell(['train_' dataset '.csv'],Delimiter='ª');
minSize = 3;

%% separe training data
%inds = randsample(1:length(reviews),7500);
y = cell2mat( ...
    data(2:end,3));
train_reviews = data(2:end,2);

%% tokenize reviews

tokenizedReviews = cellfun(@(x) cellstr( ...
           strsplit(string( ...
                    NAIVEBAYES_prepare(x)) ...
            )), ...
            train_reviews, 'UniformOutput', false);
tokenizedReviewsFlatten = [tokenizedReviews{:}];

%% create a limited vocabulary

% filter words to have 3 or more letters
allWords = tokenizedReviewsFlatten(cellfun(@(x) length(x)>minSize-1,tokenizedReviewsFlatten ) );
% get unique words
vocabulary = unique(allWords);

%% BoW
vocabMap = containers.Map(vocabulary, 1:numel(vocabulary));

szVocab = length(vocabulary);

numReviews = length(train_reviews);
BoW = sparse(numReviews,szVocab);

h = waitbar(0, 'BoW...');

% populate the BoW
for review_i = 1:numReviews

    % get tokens from review that have minSize or more letters
    tokens = tokenizedReviews{review_i};
    tokens = tokens( ...
        cellfun(@(x) length(x) > minSize-1, tokens ...
        ));

    tokens = tokens(ismember(tokens, keys(vocabMap)));

    if isempty(tokens)
        continue
    end

    % get word indices
    indices = cellfun( ...
        @(x) vocabMap(x),tokens  ...
        );

    % save in the sparse matrix
    BoW(review_i,:) = accumarray(indices',1,[szVocab,1])';

    if mod(review_i, 100) == 0
        waitbar(review_i / numReviews, h);
    end

end
close(h);

%% prior
classes = unique(y);
prior = zeros(1,length(classes));
for i = 1:length(classes)
    
    prior(i) = sum( y == classes(i))/length(y);
end
clear allWords_no_filter allWords WordsCount indices i h review_i wordIndices idxBad idxGood szVocab vocabMap wordIndicesBad wordIndicesGood

%% likelihood using presence of words

loglikelihood = zeros(length(classes),length(vocabulary));
h = waitbar(0, 'likelihood...');
numFeatures = length(vocabulary);
for feature_i = 1:numFeatures
    
    % class 1
    loglikelihood(1,feature_i) = log(...
        sum( ...
        (BoW(y==classes(1),feature_i)>0)/ ... % all occurencies of this feature
        (sum(BoW(y==classes(1),:), "all" ))... % all occurencies of features in this class
        )...
        +eps);

    % class 2
    loglikelihood(2,feature_i) = log(...
        sum( ...
        (BoW(y==classes(2),feature_i)>0)/ ... % all occurencies of this feature
        (sum(BoW(y==classes(2),:)>0, "all" ) )... % all occurencies of features in this class
        )...
        +eps);

    if mod(feature_i, 100) == 0
        waitbar(feature_i / numFeatures, h);
    end
end
close(h);
%%
clear vocabMap tokenizedReviews tokens train_reviews WordsCountBad WordsCountGood wordIndicesBad wordIndicesGood emojis 

%% change data file
data = readcell(['test_' dataset '.csv'],Delimiter='ª');
reviews = data(:,2);
users = data(:,1);
users(cellfun(@(x) isa(x, 'missing'), users)) = {'unknown'};
%% MINHASH  --- users reviews indices MH

%% get shingles
shingle_size = 4;
[shingles,indices] = MINHASH_genSetOfShingles(reviews,shingle_size);

%% hash function
R = MINHASH_genHashFunc(20);

%% minhash matrice
MH = MINHASH_genMH(shingles,R);
clear numShingles 

%% BLOOMFILTER --- bloomfilter


m = length(vocabulary); 

[n,k] = getParams(m,p_falsos_positivos);
 
bloom_filter = FILTROBLOOM_class(n,k);

%% add words to filter
wb = waitbar(0, "bloom filter...");

for i = 1:m
    
    word = vocabulary{i};
    bloom_filter = bloom_filter.addElement(word); %adiciona o shingle ao filtro
    
    waitbar(i/m);
end
delete(wb)


%% COUNTING BLOOM FILTER --- counting bloom filter with users name

m = length(users); %quantos elementos vao ser adicionados
[n,k] = getParams(m,p_falsos_positivos);

%% create counting bf
counting_bloom_filter = COUNTINGBF_class(n,k);

% add users to bloom bf
wb = waitbar(0, "counting bloom filter...");

for i = 1:length(users)
    user = users{i};
    counting_bloom_filter = counting_bloom_filter.addElement(user);
    waitbar(i/m);
end
delete(wb)

%% save data
save("save/data.mat","bloom_filter","MH","R","reviews","shingle_size", ...
            "users","vocabulary","loglikelihood","indices","prior","classes","minSize","counting_bloom_filter")
toc