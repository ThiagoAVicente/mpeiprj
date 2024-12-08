function tokens = tokenize(data)
    % return all tokens of data

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

                    % Se o token começa com a palavra ou se a palavra começa com o token
                    if startsWith(token, word)  % Substitui o token por uma versão mais curta
                        tokens(token) = word; % Substitui o token
                        add = false; % Não adiciona, pois o token foi substituído
                        break;
                    elseif startsWith(word, token) % Se a palavra é um prefixo do token, não adiciona
                        add = false;
                        break;
                    end
                end

                % Se a palavra não substituir um token existente, adiciona
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