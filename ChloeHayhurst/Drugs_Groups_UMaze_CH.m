function Mouse=Drugs_Groups_UMaze_CH(group)

if group==1 % rip control sleep ALL
    Mouse=[1610,1611,1614];
elseif group==2 % rip inhib sleep ALL
    Mouse=[1594,1612,1641];
elseif group==3 % rip control sleep GOOD
    Mouse=[1610,1611,1614];
elseif group==4 % rip inhib sleep GOOD
    Mouse=[1594,1641];
elseif group==5 % rip control wake
    Mouse=[1412,1415,1416,1437,1439,1446,1482,1502,41530,41531];
elseif group==6 % rip inhib wake
    Mouse=[1411,1418,1438,1440,1476,1480,1481,1483,51500,51501];
elseif group==7 % baseline
%     Mouse=[1685,1686,1687,1688,1713,1714,1715];
    Mouse=[1685,1686,1687,1688,1713,1714,1715,1610,1611,1614];

elseif group == 8 % All Saline like
    Mouse=[425 431 436 437 438 439 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568 569 566,...
        666 667 668 669 688 739 777 779 849 893 1096 1144 1146 1147 1170 1171 9184 1189 9205 1391 1392 1393 1394 1224 1225 1226];
    
end

