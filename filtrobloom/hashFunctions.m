function hc = hashFunctions(item,hf)
    
    sizeString = length(item);
    elemento = item;
    for i = 1:hf
        elemento(sizeString + i) =  num2str(mod(i, 10));
    end
    
    % use ascii values of item
    ASCII = double(...
        char(elemento));

    % inspiration taken from java implementation of string.hashcode()
    hc = 7;

    for i = 1:length(ASCII)
        carac = ASCII(i);

        hc = 31*hc + carac;
    end
end