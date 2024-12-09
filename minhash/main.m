% thiago vicente - 121497
%% load data
clear
clc
load("saved/data.mat")

%% find similar
threshold = 0.1;
similar = findSimilar('very good application',...
                    shingle_size,MH, ...
                    threshold,R);


disp(reviews(indices(similar)));