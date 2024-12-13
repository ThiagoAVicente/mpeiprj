shingle_size = 4;
k = 5;
R = MINHASH_genHashFunc(k);
%%
data = readcell("reduced.csv");
reviews = data(:,2);

%%
tic
Set = MINHASH_genSetOfShingles(reviews,shingle_size);
toc
%%
Set_flatten = unique([Set{:}]);

%%
hashCodes = zeros(1,length(Set_flatten));
tic
for j = 1:k
    for i = 1:length(Set_flatten)
    
        item = Set_flatten{i};
        hashCodes(i) = MINHASH_hashFunctions(item,R,j);
    end
    figure(j)
    length(hashCodes)
    length(unique(hashCodes))
    
    % pllot
    counts = accumarray(hashCodes' + 1, 1);
    stem(counts,"Marker","none")
    title("Distribuição dos hashcodes com 68000 shingles diferentes")
    ylabel("Número de atribuições")

end
toc

%%
