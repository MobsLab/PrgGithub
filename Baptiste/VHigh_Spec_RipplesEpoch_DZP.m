

cd('/media/nas6/ProjetEmbReact/DataEmbReact')
load('Sess.mat', 'Sess')
 
GetEmbReactMiceFolderList_BM
Mouse=[1189 1251 1253 1254 1392 11204,11207,11251,11252,11253,11254];
Side={'All','Shock','Safe'};
window_time = 1;

cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre3')
load('H_VHigh_Spectrum.mat')



for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
%     HPC_VHigh_Spec_FearSess.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) ,'spectrum','prefix','H_VHigh');
    Ripples.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) ,'ripples');
    Fz_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) ,'epoch','epochname','freezeepoch');
    Zone_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}) ,'epoch','epochname','zoneepoch');
    Shock_Epoch.(Mouse_names{mouse}) = Zone_Epoch.(Mouse_names{mouse}){1};
    Safe_Epoch.(Mouse_names{mouse}) = or(Zone_Epoch.(Mouse_names{mouse}){2} , Zone_Epoch.(Mouse_names{mouse}){5});
    Fz_Ripples.All.(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
    Fz_Ripples.Shock.(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse})));
    Fz_Ripples.Safe.(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse})));
    HPC_VHigh_Spec_Fz.(Mouse_names{mouse}) = Restrict(HPC_VHigh_Spec_FearSess.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
    
%     Ripples_Epoch_Sleep.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(2) ,'around_ripples_epoch');
%     HPC_VHigh_Spec_SleepSess.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(2) ,'spectrum','prefix','H_VHigh');
%     Sleep_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(SleepSess.(Mouse_names{mouse})(1) ,'epoch','epochname','sleepstates');
%     Sleep_Ripples_Epoch.(Mouse_names{mouse}) = and(Sleep_Epoch.(Mouse_names{mouse}){2} , Ripples_Epoch_Sleep.(Mouse_names{mouse}));
%     HPC_VHigh_Spec_NREM.(Mouse_names{mouse}) = Restrict(HPC_VHigh_Spec_SleepSess.(Mouse_names{mouse}) , Sleep_Epoch.(Mouse_names{mouse}){2});
    
    disp(Mouse_names{mouse})
end
clear HPC_VHigh_Spec_SleepSess HPC_VHigh_Spec_FearSess

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for side=1:3
        R = Range(Fz_Ripples.(Side{side}).(Mouse_names{mouse}));
        for ep=1:size(R,1)
            clear HPC_VHigh_Spec_On_Ripples_Epoch_temp HPC_VHigh_Spec_On_Ripples_Epoch_temp_Norm
            Around_rip = intervalSet(R(ep)-.25e4 , R(ep)+.25e4);
            HPC_VHigh_Spec_On_Ripples_Epoch_temp = Data(Restrict(HPC_VHigh_Spec_Fz.(Mouse_names{mouse}) , Around_rip));
            if and(~isempty(HPC_VHigh_Spec_On_Ripples_Epoch_temp) , size(HPC_VHigh_Spec_On_Ripples_Epoch_temp , 1)>2)
                for line=1:94
                    HPC_VHigh_Spec_On_Ripples_Epoch_temp_Norm(:,line) = interp1(linspace(0,1,size(HPC_VHigh_Spec_On_Ripples_Epoch_temp , 1)) ,  HPC_VHigh_Spec_On_Ripples_Epoch_temp(:,line)' , linspace(0,1,50));
                end
                HPC_VHigh_Spec_On_Ripples_Epoch_Norm2.(Side{side}).(Mouse_names{mouse})(ep,:,:) = HPC_VHigh_Spec_On_Ripples_Epoch_temp_Norm;
            else
                HPC_VHigh_Spec_On_Ripples_Epoch_Norm2.(Side{side}).(Mouse_names{mouse})(ep,:,:) = NaN(50,94);
            end
        end
        HPC_VHigh_Spec_On_Ripples_Epoch_Norm_Mean.(Side{side}).(Mouse_names{mouse}) = nanmean(HPC_VHigh_Spec_On_Ripples_Epoch_Norm2.(Side{side}).(Mouse_names{mouse}));
    end
%     for ep=1:size(Start(Sleep_Ripples_Epoch.(Mouse_names{mouse})),1)
%         clear HPC_VHigh_Spec_On_SleepRipples_Epoch_temp HPC_VHigh_Spec_On_SleepRipples_Epoch_temp_Norm
%         HPC_VHigh_Spec_On_SleepRipples_Epoch_temp = Data(Restrict(HPC_VHigh_Spec_NREM.(Mouse_names{mouse}) , subset(Sleep_Ripples_Epoch.(Mouse_names{mouse}), ep)));
%         if and(~isempty(HPC_VHigh_Spec_On_SleepRipples_Epoch_temp) , size(HPC_VHigh_Spec_On_SleepRipples_Epoch_temp , 1)>2)
%             for line=1:94
%                 HPC_VHigh_Spec_On_SleepRipples_Epoch_temp_Norm(:,line) = interp1(linspace(0,1,size(HPC_VHigh_Spec_On_SleepRipples_Epoch_temp , 1)) ,  HPC_VHigh_Spec_On_SleepRipples_Epoch_temp(:,line)' , linspace(0,1,50));
%             end
%             HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm2.(Mouse_names{mouse})(ep,:,:) = HPC_VHigh_Spec_On_SleepRipples_Epoch_temp_Norm;
%         else
%             HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm2.(Mouse_names{mouse})(ep,:,:) = NaN(50,94);
%         end
%     end
%     HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm_Mean.(Mouse_names{mouse}) = nanmean(HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm2.(Mouse_names{mouse}));
%     
    disp(Mouse_names{mouse})
end


for group=1:2
    if group==1
        Mouse = [1251 1253 1254 1392];
    else
        Mouse=[11204,11251,11254];
    end
    for  side=1:3
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            HPC_VHigh.(Side{side}){group}(mouse,:,:) = squeeze(HPC_VHigh_Spec_On_Ripples_Epoch_Norm_Mean.(Side{side}).(Mouse_names{mouse}));
            
        end
        HPC_VHigh_mean.(Side{side}){group} = squeeze(nanmean(HPC_VHigh.(Side{side}){group}));
    end
end




figure; side=1;
Mouse=[1189,1251,1253,1254 11204,11207,11251,11252,11253,11254];
for mouse =1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    subplot(1,5,mouse)
    imagesc([1:50] , Spectro{3} , squeeze(HPC_VHigh_Spec_On_Ripples_Epoch_Norm_Mean.(Side{side}).(Mouse_names{mouse}))'); axis xy
    ylim([100 250])
    caxis([0 6e2])
    h=vline(25,'--r'); set(h,'LineWidth',2)
    h=hline(183,'--r'); set(h,'LineWidth',2)
    if side==3; xticks([1 25 50]); xticklabels({'-100ms','0','+100ms'});
    else; xticks([0 25 50]); xticklabels({'','',''});  end
    
%     subplot(2,5,mouse+5)
%     imagesc([1:50] , Spectro{3} , squeeze(HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm_Mean.(Mouse_names{mouse}))'); axis xy
%     ylim([100 250])
%     caxis([0 6e2])
%     h=vline(25,'--r'); set(h,'LineWidth',2)
%     h=hline(183,'--r'); set(h,'LineWidth',2)
%     if side==3; xticks([1 25 50]); xticklabels({'-100ms','0','+100ms'});
%     else; xticks([0 25 50]); xticklabels({'','',''}); end
%     
    colormap jet
end


% increase quality for Poster FENS
Mouse=[1254 11254];
for mouse =1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for side=2:3
        
        for line=1:94
            A.(Side{side}).(Mouse_names{mouse})(:,line) = interp1(linspace(0,1,size(squeeze(HPC_VHigh_Spec_On_Ripples_Epoch_Norm_Mean.(Side{side}).(Mouse_names{mouse})) , 1)) ,  squeeze(HPC_VHigh_Spec_On_Ripples_Epoch_Norm_Mean.(Side{side}).(Mouse_names{mouse})(1,:,line))' , linspace(0,1,500));
        end
        for column=1:500
            A2.(Side{side}).(Mouse_names{mouse})(column,:) = interp1(linspace(0,1,size(A.(Side{side}).(Mouse_names{mouse}) , 2)) ,  A.(Side{side}).(Mouse_names{mouse})(column,:) , linspace(0,1,940));
        end
        A3.(Side{side}).(Mouse_names{mouse}) = linspace(20,250,940).*runmean(A2.(Side{side}).(Mouse_names{mouse}),30);
    end
%     
%     for line=1:94
%         B.(Mouse_names{mouse})(:,line) = interp1(linspace(0,1,size(squeeze(HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm_Mean.(Mouse_names{mouse})) , 1)) ,  squeeze(HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm_Mean.(Mouse_names{mouse})(1,:,line))' , linspace(0,1,500));
%     end
%     for column=1:500
%         B2.(Mouse_names{mouse})(column,:) = interp1(linspace(0,1,size(B.(Mouse_names{mouse}) , 2)) ,  B.(Mouse_names{mouse})(column,:) , linspace(0,1,940));
%     end
%     B3.(Mouse_names{mouse}) = linspace(20,250,940).*runmean(B2.(Mouse_names{mouse}),30);
end





figure 
subplot(221)
imagesc([1:500] , Spectro{3} , A3.Shock.M1254'); axis xy
ylim([22 250]); caxis([1e3 7e4]); 
h=vline(250,'--r'); set(h,'LineWidth',2)
h=hline(183,'--r'); set(h,'LineWidth',2)
ylabel('Frequency (Hz)')
xticks([1 250 500]); xticklabels({'-250ms','0','+250ms'})
title('Saline'); 
u=text(-100,100,'Shock'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);

subplot(223)
imagesc([1:500] , Spectro{3} , A3.Safe.M1254'); axis xy
ylim([22 250]); caxis([1e3 7e4]); 
h=vline(250,'--r'); set(h,'LineWidth',2)
h=hline(183,'--r'); set(h,'LineWidth',2)
xticks([1 250 500]); xticklabels({'-250ms','0','+250ms'}); ylabel('Frequency (Hz)')
u=text(-100,100,'Safe'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90);

subplot(222)
imagesc([1:500] , Spectro{3} , A3.Shock.M11254'); axis xy
ylim([22 250]); caxis([1e3 7e4]); 
h=vline(250,'--r'); set(h,'LineWidth',2)
h=hline(183,'--r'); set(h,'LineWidth',2)
xticks([1 250 500]); xticklabels({'-250ms','0','+250ms'})
title('Diazepam'); 

subplot(224)
imagesc([1:500] , Spectro{3} , A3.Safe.M11254'); axis xy
ylim([22 250]); caxis([1e3 7e4]); 
h=vline(250,'--r'); set(h,'LineWidth',2)
h=hline(183,'--r'); set(h,'LineWidth',2)
xticks([1 250 500]); xticklabels({'-250ms','0','+250ms'})

colormap jet
a=suptitle('HPC VHigh spectrum on freezing ripples events, M1254');


for g=1:10
    figure; n=1;
    for ep=1+g*10:10+g*10
        subplot(2,5,n)
        imagesc(squeeze(HPC_VHigh_Spec_On_Ripples_Epoch_Norm2.(Side{1}).(Mouse_names{2})(ep,:,:))'); axis xy
        %ylim([100 250])
        caxis([0 6e2])
        h=vline(25,'--r'); set(h,'LineWidth',2)
        h=hline(183,'--r'); set(h,'LineWidth',2)
        
        n=n+1;
    end
end



for g=1:10
    figure; n=1;
    for ep=1+g*10:10+g*10
        subplot(2,5,n)
        imagesc(squeeze(HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm2.(Mouse_names{1})(ep,:,:))'); axis xy
        %ylim([100 250])
        caxis([0 1e3])
        h=vline(250,'-r'); set(h,'LineWidth',1)
        h=hline(183,'-r'); set(h,'LineWidth',1)
        
        colormap jet
        n=n+1;
    end
end






for ep=1:size(HPC_VHigh_Spec_On_Ripples_Epoch_Norm2.(Side{1}).(Mouse_names{1}),1)
    
    A(ep,:) = nanmean(squeeze(HPC_VHigh_Spec_On_Ripples_Epoch_Norm2.(Side{1}).(Mouse_names{1})(ep,:,41:end)),2);
    B(ep,:) = nanmean(squeeze(HPC_VHigh_Spec_On_SleepRipples_Epoch_Norm2.(Mouse_names{1})(ep,:,41:end)),2);
    
end
    
figure
plot(A')
plot(A'./max(A'))
plot(nanmean(A))
plot(nanmean(A./max(A)))


figure
plot(B')
plot(B'./max(B'))
plot(nanmean(B))
plot(nanmean(B./max(B)))





%% Mean spec

load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/HPC_VHigh_DZP.mat')


Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Session_type = {'sleep_pre','CondPost'};
for group=[13 15]
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1%:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'hpc_low');
    end
end
OutPutData2.Diazepam.sleep_pre.hpc_vhigh.mean([1 2 4 5],:,:) = NaN;
OutPutData2.Diazepam.CondPost.hpc_vhigh.mean([1 2 4 5],:,:) = NaN;

OutPutData.Saline.CondPost.hpc_low.mean([3 7],:,:) = NaN;
OutPutData.Diazepam.CondPost.hpc_low.mean([4 5 10 12],:,:) = NaN;
OutPutData.Saline.sleep_pre.hpc_low.mean([3 7],:,:) = NaN;
OutPutData.Diazepam.sleep_pre.hpc_low.mean([4 5 10 12],:,:) = NaN;


load('/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_UMazeCondBlockedSafe_PostDrug/Cond3/B_Low_Spectrum.mat')

figure
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData.Saline.sleep_pre.hpc_low.mean(:,5,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.3, .745, .93]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData.Diazepam.sleep_pre.hpc_low.mean(:,5,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Data_to_use = Data_to_use*1.04;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.85, .325, .098]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('Frequency (Hz)'), ylabel('Power (log scale)'), ylim([3.7 5.7])
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');


figure
subplot(121)
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,5,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,5,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Data_to_use = Data_to_use*1.04;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.7 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('Frequency (Hz)'), ylabel('Power (log scale)')
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');

subplot(122)
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,6,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,6,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Data_to_use = Data_to_use*1.04;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.3 .3 .7]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('Frequency (Hz)'), ylabel('Power (log scale)'), ylim([4.5 5.5])
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');




load('/media/nas6/ProjetEmbReact/Mouse1254/20211216/ProjectEmbReact_M1254_20211216_UMazeCondBlockedSafe_PostDrug/Cond3/H_VHigh_Spectrum.mat')

figure
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData2.Saline.sleep_pre.hpc_vhigh.mean(:,4,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.3, .745, .93]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData2.Diazepam.sleep_pre.hpc_vhigh.mean(:,4,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.85, .325, .098]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('Frequency (Hz)'), ylabel('Power (log scale)'),ylim([3.5 5])
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');


figure
subplot(121)
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData2.Saline.CondPost.hpc_vhigh.mean(:,5,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData2.Diazepam.CondPost.hpc_vhigh.mean(:,5,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.7 .3 .3]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('Frequency (Hz)'), ylabel('Power (log scale)'),ylim([3.5 5])
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');

subplot(122)
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData2.Saline.CondPost.hpc_vhigh.mean(:,6,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
Data_to_use = log10(Spectro{3}.*squeeze(OutPutData2.Diazepam.CondPost.hpc_vhigh.mean(:,6,:))); Data_to_use(or(Data_to_use==0 , Data_to_use==-Inf)) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar(Spectro{3} , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
col = [.3 .3 .7]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
xlabel('Frequency (Hz)'), ylabel('Power (log scale)')
makepretty
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Diazepam');




