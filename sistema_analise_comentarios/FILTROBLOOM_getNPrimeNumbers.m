function vectorPrime = FILTROBLOOM_getNPrimeNumbers(start, n)
%getNPrimeNumbers   returns a 1xN vector with N prime numbers starting on
%start

number = start;
vectorPrime = zeros(1, n);
counter = 1;

while(counter < n)
    if isprime(number)
        vectorPrime(counter) = number;
        counter = counter + 1;
    else
        number = number + 1;
    end
end
