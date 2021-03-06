function [m, n] = myLeastSuares(n, cx, cy)
%MYLEASTSUARES Summary of this function goes here
%   Detailed explanation goes here
    
    if ( n == 1 )
        m = 0.0;
        n = cy(0);
        return;
    end
    
    xbar = 0.0;
    ybar = 0.0;
    for ii = 1:n
        xbar = xbar + cx(ii);
        ybar = ybar + cy(ii);
    end
    xbar = xbar / n;
    ybar = ybar / n;
    
    top = 0.0;
    bot = 0.0;
    for ii = 1:n
        top = top + ( cx(ii) - xbar ) * ( cy(ii) - ybar );
        bot = bot + ( cx(ii) - xbar ) * ( cx(ii) - xbar );
    end
    
    m = top / bot;
    n = ybar - m * xbar;
    
end

