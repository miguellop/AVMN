function w = getowaweights(Q,na)
    y = linspace(0,1,na+1);
    y = y(2:end);
    w(1) = Q(y(1));
    for i=2:na
        w(i) =Q(y(i))-Q(y(i-1));
    end
end


