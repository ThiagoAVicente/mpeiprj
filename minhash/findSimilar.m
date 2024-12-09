function similar = findSimilar(item,shingle_size,MH,threshold,R)
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
    shingles = cell(1);
    row = {};
    char_sentence = char(sentence);

    for shingle_ind = 1:len-shingle_size+1
        % add shilgle to the Set 
        row{end+1} = [char_sentence(shingle_ind:shingle_ind+shingle_size-1)];
    end

    shingles{1} = row;
    % get minHas
    MH2 = genMH(shingles,R);

    similar = [];
    % compare to each element in MH
    for column_i = 1:size(MH,2)

        column = MH(:,column_i);

        % calculate jaccard distance
        j = sum(MH2(:) == column(:))/...
            R.k;
        
        % if jaccard distance is threshold
        if 1-j < threshold
            similar = [similar column_i];
        end


    end

end