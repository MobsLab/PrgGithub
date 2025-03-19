

SalMice = [756 758 761 763 765];
MtzlMice = [757 759 760 762 764];

figure
for i = 1:length(SalMice)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(SalMice(i)),'-16062018-Hab_00'])
    clear Correlation Temp_tail_InDegrees Temp_time
    load('ManualTemp.mat')
    load('behavResources.mat')
    Temp_tail_InDegrees = naninterp(Temp_tail_InDegrees)-runmean(naninterp(Temp_tail_InDegrees),10);
    for n=1:20
        clear Vit Temp
        for t = 2:length(Temp_tail_InDegrees)-1
            Temp(t-1) = Temp_tail_InDegrees(t);
            tps = Temp_time(t)*1e4;
            LittleEpoch = intervalSet(tps-(n+5)*1e4,tps-n*1e4);
            Vit(t-1) = mean(Data(Restrict(Vtsd,LittleEpoch)));
        end
        [R,P] = corrcoef(Temp,Vit);
        Correlation(n) = R(1,2);
        plot(Correlation), hold on
        title('saline')
    end
end

figure
for i = 1:length(MtzlMice)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',...
        num2str(MtzlMice(i)),'-16062018-Hab_00'])
    clear Correlation Temp_tail_InDegrees Temp_time
    load('ManualTemp.mat')
    load('behavResources.mat')
    Temp_tail_InDegrees = naninterp(Temp_tail_InDegrees)-runmean(naninterp(Temp_tail_InDegrees),10);
    for n=1:20
        clear Vit Temp
        for t = 2:length(Temp_tail_InDegrees)-1
            Temp(t-1) = Temp_tail_InDegrees(t);
            tps = Temp_time(t)*1e4;
            LittleEpoch = intervalSet(tps-(n+5)*1e4,tps-n*1e4);
            Vit(t-1) = mean(Data(Restrict(Vtsd,LittleEpoch)));
        end
        [R,P] = corrcoef(Temp,Vit);
        Correlation(n) = R(1,2);
        plot(Correlation), hold on
        title('Mtzl')
        
    end
end

