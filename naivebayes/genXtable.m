function x = genXtable(data,emojis,bad,good,R)
        
    bln = false(size(data,1),2);
    sizes = uint8(ones(size(data, 1), 1));

    % for each sentence check presence of bad or good words
    for i = 1:size(data,1)
        stc = string(data{i});
        parts = stc.split();

        % for good words
        for j = 1:length(parts)
            
            word = parts(j);

            % check if contains good word
            if fb_contains(good,word,R)
                bln(i,1) = true;
            end
        end

        % for bad words
        for j = 1:length(parts)
            
            word = parts(j);

            % check if contains bad word
            if fb_contains(bad,word,R)
                bln(i,2) = true;
            end
        end

        % put size
        sizes(j,1) = strlength(stc);

    end
    a = emojis(:);
    a = cell2mat(a);
    x = struct();
    x.label = '1->good 2->bad';
    x.presence = bln;
    x.sizes = sizes;
    x.emojis = a==1;

end