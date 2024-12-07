function hashcode = hashFunctions(item,hf,R)
    
    if ismissing(item)
        item = 1;
    end
    item = char(item);

    % find the "hf"st prime number starting from a given num
    p = R.p(hf);

    h = 1e9+7;
    s = 0;

    for i =1:numel(item)
        
        % ensure a odd value
        l = item(i) * i;

        if mod(l,2)==0
            l = l+1;
        end
    
        % increment sum
        s = s + mod(h*l,p);
        
    end

    hashcode =s*length(item);

end