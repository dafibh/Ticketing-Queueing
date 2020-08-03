function y = CounterSetup(CounterN)
    
    for i=1: CounterN
        printf('\n -- Counter %1.0f/%1.0f -- \n', i,CounterN);
        Counter(i,1) = input('Counter Status [0-Close / 1-Open]: ');
        Counter(i,2) = 0;
        Counter(i,3) = 0;
        Counter(i,4) = 0;
        
    end
    
    y=Counter;