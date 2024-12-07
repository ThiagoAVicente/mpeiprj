function tokens = tokenize(data)
    % return all tokens of data

    tokens = {};

    totalRows = length(data);
    progressBar = waitbar(0, 'tokens...');

    % for each line of data
    for row_i = 1:totalRows
        
        line = data{row_i};

        % use string for methods
        parts = string(line).split();

        % consider just the words that have 4 or more letters
        inds = strlength(parts)>3;
        meaning_words = parts(inds);
        
        % for each word
        for word_i = 1:length(meaning_words)
            
            word = meaning_words(word_i);

            % if tokens is empty then just add it and go to next iteraction
            if isempty(tokens)
                tokens{end+1} = word;
                continue;
            end
            

            add = true;

            % check if there is any token than is near this one
            for token_i = 1:length(tokens)
                
                token = tokens{token_i};
                % if token starts with word then remove token and add word
                if startsWith(token,word)
                    tokens{token_i} = word;
                    add = false;
                end

                % if word start with token then dont add word
                if startsWith(word,token)
                    add = false;
                end

            end

            % if not then add it
            if add
                tokens{end+1} = word;
            end

        end

        waitbar(row_i / totalRows, progressBar);
    end

    close(progressBar);
end