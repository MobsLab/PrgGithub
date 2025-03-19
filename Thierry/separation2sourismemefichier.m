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
RefSubtraction_multi('amplifier.dat',141,4,'M929',[0:31],15,[128,129,130,140],'M730',[32:63],46,[131,132,133,140],'M753',[64:95],78,[134,135,136,140],'M754',[96:127],109,[137,138,139,140]);
%atropine_baseline1
RefSubtraction_multi('amplifier.dat',141,4,'M923',[0:31],14,[128,129,130,140],'M926',[32:63],45,[131,132,133,140],'M927',[64:95],78,[134,135,136,140],'M928',[96:127],110,[137,138,139,140]);
%atropine_atropine
RefSubtraction_multi('amplifier.dat',141,4,'M923',[0:31],14,[128,129,130,140],'M926',[45],[45],[32:44,46:63,131,132,133,140],'M927',[64:95],78,[134,135,136,140],'M928',[96:127],110,[137,138,139,140]);
%rat_baseline1
RefSubtraction_multi('amplifier.dat',141,4,'M928',[0:31],14,[128,129,130,140],'M923',[32:63],46,[131,132,133,140],'M927',[64:95],78,[134,135,136,140],'M926',[96:127],109,[137,138,139,140]);
%atropine_saline
RefSubtraction_multi('amplifier.dat',141,4,'M923',[0:31],14,[128,129,130,140],'M926',[32:63],45,[131,132,133,140],'M927',[64:95],78,[134,135,136,140],'M928',[96:127],110,[137,138,139,140]);
%baseline1 predator_rat et baseline2
RefSubtraction_multi('amplifier.dat',141,4,'M928',[0:31],14,[128,129,130,140],'M923',[32:63],46,[131,132,133,140],'M927',[64:95],78,[134,135,136,140],'M926',[96:127],109,[137,138,139,140]);
%Box_rat exposure baseline 1 et baseline 2
RefSubtraction_multi('amplifier.dat',71,2,'M928',[0:31],14,[64,65,66,70],'M927',[32:63],46,[67,68,69,70]);
% Box rat 72h Baseline 1, Baseline 2 et exposure
RefSubtraction_multi('amplifier.dat',71,2,'M923',[0:31],14,[64,65,66,70],'M926',[32:63],45,[67,68,69,70]);
%CNO CRFcre session2 CNO injection
RefSubtraction_multi('amplifier.dat',141,4,'M929',[0:31],15,[128,129,130,140],'M930',[32:63],46,[131,132,133,140],'M954',[77],[77],[64:76,78:95,134,135,136,140],'M953',[96:127],110,[137,138,139,140]);
%CNO CRFcre session2 Baseline3
RefSubtraction_multi('amplifier.dat',141,4,'M929',[0:31],15,[128,129,130,140],'M930',[32:63],46,[131,132,133,140],'M953',[64:95],78,[134,135,136,140],'M954',[96:127],109,[137,138,139,140]);
%CNO CRFcre session2 Saline
RefSubtraction_multi('amplifier.dat',141,3,'M929',[0:31],15,[128,129,130,140],'M930',[32:63],46,[131,132,133,140],'M954',[96:127],109,[137,138,139,140]);
%CNO CRFcre session2 Baseline2
RefSubtraction_multi('amplifier.dat',141,2,'M953',[78],[78],[64:77,79:95,134,135,136,140],'M954',[96:127],109,[137,138,139,140]);
%Exchangecage session2 Exchange cage, Baseline3 et Baseline4
RefSubtraction_multi('amplifier.dat',141,4,'M923',[0:31],14,[128,129,130,140],'M926',[32:63],45,[131,132,133,140],'M927',[64:95],78,[134,135,136,140],'M928',[96:127],110,[137,138,139,140]);
%Exchangecage session2 Baseline 2
RefSubtraction_multi('amplifier.dat',141,4,'M923',[14],[14],[0:13,15:31,128,129,130,140],'M926',[32:63],45,[131,132,133,140],'M927',[78],[78],[64:77,79:95,134,135,136,140],'M928',[96:127],110,[137,138,139,140]);
%Exchangecage session2 Exchange cage
RefSubtraction_multi('amplifier.dat',141,4,'M923',[0:31],14,[128,129,130,140],'M926',[32:63],45,[131,132,133,140],'M927',[64:95],78,[64:77,79:95,134,135,136,140],'M928',[110],[110],[96:109,111:127,137,138,139,140]);
%Exchangecage session2 Baseline 3
RefSubtraction_multi('amplifier.dat',141,4,'M923',[0:31],14,[128,129,130,140],'M926',[45],[45],[32:44,46:63,131,132,133,140],'M927',[64:95],78,[64:77,79:95,134,135,136,140],'M928',[96:127],110,[137,138,139,140]);
%Exchangecage session2 Baseline 4
RefSubtraction_multi('amplifier.dat',141,4,'M923',[0:31],14,[128,129,130,140],'M926',[32:63],45,[131,132,133,140],'M927',[64:95],78,[64:77,79:95,134,135,136,140],'M928',[96:127],110,[137,138,139,140]);

%PFC-VLPO_deadd-ex Baseline 1, Saline
RefSubtraction_multi('amplifier.dat',141,4,'M1035',[0:31],[14],[128,129,130,140],'M1036',[32:63],47,[131,132,133,140],'M1037',[64:95],[78],[134,135,136,140],'M1009',[96:127],124,[137,138,139,140]);
%PFC-VLPO_deadd-ex Baseline 2
RefSubtraction_multi('amplifier.dat',141,4,'M1035',[0:31],14,[128,129,130,140],'M1036',[32:63],47,[131,132,133,140],'M1037',[64:95],78,[134,135,136,140],'M1011',[96:127],121,[137,138,139,140]);
%PFC-VLPO_deadd-ex CNO
RefSubtraction_multi('amplifier.dat',106,3,'M1035',[0:31],14,[96,97,98,105],'M1036',[32:63],47,[99,100,101,105],'M1037',[64:95],78,[102,103,104,105]);
