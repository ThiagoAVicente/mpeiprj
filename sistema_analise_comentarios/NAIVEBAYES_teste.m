%% laod data
clear
clc
load("save/data.mat")

%%

testData = readcell("test_15000.csv",Delimiter='ª');
reviews = testData(:,2);
numReviews = length(reviews);

y = cell2mat( testData(:,3));
%% classify 

true_positives = 0;
false_positives = 0;
true_negatives = 0;
false_negatives = 0;

for review_i = 1:numReviews
    
    probs = zeros(1,length(classes));
    probs(1) = log(prior(1));
    probs(2) = log(prior(2));

    % get tokens of review
    review = (reviews{review_i});
    review = char(review);

    res = NAIVEBAYES_classify(review,prior,vocabulary,loglikelihood,classes,minSize);

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
precision = true_positives/(true_positives+false_positives);
recall = true_positives/(true_positives+false_negatives);
accuracy = (true_negatives+true_positives)/numReviews;
F1 = 2*precision*recall/(precision+recall);
fprintf("Accuracy: %.2f\nRecall: %.2f\nPrecision: %.2f\nF1: %.2f\n",accuracy,recall,precision,F1)