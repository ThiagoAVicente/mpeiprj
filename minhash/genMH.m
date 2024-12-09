function MH = genMH(Set,R)
    % return a minhash matrice
    % thiago vicente - 121497 

    % initialize minhash matrice with inf values
    MH = inf(R.k,length(Set));

    % for each row in Set
    for row_i =1:length(Set)
        
        % get row shingles
        row = Set{row_i};
        numElmts = length(row);

        % for each shingle in row
        for elem_i = 1:numElmts

            % get element
            elem = row{elem_i};

            % for each hash functions 
            for hf = 1:R.k
               
                % calculate hashcode
                hc = hashFunctions(elem,R,hf);
                
                % if new hashcode is greateer than previous, change it
                if MH(hf,row_i) > hc
                    MH(hf,row_i) = hc;
                end

            end
        end

    end

end