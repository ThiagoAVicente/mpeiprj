function [n,k] = getParams(m,p)
    % retorna n e k ótimos dado m e a probabilidade de falso positivos

    %   [FÓRMUlAS]
    %   (1-e^(-ln(2))) ^ (n_ótimo*ln(2)/m) <= p
    %   k_ótimo = round( n*ln(2)/m )
    %
    %   [FÓRMULAS SIMPLIFICADAS]
    %   a = 1-e^(-ln(2))
    %   n_ótimo = ln(p)/ln(a) * m/ln(2)

    a = 1-exp(-log(2)); 
    
    n = log(p)/log(a) * m/log(2);

    % kótimo
    k = n*log(2)/m; 
    
end