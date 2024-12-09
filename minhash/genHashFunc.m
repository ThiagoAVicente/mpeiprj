function R =  genHashFunc(m,shingle_size)
    % returns struct with params for hashfunctions
    % thiago vicente - 121497

    R = struct;
    
    % find a big prime number
    largePrime = 1e7+7;
    while ~isprime(largePrime)
        largePrime= largePrime+2;
    end

    % compute the num of needed hashfunctions for less colisions
    nhf = round(largePrime*log(2)/m);

    R.values = randi([0 largePrime-1],nhf,shingle_size);
    R.b = randi([0 largePrime-1],nhf,1);
    R.distributionFactor = 31;
    R.p = largePrime;
    R.k = nhf;

end