function y = InterArrivalSetup(InterArrivalN)
    
    for i=1: InterArrivalN
        printf('\n -- InterArrival %1.0f/%1.0f -- \n', i,InterArrivalN);
        InterArrival(i,5) = input('InterArrival Time Amount: ');
        InterArrival(i,4) = input('InterArrival Max Range: ');
    end
    
    y=InterArrival;