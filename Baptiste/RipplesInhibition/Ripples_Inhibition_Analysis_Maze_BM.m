
cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib','SalineShortAll','Saline2','DZPShortAll','DZP2','RipControlOld','RipInhibOld','AcuteBUS','ChronicBUS','SalineLongBM','DZPLongBM'};
Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

Group = [5:8 13:14];

cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

for group=Group
    clear Mouse
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) % generate all data required for analyses
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ob_low','heartrate','heartratevar','ripples','respi_freq_bm','ob_high');
    end
end


%% OB Low
Group = 5:8;

for group=Group
    clear Mouse
    Mouse=Drugs_Groups_UMaze_BM(group);
    
    figure; n=1;
    for sess=[4 5 3]
    subplot(3,3,n)
    if or(group==5 , group==6)
        [a,b] = max(RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))');
    else
        [a,b] = max(RangeLow(26:end)'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,26:end))');        
    end
        Data_to_use = ((RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))')./a)';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
    [c,d]=max(Mean_All_Sp(26:end));
    vline(RangeLow(d+25),'--r')
    if or(group==5 , group==6)
        [a,b] = max(RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))');
    else
        [a,b] = max(RangeLow(26:end)'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,26:end))');        
    end
    Data_to_use = ((RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))')./a)';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
    shadedErrorBar(RangeLow , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
    [c,d]=max(Mean_All_Sp(26:end));
    vline(RangeLow(d+25),'--b')
    f=get(gca,'Children');
    if n==1; a=legend([f(8),f(4)],'Shock side freezing','Safe side freezing'); end
    makepretty; ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
    title(Session_type{sess})
    
    subplot(3,3,3+n)
    if or(group==5 , group==6)
        [a,b] = max(RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))');
    else
        [a,b] = max(RangeLow(26:end)'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,26:end))');        
    end
    Data_to_use = ((RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))')./a)';
    plot(RangeLow , Data_to_use ,'-r'); hold on;
    makepretty; if n==1; ylabel('Power (a.u.)'); end; xlim([0 10]); ylim([0 1.2]); vline(4,'--r')
    
    subplot(3,3,n+6);
    if or(group==5 , group==6)
        [a,b] = max(RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))');
    else
        [a,b] = max(RangeLow(26:end)'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,26:end))');        
    end
    Data_to_use = ((RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))')./a)';
    plot(RangeLow , Data_to_use ,'-b'); hold on;
    makepretty; if n==1; ylabel('Power (a.u.)'); end; xlim([0 10]); ylim([0 1.2]); vline(4,'--r')
    xlabel('Frequency (Hz)')
    
    n=n+1;
    end
     a=suptitle(['OB mean spectrum, ' Drug_Group{group} ', n=' num2str(length(Mouse))]); a.FontSize=20;
end


% for sess=1:length(Session_type)
%     n=1;
%     for group=Group
%         
%         clear b
%         if or(group==5 , group==6)
%             [a,b] = max(RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))');
%             Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess}) = RangeLow(b);
%             Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess})(Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess})==RangeLow(1))=NaN;
%         else
%             [a,b] = max(RangeLow(26:end)'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,26:end))');
%             Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess}) = RangeLow(b+25);
%             Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess})(Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess})==RangeLow(26))=NaN;
%         end
%         
%         clear c
%         if or(group==5 , group==6)
%             [a,b] = max(RangeLow'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))');
%             Max_OB_Spectrum_Safe.(Drug_Group{group}).(Session_type{sess}) = RangeLow(b);
%             Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess})(Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess})==RangeLow(1))=NaN;
%         else
%             [~,b] = max(RangeLow(26:end)'.*squeeze(OutPutData.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,26:end))');
%             Max_OB_Spectrum_Safe.(Drug_Group{group}).(Session_type{sess}) = RangeLow(b+25);
%             Max_OB_Spectrum_Safe.(Drug_Group{group}).(Session_type{sess})(Max_OB_Spectrum_Safe.(Drug_Group{group}).(Session_type{sess})==RangeLow(26))=NaN;
%         end
%         
%         Max_OB_Spectrum_Shock.(Session_type{sess}){n} = Max_OB_Spectrum_Shock.(Drug_Group{group}).(Session_type{sess});
%         Max_OB_Spectrum_Safe.(Session_type{sess}){n} = Max_OB_Spectrum_Safe.(Drug_Group{group}).(Session_type{sess});
%         
%         n=n+1;
%     end
% end

% Max_OB_Spectrum_Shock.CondPost{3}(2) = 6.714;
% 
% figure; n=1;
% for sess=[4 5 3]
%     subplot(2,3,n)
%     MakeSpreadAndBoxPlot2_SB(Max_OB_Spectrum_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
%     if sess==4; ylabel('Frequency (Hz)'); u=text(-1,3.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
%     title(Session_type{sess})
%     ylim([1 9])
%     
%     subplot(2,3,n+3)
%     MakeSpreadAndBoxPlot2_SB(Max_OB_Spectrum_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
%     if sess==4; ylabel('Frequency (Hz)'); u=text(-1,3.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20);end
%     ylim([1 8])
%     
%     n=n+1;
% end
% a=suptitle('OB spectrums maxima'); a.FontSize=20;


OB_MaxFreq_Maze_BM

figure, n=1;
for sess=[4 5 3]
    for group=5:8
        
        subplot(3,4,group-4+(n-1)*4)
        MakeSpreadAndBoxPlot2_SB({OB_Max_Freq.(Drug_Group{group}).(Session_type{sess}).Shock OB_Max_Freq.(Drug_Group{group}).(Session_type{sess}).Safe},{[1 .5 .5],[.5 .5 1]},[1 2],NoLegends,'showpoints',0,'paired',1);
        ylim([0.9 7])
        
    end
    n=n+1;
end

figure
for group=5:8
    
    subplot(1,4,group-4)
    MakeSpreadAndBoxPlot2_SB({OB_Max_Freq.(Drug_Group{group}).(Session_type{4}).Shock-OB_Max_Freq.(Drug_Group{group}).(Session_type{4}).Safe OB_Max_Freq.(Drug_Group{group}).(Session_type{5}).Shock-OB_Max_Freq.(Drug_Group{group}).(Session_type{5}).Safe OB_Max_Freq.(Drug_Group{group}).(Session_type{3}).Shock-OB_Max_Freq.(Drug_Group{group}).(Session_type{3}).Safe},{[1 .8 1],[1 .5 1],[1 .2 1]},[1:3],{'CondPre','CondPost','Ext'},'showpoints',0,'paired',1);
    hline(0,'--k')
    ylim([-1 3])
    
end




%% HR
for sess=1:length(Session_type)
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            HR_Shock.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartrate.mean(mouse,5);
            HR_Safe.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartrate.mean(mouse,6);
            
            HRVar_Shock.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartratevar.mean(mouse,5);
            HRVar_Safe.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).heartratevar.mean(mouse,6);
            
            HR_Shock.(Session_type{sess}){n}(HR_Shock.(Session_type{sess}){n}==0)=NaN;
            HR_Safe.(Session_type{sess}){n}(HR_Safe.(Session_type{sess}){n}==0)=NaN;
            HRVar_Shock.(Session_type{sess}){n}(HRVar_Shock.(Session_type{sess}){n}==0)=NaN;
            HRVar_Safe.(Session_type{sess}){n}(HRVar_Safe.(Session_type{sess}){n}==0)=NaN;
        end
        n=n+1;
    end
end


figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(HR_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([7 14])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(HR_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([7 14])
    
    n=n+1;
end
a=suptitle('Heart rate analysis'); a.FontSize=20;


figure, n=1;
for sess=[4 5 3]
    for group=5:8
        
        subplot(3,4,group-4+(n-1)*4)
        MakeSpreadAndBoxPlot2_SB({HR_Shock.(Session_type{sess}){group-4} HR_Safe.(Session_type{sess}){group-4}},{[1 .5 .5],[.5 .5 1]},[1 2],NoLegends,'showpoints',0,'paired',1);
        ylim([8 13.5])
        
    end
    n=n+1;
end


figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(HRVar_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 .3])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(HRVar_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Frequency (Hz)'); u=text(-1,9.5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 .3])
    
    n=n+1;
end
a=suptitle('Heart rate variability analysis'); a.FontSize=20;


figure, n=1;
for sess=[4 5 3]
    for group=5:8
        
        subplot(3,4,group-4+(n-1)*4)
        MakeSpreadAndBoxPlot2_SB({HRVar_Shock.(Session_type{sess}){group-4} HRVar_Safe.(Session_type{sess}){group-4}},{[1 .5 .5],[.5 .5 1]},[1 2],NoLegends,'showpoints',0,'paired',1);
        ylim([0 .4])
        
    end
    n=n+1;
end


%% Ripples
for sess=1:length(Session_type)
    n=1;
    for group=Group
        Mouse=Drugs_Groups_UMaze_BM(group);
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Ripples_Shock.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).ripples.mean(mouse,5);
            Ripples_Safe.(Session_type{sess}){n}(mouse) = OutPutData.(Drug_Group{group}).(Session_type{sess}).ripples.mean(mouse,6);
            
            Ripples_Shock.(Session_type{sess}){n}(Ripples_Shock.(Session_type{sess}){n}==0)=NaN;
            Ripples_Safe.(Session_type{sess}){n}(Ripples_Safe.(Session_type{sess}){n}==0)=NaN;
        end
        n=n+1;
    end
end


figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(Ripples_Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Frequency (Hz)'); u=text(-1,.7,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 2])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Ripples_Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Frequency (Hz)'); u=text(-1,.7,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 2])
    
    n=n+1;
end
a=suptitle('Ripples analysis'); a.FontSize=20;


figure, n=1;
for sess=[4 5 3]
    for group=5:8
        
        subplot(3,4,group-4+(n-1)*4)
        MakeSpreadAndBoxPlot2_SB({Ripples_Shock.(Session_type{sess}){group-4} Ripples_Safe.(Session_type{sess}){group-4}},{[1 .5 .5],[.5 .5 1]},[1 2],NoLegends,'showpoints',0,'paired',1);
        ylim([0 2])
        
    end
    n=n+1;
end



%% Behaviour features
% Freezing proportion and ratio shock/safe
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
% Create_Behav_Drugs_BM
cd('/media/nas6/ProjetEmbReact/DataEmbReact'); load('Create_Behav_Drugs_BM.mat')
GetEmbReactMiceFolderList_BM
Side={'All','Shock','Safe'};
Side_ind=[3,5,6];
Group=5:8;
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM','Diazepam','RipControl','RipInhib','SalineShortAll','Saline2','DZPShortAll','DZP2','RipControlOld','RipInhibOld','AcuteBUS','ChronicBUS','SalineLongBM','DZPLongBM'};
Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.6350, 0.0780, 0.1840],[0.75, 0.75, 0]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};


for sess=1:length(Session_type)
    FreezingProportion.Figure.All.(Session_type{sess}){5}(9) = NaN;
    FreezingProportion.Figure.Shock.(Session_type{sess}){5}(9) = NaN;
    FreezingProportion.Figure.Safe.(Session_type{sess}){5}(9) = NaN;
    FreezingProportion.Figure.Ratio.(Session_type{sess}){5}(9) = NaN;
end


figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.All.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Freezing proportion'); end
    title(Session_type{sess})
    ylim([-0.01 0.75])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Ratio.(Session_type{sess})(Group),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Shock/Safe ratio'); end
    ylim([-0.01 1.1])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


% Shock & safe freezing proportion
figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Shock.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if sess==4; ylabel('proportion'); end
    if n==1; u=text(-1,.35,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([-0.01 0.9])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(FreezingProportion.Figure.Safe.(Session_type{sess})(Group),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('proportion'); end
    if n==1; u=text(-1,.27,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([-0.01 .7])
    
    n=n+1;
end
a=suptitle('Freezing analysis, UMaze drugs experiments'); a.FontSize=20;


% Episode length & mean duration
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        for side=1:length(Side)
            
            EpisodeNumber.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Epoch1.(Session_type{sess}){mouse,Side_ind(side)}));
            EpisodeMedianDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = nanmedian(Stop(Epoch1.(Session_type{sess}){mouse,Side_ind(side)})-Start(Epoch1.(Session_type{sess}){mouse,Side_ind(side)}))/1e4;
            EpisodeMeanDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Epoch1.(Session_type{sess}){mouse,Side_ind(side)})-Start(Epoch1.(Session_type{sess}){mouse,Side_ind(side)}))/1e4;
            
        end
    end
end


for side=1:length(Side)
    for sess=1:length(Session_type)
        n=1;
        for group=Group
            Mouse=Drugs_Groups_UMaze_BM(group);
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                Episode_Number.(Side{side}).(Session_type{sess}){n}(mouse) = EpisodeNumber.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                Episode_MedianDuration.(Side{side}).(Session_type{sess}){n}(mouse) = EpisodeMedianDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                Episode_MeanDuration.(Side{side}).(Session_type{sess}){n}(mouse) = EpisodeMeanDuration.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
                
            end
            n=n+1;
        end
    end
end


figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(Episode_Number.Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('#'); end
    title(Session_type{sess})
    if n==1; u=text(-1,35,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 100])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Episode_Number.Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('#'); end
    ylim([-1 160])
    if n==1; u=text(-1,60,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end

    n=n+1;
end
a=suptitle('Freezing analysis, episodes number'); a.FontSize=20;


figure; n=1;
for sess=[4 5 3]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Shock.(Session_type{sess}),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    title(Session_type{sess})
    ylim([0 12])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(Episode_MedianDuration.Safe.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('time (s)'); end
    if n==1; u=text(-1,5,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 12])
    
    n=n+1;
end
a=suptitle('Freezing analysis, episodes median duration'); a.FontSize=20;



%% Learning
figure; n=1;
for sess=[4 5 7]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Shock.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('entries/min'); end
    title(Session_type{sess})
    if n==1; u=text(-1,2,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 6.5])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(ZoneEntries.Figure.Safe.(Session_type{sess})(Group),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('entries/min'); end
    ylim([0 5.5])
    if n==1; u=text(-1,2,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end

    n=n+1;
end
a=suptitle('Zone entries'); a.FontSize=20;

figure; n=1;
for sess=[4 5 7]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Shock.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('proportion'); end
    title(Session_type{sess})
    if n==1; u=text(-1,.22,'Shock'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end
    ylim([0 .6])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(ZoneOccupancy.Figure.Safe.(Session_type{sess})(Group),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('proportion'); end
    ylim([0 1.1])
    if n==1; u=text(-1,.4,'Safe'); set(u,'Rotation',90,'FontWeight','bold','FontSize',20); end

    n=n+1;
end
a=suptitle('Zone occupancy analysis'); a.FontSize=20;


figure; n=1;
for sess=[4 5]
    subplot(2,2,n)
    MakeSpreadAndBoxPlot2_SB(ExtraStim.Figure.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('#stim/min'); end
    title(Session_type{sess})
    ylim([0 2.6])
    
    subplot(2,2,n+2)
    MakeSpreadAndBoxPlot2_SB(Stim_By_SZ_entries.Figure.(Session_type{sess})(Group),Cols,X,Legends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('SZ entries/#stim'); end
    ylim([0 40])

    n=n+1;
end
a=suptitle('Extra stim analysis'); a.FontSize=20;


% Mean time in zones
figure; n=1;
for sess=[4 5 7]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Shock.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Mean time in shock zone (s)'); end
    title(Session_type{sess})
    ylim([-0.01 20])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(OccupancyMeanTime.Figure.Safe.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('Mean time in safe zone (s)'); end
   ylim([-0.01 70])
    
    n=n+1;
end
a=suptitle('Mean time in zone when unblocked'); a.FontSize=20;


% Middle zone analysis
figure; n=1;
for sess=[4 5 7]
    subplot(2,3,n)
    MakeSpreadAndBoxPlot2_SB(Occupancy_MiddleZone.Figure.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('proportion'); end
    title(Session_type{sess})
%     ylim([-0.01 20])
    
    subplot(2,3,n+3)
    MakeSpreadAndBoxPlot2_SB(FreezingProp_MiddleZone.Figure.(Session_type{sess})(Group),Cols,X,NoLegends,'showpoints',1,'paired',0); 
    if sess==4; ylabel('proportion'); end
%    ylim([-0.01 70])
    
    n=n+1;
end
a=suptitle('Middle zone analysis'); a.FontSize=20;


%% Karim demands
% Rip inhib and DZP
figure; sess=2;
subplot(231)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){5}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){6}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){5}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){6}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , {'Saline','DZP','Saline','DZP'} , 'showpoints',1,'paired',0);
ylim([0 35])
ylabel('% time freezing')
subplot(232)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){5}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){6}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){5}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){6}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , {'Saline','DZP','Saline','DZP'} , 'showpoints',1,'paired',0);
ylim([0 105])
ylabel('% session time')
subplot(233)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){5} ZoneEntries.Figure.Shock.(Session_type{sess}){6} ZoneEntries.Figure.Safe.(Session_type{sess}){5} ZoneEntries.Figure.Safe.(Session_type{sess}){6}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , {'Saline','DZP','Saline','DZP'} , 'showpoints',1,'paired',0);
ylabel('entries/min')
ylim([0 4.7])


subplot(234)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){16}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){13}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){16}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){13}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 80])
ylabel('% time freezing')
subplot(235)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){16}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){13}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){16}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){13}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylim([0 105])
ylabel('% session time')
subplot(236)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){16} ZoneEntries.Figure.Shock.(Session_type{sess}){13} ZoneEntries.Figure.Safe.(Session_type{sess}){16} ZoneEntries.Figure.Safe.(Session_type{sess}){13}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',1,'paired',0);
ylabel('entries/min')
ylim([0 4.7])



% Look at rip inhib groups differently
figure; sess=2;
subplot(331)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){16}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){13}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){16}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){13}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , NoLegends1 , 'showpoints',1,'paired',0);
ylim([0 80])
ylabel('% time freezing')
subplot(332)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){16}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){13}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){16}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){13}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , NoLegends1 , 'showpoints',1,'paired',0);
ylim([0 105])
ylabel('% session time')
subplot(333)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){16} ZoneEntries.Figure.Shock.(Session_type{sess}){13} ZoneEntries.Figure.Safe.(Session_type{sess}){16} ZoneEntries.Figure.Safe.(Session_type{sess}){13}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , NoLegends1 , 'showpoints',1,'paired',0);
ylabel('entries/min')
ylim([0 4.7])

% first Maze
subplot(334)
[p,~]= MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){18}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){17}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){18}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){17}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , NoLegends1 , 'showpoints',1,'paired',0);
ylim([0 80])
ylabel('% time freezing')
subplot(335)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){18}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){17}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){18}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){17}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , NoLegends1 , 'showpoints',1,'paired',0);
ylim([0 105])
ylabel('% session time')
subplot(336)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){18} ZoneEntries.Figure.Shock.(Session_type{sess}){17} ZoneEntries.Figure.Safe.(Session_type{sess}){18} ZoneEntries.Figure.Safe.(Session_type{sess}){17}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , NoLegends1 , 'showpoints',1,'paired',0);
ylabel('entries/min')
ylim([0 4.7])

% paired results
subplot(337)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.(Session_type{sess}){20}*100 FreezingProportion.Figure.Shock.(Session_type{sess}){19}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){20}*100 FreezingProportion.Figure.Safe.(Session_type{sess}){19}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',0,'paired',1);
ylim([0 80])
ylabel('% time freezing')
subplot(338)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.(Session_type{sess}){20}*100 ZoneOccupancy.Figure.Shock.(Session_type{sess}){19}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){20}*100 ZoneOccupancy.Figure.Safe.(Session_type{sess}){19}*100} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',0,'paired',1);
ylim([0 105])
ylabel('% session time')
subplot(339)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.(Session_type{sess}){20} ZoneEntries.Figure.Shock.(Session_type{sess}){19} ZoneEntries.Figure.Safe.(Session_type{sess}){20} ZoneEntries.Figure.Safe.(Session_type{sess}){19}} , {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]} , X1 , Legends1 , 'showpoints',0,'paired',1);
ylabel('entries/min')
ylim([0 4.7])



