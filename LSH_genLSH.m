function [LSH,D] = LSH_genLSH(b,MH,D)
    % creates the lsh matrice
    
    % calculate r
    numLines = size(MH,1);
    r = numLines/b;
    % initialize r
    LSH = zeros(b,size(MH,2));

    h = waitbar(0, 'LSH...');
    
    for band_i = 1:b

        b_now = band_i;
        start_row = (b_now-1)*r+1;
        end_row = b_now *r;
        
        band = MH(start_row:end_row,:);

        % iterate for each document and apply hash to that document band
        for doc_i = 1:size(MH,2)
            % get signatures on this document and band
            signature = band(:,doc_i);

            hash_curr = LSH_hashFunction(signature,D,band_i);
            LSH(band_i,doc_i) = hash_curr;

        end
        waitbar(band_i / b, h);
    end
    close(h);
    

end