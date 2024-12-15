%% DATASET
dataset = '5000';
%dataset = '15000';

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

%% BLOOMFILTER --- bloomfilter


m = length(vocabulary); 
n = m * 100;

% kótimo
k = floor(n*log10(2) / m); 
bloom_filter = FILTROBLOOM_class(n,k);

%% add words to filter
wb = waitbar(0, "bloom filter...");

for i = 1:m
    
    word = vocabulary{i};
    bloom_filter = bloom_filter.addElement(word); %adiciona o shingle ao filtro
    
    waitbar(i/m);
end
delete(wb)
