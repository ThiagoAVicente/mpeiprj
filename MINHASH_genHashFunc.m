function R =  MINHASH_genHashFunc(k)
    % returns struct with params for hashfunctions

    R = struct;
    
    % find a big prime number
    largePrime = 1e7+7;
    while ~isprime(largePrime)
        largePrime= largePrime+2;
    end

    % compute the num of needed hashfunctions for less colisions
    nhf = k;

    R.b = randi([0 largePrime-1],nhf,1);
    R.distributionFactor = 31;
    R.p = largePrime;
    R.k = nhf;

end