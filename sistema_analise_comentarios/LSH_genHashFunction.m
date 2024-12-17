function D = LSH_genHashFunction(b,r)
    
    D = struct();

    % find a big prime number
    largePrime = 1e7+7;
    while ~isprime(largePrime)
        largePrime= largePrime+2;
    end

    D.b = randi([1 largePrime-1],b,r);
    D.p = largePrime;
    D.a = randi([1 largePrime-1],b,r);



end