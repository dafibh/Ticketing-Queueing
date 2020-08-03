function y = Type(rand,Item,ItemN)
    
    for i=1 : ItemN
        if rand <=Item(i,4)
            num=i;
            break;
        end
    end
    
    y=num;