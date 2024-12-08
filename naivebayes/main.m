%% laod data
load("saved/data.mat")
numFeatures = size(BoW,2);
%% prior
classes = unique(y);
prior = zeros(1,length(classes));
for i = 1:length(classes)
    
    prior(i) = sum( y == classes(i))/length(y);
end
clear allWords_no_filter allWords WordsCount indices i h review_i wordIndices
%% likelihood using laplace

loglikelihood = zeros(length(classes),numFeatures);

for feature_i = 1:numFeatures
    
    % class 1
    loglikelihood(1,feature_i) = log(...
        sum( ...
        (BoW(y==classes(1),feature_i)>0+1)/ ... % all occurencies of this feature
        (sum(BoW(y==classes(1),:)>0, "all" ) + numFeatures)... % all occurencies of features in this class
        )...
        );

    % class 2
    loglikelihood(2,feature_i) = log(...
        sum( ...
        (BoW(y==classes(2),feature_i)>0+1)/ ... % all occurencies of this feature
        (sum(BoW(y==classes(2),:)>0, "all" ) + numFeatures)... % all occurencies of features in this class
        )...
        );
end

%% classify 

true_positives = 0;
false_positives = 0;
true_negatives = 0;
false_negatives = 0;

vocabMap = containers.Map(vocabulary, 1:numel(vocabulary));

for review_i = numReviews-100:numReviews
    
    probs = zeros(1,length(classes));
    probs(1) = log(prior(1));
    probs(2) = log(prior(2));

    % get tokens of review
    tokens = tokenizedReviews{review_i};
    tokens = tokens( ...
        cellfun(@(x) length(x) > minSize-1, tokens ...
        ));
    
    tokens = tokens(ismember(tokens, keys(vocabMap)));

    % if has any valid token then add its likelihood
    if ~isempty(tokens)
        
        % get indices
        indices = cellfun( ...
        @(x) vocabMap(x),tokens  ...
        );

        % for each feature add its probability
        for feature_i = indices
            
            probs(1) = probs(1) + loglikelihood(1,feature_i);
            probs(2) = probs(2) + loglikelihood(2,feature_i);

        end

    end

    % compare the true response with the classifier's one
    res = classes(1);
    if probs(2) > probs(1)
        res = classes(2);
    end

    % if calssifier got it rigth
    if y(review_i) == res

        % true positive
        if res == classes(2)
            true_positives = true_positives+1;
        
        % true negative
        else
            true_negatives = true_negatives+1;
        end

        
       
    % else
    else
        % false positive
        if res == classes(2)
            false_positives = false_positives+1;
        % false negative
        else
            false_negatives = false_negatives+1;
        end


    end
end
%%
true_positives/(true_positives+false_positives)

true_positives/(true_positives+true_negatives)