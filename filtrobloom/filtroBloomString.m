classdef filtroBloomString
    %FiltroBloom
    %Classe de filtroBloom que permite colocar elementos(tem que ser
    %array de char(string)) e depois rapidamente averiguar se fazem parte ou não do
    %conjunto
    %Para isso são usadas funções de hash e uma hash table
 
    properties
        hashTable; %tabela em si
        nmrOfElements; %nmr de elementos já colocados
        nmrOfFunctions; %nmr de funcoes de hash
        sizeOfTable; % tamanho da hash table(quantos "lugares" tem a tabela)
        matrixPrime; %matrix that helps the hashcode generation
    end

    methods
        function obj = filtroBloomString(n ,k)
            %Construtor da classe FiltroBloomString
            %Cria um filtroBloom com uma hashTable
            %com n lugares livres e vai usar k funções de hash

            obj.hashTable = zeros(n, 1);
            obj.sizeOfTable = n;
            obj.nmrOfElements = 0;
            obj.nmrOfFunctions = k;
            obj.matrixPrime = getNPrimeNumbers(31, k);
        end

        function obj = addElement(obj, element)
            %AddElement
            %   Adds imput to the bloomFilter, it uses obj.nmrOfFunctions hash functions to put value on hashTable
            
             obj.nmrOfElements = obj.nmrOfElements + 1;            
             element = convertStringsToChars(element);

             for i = 1:obj.nmrOfFunctions
                hashcode = mod(hashFunctions(element,obj.matrixPrime,i), obj.sizeOfTable) + 1;
                obj.hashTable(hashcode) = 1;
             end

        end

        function isIn = checkElement(obj, element)
            %CheckElement
            %   Checks if certain element is in bloomFilter
            %   It uses obj.nmrOfFunctions hash functions to check the hash
            %   value and then checks if the value is part or not part of
            %   the set

            %IMPORTANT
            
            %   if the function returns 0(non existent) it is 100% certain
            %   that the element does not exist on the set, but if the
            %   function returns 1(exists) it is not certain(but it is very likely)
            %   that the element exists
            
            isIn = 1;
            element = convertStringsToChars(element);
            
            for i = 1:obj.nmrOfFunctions
               hashcode = mod(hashFunctions(element,obj.matrixPrime,i), obj.sizeOfTable) + 1;
               if obj.hashTable(hashcode) == 0
                   isIn = 0;
                   return
               end
               
            end

        end
    end
end