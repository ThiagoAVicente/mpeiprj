%% [OBJECTIVE]
% do the same as main.m but with a window
% window must have a search bar, a thereshold slider, a 
% minimum slider and a fiels where the output will be displayed


%% load data
clear
clc
load("save/data.mat")


%% create window

width = 800;
height = 600;

window = uifigure('Name', 'Sistema de analise de comentarios', ...
    'Position', [500, 50, width, height]);

search_bar = uieditfield(window,'text','Position',[5 560 width-5 30 ]);
threshold_slider = uislider(window,'Position',[50 530 90 3], ...
    'Limits', [0, 1], 'Value', 0.5,'MajorTicks', [],'MinorTicks',[]);
threshold_label = uilabel(window, 'Position', [150 515 100 30], ...
    'Text', ['threshold: ', num2str(threshold_slider.Value)]);
naivebayes_label = uilabel(window, 'Position', [300 515 400 30], ...
    'Text', 'Naive Bayes: selecione um comentário','FontSize', 16);

output = uilistbox(window, 'Position', [25, 25, width-50, height-(height-515+25)], ...
    'Multiselect', 'off','FontSize', 14, ...
    'ValueChangedFcn', @(src, event) ...
    naiveBayesCalculation(src,naivebayes_label,prior,vocabulary,loglikelihood,classes,minSize));

output.Items = {};

% when a list element is selected calculate the naive bayes prediction to
% the review
function naiveBayesCalculation(selected,naivebayes_label,prior,vocabulary,loglikelihood,classes,minSize)
    
    % separe review from user
    review = selected.Value;
    review = split(review,': ');
    
    % validate if there is a comment
    if length(review) < 2
        return
    end
    
    review = review{2};
    if isempty(review)
        return
    end
    
    % classify with naive bayes
    predicted_class = NAIVEBAYES_classify(review,prior,vocabulary,loglikelihood,classes,minSize);
    response = '(1,2)';
    if predicted_class == classes(2)
        response = '(4,5)';
    end

    % display response
    naivebayes_label.Text = ['Naive Bayes: ' response];

end

% on update searchbar call all fucntions
search_bar.ValueChangedFcn = @(src, event) processData(src,threshold_slider,output,users,reviews, ...
    shingle_size,bloom_filter,MH,R,indices);

function processData(search_bar,threshold_slider,output_field,users, ...
    reviews,shingle_size,bloom_filter,MH,R,indices)
    % call bloomfilter, naive bayes and minhash

    threshold = threshold_slider.Value;
    toSearch = search_bar.Value;
    if isempty(toSearch)
        return
    end

    [shingles,~] = MINHASH_genSetOfShingles({toSearch},shingle_size);
    shingles = shingles{1};
    
    % check if any shingle is in bloom_filter
    response = false;
    count = 0;
    minimum = 0;
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
    
    % if exists them find similars using minhash
    if response == 0
        output_field.Items = {'Filtro bloom: nenhum comentário com esses shingles'};
        return
    end
    similar = MINHASH_findSimilar(toSearch,...
                    shingle_size,MH, ...
                    threshold,R);
    similarItems = {};
    for i = indices(similar)
        similarItems{end+1} = sprintf('%s: %s', users{i}, reviews{i});
    end
    output_field.Items = similarItems;
    
end

% update the threshold label
threshold_slider.ValueChangedFcn = @(src, event) updateThreshold(src, threshold_label);
function updateThreshold(slider,label)
    % update label value
    threshold = slider.Value;
    label.Text = ['threshold: ', num2str(threshold)];
end