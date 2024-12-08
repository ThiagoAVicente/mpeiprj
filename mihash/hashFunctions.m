function hc = hashFunctions(item,R,hf)

    % use ascii values of item
    ASCII = double(...
        char(item));
    ASCII = ASCII.*(1:numel(item));

    % get values from R
    r = R.values(hf,:);
    dis = R.disrupt;
    b = R.b(hf);
    p = R.p;
    ASCII = ASCII-dis;
    % apply equation
    hc =mod ( (sum(r.*ASCII) + b), p );

end