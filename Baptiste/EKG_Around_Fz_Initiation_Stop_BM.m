

Mouse=1189;
Session_type={'Cond'};
States={'All','Shock','Safe'};
sta=[3 5 6];
[OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{1}),'accelero','heartbeat','lfp',7);

% ISI = ConcatenateDataFromFolders_SB(CondSess.M1189,'heart_isi');
% 
% 
% 
% for group=Group
%     Mouse=Drugs_Groups_UMaze_BM(group);
%     for sess=1:length(Session_type) % generate all data required for analyses
%         [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'heartrate','heartratevar','ripples','ob_low','respi_freq_BM');
%     end
% end


%%
window_size = 2e3;
for states=1:length(States)
    Freezing_Sta.(States{states}) = Start(Epoch1{1,sta(states)});
    Freezing_Sto.(States{states}) = Stop(Epoch1{1,sta(states)});
    R = Range(OutPutData.heartbeat.ts{1,1});
    for ep=1:length(Freezing_Sta.(States{states}))
        ind = sum(Freezing_Sta.(States{states})(ep)>R);
        ISI_before_Fz.(States{states})(ep) = R(ind+1)-R(ind);
        Distance_to_QRS_before.(States{states})(ep) = Freezing_Sta.(States{states})(ep)-R(ind);
        Distance_to_QRS_after.(States{states})(ep) = R(ind+1)-Freezing_Sta.(States{states})(ep);
        
        Around_Fz_Initiation = intervalSet(Freezing_Sta.(States{states})(ep)-window_size , Freezing_Sta.(States{states})(ep)+window_size);
        ind2 = ceil(rand()*max(Range(OutPutData.heartbeat.ts{1,6})))-1;
        Random_Initiation = intervalSet(ind2-window_size , ind2+window_size);
        EKG_Around_Fz_Initiation.(States{states})(ep,:) = Data(Restrict(OutPutData.lfp.tsd{1,1} , Around_Fz_Initiation));
        Accelero_Around_Fz_Initiation.(States{states})(ep,:) = Data(Restrict(OutPutData.accelero.tsd{1,1} , Around_Fz_Initiation));
        try
            EKG_Around_Random_Initiation.(States{states})(ep,:) = Data(Restrict(OutPutData.lfp.tsd{1,1} , Random_Initiation));
        end
    end
    ISI_before_Fz.(States{states})(ISI_before_Fz.(States{states})>5e3)=NaN;
    Distance_to_QRS_before.(States{states})(Distance_to_QRS_before.(States{states})>5e3)=NaN;
    Distance_to_QRS_after.(States{states})(Distance_to_QRS_after.(States{states})>5e3)=NaN;
    Prop_distance_in_ISI.(States{states}) = Distance_to_QRS_before.(States{states})./ISI_before_Fz.(States{states});
    ISI_Fz.(States{states}) = diff(Range(OutPutData.heartbeat.ts{1,3}));
    ISI_Fz.(States{states})(ISI_Fz.(States{states})>5e3)=NaN;
    EKG_Around_Random_Initiation.(States{states})(EKG_Around_Random_Initiation.(States{states})==0) = NaN;
    [a,b]= find(abs(EKG_Around_Random_Initiation.(States{states}))>5e3); a=unique(a);
    EKG_Around_Random_Initiation.(States{states})(a,:) = NaN;
    
    
    for ep=1:length(Freezing_Sto.(States{states}))-1
        ind = sum(Freezing_Sto.(States{states})(ep)>R);

        Around_Fz_Initiation = intervalSet(Freezing_Sto.(States{states})(ep)-window_size , Freezing_Sto.(States{states})(ep)+window_size);
        EKG_Around_Fz_Stop.(States{states})(ep,:) = Data(Restrict(OutPutData.lfp.tsd{1,1} , Around_Fz_Initiation));
        Accelero_Around_Fz_Stop.(States{states})(ep,:) = Data(Restrict(OutPutData.accelero.tsd{1,1} , Around_Fz_Initiation));
        try
            EKG_Around_Random_Stop.(States{states})(ep,:) = Data(Restrict(OutPutData.lfp.tsd{1,1} , Random_Initiation));
        end
    end
end

states=1;

figure
for states=1:3
    subplot(1,3,states)
%     Data_to_use = (EKG_Around_Random_Initiation.(States{states})'-mean(EKG_Around_Random_Initiation.(States{states})'))';
%     Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
%     clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
%     shadedErrorBar([1:250] , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) , '-k')
%     hold on
    Data_to_use = (EKG_Around_Fz_Initiation.(States{states})'-mean(EKG_Around_Fz_Initiation.(States{states})'))';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar([1:250] , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) , '-r')
end

figure
for states=1:3
    subplot(1,3,states)
%     Data_to_use = (EKG_Around_Random_Initiation.(States{states})'-mean(EKG_Around_Random_Initiation.(States{states})'))';
%     Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
%     clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
%     shadedErrorBar([1:250] , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) , '-k')
%     hold on
    Data_to_use = Accelero_Around_Fz_Initiation.(States{states});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar([1:20] , Mean_All_Sp , Conf_Inter , '-r')
end

figure
for states=1:3
    subplot(1,3,states)
%     Data_to_use = (EKG_Around_Random_Initiation.(States{states})'-mean(EKG_Around_Random_Initiation.(States{states})'))';
%     Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
%     clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
%     shadedErrorBar([1:250] , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) , '-k')
%     hold on
    Data_to_use = Accelero_Around_Fz_Stop.(States{states});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar([1:20] , Mean_All_Sp , Conf_Inter , '-r')
end

figure
plot(Accelero_Around_Fz_Stop.(States{states})')


shadedErrorBar([1:250] , (EKG_Around_Random_Initiation'-mean(EKG_Around_Random_Initiation'))' , '-r')

plot(runmean(mean((EKG_Around_Fz_Initiation'-mean(EKG_Around_Fz_Initiation'))'),5),'k')
EKG_Around_Random_Initiation
vline(125,'--r'), xlabel('time (ms)'), xticks([0 125 250]), xticklabels({'-100','0','+100'})
ylabel('voltage (a.u.)')
title('Mean EKG LFP around Fz initiation')

subplot(122)
[X,Y]=hist(Distance_to_QRS_after,15);
bar([X(8:20) X(1:7)])

hist(Distance_to_QRS_before,52)
hist(Distance_to_QRS_after,52)
hist(ISI_before_Fz,52), hold on, hist(ISI_Fz.(States{states}),52)
hist(Prop_distance_in_ISI,52)

Distance_to_QRS_before(Distance_to_QRS_before>1e3)=NaN;
Distance_to_QRS_after(Distance_to_QRS_after>.9e3)=NaN;



