function h = LSH_hashFunction(signature,D,hf)
    % xor based hashfunction for lsh
    % return a hashcode using binary numbers
    % important links:
    %   https://www.geeksforgeeks.org/hash-functions-and-list-types-of-hash-functions/
    %   https://ieeexplore.ieee.org/document/1432664
    %   

    a = D.a(hf,:);
    b = D.b(hf,:);
    p = D.p;
    %size(a)
    %size(signature)
    mul = a'.*signature;

    hc = 0;
    % apply xor 
    for sig_i = 1:length(signature)
        hc = bitxor(mul(sig_i),hc) + b(sig_i);
        hc = hc * 2;
    end


    h = mod(hc,p);



end