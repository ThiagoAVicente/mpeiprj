classdef CountingFiltroBloomString
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
        function obj = CountingFiltroBloomString(n ,k)
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
                hashcode = mod(hashFunction2(element,i), obj.sizeOfTable) + 1;
                obj.hashTable(hashcode) = obj.hashTable(hashcode) + 1;
             end

        end

        function isRepeatedLess = isRepeatedLessThan(obj, element, limiar)
            %   isRepeatedLessThan 
            %   Checks if certain element is in BloomFilter less than
            %   limiar times
            %   It uses obj.nmrOfFunctions hash functions to check the hash
            %   value and then checks if the value is part or not part of
            %   the set

            %IMPORTANT
            
            %   if the function returns 0(repeatedLessThan) it is 100% certain
            %   that the element does not repeat on the set more than limiar times, but if the
            %   function returns 1(repeats more or the same times as limiar) 
            %   it is not certain(but it is likely) that the element
            %   repeats more(or same as) than limiar times 
            
            isRepeatedLess = 1;
            element = convertStringsToChars(element);
            
            for i = 1:obj.nmrOfFunctions
               hashcode = mod(hashFunction2(element,i), obj.sizeOfTable) + 1;
               if obj.hashTable(hashcode) < limiar
                   isRepeatedLess = 0;
                   return
               end
               
            end

        end
    end
end