%% laod data
clear
clc
load("save/naiveBayes.mat")

dataset = '5000';
%dataset = '15000';

testData = readcell(['test_' dataset '.csv'],Delimiter='ª');
reviews = testData(:,2);
numReviews = length(reviews);
y = cell2mat( testData(:,3));
labels = y;
%% teste com todos as linhas


% classify 
true_positives = 0;
false_positives = 0;
true_negatives = 0;
false_negatives = 0;
h = waitbar(0, 'Naive Bayes...');
for review_i = 1:numReviews
    
    probs = zeros(1,length(classes));
    probs(1) = log(prior(1));
    probs(2) = log(prior(2));

    % get tokens of review
    review = (reviews{review_i});
    review = char(review);
    review = NAIVEBAYES_prepare(review);

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
            %disp(reviews{review_i})
            
        % false negative
        else
            false_negatives = false_negatives+1;
            %disp(reviews{review_i})
        end


    end
    if mod(review_i, 100) == 0
        waitbar(review_i / numReviews, h);
    end

end
close(h);

%
precision = true_positives/(true_positives+false_positives);
recall = true_positives/(true_positives+false_negatives);
accuracy = (true_negatives+true_positives)/numReviews;
F1 = 2*precision*recall/(precision+recall);
fprintf("Accuracy: %.2f\nRecall: %.2f\nPrecision: %.2f\nF1: %.2f\n",accuracy,recall,precision,F1)


%% teste para fazer a média

numTests = 5;
originalNumReviews = 5000;

precision = 0;
recall = 0;
accuracy = 0;
F1 = 0;
batch_size = 500;
all_pos = 1:originalNumReviews-batch_size-1;

for i = 1:numTests
    kni = randsample(all_pos,1);
    all_pos(all_pos == kni) = [];
    reviews = testData(kni:kni+batch_size-1,2);
    y = labels(kni:kni+batch_size-1);
    numReviews = length(reviews);
   
    % classify 
    true_positives = 0;
    false_positives = 0;
    true_negatives = 0;
    false_negatives = 0;
    h = waitbar(0, 'Naive Bayes...');
    for review_i = 1:numReviews
        
        probs = zeros(1,length(classes));
        probs(1) = log(prior(1));
        probs(2) = log(prior(2));
    
        % get tokens of review
        review = (reviews{review_i});
        review = char(review);
        review = NAIVEBAYES_prepare(review);
       
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
                %disp(reviews{review_i})
                
            % false negative
            else
                false_negatives = false_negatives+1;
                %disp(reviews{review_i})
            end
    
    
        end
        if mod(review_i, 100) == 0
            waitbar(review_i / numReviews, h);
        end
    
    end
    close(h);
    
    %
    precision = [precision true_positives/(true_positives+false_positives)];
    recall = [recall true_positives/(true_positives+false_negatives)];
    accuracy = [accuracy (true_negatives+true_positives)/(true_positives+true_negatives+false_negatives+false_positives)];
    F1 = [F1 2*precision(end)*recall(end)/(precision(end)+recall(end))];
end

%% final 
fprintf("Accuracy: %.2f\nRecall: %.2f\nPrecision: %.2f\nF1: %.2f\n", ...
    sum(accuracy)/numTests,sum(recall)/numTests,sum(precision)/numTests,sum(F1)/numTests)

