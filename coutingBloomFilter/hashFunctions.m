function hash = hashFunctions(item,matrixPrime,hf)
    
    ASCII = double(item);

    % inspiration taken from java implementation of string.hashcode() and
    % FV

    prime = matrixPrime(hf); %get a prime number from the matrix
    hash = prime;
    for i=1:size(ASCII,2) 
        hash = bitxor(hash, ASCII(i));
        hash = hash*prime * ASCII(i);
        hash = mod(hash, 2^32 - 1); %in case it overflows (it WILL overflow)
    end
    
end