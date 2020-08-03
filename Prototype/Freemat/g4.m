function g4()
    clc;
    seed = input('Seed: ');
    speed = 1;
    speed = input('Simulation Speed. [0-Instant / 1-Default]: ');
    InterSeed = seed;
    ServiceSeed = seed;
    TicketSeed = seed;
    
    TicketN = input('How many type of tickets?: ');
    
    CounterN = input('Amount of Counters: ');
    ServiceN = input('How many type of Service Time? : ' );
    InterArrivalN = input('How many type of InterArrival Time: ');
    CustomerN = input('How many Customers?: ');
    
    if CustomerN<1
        printf('Customer cannot be less than 1, assigned 10 customers.');
    end
    
    % TICKET SETUP [ Price, Probability, CDF, Range ]
    clc;
    disp('   Ticket Setup    <--')
    
    Ticket = TicketSetup(TicketN);
    TicketMaxRange = Ticket(TicketN,4);
    Ticket = probCDFRange(Ticket, TicketN, TicketMaxRange); % SET PROBABILITY, CDF, MIN RANGE
    printf('\n');
    MinQty = input('Minimum Quantity of Ticket: ');
    MaxQty = input('Maximum Quantity of Ticket: ');
    
    
    % SERVICE TIME SETUP [ Time, Probability, CDF, Range ]
    clc;
    disp('   Service Time Setup    <--')
    
    Service = ServiceSetup(ServiceN);
    ServiceMaxRange = Service(ServiceN,4);
    Service = probCDFRange(Service, ServiceN, ServiceMaxRange); % SET PROBABILITY, CDF, MIN RANGE
    
    
    % INTERARRIVAL TIME SETUP [ Time, Probability, CDF, Range ]
    clc;
    disp('   InterArrival Time Setup    <--')
    
    InterArrival = InterArrivalSetup(InterArrivalN);
    InterArrivalMaxRange = InterArrival(InterArrivalN,4);
    InterArrival = probCDFRange(InterArrival, InterArrivalN, InterArrivalMaxRange); % SET PROBABILITY, CDF, MIN RANGE
    
    
    % COUNTER SETUP [ Status ] 
    clc;
    disp('   Counter Setup    <--');
    
    Counter = CounterSetup(CounterN);
    % Initialize Individual Counter Queues
    for i=1: CounterN
        Cursor(i)=1;
        for x=1:CustomerN
            Queue(i,x)=0;
        end
    end
    
    %Initialize Ready Queue
    for i=1: CustomerN
        ReadyQ(i)=0;
    end
    ReadyCursor=1;
    
    
    %RNG SETUP
    clc;
    disp('   RNG Setup    <--');
    printf('RN = [ ( Seed*A ) + C ] mod M\n');
    printf('\n[1] Mixed LCG\n[2] Additive LCG, A=1\n[3] Multiplicative LCG, C=0\n[4] Freemat randi(X,Y) function *Recommended\n*Choice 4 does not use seed\n\n');
    Randomizer=input('Randomizer Type: ');
    A=input('Value for A: ');
    C=input('Value for C: ');
    
    
    
    % CUSTOMER INIT ( Too much work to put in different .m file )
    for i=1:CustomerN
        Customer(i,1) = Rando(Randomizer, InterArrivalMaxRange, InterSeed,A,C);%RN for Inter
        InterSeed=Customer(i,1);
        
        Customer(i,2) = InterArrival(Type(Customer(i,1),InterArrival,InterArrivalN),5);%Actual Inter
        
        if i==1 %AT (This Inter+prvious cust AT)
            Customer(i,3) = 0;
        else
            Customer(i,3) = Customer(i-1,3)+Customer(i,2);
        end
        
        Customer(i,4) = Rando(Randomizer, ServiceMaxRange, ServiceSeed,A,C);%RN for BT
        ServiceSeed=Customer(i,4);
        
        Customer(i,5) = Service(Type(Customer(i,4),Service,ServiceN),5);%actual BT
        Customer(i,6) = 0; %Elapsed Time, time being served
        Customer(i,7) = 0; %Waiting Time, Time in Queue but not served
        Customer(i,8) = 0; %Counter Chosed
        Customer(i,9) = 0; %Time in System, Waiting+BT
        Customer(i,10) = Rando(Randomizer, TicketMaxRange, TicketSeed,A,C); %RN Ticket Type
        TicketSeed=Customer(i,10);
        
        Customer(i,11) = Type(Customer(i,10),Ticket,TicketN); %Ticket Type
        Customer(i,12) = randi(MinQty,MaxQty); %Ticket Amount
        Customer(i,13) = Customer(i,12)*Ticket(Customer(i,11),5); %Total Price [Amount * Ticket Price]
        Customer(i,14) = 0;%Service Start time
        Customer(i,15) = 0;%Service Finish time
    end
    
    clc;
    printf('\n -- SERVICE TABLE --\n');
    printf(' -------------------\n');
    printInit(Service,ServiceN, 'TIME');
    printf('\n -- INTERARRIVAL TABLE --\n');
    printf(' ------------------------\n');
    printInit(InterArrival,InterArrivalN, 'TIME');
    printf('\n -- TICKET TABLE --\n');
    printf(' ------------------\n');
    printInit(Ticket,TicketN, 'PRICE');
    
    
    
    
    
    
    %Begin Simulation
    printf('\nSTART SIMULATION\n\n');
    
    
    time=0;
    Done=0; %Amount of customers that have been served
    
    totalOpen=0; %Init amount of open starting counter to avoid no counter open at start
    for i=1:CounterN
        if Counter(i,1)==1
            totalOpen=totalOpen+1;
        end
    end
    if totalOpen<1 %Open the first Counter due to no open counter 
            ctr=randi(1,CounterN);
            Counter(ctr,1)=1;
            printf('Random Counter opened due to no open counters. Counter %1.0f Opened\n',ctr);
        end
    for i=1:TicketN %Init Amount of ticket Bought
        ticketBoughtN(i)=0;
    end
    
    while Done ~= CustomerN
        
        for i=1:CounterN %elapsed
            if Cursor(i)>1
                Customer(Queue(i,1),6)=Customer(Queue(i,1),6)+1;
            end
            
            if Cursor(i)>2%Waiting
                for x=2:Cursor(i)-1
                    Customer(Queue(i,x),7)=Customer(Queue(i,x),7)+1;
                end
            end
        end
        
         for i=1:CounterN %completing
            if Cursor(i)>1
                if Customer(Queue(i,1),6) == Customer(Queue(i,1),5)
                    printf('[ %1.0f ] Counter %1.0f has finished serving Customer %1.0f.\n',time, i,Queue(i,1));
                    pause(speed);
                    Queue(i,1)=0;
                    Queue(i,:)=circshift(Queue(i,:),[0,-1]);
                    Cursor(i)=Cursor(i)-1;
                    Done=Done+1;
                    
                    if Cursor(i)>1
                        printf('[ %1.0f ] Counter %1.0f has started serving Customer %1.0f.\n',time, i,Queue(i,1));
                    end
                end
            end
        end
        
        for i=1:CustomerN %put into readyq
            if Customer(i,3) == time
                ReadyQ(ReadyCursor)=i;
                printf('[ %1.0f ] Customer %1.0f has arrived.\n',time,i);
                pause(speed);
                ReadyCursor=ReadyCursor+1;
            end
        end
        
        while ReadyCursor>1 %ready into open q
            lowest=0;
            for i=1:CounterN % lowest amount of cust of open Counter
                if Counter(i,1)==1
                    lowest=i;
                    break;
                end
            end
            if lowest~=0
                for i=1:CounterN %put into q by first comparing among the lowest counters
                    if Cursor(i)<Cursor(lowest) && Counter(i,1)==1
                        lowest=i;
                    end
                end
            end
            Queue(lowest,Cursor(lowest))=ReadyQ(1); 
            Cursor(lowest)=Cursor(lowest)+1;
            Customer(ReadyQ(1),8)=lowest;
            printf('[ %1.0f ] Customer %1.0f has entered Counter %1.0f.\n',time, ReadyQ(1),lowest);
            pause(speed);
            
            ReadyQ(1)=0;
            ReadyQ=circshift(ReadyQ,[0,-1]);
            ReadyCursor=ReadyCursor-1;
            
            for i=1:CounterN %open counter Decision
                if Cursor(i)>2
                    for x=1:CounterN
                        if Counter(x,1)==0
                            Counter(x,1)=1;
                            
                            printf('[ %1.0f ] Opening counter %1.0f\n',time, x);
                            break;
                        end
                    end
                end
            end
            
        end
        
        pause(speed);
        time = time+1;
        printf('\n');
    end
    disp('SIMULATION ENDED');
    
    % SUMMARIZATION
    
    for i=1: CustomerN %Set Values
        Customer(i,9)=Customer(i,7)+Customer(i,5);%Time in System
        Customer(i,14)=Customer(i,7)+Customer(i,3);%Service Start Time
        Customer(i,15)=Customer(i,14)+Customer(i,5);%Service End TIme
    end
    
    
    %Print Customer Summary
    printf('\n\n ----------------------\n');
    printf(' -- CUSTOMER SUMMARY --\n');
    printf(' ----------------------\n');
    printf('%2s%10s%10s%10s%10s%10s%11s%10s\n','n','RN Inter','Inter.','Arrival','RN Tkt','Tkt Type','Tkt Qty ', ' Amt. Paid');
    for i=1:CustomerN
        printf('%2.0f%10.0f%10.0f%10.0f%10.0f%10.0f%10.0f%10.0f\n',i, Customer(i,1),Customer(i,2),Customer(i,3),Customer(i,10),Customer(i,11),Customer(i,12),Customer(i,13));
    end
    
    %Print Counters Summary
    printf('\n\n ---------------------\n');
    printf(' -- COUNTER SUMMARY --\n');
    printf(' ---------------------\n');
    for i=1:CounterN
        printf(' Counter %1.0f\n',i);
        printf(' -------------\n');
        printf('%2s%10s%8s%12s%10s%10s%16s\n','n','RN Serv','Serv.','Serv Start','Serv End','Waiting','Time in System');
        for x=1:CustomerN
            if Customer(x,8)==i
                printf('%2.0f%10.0f%8.0f%12.0f%10.0f%10.0f%10.0f\n',x, Customer(x,4),Customer(x,5),Customer(x,14),Customer(x,15),Customer(x,7),Customer(x,9));
            end
        end
    end
    
    %Print Simulation Summary
    printf('\n\n ------------------------\n');
    printf(' -- SIMULATION SUMMARY --\n');
    printf(' ------------------------\n');
    
    %average waiting time
    %average interarival
    %average arrival
    %average time spent
    avgWT=0;
    avgIT=0;
    avgAT=0;
    avgTS=0;
    for i=1:CustomerN
        avgWT=avgWT+Customer(i,7);
        avgIT=avgIT+Customer(i,2);
        avgAT=avgAT+Customer(i,3);
        avgTS=avgTS+Customer(i,9);
    end
    avgWT=avgWT/CustomerN;
    avgIT=avgIT/CustomerN;
    avgAT=avgAT/CustomerN;
    avgTS=avgTS/CustomerN;
    
    
    
    %average service per counter
    %sales per counter
    for i=1:CounterN
        avgServ(i)=0;
        custpercounter(i)=0;
        counterSales(i)=0;
    end
    for i=1:CustomerN
        for x=1:CounterN
            if Customer(i,8)==x
                avgServ(x)=avgServ(x)+Customer(i,5);
                counterSales(x)=counterSales(x)+Customer(i,13);
                custpercounter(x)=custpercounter(x)+1;
            end
        end
    end
    
    for i=1:CounterN
        avgServ(i)=avgServ(i)/custpercounter(i);
    end
    
    
    printf('Average Waiting Time: %1.2f\n',avgWT);
    printf('Average InterArrival Time Time: %1.2f\n',avgIT);
    printf('Average Arrival Time: %1.2f\n',avgAT);
    printf('Average Time Spent in System: %1.2f\n\n',avgTS);
    
    for i=1:CounterN
        printf('Counter %1.0f Average Service: %1.2f\n',i, avgServ(i));
        printf('Counter %1.0f Total Sales: %1.2f\n',i, counterSales(i));
    end