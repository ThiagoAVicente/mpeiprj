function hc = hashFunction2(elemento,hf)

size = length(elemento);

for i = 1:hf
    elemento(size + i) =  num2str(mod(i, 10));
end

hc = string2hash(elemento);