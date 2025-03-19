
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 2 freezing types

figure; sess=2;
clear DATA a; DATA = OB_Low_Spec.Shock.SalineSB.(Session_type{sess}); [a,b]=max(DATA(:,13:end)'); a(7)=1.089e5;
DATA = OB_Low_Spec.Shock.SalineSB.(Session_type{sess})./a'; 
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
shadedErrorBar(Spectro{3}, nanmean(DATA) , Conf_Inter , '-r',1); hold on;

clear DATA a; DATA = OB_Low_Spec.Safe.SalineSB.(Session_type{sess}); [a,b]=max(DATA(:,13:end)'); a([4 6 7])=[3.5e4 NaN 1.2e5];
DATA = OB_Low_Spec.Safe.SalineSB.(Session_type{sess})./a'; 
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
shadedErrorBar(Spectro{3}, nanmean(DATA) , Conf_Inter , '-b',1); hold on;
makepretty
xlim([0 10]); ylim([0 1.2])
f=get(gca,'Children'); a=legend([f(5),f(1)],'Shock','Safe');
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')


figure
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess})},{[1 .5 .5],[.5 .5 1]},[1:2],{'Shock','Safe'},'showpoints',0,'paired',1)
title('Ripples')

figure
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineBM_Short.(Session_type{sess}) HR.Safe.SalineBM_Short.(Session_type{sess})},{[1 .5 .5],[.5 .5 1]},[1:2],{'Shock','Safe'},'showpoints',0,'paired',1)
title('Heart rate')


%% Saline & Chronic Flx
Mouse=[688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 1130];
Session_type={'Cond','Ext'};
Drug_Group={'Saline','ChronicFlx'};
Cols = {[1, 0.5, 0.5],[0.5 0.5 1],[0.8, 0.5, 0.5],[0.5 0.5 0.8]};
X = [1:4];
Legends = {'Saline - shock','Saline - safe','Chronic flx - shock','Chronic flx - safe'};
Type= {'All' ,'Shock' ,'Safe'};
ind = [3 5 6];

for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'heartrate','heartratevar','respi_freq_bm','ripples','ob_high','ob_low');
end

cd('/media/nas6/ProjetEmbReact/DataEmbReact/')
load('Create_Behav_Drugs_BM.mat')


% Behaviour
Cols1 = {[0 0 1],[0 1 0]};
X1 = [1:2];
Legends1 = {'Saline','Chronic Flx'};
NoLegends1 = {'',''};

% freezing
subplot(221)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.All.Cond{1:2}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0);
subplot(222)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Ratio.Cond{1:2}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0); 
subplot(223)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0); 
subplot(224)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Safe.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0);
% occupancy
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(222)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Safe.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(223)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.TestPost{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(224)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Safe.TestPost{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% occupancy mean time
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Shock.Cond{1:2}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0) 
subplot(222)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Shock.TestPost{1:2}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0) 
subplot(223)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Safe.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(224)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Safe.TestPost{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% extra stim
figure
MakeSpreadAndBoxPlot2_SB({ExtraStim.Figure.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% Zone entries
subplot(121)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(122)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Safe.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% RA
MakeSpreadAndBoxPlot2_SB({RA.SalineSB.Cond RA.ChronicFlx.Cond} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% Escape latency
subplot(121)
MakeSpreadAndBoxPlot2_SB({EscapeLatency.Shock.SalineSB.Cond EscapeLatency.Shock.ChronicFlx.Cond} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0)
subplot(122)
MakeSpreadAndBoxPlot2_SB({EscapeLatency.Safe.SalineSB.Cond EscapeLatency.Safe.ChronicFlx.Cond} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0)
% Distance to door
% no differences, see OccupMaps
% Time in zone 3

% Stim by SZ entries
MakeSpreadAndBoxPlot2_SB({Stim_By_SZ_entries.Figure.Cond{1:2}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 


%%%%%%%%% What do we keep in mind ??
figure; sess=1;
subplot(151)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Shock.SalineSB.(Session_type{sess}) FreezingProportion.Shock.ChronicFlx.(Session_type{sess}) },{[1 .5 .5],[.8 .5 .5]},[1 2],{'Saline','Chronic Flx'},'showpoints',1,'paired',0)
title('Shock zone')
subplot(152)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Safe.SalineSB.(Session_type{sess}) FreezingProportion.Safe.ChronicFlx.(Session_type{sess}) },{[.5 .5 1],[.5 .5 .8]},[1 2],{'Saline','Chronic Flx'},'showpoints',1,'paired',0)
title('Safe zone')
subplot(153)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Shock.SalineSB.TestPost ZoneOccupancy.Shock.ChronicFlx.TestPost},{[1 .5 .5],[.8 .5 .5]},[1 2],{'Saline','Chronic Flx'},'showpoints',1,'paired',0)
title('Shock zone')
subplot(154)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Safe.SalineSB.TestPost ZoneOccupancy.Safe.ChronicFlx.TestPost},{[.5 .5 1],[.5 .5 .8]},[1 2],{'Saline','Chronic Flx'},'showpoints',1,'paired',0)
title('Safe zone')
subplot(155)
MakeSpreadAndBoxPlot2_SB({RA.SalineSB.Cond RA.ChronicFlx.Cond} , {[1 .5 1],[.8 .5 .8]},[1 2],{'Saline','Chronic Flx'} , 'showpoints',1,'paired',0,'optiontest','ttest') 



% Neurological & somatic markers
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
%         try
            for type=1:length(Type)
                % OB Low
                OB_Low_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_low.mean(mouse,ind(type),:);
                OB_Low_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_low.power(mouse,ind(type),:);
                OB_Low_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_low.max_freq(mouse,ind(type),:);
                % OB High
                OB_High_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.mean(mouse,ind(type),:);
                OB_High_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.power(mouse,ind(type),:);
                OB_High_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.max_freq(mouse,ind(type),:);
                % Ripples
                try; Ripples.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ripples.mean(mouse,ind(type)); end
                % Respi
                Respi.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).respi_freq_bm.mean(mouse,ind(type));
                % HR
                try; HR.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).heartrate.mean(mouse,ind(type)); end
                % HRVar
                try; HRVar.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).heartratevar.mean(mouse,ind(type)); end
            end
        %end
    end
    disp(Mouse_names{mouse})
end


for group=1:14
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for type=1:length(Type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                OB_Low_Spec.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:)=OB_Low_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_Low_Power.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_Low_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_Low_MaxFreq.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_Low_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_High_Spec.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:)=OB_High_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_High_Power.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_High_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_High_MaxFreq.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_High_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                HR.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=HR.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                HRVar.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=HRVar.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                Respi.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=Respi.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                Ripples.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=Ripples.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                
                
            end
            HR.(Type{type}).(Drug_Group{group}).(Session_type{sess})(HR.(Type{type}).(Drug_Group{group}).(Session_type{sess})==0)=NaN;
            HRVar.(Type{type}).(Drug_Group{group}).(Session_type{sess})(HRVar.(Type{type}).(Drug_Group{group}).(Session_type{sess})==0)=NaN;
            Ripples.(Type{type}).(Drug_Group{group}).(Session_type{sess})(Ripples.(Type{type}).(Drug_Group{group}).(Session_type{sess})==0)=NaN;
        end
    end
end


figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess}) ,HR.Safe.SalineSB.(Session_type{sess})  HR.Shock.ChronicFlx.(Session_type{sess}) , HR.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess}) , HR.Safe.SalineSB.(Session_type{sess}) ,HR.Shock.ChronicFlx.(Session_type{sess})  HR.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineSB.(Session_type{sess}) ,HRVar.Safe.SalineSB.(Session_type{sess}) ,  HRVar.Shock.ChronicFlx.(Session_type{sess}) HRVar.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineSB.(Session_type{sess}) ,  HRVar.Safe.SalineSB.(Session_type{sess}) HRVar.Shock.ChronicFlx.(Session_type{sess}), HRVar.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({Respi.Shock.SalineSB.(Session_type{sess}) , Respi.Shock.ChronicFlx.(Session_type{sess}) Respi.Safe.SalineSB.(Session_type{sess}) , Respi.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({Respi.Shock.SalineSB.(Session_type{sess}) , Respi.Shock.ChronicFlx.(Session_type{sess}) Respi.Safe.SalineSB.(Session_type{sess}) , Respi.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.ChronicFlx.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.ChronicFlx.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_Low_Power.Shock.SalineSB.(Session_type{sess}) , OB_Low_Power.Shock.ChronicFlx.(Session_type{sess}) OB_Low_Power.Safe.SalineSB.(Session_type{sess}) , OB_Low_Power.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_Low_Power.Shock.SalineSB.(Session_type{sess}) , OB_Low_Power.Shock.ChronicFlx.(Session_type{sess}) OB_Low_Power.Safe.SalineSB.(Session_type{sess}) , OB_Low_Power.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_High_Power.Shock.SalineSB.(Session_type{sess}) , OB_High_Power.Shock.ChronicFlx.(Session_type{sess}) OB_High_Power.Safe.SalineSB.(Session_type{sess}) , OB_High_Power.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_High_Power.Shock.SalineSB.(Session_type{sess}) , OB_High_Power.Shock.ChronicFlx.(Session_type{sess}) OB_High_Power.Safe.SalineSB.(Session_type{sess}) , OB_High_Power.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.ChronicFlx.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.ChronicFlx.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)


% mean spectrum: OB High
figure; sess=1; subplot(221)
clear DATA; DATA = OB_High_Spec.Shock.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_High_Spec.Shock.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty

subplot(222)
clear DATA; DATA = OB_High_Spec.Safe.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_High_Spec.Safe.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty

sess=2; subplot(223)
clear DATA; DATA = OB_High_Spec.Shock.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_High_Spec.Shock.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty

subplot(224)
clear DATA; DATA = OB_High_Spec.Safe.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_High_Spec.Safe.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty

% mean spectrum: OB Low
figure; sess=1; subplot(221)
clear DATA; DATA = OB_Low_Spec.Shock.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_Low_Spec.Shock.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty

subplot(222)
clear DATA; DATA = OB_Low_Spec.Safe.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_Low_Spec.Safe.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty

sess=2; subplot(223)
clear DATA; DATA = OB_Low_Spec.Shock.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_Low_Spec.Shock.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty

subplot(224)
clear DATA; DATA = OB_Low_Spec.Safe.SalineSB.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_Low_Spec.Safe.ChronicFlx.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty


sess=5;
OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess})(7)=3.662; 
OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess})([4 6 7])=[2.823 NaN 2.594]; 
OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess})([1 5 7])=[57.37 54.93 59.81];
sess=1;
OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess})(7)=2.747; 
OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess})([4 7])=[2.747 3.357]; 
OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})(7)=2.747; 
OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})([4 7])=[2.747 3.357]; 
sess=2;
OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})([4:6])=NaN; 
OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess})([4:6])=NaN; 


figure
subplot(141); sess=5;
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('OB Low')
ylabel('Frequency (Hz)')
subplot(142)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_High_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('OB High')
subplot(143)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Safe.SalineSB.(Session_type{sess})  Ripples.Shock.ChronicFlx.(Session_type{sess}), Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Ripples')
subplot(144)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess}) , HR.Safe.SalineSB.(Session_type{sess}) ,HR.Shock.ChronicFlx.(Session_type{sess})  HR.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Heart rate')




%% Saline & Diazepam
Mouse=[1144,1146,1147,1170,1171,1174,9184,1189,9205,1251,1253,1254,11147,11184,11189,11200,11204,11205,11206,11207,11251,11252,11253,11254];
Session_type={'Cond','Ext'};
Drug_Group={'','','','','Saline','Diazepam'};
Cols = {[1, .5, .5],[.5 .5 1],[1 .8 .8],[.8 .8 1]};
X = [1:4];
Legends = {'Saline - shock','Saline - safe','Diazepam - shock','Diazepam - safe'};
Type= {'All' ,'Shock' ,'Safe'};
ind = [3 5 6];

for sess=1:length(Session_type) 
    [OutPutData.(Session_type{sess}) , Epoch.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'heartrate','heartratevar','respi_freq_bm','ripples','ob_high','ob_low');
end


cd('/media/nas6/ProjetEmbReact/DataEmbReact/')
load('Create_Behav_Drugs_BM.mat')


% Behaviour
Cols1 = {[0 0 1],[0 1 0]};
X1 = [1:2];
Legends1 = {'Saline','Diazepam'};
NoLegends1 = {'',''};

% freezing
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.All.Cond{5:6}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0);
subplot(222)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Ratio.Cond{5:6}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0); 
subplot(223)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0); 
subplot(224)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Safe.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0)
% occupancy
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(222)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Safe.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(223)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.TestPost{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(224)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Safe.TestPost{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% occupancy mean time
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Shock.Cond{5:6}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0) 
subplot(222)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Shock.TestPost{5:6}} , Cols1 , X1 , NoLegends1 , 'showpoints',1,'paired',0) 
subplot(223)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Safe.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(224)
MakeSpreadAndBoxPlot2_SB({OccupancyMeanTime.Figure.Safe.TestPost{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% extra stim
figure
MakeSpreadAndBoxPlot2_SB({ExtraStim.Figure.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% Zone entries
figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Shock.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
subplot(122)
MakeSpreadAndBoxPlot2_SB({ZoneEntries.Figure.Safe.Cond{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% RA
figure
MakeSpreadAndBoxPlot2_SB({RA.SalineBM_Short.Cond RA.Diazepam_Short.Cond} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 
% Escape latency
MakeSpreadAndBoxPlot2_SB({EscapeLatency.Shock.SalineSB.Cond EscapeLatency.Shock.ChronicFlx.Cond} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0)
% Distance to door
% no differences, see OccupMaps
% Time in zone 3

% Stim by SZ entries
figure
MakeSpreadAndBoxPlot2_SB({Stim_By_SZ_entries.Figure.Fear{5:6}} , Cols1 , X1 , Legends1 , 'showpoints',1,'paired',0) 


%%%%%%%%% What do we keep in mind ??
figure; sess=2;
subplot(151)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Shock.SalineBM_Short.(Session_type{sess}) FreezingProportion.Shock.Diazepam_Short.(Session_type{sess}) },{[1 .5 .5],[1 .8 .8]},[1 2],{'Saline','Diazepam'},'showpoints',1,'paired',0)
title('Shock zone')
subplot(152)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Safe.SalineBM_Short.(Session_type{sess}) FreezingProportion.Safe.Diazepam_Short.(Session_type{sess}) },{[.5 .5 1],[.8 .8 1]},[1 2],{'Saline','Diazepam'},'showpoints',1,'paired',0)
title('Safe zone')
subplot(153)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Shock.SalineBM_Short.TestPost ZoneOccupancy.Shock.Diazepam_Short.TestPost},{[1 .5 .5],[1 .8 .8]},[1 2],{'Saline','Diazepam'},'showpoints',1,'paired',0)
title('Shock zone')
subplot(154)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Safe.SalineBM_Short.TestPost ZoneOccupancy.Safe.Diazepam_Short.TestPost},{[.5 .5 1],[.8 .8 1]},[1 2],{'Saline','Diazepam'},'showpoints',1,'paired',0)
title('Safe zone')
subplot(155)
MakeSpreadAndBoxPlot2_SB({RA.SalineBM_Short.Cond RA.Diazepam_Short.Cond} , {[1 .5 1],[1 .8 1]},[1 2],{'Saline','Diazepam'} , 'showpoints',1,'paired',0,'optiontest','ttest') 


% Neurological & somatic markers
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
%         try
            for type=1:length(Type)
                % OB Low
                OB_Low_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_low.mean(mouse,ind(type),:);
                OB_Low_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_low.power(mouse,ind(type),:);
                OB_Low_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_low.max_freq(mouse,ind(type),:);
                % OB High
                OB_High_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.mean(mouse,ind(type),:);
                OB_High_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.power(mouse,ind(type),:);
                OB_High_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.max_freq(mouse,ind(type),:);
                % Ripples
                try; Ripples.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ripples.mean(mouse,ind(type)); end
                % Respi
                Respi.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).respi_freq_bm.mean(mouse,ind(type));
                % HR
                try; HR.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).heartrate.mean(mouse,ind(type)); end
                % HRVar
                try; HRVar.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).heartratevar.mean(mouse,ind(type)); end
            end
        %end
    end
    disp(Mouse_names{mouse})
end


for group=1:14
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for type=1:length(Type)
            for mouse=1:length(Mouse)
                Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
                
                OB_Low_Spec.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:)=OB_Low_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_Low_Power.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_Low_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_Low_MaxFreq.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_Low_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_High_Spec.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse,:)=OB_High_Spec.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_High_Power.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_High_Power.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                OB_High_MaxFreq.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=OB_High_MaxFreq.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                try; HR.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=HR.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                    HRVar.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=HRVar.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}); end
                Respi.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=Respi.(Type{type}).(Session_type{sess}).(Mouse_names{mouse});
                try; Ripples.(Type{type}).(Drug_Group{group}).(Session_type{sess})(mouse)=Ripples.(Type{type}).(Session_type{sess}).(Mouse_names{mouse}); end
                
            end
            HR.(Type{type}).(Drug_Group{group}).(Session_type{sess})(HR.(Type{type}).(Drug_Group{group}).(Session_type{sess})==0)=NaN;
            HRVar.(Type{type}).(Drug_Group{group}).(Session_type{sess})(HRVar.(Type{type}).(Drug_Group{group}).(Session_type{sess})==0)=NaN;
            Ripples.(Type{type}).(Drug_Group{group}).(Session_type{sess})(Ripples.(Type{type}).(Drug_Group{group}).(Session_type{sess})==0)=NaN;
        end
    end
end


figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess}) ,HR.Safe.SalineSB.(Session_type{sess}) , HR.Shock.Diazepam.(Session_type{sess})  HR.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess}) HR.Safe.SalineSB.(Session_type{sess}) , HR.Shock.Diazepam.(Session_type{sess}) , HR.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineSB.(Session_type{sess}) HRVar.Safe.SalineSB.(Session_type{sess}), HRVar.Shock.Diazepam.(Session_type{sess})  , HRVar.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineSB.(Session_type{sess}) HRVar.Safe.SalineSB.(Session_type{sess}), HRVar.Shock.Diazepam.(Session_type{sess})  , HRVar.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({Respi.Shock.SalineSB.(Session_type{sess}) , Respi.Shock.Diazepam.(Session_type{sess}) Respi.Safe.SalineSB.(Session_type{sess}) , Respi.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({Respi.Shock.SalineSB.(Session_type{sess}) , Respi.Shock.Diazepam.(Session_type{sess}) Respi.Safe.SalineSB.(Session_type{sess}) , Respi.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.Diazepam.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.Diazepam.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_Low_Power.Shock.SalineSB.(Session_type{sess}) , OB_Low_Power.Shock.Diazepam.(Session_type{sess}) OB_Low_Power.Safe.SalineSB.(Session_type{sess}) , OB_Low_Power.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_Low_Power.Shock.SalineSB.(Session_type{sess}) , OB_Low_Power.Shock.Diazepam.(Session_type{sess}) OB_Low_Power.Safe.SalineSB.(Session_type{sess}) , OB_Low_Power.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Shock.Diazepam.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Shock.Diazepam.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_Low_MaxFreq.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_High_Power.Shock.SalineSB.(Session_type{sess}) , OB_High_Power.Shock.Diazepam.(Session_type{sess}) OB_High_Power.Safe.SalineSB.(Session_type{sess}) , OB_High_Power.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_High_Power.Shock.SalineSB.(Session_type{sess}) , OB_High_Power.Shock.Diazepam.(Session_type{sess}) OB_High_Power.Safe.SalineSB.(Session_type{sess}) , OB_High_Power.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Shock.Diazepam.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Shock.Diazepam.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) , OB_High_MaxFreq.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=1; subplot(121)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.Diazepam.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
sess=2; subplot(122)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Shock.Diazepam.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) , Ripples.Safe.Diazepam.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)



% Mean spectrum: OB Low
figure; sess=1; subplot(221)
clear DATA; DATA = OB_Low_Spec.Shock.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_Low_Spec.Shock.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([0 10])

subplot(222)
clear DATA; DATA = OB_Low_Spec.Safe.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_Low_Spec.Safe.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([0 10])

sess=2; subplot(223)
clear DATA; DATA = OB_Low_Spec.Shock.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_Low_Spec.Shock.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([0 10])

subplot(224)
clear DATA; DATA = OB_Low_Spec.Safe.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_Low_Spec.Safe.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([0 10])


% Mean spectrum: OB High
figure; sess=1; subplot(221)
clear DATA; DATA = OB_High_Spec.Shock.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_High_Spec.Shock.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([20 100])

subplot(222)
clear DATA; DATA = OB_High_Spec.Safe.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_High_Spec.Safe.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([20 100])

sess=2; subplot(223)
clear DATA; DATA = OB_High_Spec.Shock.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-r',1); hold on;
clear DATA; DATA = OB_High_Spec.Shock.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([20 100])

subplot(224)
clear DATA; DATA = OB_High_Spec.Safe.SalineBM_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-b',1); hold on;
clear DATA; DATA = OB_High_Spec.Safe.Diazepam_Short.(Session_type{sess});
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3},Mean_All_Sp/max(Mean_All_Sp),Conf_Inter/max(Mean_All_Sp),'-k',1); hold on;
makepretty
xlim([20 100])


sess=2;
OB_Low_MaxFreq.Shock.SalineBM_Short.(Session_type{sess})([3])=NaN;
OB_Low_MaxFreq.Safe.SalineBM_Short.(Session_type{sess})([4])=NaN;
OB_Low_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})([8])=3.891;
sess=5;
OB_Low_MaxFreq.Shock.SalineBM_Short.(Session_type{sess})([3 4])=[2.747 NaN]; 
OB_Low_MaxFreq.Safe.SalineBM_Short.(Session_type{sess})([4 12])=NaN; 
OB_Low_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})([4 5])=[NaN 5.112]; 
OB_Low_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})([4 5 7 8 9])=[NaN NaN 3.357 2.06 NaN];
OB_High_MaxFreq.Safe.SalineBM_Short.(Session_type{sess})(12)=NaN; 
OB_High_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})(12)=57.37; 
OB_High_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})([5 6 9])=[NaN 52.49 NaN]; 
sess=4;
OB_Low_MaxFreq.Shock.SalineBM_Short.(Session_type{sess})([3])=[NaN]; 
OB_Low_MaxFreq.Safe.SalineBM_Short.(Session_type{sess})([4])=[NaN]; 
OB_Low_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})([2])=[3.891]; 
OB_High_MaxFreq.Shock.SalineBM_Short.(Session_type{sess})([3])=[NaN]; 
OB_High_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})([12])=[NaN]; 
OB_High_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})([12])=[NaN]; 


figure; sess=2;
subplot(141)
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineBM_Short.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineBM_Short.(Session_type{sess}) OB_Low_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})  , OB_Low_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Frequency (Hz)')
title('OB Low')
subplot(142)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineBM_Short.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineBM_Short.(Session_type{sess}) OB_High_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})  , OB_High_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('OB High')
subplot(143)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) Ripples.Shock.Diazepam_Short.(Session_type{sess})  , Ripples.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Ripples')
subplot(144)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineBM_Short.(Session_type{sess}) HR.Safe.SalineBM_Short.(Session_type{sess}), HR.Shock.Diazepam_Short.(Session_type{sess})  , HR.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Heart rate')



MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) Ripples.Shock.Diazepam_Short.(Session_type{sess})  , Ripples.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)


MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineBM_Short.(Session_type{sess}) Ripples.Safe.SalineBM_Short.(Session_type{sess}) Ripples.Shock.Diazepam_Short.(Session_type{sess})  , Ripples.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)

figure; sess=4;
subplot(141)
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineBM_Short.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineBM_Short.(Session_type{sess}) OB_Low_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})  , OB_Low_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Frequency (Hz)')
title('OB Low')
subplot(142)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineBM_Short.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineBM_Short.(Session_type{sess}) OB_High_MaxFreq.Shock.Diazepam_Short.(Session_type{sess})  , OB_High_MaxFreq.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('OB High')
subplot(143)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) Ripples.Safe.SalineSB.(Session_type{sess}) Ripples.Shock.Diazepam_Short.(Session_type{sess})  , Ripples.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Ripples')
subplot(144)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineBM_Short.(Session_type{sess}) HR.Safe.SalineBM_Short.(Session_type{sess}), HR.Shock.Diazepam_Short.(Session_type{sess})  , HR.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Heart rate')


figure
MakeSpreadAndBoxPlot2_SB({HRVar.Shock.SalineBM_Short.(Session_type{sess}) HRVar.Safe.SalineBM_Short.(Session_type{sess}), HRVar.Shock.Diazepam_Short.(Session_type{sess})  , HRVar.Safe.Diazepam_Short.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
title('Heart rate')




%% trash ?
OB_Low_MaxFreq.Shock.ChronicBUS.(Session_type{2})(4) = NaN;
OB_Low_MaxFreq.Safe.ChronicBUS.(Session_type{2})(1) = 4.959;
OB_Low_MaxFreq.Shock.ChronicBUS.(Session_type{5})(1) = NaN;
OB_Low_MaxFreq.Safe.ChronicBUS.(Session_type{5})(1) = 4.196;

OB_Low_MaxFreq.Shock.RipInhib.(Session_type{2}) = [3.433 5.722 4.959 4.349];
OB_Low_MaxFreq.Safe.RipInhib.(Session_type{2}) = [3.967 4.501 4.883 5.112];
OB_Low_MaxFreq.Shock.RipInhib.(Session_type{5}) = [3.967 4.501 4.883 5.112];
OB_High_MaxFreq.Shock.RipInhib.(Session_type{2})(4) = 68.36;
OB_High_MaxFreq.Safe.RipInhib.(Session_type{2})(4) = 68.36;

OB_Low_MaxFreq.Shock.Saline2.(Session_type{2}) = [3.433 5.722 4.959 4.349];
OB_Low_MaxFreq.Safe.Saline2.(Session_type{2}) = [3.967 4.501 4.883 5.112];
OB_Low_MaxFreq.Shock.Saline2.(Session_type{5}) = [3.967 4.501 4.883 5.112];
OB_High_MaxFreq.Shock.Saline2.(Session_type{2})(4) = 68.36;
OB_High_MaxFreq.Safe.Saline2.(Session_type{2})(4) = 68.36;

OB_Low_MaxFreq.Shock.Saline2.(Session_type{2}) = [3.433 5.722 4.959 4.349];
OB_Low_MaxFreq.Safe.Saline2.(Session_type{2}) = [3.967 4.501 4.883 5.112];
OB_Low_MaxFreq.Shock.Saline2.(Session_type{5}) = [3.967 4.501 4.883 5.112];
OB_High_MaxFreq.Shock.Saline2.(Session_type{2})(4) = 68.36;
OB_High_MaxFreq.Safe.Saline2.(Session_type{2})(4) = 68.36;

OB_Low_MaxFreq.Safe.Diazepam_Long.(Session_type{2})([4]) = [3.052]
OB_Low_MaxFreq.Shock.Diazepam_Long.(Session_type{2})([1 4]) = [4.654 3.51]






figure
subplot(241); sess=2;
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0)
title('OB Low')
ylabel('Frequency (Hz)')
subplot(242)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_High_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0)
title('OB High')
subplot(243)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Safe.SalineSB.(Session_type{sess})  Ripples.Shock.ChronicFlx.(Session_type{sess}), Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0)
title('Ripples')
subplot(244)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess}) , HR.Safe.SalineSB.(Session_type{sess}) ,HR.Shock.ChronicFlx.(Session_type{sess})  HR.Safe.ChronicFlx.(Session_type{sess})},Cols,X,NoLegends,'showpoints',1,'paired',0)
title('Heart rate')

subplot(245); sess=5;
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Frequency (Hz)')
subplot(246)
MakeSpreadAndBoxPlot2_SB({OB_High_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_High_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_High_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
subplot(247)
MakeSpreadAndBoxPlot2_SB({Ripples.Shock.SalineSB.(Session_type{sess}) , Ripples.Safe.SalineSB.(Session_type{sess})  Ripples.Shock.ChronicFlx.(Session_type{sess}), Ripples.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
subplot(248)
MakeSpreadAndBoxPlot2_SB({HR.Shock.SalineSB.(Session_type{sess}) , HR.Safe.SalineSB.(Session_type{sess}) ,HR.Shock.ChronicFlx.(Session_type{sess})  HR.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)




subplot(141); sess=2;
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Shock.SalineSB.(Session_type{sess}) FreezingProportion.Safe.SalineSB.(Session_type{sess}) FreezingProportion.Shock.ChronicFlx.(Session_type{sess})  , FreezingProportion.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 .28]); ylabel('proportion')
subplot(143); sess=5;
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Shock.SalineSB.(Session_type{sess}) FreezingProportion.Safe.SalineSB.(Session_type{sess}) FreezingProportion.Shock.ChronicFlx.(Session_type{sess})  , FreezingProportion.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 .45]); ylabel('proportion')

subplot(142); sess=2;
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 6.5]); ylabel('Frequency (Hz)')
subplot(144); sess=5;
MakeSpreadAndBoxPlot2_SB({OB_Low_MaxFreq.Shock.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Safe.SalineSB.(Session_type{sess}) OB_Low_MaxFreq.Shock.ChronicFlx.(Session_type{sess})  , OB_Low_MaxFreq.Safe.ChronicFlx.(Session_type{sess})},Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 6.5]); ylabel('Frequency (Hz)')




for group=[5 2 6 14 13]
    
    A{group} = Proportion_Time_Spent_In_Zones.(Drug_Group{group}).Cond(:,3);
    B{group} = Proportion_Time_Spent_Freezing_In_Zones.(Drug_Group{group}).Cond(:,3);
    
end

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({A{[5 2 6 14 13]}} ,{[1 .5 1],[1 .8 1],[.8 .5 .8],[.9 .3 .9],[.9 .6 .9]},[1:5],{'Saline','Chronic Flx','Diazepam','Chronic BUS','Rip Inhib'},'showpoints',1,'paired',0)
title('Middle zone occupancy')
ylabel('proportion')
subplot(122)
MakeSpreadAndBoxPlot2_SB({B{[5 2 6 14 13]}} ,{[1 .5 1],[1 .8 1],[.8 .5 .8],[.9 .3 .9],[.9 .6 .9]},[1:5],{'Saline','Chronic Flx','Diazepam','Chronic BUS','Rip Inhib'},'showpoints',1,'paired',0)
title('Middle zone freezing')
ylabel('proportion')






