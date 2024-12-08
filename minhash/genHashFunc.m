function R =  genHashFunc(m,shingle_size)
    % returns struct with params for hashfunctions

    R = struct;
    
    largePrime = 1e7+7;
    while ~isprime(largePrime)
        largePrime= largePrime+2;
    end


    nhf = round(largePrime*log(2)/m);

    R.values = randi([0 largePrime-1],nhf,shingle_size);
    R.b = randi([0 largePrime-1],nhf,1);
    R.disrupt = 31;
    R.p = largePrime;
    R.k = nhf;

end