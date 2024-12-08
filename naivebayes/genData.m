clear
clc

data = readcell("output.csv");
minSize = 3;
%% 
reviews = data(2:end,2);
labels = data(2:end,3);

%% separe training data
inds = randsample(1:length(reviews),round(length(reviews)/2));
y = cell2mat(labels(inds));
train_reviews = reviews(inds);

%% tokenize reviews

tokenizedReviews = cellfun(@(x) cellstr( strsplit(lower(string(x))) ), train_reviews, 'UniformOutput', false);

%% create a limited vocabulary
numFeatures = 10000;

% filter words to have 3 or more letters
allWords_no_filter = [tokenizedReviews{:}];
allWords = allWords_no_filter(cellfun(@(x) length(x)>minSize-1,allWords_no_filter ) );

% get unique words
[uniqueWords,~,wordIndices] = unique(allWords);

% get the first "numFeatures" more used words
WordsCount = accumarray(wordIndices,1);
[~,idx] = sort(WordsCount,'descend');
vocabulary = uniqueWords(idx(1:numFeatures));

%% BoW
vocabMap = containers.Map(vocabulary, 1:numel(vocabulary));

numReviews = length(train_reviews);
BoW = sparse(numReviews,numFeatures);

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
    BoW(review_i,:) = accumarray(indices',1,[numFeatures,1])';

    if mod(review_i, 100) == 0
        waitbar(review_i / numReviews, h);
    end

end
close(h);

