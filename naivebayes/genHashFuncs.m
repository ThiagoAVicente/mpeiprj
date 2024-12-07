function R = genHashFuncs(hf)
    % returns a struct with hf prime numbers
    
    start = randi([1e7 1e9]);
    
    %ensure start is odd
    if mod(start,2)==1
        start = start+1;
    end
    primes = zeros(1, hf);
    count = 0;
    
    % Loop until hf primes are found
    while count < hf
        while ~isprime(start)
            
            start = start+1;
            
        end
        count = count+1;
        primes(count) = start;
        
        
        %select new start 
        start = randi([1e7 1e9]);
        if mod(start,2)==1
            start = start+1;
        end
    end
    
    R.p = primes;
end