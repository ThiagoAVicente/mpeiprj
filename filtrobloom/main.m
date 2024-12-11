clear
clc

dic = readcell("save/reduced.csv");
userNames = dic(:, 1);

m = length(userNames);
n = length(userNames) * 100;

k = floor(n*log10(2) / m);
filtroBloomUsers = filtroBloomString(n, k);

counter = 1;
for i = 1:m
    
    name = userNames{i};
    
    if isa(name, 'missing')
        continue
    end

    if(filtroBloomUsers.checkElement(name) == 1)
        counter = counter + 1;
    else
        filtroBloomUsers = filtroBloomUsers.addElement(name);
    end
end
