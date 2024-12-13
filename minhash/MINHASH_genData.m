% thiago vicente - 121497

%% load data
clear
clc
data = readcell("reduced.csv");
reviews = data(2:end,2);
users = data(2:end,1);
%% get shingles
shingle_size = 4;
[shingles,indices] = MINHASH_genSetOfShingles(reviews,shingle_size);

%% hash fucntion
% get num of unique shingles for creating hash function
numShingles = length(...
    unique(...
    [shingles{:}]));

% gen hash function
R = MINHASH_genHashFunc(5);

%% minhash matrice
tic
MH = MINHASH_genMH(shingles,R);
toc
%% save
save("saved/data","shingles","indices","MH","R","numShingles","reviews","shingle_size","users");
