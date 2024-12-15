%% DATASET

dataset = '5000';
%dataset = '15000';

%%
dic = readcell(['test_' dataset '.csv');
users = dic(:,1);

save("save/bloomFilter.mat", "users", '-mat');