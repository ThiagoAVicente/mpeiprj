function vWords = getWords( txt )
    
    %str join
    %regexp
    %unique

    counter = 1;

    for i = 1:length(txt)
        stc = txt{i};
        words = split(stc); % split sentence into words
        
        for j = 1:length(words)
            cleanWord = regexprep(words{j}, '[^a-zA-Z]', '');

            % Skip empty words after cleaning
            if ~isempty(cleanWord)
                vWords{counter} = cleanWord; % Store the cleaned word
                counter = counter + 1;
            end
        end
    
    end


end