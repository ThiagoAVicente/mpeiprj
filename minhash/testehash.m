shingle_size = 4;
k = 5;
R = genHashFunc(k,shingle_size);
%%
data = readcell("reduced.csv");
reviews = data(:,2);

%%
tic
Set = genSetOfShingles(reviews,shingle_size);
toc
%%
Set_flatten = unique([Set{:}]);

%%
hashCodes = zeros(1,length(Set_flatten));
tic
for i = 1:length(Set_flatten)

    item = Set_flatten{i};
    hashCodes(i) = hashFunctionsBin(item,R,k);

end
toc

%%
length(hashCodes)
length(unique(hashCodes))

% pllot
counts = accumarray(hashCodes' + 1, 1);
stem(counts,"Marker","none")
title("Distribuição dos hashcodes com 68000 shingles diferentes")
ylabel("Número de atribuições")