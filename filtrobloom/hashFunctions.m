function hc = hashFunctions(item,prime,hf)

    % use ascii values of item
    ASCII = double(...
        char(item));
    ASCII = ASCII.*(1:numel(item));

    sizeString = length(ASCII);
    
    for i = 0:hf-1
        ASCII(sizeString + i) = i;
    end

    % inspiration taken from java implementation of string.hashcode()
    hc = 1;
    for i = 1:sizeString
        carac = ASCII(i);

        hc = prime*h + carac;
    end

end