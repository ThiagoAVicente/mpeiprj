
%% load data
clear
clc
load("save/minHash.mat")

%% find similar
threshold = 0.8; % similaridade


% 30 hash functions
D = LSH_genHashFunction(10,3);

LSH = LSH_genLSH(10,MH,D);

similar = LSH_findSimilar('good app',shingle_size,MH,threshold,R,LSH,D);
if isempty(similar)
    disp("Nenhum similar")
end

% remove missing values
users(cellfun(@(x) isa(x, 'missing'), users)) = {'unknown'};
for i = indices(similar)
    fprintf("%s: %s\n",users{i},reviews{i});

end