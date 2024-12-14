function response = NAIVEBAYES_prepare(mssg)
    % this function removes non alphan-numeric characters and marks the negation in the sentences for better naive
    % bayes classification
    % [HOW?] not happy -> NOT_happy
    % [SOURCE]
    %   https://elearning.ua.pt/pluginfile.php/5609385/mod_resource/content/7/MPEI-2024-2025-TP6_Naive_Bayes_AT.pdf
    %   at page 32
    % mssg is a char array
    
    response = "";

    if ismissing(mssg)
        return
    end

    % split message on ' ' 
    parts = split( ...
        lower(mssg) ...
        ,' ');

    % remove non alpha-numerics from each part but keep punctuation still
    parts = regexprep(parts, '[^a-zA-Z.,!?;:]', '');
    
    % negation words [TODO] add more
    negationWords = { ...
    'not', 'none', 'never', 'nowhere', 'nothing', ...
    'nobody', 'dont', 'doesnt', 'didnt', 'cant', 'cannot', ...
    'couldnt', 'wont', 'wouldnt', 'shouldnt', 'isnt', 'arent', ...
    'wasnt', 'werent', 'havent', 'hasnt', 'hadnt', 'without' ...
    };

    negationWordsDict = containers.Map(negationWords,1:length(negationWords));

    negate = false;

    % for each part
    for i = 1:length(parts)
       
        word = parts{i};
        clean_word = regexprep(word,'[.,!?;:]','');
        
        if isempty(clean_word)
            
            negate = false;
            continue
        end

        % check if it is a negation word
        if isKey( ...
                negationWordsDict, ...
                clean_word)
            negate = true;
            response = strcat(response,[' ' clean_word]);
            continue
        end

        % if negate is true, then negate the word
        if negate
            response = strcat(response,[' NOT_' clean_word]);
        
            % if this word has a punctuation then negate to false
            % if length isnt equal then  punctuation was removed 
            if length(word) ~= length(clean_word) 
                negate = false;
                
            end
            continue
        end
            
        % add word to response
        response = strcat(response,[' ' clean_word]);

    end
    response = strtrim(response);
    
end
