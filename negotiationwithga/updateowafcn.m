function updateowafcn()
    global ALFA;
    global ST;
    global quota;
    global flagupdate;
    
    %ALFA = ALFA+0.1;  
    if flagupdate == 1
        if ST >= 0.99
            quota = quota-1;
        else
            quota = quota+1;
        end
        if quota > 18
            quota = 18;
        end
        if quota < 2
            quota = 2;
        end
    end
    if flagupdate == 2
    
        ALFA = ALFA + 5;

        if ST <= 0.99
            ALFA = ALFA - 0.0001;
        end

        if ALFA > 100
            ALFA = 100;
        end
        if ALFA < -100
            ALFA = -100;
        end
    end
    %fprintf('Q: %i S: %.2f ST: %.2f ALFA: %.2f \n', quota, S, ST, ALFA);
    
end

