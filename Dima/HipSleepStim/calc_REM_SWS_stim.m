% calc_REM_SWS_stim.m

Dir.path={
    '/media/mobsrick/DataMOBs71/Mouse-534/09062017_SleepStim/FEAR-Mouse-534-09062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/12062017-SleepStim/FEAR-Mouse-534-12062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/14062017-SleepStim/FEAR-Mouse-534-14062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/15062017-SleepStim/FEAR-Mouse-534-15062017';
    '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017'
    };


fq_list = [1 2 4 7 10 13 15 20];

for man=1:length(Dir.path) 
        cd (Dir.path{man})
        
        load StateEpoch.mat
        load StimInfo.mat
        
for i=1:length(fq_list)
    LaserInt{man,i} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(i))*1E4, StimInfo.StopTime(StimInfo.Freq==fq_list(i))*1E4);
    Laser_SWS = and(LaserInt{man,i}, SWSEpoch);
    Laser_REM = and(LaserInt{man,i}, REMEpoch);
    l_SWS(man,i) = sum(End(Laser_SWS)-Start(Laser_SWS))/1E4;
    l_REM(man,i) = sum(End(Laser_REM)-Start(Laser_REM))/1E4;
end

end


for j=1:length(fq_list)
    l_SWS_fin = sum(l_SWS,1);
    l_REM_fin = sum(l_REM,1);
    disp (['Length of ' num2str(fq_list(j)) ' Hz stimulations during SWS - ' num2str(l_SWS_fin(j))]);
    disp (['Length of ' num2str(fq_list(j)) ' Hz stimulations during REM - ' num2str(l_REM_fin(j))]);
end