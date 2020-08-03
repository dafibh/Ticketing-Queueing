function y = ServiceSetup(ServiceN)
    
    for i=1: ServiceN
        printf('\n -- Service %1.0f/%1.0f -- \n', i,ServiceN);
        Service(i,5) = input('Service Time Amount: ');
        Service(i,4) = input('Service Max Range: ');
    end
    
    y=Service;