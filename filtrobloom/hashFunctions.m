function hash = hashFunctions(item,hf)
    
    %sizeString = length(item);
    %elemento = item;
    %for i = 1:hf
        %elemento(sizeString + i) =  num2str(mod(i, 10));
    %end
    
    % use ascii values of item
    ASCII = double(item);

    % inspiration taken from java implementation of string.hashcode()
    primeNums = primes(hf*10);
    numP = primeNums(length(primeNums));
    hash = 7;
    for i=1:size(ASCII,2) 
        hash = hash * numP + ASCII(:, i);
    end
   
    hash = mod(hash, 2^32 - 1); %values were getting a lot big and it has very bad, so this stops it
end