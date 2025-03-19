function sig = sigm(ls, lp, x)
    sig = 1 ./ (1 + exp( - ls * (x - lp)));
end 