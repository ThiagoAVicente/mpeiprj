function hc = hashFunctions(item,R,hf)
    % return a hashcode
    % thiago vicente - 121497

    % use ascii values of item
    ASCII = double(...
        char(item));
    ASCII = ASCII.*(1:numel(item));

    % get values from R
    r = R.values(hf,:);
    dis = R.distributionFactor;
    b = R.b(hf);
    p = R.p;
    ASCII = ASCII.*p-dis;
    % apply equation
    hc =mod ( (sum(r.*ASCII) + b), p );

end