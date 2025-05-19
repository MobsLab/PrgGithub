function afficherErreur(err)

    normeErr = sqrt(err(:,1).^2+err(:,2).^2);
    seuil = 60;
    normeErr= normeErr(normeErr<seuil);
    [ne, nout] = hist(normeErr,60);
    figure(66);
    clf;
    plot(ne);

end