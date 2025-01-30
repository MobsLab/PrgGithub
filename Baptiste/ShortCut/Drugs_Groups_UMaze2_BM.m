
% Drug_Group={'First_PAG','Night_PAG','Neurons_PAG','First_Eyelid','Saline_Long_SB','Chronic_Flx','Acute_Flx',...
% 'Midazolam','Saline_Short','Diazepam_Short','Saline_Short2','Diazepam_Short2','Saline_Long_BM','Diazepam_Long_BM',...
% 'Acute_Bus','ChronicBUS','RipControl1','RipInhib1','RipControl2','RipInhib2','RipControl3','RipInhib3'};

function Mouse=Drugs_Groups_UMaze2_BM(group)

if group==1 % First PAG mice
    Mouse=[404 425 431 436 437 438 439];
    
elseif group==2 % night time
    Mouse=[469 470 471 483 484 485];
    
elseif group==3 % PAG neurons
    Mouse=[490 507 508 509 510 512 514];
    
elseif group==4 % eyelid
    Mouse=[561 567 568 569 566 666 667 668];
    
elseif group==5 % saline long
    Mouse=[688 739 777 779 849 893 1096];
    
elseif group==6 % chronic flx
    Mouse=[875 876 877 1001 1002 1095 1130];
    
elseif group==7 % acute flx
    Mouse=[740 750 775 778 794];
    
elseif group==8 % midazolam
    Mouse=[829 851 857 858 859 1005 1006];
    
elseif group==9 % saline short
    Mouse=[1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394];
    
elseif group==10 % diazepam short
    Mouse=[11200 11206 11207 11251 11252 11253 11254];
    
elseif group==11 % saline short second Maze
    Mouse=[1251 1253 1254];
    
elseif group==12 % diazepam short second Maze
    Mouse=[11147 11184 11189 11204 11205];
    
elseif group==13 % saline long BM
    Mouse=[1184 1205 1224 1225 1226];

elseif group==14 % diazepam long BM
    Mouse=[11225 11226 11203 1199 1230 1223];
    
elseif group==15 % acute buspirone
    Mouse=[21251 21253];
    
elseif group==16 % chronic buspirone
    Mouse=[31253 31266 31269 31305];
    
elseif group==17 % ripples control 1
    Mouse=[41305 41349 41350 41352 1376 1385];
    
elseif group==18 % ripples inhib 1
    Mouse=[1267 1269 1304 1351 1377];
    
elseif group==19 % ripples control 2
    Mouse=[41266 41268 41269 41351];
    
elseif group==20 % ripples inhib 2
    Mouse=[1266 1267 1268 1269 1304 1305 1350 1351 1352  1349 1377];
    
elseif group==21 % ripples control 3
    Mouse=[1412,1415,1416,1437,1439,1446,1482,1502,41530,41531];
    
elseif group==22 % ripples inhibition 3
    Mouse=[1411,1418,1438,1440,1476,1480,1481,1483,51500,51501];
    
end

