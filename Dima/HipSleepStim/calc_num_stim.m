% calc_num_stim.m

% Dir.path={
%     '/media/mobsrick/DataMOBs71/Mouse-534/09062017_SleepStim/FEAR-Mouse-534-09062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/12062017-SleepStim/FEAR-Mouse-534-12062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/14062017-SleepStim/FEAR-Mouse-534-14062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/15062017-SleepStim/FEAR-Mouse-534-15062017';
%     '/media/mobsrick/DataMOBs71/Mouse-534/16062017-SleepStim/FEAR-Mouse-534-16062017'
%     };

Dir.path={
    '/media/mobsrick/DataMOBs71/Mouse-538/06072017_SleepStim/FEAR-Mouse-538-06072017/'
    };

fq_list = [1 2 4 7 10 13 15 20];

for man=1:length(Dir.path) 
        cd (Dir.path{man})
        
        load StateEpoch.mat
        load StimInfo.mat
        
for i=1:length(fq_list)
    LaserInt{man,i} =intervalSet(StimInfo.StartTime(StimInfo.Freq==fq_list(i))*1E4, StimInfo.StopTime(StimInfo.Freq==fq_list(i))*1E4);
    stim(man,i) = length(Start(LaserInt{man,i}));
end

end




for j=1:length(fq_list)
    num_st = sum(stim(:,j));
    disp (['Number of ' num2str(fq_list(j)) ' Hz stimulations is ' num2str(num_st)]);
end