function err = afficherErreur(positions, positionsE)
    
    %initialisation de la fenêtre:
    fenetre = figure(1002);
    set(fenetre,'Name','Erreur d''estimation','NumberTitle','off');
    clf;
    hold all;
    axis square;
    
    %err1 = positions-positionsE(1:2,:);
    %err2 = positions-positionsE(3:4,:);
    err3 = positions-positionsE(5:6,:);
    err4 = positions-positionsE(7:8,:);
    
    %errNorm1 = sqrt(sum(err1.^2,1));
    %errNorm2 = sqrt(sum(err2.^2,1));
    errNorm3 = sqrt(sum(err3.^2,1));
    errNorm4 = sqrt(sum(err4.^2,1));
    
    %errMoy1 = mean(errNorm1)
    %errMoy2 = mean(errNorm2)
    errMoy3 = mean(errNorm3);
    errMoy4 = mean(errNorm4);
    err=[errMoy3 errMoy4]
    %plot(errNorm1, '+--');
    %plot(errNorm2, '+--');
    plot(errNorm3, '+-');
    plot(errNorm4, '+-');
    
    legend('Barycentre', 'Régression');
end