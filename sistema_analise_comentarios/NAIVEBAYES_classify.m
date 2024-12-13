function res = NAIVEBAYES_classify(review,prior,vocabulary,loglikelihood,classes,minSize)

    % create a map for better efficiency
    vocabMap = containers.Map(vocabulary, 1:numel(vocabulary));

    probs = zeros(1,length(classes));
    probs(1) = log(prior(1));
    probs(2) = log(prior(2));

    tokens = split(review,' ');

    % get tokens of review
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
        for indices_i = 1:length(indices)
            
            feature_i = indices(indices_i);
            %loglikelihood(1,feature_i)
            probs(1) = probs(1) + loglikelihood(1,feature_i);
            probs(2) = probs(2) + loglikelihood(2,feature_i);

        end

    end

    classes
    % compare the true response with the classifier's one
    res = classes(1);
    if probs(2) > probs(1)
        res = classes(2);
    end
end