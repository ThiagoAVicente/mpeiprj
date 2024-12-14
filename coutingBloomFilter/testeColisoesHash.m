clear
clc

load("save/output.mat")

m = length(userNames);
userPassed = cell(0);
userPassedC = 0;
isMissing = 0;
hashcodes = [];
howManyValidUsers = 0;
for i = 1:m

    user = userNames{i};

    if isa(user, 'missing') %no dataset pode haver linhas sem user name
        isMissing = isMissing + 1;
        continue            %entao este if faz com que o programa nao "morra"
    end                     %caso haja uma linha sem username
    
    if isa(user, "double")
        user = convertStringsToChars(int2str(user));
    end

    if( (ismember(user, userPassed) == false) )
        userPassedC = userPassedC + 1;
        userPassed{userPassedC} = user;
        hashcodes(userPassedC) = hashFunctions(user, 31, 1);
    end

    howManyValidUsers = howManyValidUsers + 1;

end

howManyUniqueHashes = length(unique(hashcodes));
colisions = userPassedC - howManyUniqueHashes;

probOfColision = colisions / howManyValidUsers;

disp("Probabilidade de colisao e : " + probOfColision);

