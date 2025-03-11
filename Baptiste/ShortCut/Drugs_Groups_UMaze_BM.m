
% Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
% Cols = {[0, 0, 1],[1, 0, 0],[1, .5, .5],[0, .5, 0],[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
% Legends = {'Saline_long','Chronic_Flx','Acute_Flx','Midazolam','Saline_short','DZP','RipControl','RipInhib'};


function Mouse=Drugs_Groups_UMaze_BM(group)

if group==1 % saline mice, long protocol, SB
    Mouse=[688 739 777 779 849 893]; % add 1096 ?
elseif group==2 % chronic flx mice, long protocol
    Mouse=[875 876 877 1001 1002 1095]; % 1130
elseif group==3 % Acute Flx, long protocol
    Mouse=[740 750 775 778 794];
elseif group==4 % midazolam mice, long protocol
    Mouse=[829 851 857 858 859 1005 1006];
elseif group==5 % saline short BM first Maze
    Mouse=[1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394];
elseif group==6 % DZP  first Maze
    Mouse=[11200 11206 11207 11251 11252 11253 11254];
elseif group==7 % rip control
    Mouse=[1412,1415,1416,1437,1439,1446,1482,1502,41530,41531];
elseif group==8 % rip inhib
    Mouse=[1411,1418,1438,1440,1476,1480,1481,1483,51500,51501];
elseif group==9 % PAG
    Mouse=[404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514];
elseif group==10 % all eyelid
    Mouse=[561 567 568 569 566 666 667 668 669 688 739 777 779 849 893 1096 1144 1146 11471170 1171 9184 1189,...
        9205 1391 1392 1393 1394 1224 1225 1226 1227 1184 1205 1500 1501 1529 1530 1532 1251 1253 1254];
elseif group==11 % all saline-like
    Mouse=[404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566,...
        666 667 668 669 688 739 777 779 849 893 1096 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226]; % no 117
elseif group==12 % all eyelid Elisa
    Mouse = [688 777 849 1144 1146 1147 1170 1171 9184 9205 1391 1392 1394 1224 1225 1226 739 779 893 1189 1393];
elseif group==13 % saline  short all
    Mouse=[1144 1147 1170 1171 1189 9205 1251 1253 1254 1392 1394]; % no 1146 9184 1391 1393 because too much thigmo in TestPre
    %     Mouse=[1170 1171 1189 9205 1251 1253 1254 1392 1394]; % no 1146 9184 1391 1393 because too much thigmo in TestPre
elseif group==14 % saline  second Maze
    Mouse=[1251 1253 1254];
elseif group==15 % DZP  short all
    Mouse=[11147 11184 11189 11200 11204 11205 11206 11207 11251 11252 11253 11254];
    %     Mouse=[11189 11200 11204 11205 11206 11207 11251 11252 11253 11254];
elseif group==16 % DZP  second maze
    Mouse=[11147 11184 11189 11204 11205];
elseif group ==17 % Saline long all
    Mouse = [688 739 777 779 849 893 1161,1184,1205,1223,1224,1225,1226,1227 1500 1501 1529 1530 1532];
elseif group==18 % Atropine CH
    Mouse=[1561 1562 1563];
    
elseif group ==20 % All saline long CH (1rst and 2nd maze)
    Mouse = [1500 1501 1529 1530 1532];
    
elseif group ==21 % Saline long BM
    Mouse = [1161,1184,1205,1223,1224,1225,1226,1227];
    
    
elseif group==19
    Mouse=[688 739 777 779 849 893   1147 1171 1189 9205 1251 1253 1254 1392 1394];
   
    % all eyelid good stim, less than 30 stims, fz shock and safe in good amount
elseif group==22
    Mouse=[561 567 568 566 666 667 668 669 688 739 777 779 849 1144 1147 1171 1184 9184 1205 9205 1225 1226 1251 1253 1254,...
       1391 1392 1393 1394];
    
    % all saline new
elseif group==23
    Mouse=[404 425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566,...
        666 667 668 669 688 739 777 779 849 893 1096 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394,...
        1224 1225 1226 1227 1161 1162 1184 1205 1500 1501 1529 1530 1532 1251 1253 1254 1685,1686,1687];
    
    %
    %
    % elseif group==13 % ripples control old
    %     Mouse=[41266 41268 41269 41305 41349 41350 41351 41352 1376 1385 1386]; % no
    % elseif group==14 % ripples inhib old
    %     Mouse=[1267 1269 1304 1305 1350 1351 1352  1349 1377];
    % elseif group==15 % acute BUS
    %     Mouse=[21251 21253];
    elseif group==24 % chronic BUS
        Mouse=[31253 31266 31269 31305];
    % elseif group==13 % ripples control first maze
    %     Mouse=[41305 41349 41350 1385]; % no 1376 41352
    % elseif group==14 % ripples inhibition first maze
    %     Mouse=[1267 1269 1304 1351 1377];  % no 1266 1268
    % elseif group==19 % ripples inhibition second maze
    %     Mouse=[1305 1350 1352 1349];
    % elseif group==20 % ripples control second maze
    %     Mouse=[41266 41268 41269 41351];
    % elseif group==21 % Saline  Maze1  1st Maze
    %     Mouse=[1144 1146 1147 1170 1171 9184 1189 1200 1251];
    % elseif group==22 % Saline  Maze4  1st Maze
    %     Mouse=[9205 1391 1392 1393 1394];
    % elseif group==23 % DZP  Maze1  1st Maze
    %     Mouse=[11206 11207];
    % elseif group==24 % DZP  Maze4  1st Maze
    %     Mouse=[11200 11251 11252 11253 11254];
    % elseif group==17 % saline long BM
    %     Mouse=[1184 1205 1224 1225 1226];
    % elseif group==13 % DZP long BM
    %     Mouse=[11225 11226 11203 1199 1230 1223];
end


% Saline-like
% Mouse=[688,739,777,779,849,893,1096,740,750,775,778,794,829,851,857,858,859,1005,1006];

% Mice with ripples
% if group==1 % saline mice
%     Mouse=[688,739,777,849];
% elseif group==2 % chronic flx mice
%     Mouse=[1001,1002];
% elseif group==3 % Acute Flx
%     Mouse=[750,794];
% elseif group==4 % midazolam mice
%     Mouse=[829,857,858,859,1005,1006];
% elseif group==5 % saline short BM
%      Mouse=[1170,1189,1251,1253,1254];
% elseif group==6 % diazepam short
%     Mouse=[11204,11207,11251,11252,11253,11254]; %11200
% elseif group==7 % saline long
%     Mouse=[1224 1225 1226 1227];
% elseif group==8 % diazepam long BM
%     Mouse=[11225 11226 11203 1199 1230];
% end

%% Exclusions
% no 1130 because too much freezing choc
% no 1268 because many stims and not during freezing
% no 1266 because
% no 1174 because too much freezing, was traumatized by Sophie regulating the PulsePal hihi
% no 1172, 1200, 1204, 1206 because not enough freezing

% no 1414 because bad ripples
% no 1448 because not enough freezing


