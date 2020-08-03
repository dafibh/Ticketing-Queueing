function y = Rando(Choice, m,seed,A,C)
    a=A;
    c=C;
    if Choice==2 %Additive
        a=1;
    elseif Choice ==3 %Multiplicative
        c=0;
    end
    
    Number = mod(((a*seed) + c),m);
    Number = Number+1;
    
    if Choice==4
        Number = randi(1,m);
    end
    y=Number;