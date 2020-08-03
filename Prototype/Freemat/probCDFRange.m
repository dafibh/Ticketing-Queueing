function y = probCDFRange(matrix,n,maxrange)
    
    % Matrix :- 
    % prob | CDF | min | max
    
    %Set Min Range
    for i=1: n
        if i == 1
            matrix(i,3) = 1;
        else
            matrix(i,3) = matrix(i-1,4)+1;
        end
    end
    
    %Set CDF
    for i=1: n
        matrix(i,2) = matrix(i,4)/maxrange;
    end
    
    %Set Probability
    for i=1:n
        matrix(i,1) = (matrix(i,4)+1 - matrix(i,3)) / maxrange;
    end
    
    y=matrix;