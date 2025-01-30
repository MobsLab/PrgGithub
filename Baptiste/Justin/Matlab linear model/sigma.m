function[Y] = sigma(w0,w,X)
    Y=1./(1+exp(-w0-w'.*X));
end