%%
%fichier amplifier.xml, ajouter le plugin mergedat avec les nombres de
%voies pour wideband, accelero et digin, et leur nom. puis renomer les
%fichier .dat en amplifier-wideband -accelero - digin 
%puis dans un terminal :

%ndm_mergedat amplifier

%separer avec les codes ci dessous

% /!\ a la fin, rename amplifier_xxx.dat en amplifier_Mxxx.dat !!!
% /!\ renomer behavResources-xxx.mat en behavResources.mat
%/!\ ne pas oublier de cocher merge done et ref done par la suite
%% sommeil pré expé des dreadd
RefSubtraction_multi('amplifier.dat',106,3,...
'874',[0:22 24:31],23,[23 96 97 98 105], '873', [32:36 38:63],37, [37 99 100 101 105], '891', [65:95], 64, [64 102 103 104 105])


%% conditionnement des dreadds

%891 en premier
%RefSubtraction_multi('amplifier.dat',71,2,...
%'891',[1:31],0,[0 64 65 66 70], '874', [32:54 56:63],55, [55 67 68 69 70])

%874 en premier
RefSubtraction_multi('amplifier.dat',71,2,...
'874',[0:22 24:31],23,[23 64 65 66 70], '891', [33:63],32, [32 67 68 69 70])


%%  souris fluo 875_D4-5_876_D11-12
RefSubtraction_multi('amplifier.dat',71,2,...
    '875',[0:24 26:31],25,[25 64 65 66 70], '876', [32:55 57:63], 56, [56 67 68 69 70])

%%  souris fluo 875_D11-12_876_D18-19
RefSubtraction_multi('amplifier.dat',71,2,...
    '875',[0:24 26:31],25,[25 64 65 66 70], '876', [32:55 57:63], 56, [56 67 68 69 70])

%% souris archt
RefSubtraction_multi('amplifier.dat',71,2,...
    '915',[0:17 19:31],18,[18 64 65 66 70], '919', [32:37 39:63], 38, [38 67 68 69 70])

RefSubtraction_multi('amplifier.dat',71,2,...
    '916',[0:18 20:31],19,[19 64 65 66 70], '917', [32:54 56:63], 55, [55 67 68 69 70])

RefSubtraction_multi('amplifier.dat',71,2,...
    '920',[0:6 8:31],7,[7 64 65 66 70], '918', [32:56 58:63], 57, [57 67 68 69 70])

%% baseline sleep 875-876-893

RefSubtraction_multi('amplifier.dat',106,3,...
'875',[0:24 26:31],25,[25 96 97 98 105], '893', [32:40 42:63],41, [41 99 100 101 105], '876', [64:87 89:95], 88, [88 102 103 104 105])

%%  souris fluo 877_D18-19_893_baseline
RefSubtraction_multi('amplifier.dat',70,2,...
    '877',[0:23 25:31],24,[24 64 65 66], '893', [41], 41, [32:40 42:63 67 68 69])
