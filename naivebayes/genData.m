% thiago vicente -121497
clear
clc

data = readcell("reduced.csv");
minSize = 3;
%% 
reviews = data(2:end,2);
emojis = cell2mat(data(2:end,4));
labels = data(2:end,3);

%% separe training data
%inds = randsample(1:length(reviews),7500);
inds = 1:length(reviews);
y = cell2mat(labels(inds));
train_reviews = reviews(inds);

%% tokenize reviews

tokenizedReviews = cellfun(@(x) cellstr( strsplit(lower(string(x))) ), train_reviews, 'UniformOutput', false);

%% create a limited vocabulary
numFeatures = 1000;

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

%% calculate the length of each sentence
train_reviews_length = cellfun( ...
    @(x) numel(strsplit(string(x))) ...
    , train_reviews);

%% save data
save("saved/data.mat","BoW","labels","train_reviews","y","tokenizedReviews","vocabulary","train_reviews_length")