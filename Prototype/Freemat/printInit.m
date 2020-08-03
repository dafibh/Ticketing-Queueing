function printInit(matrix, n,title)
    printf('%2s%10s%10s%10s%14s\n','n',title,'PROB.','CDF','RANGE');
    for i=1 : n
        printf('%2.0f%10.2f%10.2f%10.2f%10.0f - %2.0f\n', [ i matrix(i , 5) matrix(i , 1) matrix(i , 2) matrix(i , 3) matrix(i , 4)]);
    end