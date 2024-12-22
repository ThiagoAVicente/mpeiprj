function similar = LSH_findSimilar(item,shingle_size, MH,threshold,R,LSH,D)
    % find similars using lsh aproach

    sentence = string(item);
    len = strlength(sentence);
    % if length of the row is less than shingle size then skip it
    if len < shingle_size
        error("[ERROR] cannot create shingles from item")
    end

    [shingles, ~] = MINHASH_genSetOfShingles({item},shingle_size);

    % get minHas
    MH2 = MINHASH_genMH(shingles,R);
    
    b = size(D.a,1);
    LSH2 = LSH_genLSH(b,MH2,D);
    
    
    similar = [];
    % compare to each element in MH
    for column_i = 1:size(LSH,2)

        column = LSH(:,column_i);

        if any(LSH2 == column)
            % calculate jaccard distance
            j = sum(MH2== MH(:,column_i))/...
                R.k;
            
            % if jaccard similarity is greater or equal threshold
            if j >= threshold
                similar = [similar column_i];
            end
        end
    end
    
    

end
