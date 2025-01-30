function Mouse=Drugs_Groups_UMaze_CH(group)

if group==1 % rip inhib sleep
    Mouse=[1594,1612];
elseif group==2 % rip control sleep
    Mouse=[1610,1611];
elseif group==3 % rip inhib wake
    Mouse=[1411,1418,1438,1440,1476,1480,1481,1483,51500,51501];
elseif group==4 % rip control wake
    Mouse=[1412,1415,1416,1437,1439,1446,1482,1502,41530,41531];
    
end