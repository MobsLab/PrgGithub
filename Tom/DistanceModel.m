function f = DistanceModel(M1,M2)
    b1 = M1.table.Coefficients.Estimate;
    b2 = M2.table.Coefficients.Estimate;
    f = 2*sum(abs((b1 - b2) ./ (b1 + b2)));

end 