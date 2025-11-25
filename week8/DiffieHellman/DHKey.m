function ha = DHKey(g, p)
    if ~isprime(g) || ~isprime(p)
        error('Inputs g and p must be prime numbers.');
    end

    if p <= 1
         error('p must be greater than 1');
    end
    
    xa = randi([1 p-1]);%Calculate value of Xa
    xb = randi([1 p-1]);%Calculate value of Xb
        
    % Calculate value of Ya and Yb
    ya = power(g,xa);
    ya = mod(ya,p);
    yb = power(g,xb);
    yb = mod(yb,p);

    % Calculate shared key
    ha = power(yb,xa);
    ha = mod(ha,p);
    hb = power(ya,xb);
    hb = mod(hb,p);
end
