%% load data
clear
clc
data = readcell("output.csv");
reviews = data(:,2);

%% get shingles
shingle_size = 5;
[shingles,indices] = genSetOfShingles(reviews,shingle_size);

%%
save("saved/data","shingles","indices");

%% hash fucntion
% get num of unique shingles for creating hash function
numShingles = length(...
    unique(...
    [shingles{:}]));

% gen hash function
R = genHashFunc(numShingles,shingle_size);

%%
MH = genMH(shingles,R);
%%
similar = findSimilar('very good application',shingle_size,MH,0.1,R);