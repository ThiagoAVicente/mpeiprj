clear
clc

dic = readcell("save/reduced.csv");
userNames = dic(:, 1);

counter = 0;
abc = 1;
repeated = [];
for i = 1:length(userNames)
    name1 =convertCharsToStrings(userNames{i});
    
    if  isa(name1, 'string') == 0 
        continue          
    end

    for j = i+1:length(userNames)

        name2 = convertCharsToStrings(userNames{j});
        
        if isa(name2, 'string') == 0
            continue
        end
        
        if name1 == name2
            %if ismember(name1, repeated)
                counter = counter + 1;
                %repeated(abc) = name1;
                %abc = abc + 1;
            %end
        end
    end
end