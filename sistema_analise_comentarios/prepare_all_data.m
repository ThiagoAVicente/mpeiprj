clear
clc

%% NAIVE BAYES --- likelihood  vocabulary minsizeBoW classes prior

data = readcell("reduced.csv");
minSize = 3;

%% separe training data
%inds = randsample(1:length(reviews),7500);
y = cell2mat( ...
    data(2:end,3));
train_reviews = data(2:end,2);

%% tokenize reviews

tokenizedReviews = cellfun(@(x) cellstr( strsplit(lower(string(x))) ), train_reviews, 'UniformOutput', false);

%% create a limited vocabulary
numFeatures = 300;

% get features from each class
allWords_no_filterGood = [tokenizedReviews(y == 1)];
allWords_no_filterBad = [tokenizedReviews(y==0)];

% filter words to have 3 or more letters
allWordsBad = allWords_no_filterBad(cellfun(@(x) length(x)>minSize-1,allWords_no_filterBad ) );
allWordsGood = allWords_no_filterGood(cellfun(@(x) length(x)>minSize-1,allWords_no_filterGood ) );

% get unique words
[uniqueWordsGood,~,wordIndicesGood] = unique([allWordsGood{:}]);
[uniqueWordsBad,~,wordIndicesBad] = unique([allWordsBad{:}]);

% get the first "numFeatures" more used words
WordsCountGood = accumarray(wordIndicesGood,1);
WordsCountBad = accumarray(wordIndicesBad,1);

[~,idxGood] = sort(WordsCountGood,'descend');
[~,idxBad] = sort(WordsCountBad,'descend');

vocabulary = unique([uniqueWordsGood(idxGood(1:numFeatures))...
               uniqueWordsBad(idxBad(1:numFeatures)) ]);

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

loglikelihood = zeros(length(classes),numFeatures);

for feature_i = 1:numFeatures
    
    % class 1
    loglikelihood(1,feature_i) = log(...
        sum( ...
        (BoW(y==classes(1),feature_i)>0)/ ... % all occurencies of this feature
        (sum(BoW(y==classes(1),:), "all" ))... % all occurencies of features in this class
        )...
        );

    % class 2
    loglikelihood(2,feature_i) = log(...
        sum( ...
        (BoW(y==classes(2),feature_i)>0)/ ... % all occurencies of this feature
        (sum(BoW(y==classes(2),:)>0, "all" ) )... % all occurencies of features in this class
        )...
        );
end
%%
clear vocabMap tokenizedReviews tokens train_reviews WordsCountBad WordsCountGood wordIndicesBad wordIndicesGood emojis 

%% change data file
data = readcell("test.csv");
reviews = data(2:end,2);
users = data(2:end,1);

%% MINHASH  --- users reviews indices MH

%% get shingles
shingle_size = 4;
[shingles,indices] = MINHASH_genSetOfShingles(reviews,shingle_size);

%% hash function
R = MINHASH_genHashFunc(5);

%% minhash matrice
MH = MINHASH_genMH(shingles,R);
clear numShingles shingles 

%% BLOOMFILTER --- bloomfilter class

% join all cell of words in reviews
flattenedReviews = '';

% for each review
for i = 1:length(reviews)
    
    review = reviews{i};
    % join review to flattenedReviews
    flattenedReviews = [flattenedReviews ' ' review ];

end

% split on ' '
words = split(flattenedReviews,' ');
%%
% get unique words
unique_words = unique(words);
unique_words = unique_words(cellfun(@(x) length(x)>2,unique_words));

%% create bloomfilter

m = length(unique_words); 
n = m * 100;

% kótimo
k = floor(n*log10(2) / m); 
bloom_filter = FILTROBLOOM_class(n,k);

%% add words to filter
wb = waitbar(0, "bloom filter...");

for i = 1:m
    
    word = unique_words{i};
    bloom_filter = bloom_filter.addElement(word); %adiciona a palavra ao filtro
    
    waitbar(i/m);
end
delete(wb)


%% save data
save("save/data.mat","bloom_filter","MH","R","reviews","shingle_size","users","vocabulary","loglikelihood")