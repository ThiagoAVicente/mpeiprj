function rsp = fb_contains(FB,word,R)
    
    rsp = true;

    for ihf = 1: FB.k
        
        % set position given by hashfuntion to true
        h = hashFunctions(word,ihf,R);
        h = mod(h,FB.n)+1;
   
        if FB.data(1,h) == false
            rsp = false;
            break;
        end

    end

end