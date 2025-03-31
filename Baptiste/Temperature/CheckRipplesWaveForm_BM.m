



Mouse=[666 668 688 739 777 779 849 893];
[OutPutData , Epoch , NameEpoch , OutPutTSD] = MeanValuesPhysiologicalParameters_BM(Mouse,'fear','mean_ripples');



figure
u=1;
for mouse=[2 3 4 5 7]
    subplot(2,3,u)
    plot(squeeze(OutPutData.mean_ripples(mouse,5,:)),'r')
    hold on
    plot(squeeze(OutPutData.mean_ripples(mouse,6,:)),'b')
    makepretty; xlim([400 700])
    if u==1; legend('shock side freezing','safe side freezing'); end
    u=u+1;
end
a=suptitle('Mean ripple waveform, saline mice'); a.FontSize=20;

figure
u=1;
for mouse=[2 3 4 5 7]
    subplot(2,3,u)
    plot(squeeze(OutPutData.mean_ripples(mouse,7,:)),'r')
    hold on
    plot(squeeze(OutPutData.mean_ripples(mouse,8,:)),'b')
    makepretty; xlim([400 700])
    u=u+1;
end


figure
u=1;
for mouse=[2 3 4 5 7]
    subplot(2,3,u)
    plot(squeeze(OutPutData.mean_ripples(mouse,3,:)),'g')
    hold on
    plot(squeeze(OutPutData.mean_ripples(mouse,4,:)),'m')
    makepretty; xlim([400 700])
    u=u+1;
end

figure
Data_to_use = squeeze(OutPutData.mean_ripples([2 3 4 5 7],5,:)); 
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;

Data_to_use = squeeze(OutPutData.mean_ripples([2 3 4 5 7],6,:)); 
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;

makepretty; xlim([400 700])































