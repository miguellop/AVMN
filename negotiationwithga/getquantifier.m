function Q = getquantifier(beta,alfa)
if alfa == 0
    Q = @(y) y;
else
    Q = @(y) (1-beta.^(alfa.*y))./(1-beta.^alfa);
end


