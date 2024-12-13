function hash = hashFunctions(item,matrixPrime,hf)
    
    ASCII = double(item);

    % inspiration taken from java implementation of string.hashcode()

    prime = matrixPrime(hf);
    hash = 7;
    for i=1:size(ASCII,2) 
        hash = hash * prime + ASCII(i);
        hash = mod(hash, 2^32 - 1);
    end
   
end