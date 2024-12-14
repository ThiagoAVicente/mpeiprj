function vectorPrime = FILTROBLOOM_getNPrimeNumbers(start, n)
%getNPrimeNumbers   returns a 1xN vector with N prime numbers starting on
%start

number = start;
vectorPrime = zeros(1, n);
counter = 1;

if mod(start,2) == 0
    number = number+1;
end

while(counter < n+1)
    if isprime(number)
        vectorPrime(counter) = number;
        counter = counter + 1;
    end
    number = number + 2;
   
end