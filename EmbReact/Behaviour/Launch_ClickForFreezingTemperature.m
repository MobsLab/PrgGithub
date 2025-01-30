clear all
f=0;
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedSafe_PreDrug/Cond1';
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedSafe_PreDrug/Cond2';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedShock_PreDrug/Cond1';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedShock_PreDrug/Cond2';
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedSafe_PostDrug/Cond1';
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedSafe_PostDrug/Cond2';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedShock_PostDrug/Cond1';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse740/25052018/ProjectEmbReact_M740_25052018_UMazeCondBlockedShock_PostDrug/Cond2';

% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_ExtinctionBlockedShock_PostDrug/Ext1/';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_ExtinctionBlockedShock_PostDrug/Ext2/';
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedSafe_PostDrug/Cond1/';
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedSafe_PostDrug/Cond2/';
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedSafe_PreDrug/Cond1/';
f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedSafe_PreDrug/Cond2/';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedShock_PostDrug/Cond1/';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedShock_PostDrug/Cond2/';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedShock_PreDrug/Cond1/';
% f=f+1;Folder{f} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_UMazeCondBlockedShock_PreDrug/Cond2/';
% 
% for ff = 11:f
%     cd(Folder{ff})
%     load('behavResources_SB.mat')
%     if sum(Stop(Behav.FreezeAccEpoch,'s')-Start(Behav.FreezeAccEpoch,'s'))>5
%         disp(Folder{ff})
%     Temp_data = ClickForFreezingTemperature(Folder,Behav,Params);
%     save('TemperatureDataFreezing.mat','Temp_data')
%     end
% end

clear  FreezeEp LengthEp
AllEp = 1;
for ff = 1:f
    cd(Folder{ff})
    try
        load('TemperatureDataFreezing.mat','Temp_data')
        LastPoint = find(diff(Temp_data.Time)>1);
        LastPoint  = [1,LastPoint];
        for ll = 1:length(LastPoint)-1
            FreezeEp.Body{AllEp} = Temp_data.Body.Max(LastPoint(ll):LastPoint(ll+1));
            FreezeEp.Tail{AllEp} = Temp_data.Tail.Max(LastPoint(ll):LastPoint(ll+1));
                        FreezeEp.Room{AllEp} = Temp_data.Room.Max(LastPoint(ll):LastPoint(ll+1));

            LengthEp(AllEp) = length(FreezeEp.Body{AllEp});
            AllEp=AllEp+1;
        end     
    end
end


clear Body_Long  Tail_Long Body_Short Tail_Short Room_Long
ShortEp = find(LengthEp<40);
for n=1:length(ShortEp)
    k = ShortEp(n);
    dat_body = naninterp(FreezeEp.Body{k}(7:end-6));
    Body_Short(n,:) =     interp1([1:length(dat_body)]/length(dat_body),dat_body,[0.1:0.1:1]);
    if sum(isnan(FreezeEp.Tail{k}))./length(FreezeEp.Tail{k})<0.5
        dat_tail = naninterp(FreezeEp.Tail{k}(7:end-6));
        Tail_Short(n,:) =     interp1([1:length(dat_tail)]/length(dat_tail),dat_tail,[0.1:0.1:1]);
    else
        Tail_Short(n,:) = nan(1,10);
    end
    dat_Room = naninterp(FreezeEp.Room{k}(7:end-6));
    Room_Short(n,:) =     interp1([1:length(dat_Room)]/length(dat_Room),dat_Room,[0.1:0.1:1]);

    
end

LongEp = find(LengthEp>40);
for n=1:length(LongEp)
    k = LongEp(n);
    dat_body = naninterp(FreezeEp.Body{k}(7:end-6));
    Body_Long(n,:) =     interp1([1:length(dat_body)]/length(dat_body),dat_body,[0.05:0.05:1]);
    if sum(isnan(FreezeEp.Tail{k}))./length(FreezeEp.Tail{k})<0.5
        dat_tail = naninterp(FreezeEp.Tail{k}(7:end-6));
        Tail_Long(n,:) =     interp1([1:length(dat_tail)]/length(dat_tail),dat_tail,[0.05:0.05:1]);
    else
        Tail_Long(n,:) = nan(1,20);
    end
        dat_Room = naninterp(FreezeEp.Room{k}(7:end-6));
    Room_Long(n,:) =     interp1([1:length(dat_Room)]/length(dat_Room),dat_Room,[0.05:0.05:1]);
end

figure
subplot(321)
plot(zscore(Body_Short(:,1:end)')), hold on
plot(nanmean(nanzscore(Body_Short(:,1:end)')'),'k','linewidth',3), ylim([-4 4])
title('Body_Short')
subplot(322)
plot(nanzscore(Body_Long(:,1:end)')), hold on
plot(nanmean(nanzscore(Body_Long(:,1:end)')'),'k','linewidth',3), ylim([-4 4])
title('Body_Long')
subplot(323)
plot(nanzscore(Tail_Short(:,1:end)')), hold on
plot(nanmean(nanzscore(Tail_Short(:,1:end)')'),'k','linewidth',3), ylim([-4 4])
title('Tail_Short')
subplot(324)
plot(nanzscore(Tail_Long(:,1:end)')), hold on
plot(nanmean(nanzscore(Tail_Long(:,1:end)')'),'k','linewidth',3), ylim([-4 4])
title('Tail_Long')
subplot(325)
plot(nanzscore(Room_Short(:,1:end)')), hold on
plot(nanmean(nanzscore(Room_Short(:,1:end)')'),'k','linewidth',3), ylim([-4 4])
title('Room_Short')
subplot(326)
plot(nanzscore(Room_Long(:,1:end)')), hold on
plot(nanmean(nanzscore(Room_Long(:,1:end)')'),'k','linewidth',3), ylim([-4 4])
title('Room_Long')

figure
subplot(321)
plot((Body_Short(:,1:end)')), hold on
plot(nanmean((Body_Short(:,1:end)')'),'k','linewidth',3),
title('Body_Short')
subplot(322)
plot((Body_Long(:,1:end)')), hold on
plot(nanmean((Body_Long(:,1:end)')'),'k','linewidth',3),
title('Body_Long')
subplot(323)
plot((Tail_Short(:,1:end)')), hold on
plot(nanmean((Tail_Short(:,1:end)')'),'k','linewidth',3), 
title('Tail_Short')
subplot(324)
plot((Tail_Long(:,1:end)')), hold on
plot(nanmean((Tail_Long(:,1:end)')'),'k','linewidth',3),
title('Tail_Long')
subplot(325)
plot((Room_Short(:,1:end)')), hold on
plot(nanmean((Room_Short(:,1:end)')'),'k','linewidth',3),
title('Room_Short')
subplot(326)
plot((Room_Long(:,1:end)')), hold on
plot(nanmean((Room_Long(:,1:end)')'),'k','linewidth',3),
title('Room_Long')

jetcol = jet(11);
for k = 1:size(Tail_Long,1)
    Tail_LongBis(k,:) = Tail_Long(k,:) -Tail_Long(k,1);
    plot(Tail_LongBis(k,:)','color',jetcol((k),:)), hold on
end

