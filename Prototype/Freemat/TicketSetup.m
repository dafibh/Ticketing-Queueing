function y = TicketSetup(TicketN)
    
    for i=1: TicketN
        printf('\n -- Ticket %1.0f/%1.0f -- \n', i,TicketN);
        Ticket(i,5) = input('Ticket Price: ');
        Ticket(i,4) = input('Ticket Max Range: ');
    end
    
    y=Ticket;