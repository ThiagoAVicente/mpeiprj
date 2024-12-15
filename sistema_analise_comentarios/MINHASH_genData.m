%% dataset
dataset = '5000';
%dataset = '15000';

%% change data file
data = readcell(['test_' dataset '.csv'],Delimiter='ª');
reviews = data(:,2);
users = data(2:end,1);
users(cellfun(@(x) isa(x, 'missing'), users)) = {'unknown'};
%% MINHASH  --- users reviews indices MH

%% get shingles
shingle_size = 4;
[shingles,indices] = MINHASH_genSetOfShingles(reviews,shingle_size);

%% hash function
R = MINHASH_genHashFunc(5);

%% minhash matrice
MH = MINHASH_genMH(shingles,R);

save("save/minHash.mat","MH","R","reviews","shingle_size","users","indices"1)
