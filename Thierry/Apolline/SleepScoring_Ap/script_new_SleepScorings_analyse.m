clear all
clc

DataLocation{1} = '/media/mobschapeau/DataMOBS81/Pre-processing/M675/21032018/M675_ProtoStimSleep_1min_180321_102404/Test_SleepScoring';
DataLocation{2} = '/media/mobschapeau/DataMOBS81/Pre-processing/M675/22032018/M675_M645_Baseline_protoSleep_1min_180322_104439/Test_SleepScoring';

DataLocation{3} = '/media/mobschapeau/DataMOBS81/Pre-processing/M675/23032018/M675_Stim_ProtoSleep_1min_180323_103305/Test_SleepScoring';
DataLocation{4} = '/media/mobschapeau/DataMOBS81/Pre-processing/M675/28032018/M675_M711_Baseline_ProtoSleep_1min_180328_111302/Test_SleepScoring';

DataLocation{5}='/media/mobschapeau/DataMOBS821/M711/10042018/M711_Stim_ProtoSleep_1min_180410_103027/Test_SleepScoring';
DataLocation{6}='/media/mobschapeau/DataMOBS821/M711/17042018/M711_M675_Baseline_ProtoSleep_1min_180417_101952/Test_SleepScoring';

DataLocation{7}='/media/mobschapeau/DataMOBS82/M711/04042018/M711_Stim_ProtoSleep_1min_180404_102816/Test_SleepScoring';
DataLocation{8}='/media/mobschapeau/DataMOBS82/M711/28032018/M711_Baseline_ProtoSleep_1min_28032018/Test_SleepScoring';

DataLocation{9}='/media/mobschapeau/DataMOBS82/M733/11052018/M733_Stim_ProtoSleep_1min_180511_103535/Test_SleepScoring';
DataLocation{10}='/media/mobschapeau/DataMOBS82/M733/24052018/M733_Baseline_ProtoSleep_1min_180524_103728/Test_SleepScoring';

DataLocation{11}='/media/mobschapeau/DataMOBS82/M733/23052018/M733_Stim_ProtoSleep_1min_180523_102236/Test_SleepScoring';
DataLocation{12}='/media/mobschapeau/DataMOBS82/M733/28052018/M733_Baseline_ProtoSleep_1min_180528_110038/Test_SleepScoring';


for i = 1:2:length(DataLocation)
    
    cd(DataLocation{i})
    ind = strfind(DataLocation{i},'/M');
    Mouse_Nb = DataLocation{i}(ind(1)+1:ind(1)+4);
    night_Stim = DataLocation{i}(ind(1)+6:ind(1)+13);
    
    
    cd('Without_all_Noise')
    SleepScoringOBGamma_Ap_noNoise();
    [ Nb, States] = LatenceTransition_new_SleepScoring_noNoise();
    save([Mouse_Nb, '_Stim_', night_Stim, '_States_noNoise'],'States');
    cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/States')
    save([Mouse_Nb, '_Stim_', night_Stim, '_States_noNoise'],'States');
    
    cd(DataLocation{i})
    cd('Without_High_Noise')
    SleepScoringOBGamma_Ap();
    [ Nb, States] = LatenceTransition_new_SleepScoring();
    save([Mouse_Nb, '_Stim_', night_Stim, '_States_groundNoise'],'States');
    cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/States')
    save([Mouse_Nb, '_Stim_', night_Stim, '_States_groundNoise'],'States');
    
    cd(DataLocation{i})
    cd ..
    if ~exist(fullfile(cd,[Mouse_Nb '_Stim_' night_Stim '_States.mat']),'file')==1
        [ Nb, States] = LatenceTransition();
        save([Mouse_Nb '_Stim_' night_Stim '_States.mat'],'States');
        cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/States')
        save([Mouse_Nb '_Stim_' night_Stim '_States.mat'],'States');
    end
    
end

for i = 2:2:length(DataLocation)
    
    cd(DataLocation{i})
    ind = strfind(DataLocation{i},'/M');
    Mouse_Nb = DataLocation{i}(ind(1)+1:ind(1)+4);
    night_Base = DataLocation{i}(ind(1)+6:ind(1)+13);
    
    
    cd('Without_all_Noise')
    SleepScoringOBGamma_Ap_noNoise();
    [ Nb, States] = LatenceTransition_new_SleepScoring_noNoise();
    save([Mouse_Nb, '_Baseline_', night_Base, '_States_noNoise'],'States');
    cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/States')
    save([Mouse_Nb, '_Baseline_', night_Base, '_States_noNoise'],'States');
    
    cd(DataLocation{i})
    cd('Without_High_Noise')
    SleepScoringOBGamma_Ap();
    [ Nb, States] = LatenceTransition_new_SleepScoring();
    save([Mouse_Nb, '_Baseline_', night_Base, '_States_groundNoise'],'States');
    cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/States')
    save([Mouse_Nb, '_Baseline_', night_Base, '_States_groundNoise'],'States');
    
    cd(DataLocation{i})
    cd ..
    if ~exist(fullfile(cd,[Mouse_Nb '_Baseline_' night_Base '_States.mat']),'file')==1
        [ Nb, States] = LatenceTransition();
        save([Mouse_Nb '_Baseline_' night_Base '_States.mat'],'States');
        cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/States')
        save([Mouse_Nb '_Baseline_' night_Base '_States.mat'],'States');
    end
    
end

%% drawing of the total length of each state

close all
pourcentage_sortie_all_Trans_new_SleepScoring_noNoise(DataLocation,'percent','all')

cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/All_Trans')
for l = 1:2:length(DataLocation)
    figure((l+1)./2);
    
    ind = strfind(DataLocation{l},'/M');
    Mouse_Nb = DataLocation{l}(ind(1)+1:ind(1)+4);
    night_Stim = DataLocation{l}(ind(1)+6:ind(1)+13);
    night_Baseline = DataLocation{l+1}(ind(1)+6:ind(1)+13);
    
    SaveName = [Mouse_Nb '_Stim' night_Stim '_Baseline' night_Baseline '_AllTrans_noNoise'];
    saveas(gcf,SaveName,'png') ;
    saveas(gcf,SaveName,'fig') ;
end

close all
pourcentage_sortie_all_Trans_new_SleepScoring(DataLocation, 'percent', 'all')

cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/All_Trans')
for l = 1:2:length(DataLocation)
    figure((l+1)./2);
    
    ind = strfind(DataLocation{l},'/M');
    Mouse_Nb = DataLocation{l}(ind(1)+1:ind(1)+4);
    night_Stim = DataLocation{l}(ind(1)+6:ind(1)+13);
    night_Baseline = DataLocation{l+1}(ind(1)+6:ind(1)+13);
    
    SaveName = [Mouse_Nb '_Stim' night_Stim '_Baseline' night_Baseline '_AllTrans_groundNoise'];
    saveas(gcf,SaveName,'png') ;
    saveas(gcf,SaveName,'fig') ;
end

close all
pourcentage_sortie_all_Trans(DataLocation, 'percent', 'all')

cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/All_Trans')
for l = 1:2:length(DataLocation)
    figure((l+1)./2);
    
    ind = strfind(DataLocation{l},'/M');
    Mouse_Nb = DataLocation{l}(ind(1)+1:ind(1)+4);
    night_Stim = DataLocation{l}(ind(1)+6:ind(1)+13);
    night_Baseline = DataLocation{l+1}(ind(1)+6:ind(1)+13);
    
    SaveName = [Mouse_Nb '_Stim' night_Stim '_Baseline' night_Baseline '_AllTrans_allNoise'];
    saveas(gcf,SaveName,'png') ;
    saveas(gcf,SaveName,'fig') ;
end

%% drawing of the comparison of the different sleepscoring
close all
Difference_SleepScoring(DataLocation,'all')
cd('/home/mobschapeau/Dropbox/Mobs_member/Apolline/New_Sleep_Scoring/States')
for l = 1:2:length(DataLocation)
    figure((l+1)./2);
    
    ind = strfind(DataLocation{l},'/M');
    Mouse_Nb = DataLocation{l}(ind(1)+1:ind(1)+4);
    night_Stim = DataLocation{l}(ind(1)+6:ind(1)+13);
    night_Baseline = DataLocation{l+1}(ind(1)+6:ind(1)+13);
    
    SaveName = [Mouse_Nb '_Stim' night_Stim '_Baseline' night_Baseline '_States'];
    saveas(gcf,SaveName,'png') ;
    saveas(gcf,SaveName,'fig') ;
end

close all

    

