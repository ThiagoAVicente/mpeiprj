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
tabGroup = uitabgroup(window,"Position", [0, 0, width, height]);
tab1 = uitab(tabGroup, "Title", "Comentários");
tab2 = uitab(tabGroup, "Title", "Filtrar utilizadores");

%% first tab
search_bar = uieditfield(tab1,'text','Position',[5 560 width-5 30 ]);
threshold_slider = uislider(tab1,'Position',[50 530 90 3], ...
    'Limits', [0, 1], 'Value', 0.5,'MajorTicks', [],'MinorTicks',[]);
threshold_label = uilabel(tab1, 'Position', [150 515 100 30], ...
    'Text', ['semelhança: ', num2str(threshold_slider.Value)]);
naivebayes_label = uilabel(tab1, 'Position', [300 515 400 30], ...
    'Text', 'Naive Bayes: selecione um comentário','FontSize', 16);

output = uilistbox(tab1, 'Position', [25, 25, width-50, height-(height-515+25)], ...
    'Multiselect', 'off','FontSize', 14, ...
    'ValueChangedFcn', @(src, event) ...
    naiveBayesCalculation(src,naivebayes_label,prior,vocabulary,loglikelihood,classes,minSize));

output.Items = {};

%% second tab
limiarLabel = uilabel(tab2, 'Position', [10 height-80 400 30], ...
    'Text', 'Quantos comentários no minimo tem o utilizador?','FontSize', 14);
limiarInput = uieditfield(tab2,'numeric','Position',[350 height-80 100 30 ]);
usersLabel = uilabel(tab2, 'Position', [10 height-120 400 30], ...
    'Text', ['Usuaŕios com menos de ', num2str(limiarInput.Value)],'FontSize', 14);
outputFiltro = uilistbox(tab2, 'Position', [25, 25, width-50, height-(height-515+25)]);
outputFiltro.Items = {};
%% first tab backend
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
    if isempty(toSearch) || length(toSearch) < shingle_size
        disp("Input é demasiado pequeno para formar um shingle")
        return
    end

    % use bloom filter to check if any word in search bar is in dataset
    words = split(lower(toSearch),' ');
    words = words(strlength(words) > 0); 
    %disp(words)
    minimum = 1;
    response = false;
    count = 0;
    for i = 1:length(words)
        if bloom_filter.checkElement(words{i})
            count = count+1;
            if count >= minimum
                response = true;
                break
            end
        end
    end

    % if exists them find similars using minhash
    if response == false
        output_field.Items = {'Filtro bloom: nenhum comentário com essas palavras'};
        return
    end

    % MINHASH
    similar = MINHASH_findSimilar(toSearch,...
                    shingle_size,MH, ...
                    threshold,R);
    similarItems = {};
    disp(similar)
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

%% second tab backend
%when the limiar changes
limiarInput.ValueChangedFcn = @(src, event) updateLimiar(limiarInput, counting_bloom_filter, users, outputFiltro);
function updateLimiar(limiarInput, counting_bloom_filter, users, outputFiltro)
    limiar = limiarInput.Value;
    
    repeatedUsersCounter = 0;
    repeatedUsers = cell(0);
    for i = 1:counting_bloom_filter.nmrOfElements

        user = users{i};

        if isa(user, 'missing') %no dataset pode haver linhas sem user name
            continue            %entao este if faz com que o programa nao "morra"
        end                     %caso haja uma linha sem username
    
        if isa(user, "double")
            user = convertStringsToChars(int2str(user));
        end

        if( counting_bloom_filter.isRepeatedLessThan(user, limiar) == 1 && (ismember(user, repeatedUsers) == false)) %nao contar mais que uma vez os repetidos
            repeatedUsersCounter = repeatedUsersCounter + 1;
            repeatedUsers{repeatedUsersCounter} = user;
        end
    end
    outputFiltro.Items = repeatedUsers;
end