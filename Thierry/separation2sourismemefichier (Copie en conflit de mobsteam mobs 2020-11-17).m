% % Faire ndm_merged dabord en renommant les fichiers 
% % auxiliary.dat -> amplifier-accelero.dat
% % amplifier.dat -> amplifier-wideband.dat
% % digitalin.dat -> amplifier-digin.dat
% puis ecrire dans system "ndm_merged amplifier"

% RefSubtraction_multi('amplifier.dat',32,2,'M733',0:15,4,[],'M724',16:31,20,[]);

% RefSubtraction_multi('amplifier.dat',64,2,'M781',0:31,10,[],'M782',31:63,42,[]);
% 
% % digitalin dans les 2 fichiers et accelero réparti dans les 2 fichiers
% RefSubtraction_multi('amplifier.dat',71,2,'M781',[0:31],10,[64,65,66,70],'M782',[32:63],42,[67,68,69,70]);


% digitalin dans les 2 fichiers et accelero réparti dans les 2 fichiers
% RefSubtraction_multi('amplifier.dat',71,2,'M796',[0:31],23,[64,65,66,70],'M779',[32:63],39,[67,68,69,70]);
% digitalin dans les 2 fichiers et accelero réparti dans les 2 fichiers
RefSubtraction_multi('amplifier.dat',71,2,'M779',[0:31],7,[64,65,66,70],'M796',[32:63],55,[67,68,69,70]);
RefSubtraction_multi('amplifier.dat',71,1,'M781',[0:31],10,[64,65,66,70])
RefSubtraction_multi('amplifier.dat',71,2,'M779',[0:31],7,[64,65,66,70],'M796',[32:63],55,[67,68,69,70]);
RefSubtraction_multi('amplifier.dat',32,1,'M929',[0:31],15,[32,33,34,35])
