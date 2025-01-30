function b = FindBestSmoothing_PF(S,occ,X,Y,x1,x2,ep)

gwIx = [2 5 10 15 20 30 45 60 75 90 105];
b = zeros(length(gwIx),1);

fprintf('\nFind best smoothing by cross-validation. Smoothing ')
for ii=1:length(gwIx)

    fprintf('#%d ',ii)
    b(ii) = CrossValidationSpatialCheck(S,gwIx(ii),x1,x2,X,Y,occ,ep);
    figure(1),clf,plot(b)
    drawnow
end
fprintf('\n');

