clear
clc

elementos = {'JoaoPedro', 'JoaoPedroA', 'JoaoPedroo', 'JoaoPedr', 'JoaoPedroB', 'JaoPderoo'};
k = 30;
matrixPrime = getNPrimeNumbers(101, k+1);
Legend = cell(1, 6);

for j = 1:length(elementos)
    elemento = elementos{j};


    codes = zeros(1, 30);
    for i = 1:k
        hascode = COUNTINGBF_hashFunctions(elemento, matrixPrime, i);
        codes(i) = hascode;
    end
    subplot(2,3, j);
    Legend{j} = elemento;
    plot(1:k,codes, "o");
end
legend(Legend);
%legend show