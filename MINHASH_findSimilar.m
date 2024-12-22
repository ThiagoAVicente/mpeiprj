function similar = MINHASH_findSimilar(item,shingle_size,MH,threshold,R)
    % return an array of items that are similar to the input item using
    % jacard distance
    % thiago vicente - 121497

    sentence = string(item);
    len = strlength(sentence);
    % if length of the row is less than shingle size then skip it
    if len < shingle_size
        error("[ERROR] cannot create shingles from item")
    end

    % get shingles in item
    [shingles, ~] = MINHASH_genSetOfShingles({item},shingle_size);

    % get minHas
    MH2 = MINHASH_genMH(shingles,R);

    similar = [];
    % compare to each element in MH
    for column_i = 1:size(MH,2)

        column = MH(:,column_i);

        % calculate jaccard distance
        j = sum(MH2(:) == column(:))/...
            R.k;
        
        % if jaccard similarity is greater or equal threshold
        if j >= threshold
            similar = [similar column_i];
        end


    end

end