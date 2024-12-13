function hc = MINHASH_hashFunctions(item, R, hf)
    % return a hashcode using binary numbers
    % important links:
    %   https://www.geeksforgeeks.org/hash-functions-and-list-types-of-hash-functions/
    %   https://ieeexplore.ieee.org/document/1432664
    %   
    % thiago vicente - 121497

    % use ascii values of item
    ASCII = char(item);
    bin_vals = '';

    % get binaries of the bin_vals
    for i = 1:length(ASCII)
        bin_vals = [bin_vals, dec2bin(double(ASCII(i)), 7)];
    end

    % get values from R
    dis = R.distributionFactor;
    b = R.b(hf);
    p = R.p;
    % Initialize hash value
    hc_bin = uint32(0);
    % Apply hash using xor and bit shifting
    for i = 1:length(bin_vals)
        
        bit_value = bin_vals(i) == '1'; 
        
        hc_bin = bitxor(hc_bin, uint32(bit_value));

        % multiply by 2
        hc_bin = bitshift(hc_bin, 1);  
    end
    % Apply final XOR with additional constants
    hc_bin = bitxor(hc_bin + uint32(b),uint32(dis));

    % Ensure that the final hash is within range by using modulo
    hc = mod(hc_bin,p);
end
