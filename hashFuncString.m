function h = hashFuncString(chave, tableSize)
%hashFuncString Functions that takes an array of caracteres (chave) amnd the 
% size fo thand returns an hash
%code

h = 0;
strDouble = double(chave);
lenghtChave = length(chave);

for i = 1:lenghtChave
    charAsci = strDouble(i);

    h = 37 * h + charAsci;
end

h = mod(h, tableSize);

end