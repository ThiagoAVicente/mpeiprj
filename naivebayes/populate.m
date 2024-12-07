function FB = populate(data,FB,R)

    % for each data
    hcs = zeros(1,length(FB.data));
    for item_indice = 1:length(data)
    
        % for each hash function
        for ihf = 1: FB.k
            % set position given by hashfuntion to true
            h = hashFunctions(data{item_indice},ihf,R);
            h = mod(h,FB.n)+1;
            hcs(h) = hcs(h) + 1;

            FB.data(1,h) = true; 
    
        end

    end

    plot(1:length(hcs),hcs)
    title("colisoes")


end