function MH = MINHASH_genMH(Set,R)
    % return a minhash matrice
    % thiago vicente - 121497 

    % initialize minhash matrice with inf values
    MH = inf(R.k,length(Set));

    h = waitbar(0, 'MH...');
    totalIterations = length(Set) * R.k;

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
                %tic
                % calculate hashcode
                hc = MINHASH_hashFunctions(elem,R,hf);
                %toc
                % if new hashcode is greateer than previous, change it
                if MH(hf,row_i) > hc
                    MH(hf,row_i) = hc;
                end

            end
        end

        if mod(row_i, 100) == 0
            waitbar(row_i / length(Set), h);
        end
    end

    close(h);
end