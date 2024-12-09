% thiago vicente - 121497

%% load data
clear
clc
data = readcell("reduced.csv");
reviews = data(2:end,2);

%% get shingles
shingle_size = 4;
[shingles,indices] = genSetOfShingles(reviews,shingle_size);

%% hash fucntion
% get num of unique shingles for creating hash function
numShingles = length(...
    unique(...
    [shingles{:}]));

% gen hash function
R = genHashFunc(numShingles,shingle_size);

%% minhash matrice
MH = genMH(shingles,R);

%% save
save("saved/data","shingles","indices","MH","R","numShingles","reviews","shingle_size");
