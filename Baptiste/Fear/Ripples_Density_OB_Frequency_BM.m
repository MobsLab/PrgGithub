
clear all

GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

thr=1; % threshold for noise
Freq_Limit=3.66;
load('/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_TestPost_PostDrug/TestPost2/B_Low_Spectrum.mat')

Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);

% Calculating data for each mouse
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        
        Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
        RipplesFreezing.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
        RespiFreezing.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        [All_Freq.(Session_type{sess}).(Mouse_names{mouse}) , EpLength.(Mouse_names{mouse}) , EpProp_2_4.(Mouse_names{mouse}) , TimeProp_thr_2_4.(Mouse_names{mouse}) , TimeProp_abs_2_4.(Mouse_names{mouse})] = FreezingSpectrumEpisodesAnalysis_BM(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freq_Limit);
        
    end
    disp(Mouse_names{mouse})
end

% dividing it by freezing episode
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        try
            Start_FzEpoch = Start(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            Stop_FzEpoch = Stop(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
            for i=1:length(Start_FzEpoch)
                if (Stop_FzEpoch(i)-Start_FzEpoch(i))>2e4
                    Ripples_numb_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(Start_FzEpoch(i) < Range(RipplesFreezing.(Session_type{sess}).(Mouse_names{mouse})) & Range(RipplesFreezing.(Session_type{sess}).(Mouse_names{mouse})) < Stop_FzEpoch(i));
                    Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = (Ripples_numb_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) / sum(Stop_FzEpoch(i)-Start_FzEpoch(i)))*1e4;
                    Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , subset(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , i))));
                else
                    Ripples_numb_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = NaN;
                    Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = NaN;
                    Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = NaN;
                end
            end
            
            %         [R_ind.(Mouse_names{mouse}),P_ind.(Mouse_names{mouse})]=corrcoef_BM(nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') , Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}));
            FzEp_Mean_Length.(Session_type{sess}).(Mouse_names{mouse}) = Stop_FzEpoch-Start_FzEpoch;
            if sum(Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})==0)==length(Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}))
                Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})=NaN(1,length(Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})));
            end
        end
    end
    disp(Mouse_names{mouse})
end

% Occup map
Session_type={'sleep_pre'};
[OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples_density');

Session_type={'Cond'};
clear MAP MAP_norm MAP2 MAP2_norm
figure
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        if length(Ripples.(Session_type{sess}).(Mouse_names{mouse}))>50
            MAP_norm.(Session_type{sess})(mouse,:,:) = hist2d([Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}) 1 1 7 7] ,...
                [Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})./OutPutData.ripples_density.mean(mouse,4) -1 6 -1 6],100,100);
            %             MAP.(Session_type{sess})(mouse,:,:) = MAP.(Session_type{sess})(mouse,:,:)./nansum(nansum(MAP.(Session_type{sess})(mouse,:,:)));
            
            MAP.(Session_type{sess})(mouse,:,:) = hist2d([Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}) 1 1 7 7] ,...
                [Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}) -.5 3 -.5 3],100,100);
            
            
            [R.(Session_type{sess})(mouse),P.(Session_type{sess})(mouse),a.(Session_type{sess})(mouse)] = ...
                PlotCorrelations_BM(Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}) ,...
                Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})./OutPutData.ripples_density.mean(mouse,4));
        end
    end
    R.(Session_type{sess})(R.(Session_type{sess})==0)=NaN;
    P.(Session_type{sess})(P.(Session_type{sess})==0)=NaN;
end
close

for mouse=1:length(Mouse)
    clear M, M = SmoothDec(squeeze(MAP_norm.Cond(mouse,:,:)),5);
    MAP2_norm.Cond(mouse,:,:) = M./nansum(nansum(squeeze(M)));
    
    clear M, M = SmoothDec(squeeze(MAP.Cond(mouse,:,:)),5);
    MAP2.Cond(mouse,:,:) = M./nansum(nansum(squeeze(M)));
end


figure
subplot(121)
B=squeeze(nanmean(MAP2.Cond)); %B(isnan(B))=0; C=nansum(B); C(C==0)=1; B=B./C; B(B>.5)=0;
imagesc(linspace(1,7,50) , linspace(-.5,3,50) , zscore(SmoothDec(B',2))), axis xy, axis square, colormap jet
xlim([1 7]), ylim([0 2]), %caxis([-1.4 2])
xlabel('Breathing frequency (Hz)'), ylabel('SWR occurence (#/s)')
makepretty_BM

subplot(122)
B=squeeze(nanmean(MAP2_norm.Cond)); %B(isnan(B))=0; C=nansum(B); C(C==0)=1; B=B./C; B(B>.5)=0;
imagesc(linspace(1,7,50) , linspace(-1,6,50) , zscore(SmoothDec(B',2))), axis xy, axis square, colormap jet
xlim([1 7]), ylim([0 4]), c=caxis;, %caxis([-1.4 2])
xlabel('Breathing frequency (Hz)'), ylabel('SWR occurence (x times NREM)')
u=colorbar; u.Ticks=c; u.TickLabels={'0','1'}; u.Label.String = 'density (a.u.)'; u.Label.FontSize=12;
makepretty_BM

Cols2={[.3 .3 .3]};
X2=[1];
Legends2={'R values'};

figure
MakeSpreadAndBoxPlot4_SB({R.Cond(P.Cond<.05)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
[h,p] = ttest(R.Cond(P.Cond<.05) , zeros(1,length(R.Cond(P.Cond<.05))))
title(['p = ' num2str(p,2)])
ylim([-1 1]), hline(0,'--r'), yticks([-1:.2:1]), ylabel('R values')
makepretty_BM2

% precise binning
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        for bin=1:70
            
            Numb_Of_Ep_With_ThisFreq.(Session_type{sess}).(Mouse_names{mouse})(bin) = sum( (bin-1)/10 < nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') & nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') < bin/10 ) ;
            ind_to_use = (bin-1)/10 < nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') & nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') < bin/10 ;
            Ripples_density_In_A_Frequency_Range.(Session_type{sess}).(Mouse_names{mouse})(bin) = nanmean( Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(ind_to_use)) ;
            FzEp_Mean_Length_In_A_Frequency_Range.(Session_type{sess}).(Mouse_names{mouse})(bin) = nanmean( FzEp_Mean_Length.(Session_type{sess}).(Mouse_names{mouse})(ind_to_use)) ;
            
            if (sum(isnan(Ripples_density_In_A_Frequency_Range.(Session_type{sess}).(Mouse_names{mouse})))+sum(Ripples_density_In_A_Frequency_Range.(Session_type{sess}).(Mouse_names{mouse})==0)==70)
                Ripples_density_In_A_Frequency_Range.(Session_type{sess}).(Mouse_names{mouse})=NaN(1,70); % mice without ripples
            end
        end
    end
end

% large binning
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        for Bin=1:14
            
            Numb_Of_Ep_With_ThisFreq2.(Session_type{sess}).(Mouse_names{mouse})(Bin) = sum( (Bin-1)/2 < nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') & nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') < Bin/2 ) ;
            ind_to_use = (Bin-1)/2 < nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') & nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') < Bin/2 ;
            Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})(Bin) = nanmean( Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(ind_to_use)) ;
            FzEp_Mean_Length_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})(Bin) = nanmean( FzEp_Mean_Length.(Session_type{sess}).(Mouse_names{mouse})(ind_to_use)) ;
                        
            if (sum(isnan(Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})))+sum(Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})==0)==140)
                Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})=NaN(1,140); % mice without ripples
            end
        end
    end
end

% grouping it for drugs
Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','NewSaline','Diazepam'};
for group=1%[1:6]
    
    Drugs_Groups_Ripples_UMaze_BM
    
    for sess=1:length(Session_type)
        a=1;
        for mouse=1:length(Mouse)
           Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
           
            TotNumb_Of_Ep_With_ThisFreq.(Session_type{sess}).(Drug_Group{group})(a,:) = Numb_Of_Ep_With_ThisFreq.(Session_type{sess}).(Mouse_names{mouse});
            TotRipples_density_In_A_Frequency_Range.(Session_type{sess}).(Drug_Group{group})(a,:) = Ripples_density_In_A_Frequency_Range.(Session_type{sess}).(Mouse_names{mouse});
            TotFzEp_Mean_Length.(Session_type{sess}).(Drug_Group{group})(a,:) = FzEp_Mean_Length_In_A_Frequency_Range.(Session_type{sess}).(Mouse_names{mouse});
            
            TotNumb_Of_Ep_With_ThisFreq2.(Session_type{sess}).(Drug_Group{group})(a,:) = Numb_Of_Ep_With_ThisFreq2.(Session_type{sess}).(Mouse_names{mouse});
            TotRipples_density_In_A_Frequency_Range2.(Session_type{sess}).(Drug_Group{group})(a,:) = Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse});
            TotFzEp_Mean_Length2.(Session_type{sess}).(Drug_Group{group})(a,:) = FzEp_Mean_Length_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse});
            
            a=a+1;
        end
        TotRipples_density_In_A_Frequency_Range.(Session_type{sess}).(Drug_Group{group})(TotNumb_Of_Ep_With_ThisFreq.(Session_type{sess}).(Drug_Group{group})==0)=NaN;
        TotRipples_density_In_A_Frequency_Range2.(Session_type{sess}).(Drug_Group{group})(TotNumb_Of_Ep_With_ThisFreq2.(Session_type{sess}).(Drug_Group{group})==0)=NaN;
        
        [R{sess,group} , P{sess,group}] = corrcoef_BM([0.1:0.1:7] , nanmean(TotRipples_density_In_A_Frequency_Range.(Session_type{sess}).(Drug_Group{group})));
        R_mean(sess,group)=R{sess,group}(1,2); P_mean(sess,group)=P{sess,group}(1,2);
    end
end


%% Figures
% detail per mouse
figure
a=1; Mouse=[688,739,777,849];
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    subplot(2,2,a)
    Ripples_density_in_FzEp.Fear.(Mouse_names{mouse})(Ripples_density_in_FzEp.Fear.(Mouse_names{mouse})==0)=NaN;
    plot(nanmean(All_Freq.Fear.(Mouse_names{mouse})') , Ripples_density_in_FzEp.Fear.(Mouse_names{mouse}) , '.r' , 'MarkerSize' , 30)
    makepretty
    xlim([0 7])
    if or(a==1,a==3)
        ylabel('Ripples density (ripples/s)')
    end
    if or(a==3,a==4)
        xlabel('Mean OB frequency (Hz)')
    end
    title(['R = ' num2str(R_ind.(Mouse_names{mouse})(2,1)) ', P = ' num2str(P_ind.(Mouse_names{mouse})(2,1))])
    
    a=a+1;
end


% imagesc visualisation
TotNumb_Of_Ep_With_ThisFreq.Fear.All=[]
TotRipples_density_In_A_Frequency_Range.Fear.All=[]
TotFzEp_Mean_Length.Fear.All=[]
for group=[1:6]
    
    TotNumb_Of_Ep_With_ThisFreq.Fear.All = [TotNumb_Of_Ep_With_ThisFreq.Fear.All  ; TotNumb_Of_Ep_With_ThisFreq.Fear.(Drug_Group{group})];
    TotRipples_density_In_A_Frequency_Range.Fear.All = [TotRipples_density_In_A_Frequency_Range.Fear.All ; TotRipples_density_In_A_Frequency_Range.Fear.(Drug_Group{group})];
    TotFzEp_Mean_Length.Fear.All = [TotFzEp_Mean_Length.Fear.All ; TotFzEp_Mean_Length.Fear.(Drug_Group{group})];
    
end

figure; 
subplot(131)
imagesc([0.05:0.05:7] , [1:50] , TotNumb_Of_Ep_With_ThisFreq.Fear.All)
xlabel('OB frequency (Hz)'); xlim([1 7]); vline([2 4 6],'--r'); hline([7.5 14.5 19.5 26.5 38.5],'-r'); makepretty
yticks([3.5 10.5 16.5 22.5 32 44]); yticklabels({'Saline SB','Chronic flx','Acute Flx','Midazolam','Saline BM','DZP'})
title('Fz Ep #')

subplot(132)
imagesc([0.05:0.05:7] , [1:50] , TotRipples_density_In_A_Frequency_Range.Fear.All)
xlabel('OB frequency (Hz)'); xlim([1 7]); vline([2 4 6],'--r'); hline([7.5 14.5 19.5 26.5 38.5],'-r'); makepretty
yticks([3.5 10.5 16.5 22.5 32 44]); caxis([0 1.5])
title('Ripples density')

subplot(133)
imagesc([0.05:0.05:7] , [1:50] , TotFzEp_Mean_Length.Fear.All)
xlabel('OB frequency (Hz)'); xlim([1 7]); vline([2 4 6],'--r'); hline([7.5 14.5 19.5 26.5 38.5],'-r'); makepretty
yticks([3.5 10.5 16.5 22.5 32 44]); 
title('Ep mean duration'); caxis([2e4 20e4])


% bar scatter visualisation
figure
a=1;
for mouse=[1 3 7 13]
    subplot(2,2,a)
    
    for bin=1:14
        
        p1 = bar(bin,Numb_Of_Ep_With_ThisFreq2.(Session_type{sess}).(Mouse_names{mouse})(bin));
        if isnan(Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})(bin))
            set(p1,'FaceColor',[1 1 1]);
        else
            set(p1,'FaceColor',[1-Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})(bin) 1-Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})(bin) 1-Ripples_density_In_A_Frequency_Range2.(Session_type{sess}).(Mouse_names{mouse})(bin)]);
        end
        hold on;
    end
    makepretty
    xticks([0:4:12]); xticklabels({'0','2','4','6'})
    
    if or(a==1,a==3)
        ylabel('# Fz Ep')
    end
    if or(a==3,a==4)
        xlabel('Mean OB frequency for fz episode (Hz)')
    end
    
    ylim([0 60])
    a=a+1;
end


% All drugs and conditions Ripples=f(OB Freq)
figure
for sess=1:length(Session_type)
    a=1;
    for group=[1:6]
        
        TotRipples_density_In_A_Frequency_Range.(Session_type{sess}).(Drug_Group{group})(TotRipples_density_In_A_Frequency_Range.(Session_type{sess}).(Drug_Group{group})==0)=NaN;
        subplot(3,6,6*(sess-1)+a)
        plot([0.1:0.1:7] , nanmean(TotRipples_density_In_A_Frequency_Range.(Session_type{sess}).(Drug_Group{group})),'.r','MarkerSize',20)
        makepretty; xlim([1 7])
        tit=title(['R = ' num2str(R_mean(sess,group)) ', P = ' num2str(P_mean(sess,group))]); tit.FontSize=15;
        axis square
        ylim([0 1.5])
        
        if 6*(sess-1)+a>12; xlabel('OB frequency (Hz)') ; end
        if sess==1; u=text(2.5,2,Drug_Group{group}) ; u.FontSize=20;  end
        if 6*(sess-1)+a==1 | 6*(sess-1)+a==7 | 6*(sess-1)+a==13 ; ylabel('Ripples density (rip/s)'); 
        u=text(-1.5,0.3,Session_type{sess}) ; u.FontSize=30; set(u,'Rotation',90); set(u,'FontWeight','bold'); end
        a=a+1;
    end
end
a=suptitle('Ripples and OB frequency during Fz Ep, drugs experiments'); a.FontSize=20;


% imagesc visualisation of all Rtot and Ptot
figure
subplot(121)
imagesc(log(abs(R_mean)))
xticklabels(Drug_Group); xtickangle(45); makepretty
yticks([1 2 3]); yticklabels(Session_type);
colorbar
vline([1.5 2.5 3.5 4.5 5.5 6.5],'-k'); hline([1.5 2.5 3.5],'-k'); box on
title('R values')
subplot(122)
imagesc(log(P_mean))
xticklabels(Drug_Group); xtickangle(45); makepretty
yticks([1 2 3]); yticklabels(Session_type);
vline([1.5 2.5 3.5 4.5 5.5 6.5],'-k'); hline([1.5 2.5 3.5],'-k'); box on
colorbar
title('P values')

% Ep length and OB Freq associated
figure
a=1; sess=1;
for group=1:6
    
    subplot(2,3,a)
    Conf_Inter=nanstd(TotFzEp_Mean_Length.(Session_type{sess}).(Drug_Group{group})/1e4)/sqrt(size(TotFzEp_Mean_Length.(Session_type{sess}).(Drug_Group{group}),1));
    shadedErrorBar([0.05:0.1:7] , runmean_BM(nanmean(TotFzEp_Mean_Length.(Session_type{sess}).(Drug_Group{group})),5)/1e4 , runmean_BM(Conf_Inter,5) ,'-k',1); hold on;
    if a==1 | a==3 | a==5
        ylabel('Fz Ep mean duration (s)')
    end
    hold on
    ylim([0 10])
    makepretty
    yyaxis right
    Conf_Inter=nanstd(TotNumb_Of_Ep_With_ThisFreq.(Session_type{sess}).(Drug_Group{group}))/sqrt(size(TotNumb_Of_Ep_With_ThisFreq.(Session_type{sess}).(Drug_Group{group}),1));
    shadedErrorBar([0.05:0.1:7] , runmean_BM(nanmean(TotNumb_Of_Ep_With_ThisFreq.(Session_type{sess}).(Drug_Group{group})),5) , runmean_BM(Conf_Inter,5) ,'-r',1); hold on;
    if a==2 | a==4 | a==6
        ylabel('Fz Ep number (#)')
    end
    ylim([0 8])
    makepretty
    ax = gca;
    ax.YColor=[1 0 0];
    title(Drug_Group{group})
    if a==5 | a==6
        xlabel('OB frequency (Hz)')
    end
    
    a=a+1;
    
end
a=suptitle('Freezing episodes number and mean duration, Ext, drugs experiments'); a.FontSize=20;


%% others mice

Mouse=[117 404 425 430 431 436 437 438 439 444 445 469 470 471 483 484 485 490 507 508 509 510 512 514 561 567 568  569 566 666 667 668 669];

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end


for mouse =1:length(Mouse)
    try
        %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
        TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
        TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
        CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond/Cond')))));
        ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
        FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
        TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
        CondExploSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'CondExplo')))));
    end    
end


thr=1; % threshold for noise
Freq_Limit=3.66;
cd('/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_TestPost_PostDrug/TestPost2/')
load('B_Low_Spectrum.mat')

for mouse=1:length(Mouse)
    try
    Ripples.Fear.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'ripples');
    FreezeEpoch.Fear.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
    RipplesFreezing.Fear.(Mouse_names{mouse}) = Restrict(Ripples.Fear.(Mouse_names{mouse}) , FreezeEpoch.Fear.(Mouse_names{mouse}));
    OBSpec.Fear.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
    OBSpecFreezing.Fear.(Mouse_names{mouse})=Restrict(OBSpec.Fear.(Mouse_names{mouse}) , FreezeEpoch.Fear.(Mouse_names{mouse}));
    
    [All_Freq.(Mouse_names{mouse}) , EpLength.(Mouse_names{mouse}) , EpProp_2_4.(Mouse_names{mouse}) , TimeProp_thr_2_4.(Mouse_names{mouse}) , TimeProp_abs_2_4.(Mouse_names{mouse})] = FreezingSpectrumEpisodesAnalysis_BM(FreezeEpoch.Fear.(Mouse_names{mouse}) , OBSpec.Fear.(Mouse_names{mouse}) , Spectro{3} , thr , Freq_Limit);
    
    disp(Mouse_names{mouse})
    end
end

for mouse=1:length(Mouse)
    try
        Start_FzEpoch = Start(FreezeEpoch.Fear.(Mouse_names{mouse}));
        Stop_FzEpoch = Stop(FreezeEpoch.Fear.(Mouse_names{mouse}));
        
        for i=1:length(Start_FzEpoch)
            
            Ripples_numb_in_FzEp.Fear.(Mouse_names{mouse})(i) = sum(Start_FzEpoch(i) < Range(RipplesFreezing.Fear.(Mouse_names{mouse})) & Range(RipplesFreezing.Fear.(Mouse_names{mouse})) < Stop_FzEpoch(i));
            Ripples_density_in_FzEp.Fear.(Mouse_names{mouse})(i) = (Ripples_numb_in_FzEp.Fear.(Mouse_names{mouse})(i) / sum(Stop_FzEpoch(i)-Start_FzEpoch(i)))*1e4;
            
        end
        
        [R.(Mouse_names{mouse}),P.(Mouse_names{mouse})]=corrcoef_BM(nanmean(All_Freq.(Mouse_names{mouse})') , Ripples_density_in_FzEp.Fear.(Mouse_names{mouse}));
        FzEp_Mean_Length.Fear.(Mouse_names{mouse}) = Stop_FzEpoch-Start_FzEpoch;
    end
end

for mouse=1:length(Mouse)
    for bin=1:140
        try
        Numb_Of_Ep_With_ThisFreq.(Mouse_names{mouse})(bin) = sum( (bin-1)/20 < nanmean(All_Freq.(Mouse_names{mouse})') & nanmean(All_Freq.(Mouse_names{mouse})') < bin/20 ) ;
        ind_to_use = (bin-1)/20 < nanmean(All_Freq.(Mouse_names{mouse})') & nanmean(All_Freq.(Mouse_names{mouse})') < bin/20 ;
        Ripples_density_In_A_Frequency_Range.(Mouse_names{mouse})(bin) = nanmean( Ripples_density_in_FzEp.Fear.(Mouse_names{mouse})(ind_to_use)) ;
        FzEp_Mean_Length_In_A_Frequency_Range.(Mouse_names{mouse})(bin) = nanmean( FzEp_Mean_Length.Fear.(Mouse_names{mouse})(ind_to_use)) ;
        end
    end
end


Drug_Group={'PAG','Eyeshock'};

for group=[1:2]
    
    if group==1 % PAG mice
        Mouse=[18 19 20 21 22 23 24];
    elseif group==2 % eyeshock mice
        Mouse=[25 26 28 30:33];
    end
    
    a=1;
    for mouse=Mouse
        
    TotNumb_Of_Ep_With_ThisFreq.(Drug_Group{group})(a,:) = Numb_Of_Ep_With_ThisFreq.(Mouse_names{mouse});
    TotRipples_density_In_A_Frequency_Range.(Drug_Group{group})(a,:) = Ripples_density_In_A_Frequency_Range.(Mouse_names{mouse});
    TotFzEp_Mean_Length.(Drug_Group{group})(a,:) = FzEp_Mean_Length_In_A_Frequency_Range.(Mouse_names{mouse});
    a=a+1;
    
    end
end

TotFzEp_Mean_Length.Eyeshock(1,:)=NaN; TotFzEp_Mean_Length.Eyeshock(3,34)=NaN; TotFzEp_Mean_Length.Eyeshock(3,37)=NaN;

figure
a=1;
for group=[1:2]
    
    subplot(1,2,a)
    Conf_Inter=nanstd(TotFzEp_Mean_Length.(Drug_Group{group})/1e4)/sqrt(size(TotFzEp_Mean_Length.(Drug_Group{group}),1));
    shadedErrorBar([0.05:0.05:7] , runmean_BM(nanmean(TotFzEp_Mean_Length.(Drug_Group{group})),5)/1e4 , runmean_BM(Conf_Inter,5) ,'-k',1); hold on;
        if a==1 
ylabel('Fz Ep mean duration (s)')
        end
    hold on
   ylim([0 20])
 makepretty
    yyaxis right
    Conf_Inter=nanstd(TotNumb_Of_Ep_With_ThisFreq.(Drug_Group{group})/1e4)/sqrt(size(TotNumb_Of_Ep_With_ThisFreq.(Drug_Group{group}),1));
    shadedErrorBar([0.05:0.05:7] , runmean_BM(nanmean(TotNumb_Of_Ep_With_ThisFreq.(Drug_Group{group})),5)/1e4 , runmean_BM(Conf_Inter,5) ,'-r',1); hold on;
            if a==2 
ylabel('Fz Ep number')
            end
            ylim([0 6e-4])
    makepretty
    ax = gca;
    ax.YColor=[1 0 0];
    title(Drug_Group{group})
    if a==1 | a==2
        xlabel('OB frequency (Hz)')
    end
    
    a=a+1;
    
end





