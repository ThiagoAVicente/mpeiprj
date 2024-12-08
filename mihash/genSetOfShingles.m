function [Set,indices] = genSetOfShingles(data,shingle_size)
    % return a set of every shingle contained in data
    % also returns an array of indices of used rows
    
    Set = {};
    indices = [];
    now = 1;
    numRows = length(data);
    % for each row of data
    for row_i = 1:numRows
        
        % get sentence
        sentence = string(...
            data{row_i});

        len = strlength(sentence);
        % if length of the row is less than shingle size then skip it
        if len < shingle_size
            continue;
        end

        indices(end+1) = row_i;
        % else for each shilgle
        char_sentence = char(sentence);

        Set{end+1} = {};
        for shingle_ind = 1:shingle_size:len-shingle_size+1
            % add shilgle to the Set 
            Set{now} = [Set{now} char_sentence(shingle_ind:shingle_ind+shingle_size-1)];
        end

        now = now +1;
    end
end