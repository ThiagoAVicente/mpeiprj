
%% load data
clear
clc
load("save/minHash.mat")

%% find similar
threshold = 0.8; % similaridade
similar = MINHASH_findSimilar('good app',...
                    shingle_size,MH, ...
                    threshold,R);

if isempty(similar)
    disp("Nenhum similar")
end

% remove missing values
users(cellfun(@(x) isa(x, 'missing'), users)) = {'unknown'};
for i = indices(similar)
    fprintf("%s: %s\n",users{i},reviews{i});

end