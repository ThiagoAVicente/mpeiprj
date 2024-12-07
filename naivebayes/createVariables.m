clear
clc

n = 10000;
k = 4;
R = genHashFuncs(k);

%% laod bloom filters

% goodwords filter
goodWords = readcell("goodWords");
FBgood = genFB(n,k);

FBgood = populate(goodWords,FBgood,R);
clear goodWords
%%
% badwords filter
badWords = readcell("badWords");
FBbad = genFB(n,k);

FBbad = populate(badWords,FBbad,R);
clear badWords


%% load data
data = readcell("output.csv");
inds = randsample(2:size(data,1),round(size(data,1)/2));
train_data = data(inds,:);
%%
x = genXtable(train_data(2:end,2),train_data(2:end,end),FBbad,FBgood,R);
y = cell2mat(train_data(2:end,3));

%%
save("variables/naiveBayesData.mat","FBgood","FBbad","R","x","y")