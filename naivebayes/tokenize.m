function tokens = tokenize(data)
    % return all tokens of data
    % thiago vicente -121497

    tokens = containers.Map();

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
            if ~tokens.isKey(word)
                tokenKeys = keys(tokens);
                add = true;
                for token_i = 1:length(tokenKeys)
                    token = tokenKeys{token_i};

                    if startsWith(token, word)  
                        tokens(token) = word; 
                        add = false; 
                        break;
                    elseif startsWith(word, token) 
                        add = false;
                        break;
                    end
                end

                if add
                    tokens(word) = word;
                end
            end

        end

        waitbar(row_i / totalRows, progressBar);
    end

    close(progressBar);
end


%data = readcell("output.csv");

%%
%tokens = getTokens(data(:,2));

%%
%save("saved/tokens.mat","tokens")