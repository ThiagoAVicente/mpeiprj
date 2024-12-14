% thiago vicente - 121497
%% load data
clear
clc
load("save/data.mat")

%% find similar
threshold = 0.5; % similaridade
similar = MINHASH_findSimilar('great one',...
                    shingle_size,MH, ...
                    threshold,R);

% remove missing values
users(cellfun(@(x) isa(x, 'missing'), users)) = {'unknown'};
for i = indices(similar)
    fprintf("%s: %s\n",users{i},reviews{i});

end