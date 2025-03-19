clear all
[Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl,...
    Info_CD1_CD1cage,Info_CD1_C57cage,Info_Sleep_CD1InCage,Info_Sleep_CD1NOTInCage,Info_Sleep_Ctrl] = Get_SD_Path_UmazeComp;

%% need to add baseline mice to see if they are freezing more or less than after SDS
AllDir = {Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl};
Allinfo = {Info_CD1_CD1cage,Info_C D1_C57cage,Info_Sleep_CD1InCage,Info_Sleep_CD1NOTInCage,Info_Sleep_Ctrl};
GroupNames = {'CD1_Exp','C57_Exp','C57_Sleep','CD1_Sleep','Ctrl_Sleep'};
% 
% %% Get data SDS mice
% for dirnum  = 1:length(AllDir)
%     mouse_num = 1;
%     for dd = 1:length(AllDir{dirnum})
%         for ddd = 1:length(AllDir{dirnum}{dd}.path)
%             ddd
%             % Get data
%             if not(isempty(findstr(GroupNames{dirnum},'Sleep')))
%                 TempData = GetSVMDataFromDir_SDS_UmazeComp_SleepSession(AllDir{dirnum}{dd}.path{ddd}{1});
%             else
%                 TempData = GetSVMDataFromDir_SDS_UmazeComp(AllDir{dirnum}{dd}.path{ddd}{1});
%             end
%             Fields = fieldnames(TempData);
%             % Reorganize
%             try
%                 Data.(GroupNames{dirnum}).MouseId(mouse_num) = AllDir{dirnum}{dd}.nMice{ddd};
%             catch
%                 Data.(GroupNames{dirnum}).MouseId(mouse_num) =  eval(Dir_Sleep_Ctrl{dd}.name{ddd}(6:end));
%             end
%             Data.(GroupNames{dirnum}).FileLoc{mouse_num} = AllDir{dirnum}{dd}.path{ddd}{1};
%             Data.(GroupNames{dirnum}).AllSpec_Lo(mouse_num,:) = TempData.OBSpec_Lo;
%             Data.(GroupNames{dirnum}).AllSpec_Hi(mouse_num,:) = TempData.OBSpec_Hi;
%             Data.(GroupNames{dirnum}).Params_SVM(mouse_num,:) = [NaN,TempData.OBGammaFreq,TempData.OBGammaPower,TempData.Rip_density];
%             Data.(GroupNames{dirnum}).FzTime(mouse_num) = TempData.FzTime;
%             Data.(GroupNames{dirnum}).FzProp(mouse_num) = TempData.FzProp;
%             Data.(GroupNames{dirnum}).BreathFreq{mouse_num} = TempData.AllInstFreqFz;
%             if (isempty(findstr(GroupNames{dirnum},'Sleep')))
%                 Data.(GroupNames{dirnum}).SDSNumber(mouse_num) = Allinfo{dirnum}.FirstSecond(dd);
%             else
%                 Data.(GroupNames{dirnum}).REMProp(mouse_num) = TempData.REMProp;
%                 Data.(GroupNames{dirnum}).SleepProp(mouse_num) = TempData.SleepProp;
%             end
%             mouse_num = mouse_num+1;
%         end
%     end
% end
% 
% 
% % Get the OB peaks manually
% % fLow = [1+0.076:0.076:20-0.076];
% % for dirnum  = 1:length(AllDir)
% %     
% %     for mouse_num = 1:size(Data.AllSpec_Lo.(GroupNames{dirnum}),1)
% %         if Data.FzTime.(GroupNames{dirnum})(mouse_num)>0
% %             plot(fLow,Data.AllSpec_Lo.(GroupNames{dirnum})(mouse_num,:)), title(num2str(Data.FzTime.(GroupNames{dirnum})(mouse_num)))
% %             xlim([0 20])
% %             hold on
% %             [Data.Params_SVM.(GroupNames{dirnum})(mouse_num,1),y] = ginput(1);
% %             if Data.Params_SVM.(GroupNames{dirnum})(mouse_num,1)<0.5
% %                 Data.Params_SVM.(GroupNames{dirnum})(mouse_num,1) = NaN;
% %             end
% %             clf
% %         end
% %     end
% % end
% 
% % Load manual info
% Temp = load('SDS_Data_CompUmaze_VOld.mat');
% for dirnum  = 1:length(GroupNames)
%     for mouse_num = 1:size(Data.(GroupNames{dirnum}).AllSpec_Lo,1)
% 
% Data.(GroupNames{dirnum}).Params_SVM(mouse_num,1) = Temp.Data.Params_SVM.(GroupNames{dirnum})(mouse_num,1);
%     end
% end
% 
% % Get rid of mice with LFP problems
% BadMice = [1197,1541,1489,1488];
% for dirnum  = 1:length(GroupNames)
%     AllFields = fieldnames(Data.(GroupNames{dirnum}));
% 
%     MiceToElim = ismember(Data.(GroupNames{dirnum}).MouseId,BadMice);
%     for ff = 1:length(AllFields)
%         ff
%         if min(size(Data.(GroupNames{dirnum}).(AllFields{ff})))>1
%             Data.(GroupNames{dirnum}).(AllFields{ff})(MiceToElim,:) = [];
%         else
%             Data.(GroupNames{dirnum}).(AllFields{ff})(MiceToElim) = [];
%             
%         end
%     end
% end
% 
% % Match the sleep and CD exposure sessions
% CD1_once = unique(Data.CD1_Exp.MouseId);
% for mm = 1:length(CD1_once)
%     MatchSess.CD1_Sess{mm} = find(Data.CD1_Exp.MouseId==CD1_once(mm) & Data.CD1_Exp.SDSNumber==1);
%     MatchSess.C57_Sess{mm} = find(Data.C57_Exp.MouseId ==CD1_once(mm)  & Data.C57_Exp.SDSNumber==1);
%     MatchSess.C57_SleepSess{mm} = find(Data.C57_Sleep.MouseId==CD1_once(mm));
%     MatchSess.CD1_SleepSess{mm} = find(Data.CD1_Sleep.MouseId==CD1_once(mm));
%     
% end
% 
% cd /media/nas7/ProjetEmbReact/DataEmbReact/PaperData
% load('SDS_Data_CompUmaze_VF.mat',...
%     'Data','GroupNames','MatchSess')
% 

%% Clean things up
% Mice with too much noise for a clear peak and mice with no freezing
cd /media/nas7/ProjetEmbReact/DataEmbReact/PaperData
load('SDS_Data_CompUmaze_VF.mat')

Cols = {[1,0.4,0.4],[0.4,0,0.8],[0.4,0.4,1],[0.4,0.4,1],[0.4,0.4,0.4]};
ExpNames = {'CD1Cage-Expo','C57Cage-Expo','C57Cage-CD1wasHere','C57Cage-CD1neverHere','Ctrl'};

%% With average of OB freq
Temp = load('SDS_Data_CompUmaze_VOld.mat');
for dirnum  = 1:length(GroupNames)
    for mouse_num = 1:size(Data.(GroupNames{dirnum}).AllSpec_Lo,1)

Data.(GroupNames{dirnum}).Params_SVM(mouse_num,1) = nanmean(Data.(GroupNames{dirnum}).BreathFreq{mouse_num});
    end
end

% All mice not paired
figure
subplot(141)
MakeSpreadAndBoxPlot2_SB({Data.CD1_Exp.Params_SVM(:,1),Data.C57_Exp.Params_SVM(:,1),Data.C57_Sleep.Params_SVM(:,1),Data.CD1_Sleep.Params_SVM(:,1),Data.Ctrl_Sleep.Params_SVM(:,1)},Cols,[1:5],...
    ExpNames,'showsigstar','all','paired',0)
ylim([0 8])
ylabel('mean OB freq')
makepretty
title('all mice')

% Only mie that froze in both cases - paired statistics
matchedmice = 1;
for mm = 1 :length(Data.CD1_Exp.MouseId)
    
    matched_C57_mouse = find(Data.C57_Exp.MouseId==Data.CD1_Exp.MouseId(mm),1,'last');
    if not(isempty(matched_C57_mouse))
        Freq_CD1_matched(matchedmice) = Data.CD1_Exp.Params_SVM(mm,1);
        Freq_C57_matched(matchedmice) = Data.C57_Exp.Params_SVM(matched_C57_mouse,1);
        mouseId_matched(matchedmice) = Data.CD1_Exp.MouseId(mm);
        
        matchedmice = matchedmice+1;
    end
end

subplot(142)
MakeSpreadAndBoxPlot2_SB({Freq_CD1_matched,Freq_C57_matched},Cols(1:2),[1:2],...
    ExpNames,'showsigstar','all','paired',1)
ylim([0 8])
ylabel('mean OB freq')
makepretty
title('paired mice')

% Check if its a duration effect
subplot(143)
MakeSpreadAndBoxPlot2_SB({Data.CD1_Exp.Params_SVM(Data.CD1_Exp.FzTime<30,1),Data.C57_Exp.Params_SVM(Data.C57_Exp.FzTime<30,1)},Cols(1:2),[1:2],...
    ExpNames,'showsigstar','all','paired',0)
ylim([0 8])
ylabel('mean OB freq')
makepretty
title(' freezing less than 30s')

subplot(144)
plot(Data.CD1_Exp.FzTime,Data.CD1_Exp.Params_SVM(:,1),'.','color',Cols{1})
hold on
plot(Data.C57_Exp.FzTime,Data.C57_Exp.Params_SVM(:,1),'.','color',Cols{2})
% plot(FzTime_C57_HC,Params_SVM_C57_HC(:,1),'.','color',Cols{3})
% plot(FzTime_CD1_HC,Params_SVM_CD1_HC(:,1),'.','color',Cols{4})
ylim([0 7])
legend(ExpNames(1:2))
makepretty
xlabel('Freezing duration (s)')
ylabel('Mean OB freq')

%% Look at mice whre the freezing is happening at the same point in time - can't the mice don't freeze!
figure
matchedmice = find(cellfun(@length,MatchSess.CD1_Sess)==2);
CD1_once = unique(Data.CD1_Exp.MouseId);
MouseId = CD1_once(matchedmice); 

for mm = 1:length(MouseId)
    SOI = find(Data.CD1_Exp.MouseId==MouseId(1),1,'last');
    Freq_CD1_2ndsess(mm) = Data.CD1_Exp.Params_SVM(SOI,1);
    Data.CD1_Exp.FzTime(SOI)
end

MakeSpreadAndBoxPlot2_SB({Freq_CD1_2ndsess,Data.C57_Exp.Params_SVM(:,1)},Cols(1:2),[1:2],...
    ExpNames(1:2),'showsigstar','all','paired',0)
ylim([0 8])
ylabel('mean OB freq')
makepretty
title('all mice')

%% figure for paper
figure
MakeSpreadAndBoxPlot2_SB({Data.CD1_Exp.Params_SVM(:,1),Data.C57_Exp.Params_SVM(:,1)},Cols(1:2),[1:2],...
    ExpNames(1:2),'showsigstar','all','paired',0)
ylabel('mean OB freq')
makepretty
title('all mice')

figure
MakeSpreadAndBoxPlot2_SB({Data.CD1_Exp.FzTime(Data.CD1_Exp.FzTime>0),Data.C57_Exp.FzTime(Data.C57_Exp.FzTime>0)},Cols(1:2),[1:2],...
    ExpNames(1:2),'showsigstar','all','paired',0)
ylabel('time spent freezing')
makepretty
title('all mice')

figure
subplot(121)
pie([nanmean(Data.C57_Exp.FzTime>0),nanmean(Data.CD1_Exp.FzTime==0)])
subplot(122)
pie([nanmean(Data.C57_Exp.FzTime>0),nanmean(Data.C57_Exp.FzTime==0)])



%% Focus on the freezing in homecage before sleep
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Data.C57_Sleep.FzProp,Data.CD1_Sleep.FzProp,Data.Ctrl_Sleep.FzProp},Cols,[1:3],...
    ExpNames([3,4,5]),'showsigstar','all','paired',0)
ylabel('prop freezing time before sleep')

subplot(132)
MakeSpreadAndBoxPlot2_SB({Data.C57_Sleep.FzTime,Data.CD1_Sleep.FzTime,Data.Ctrl_Sleep.FzTime},Cols,[1:3],...
    ExpNames([3,4,5]),'showsigstar','all','paired',0)
ylabel('total freezing time before sleep (s)')

subplot(133)
MakeSpreadAndBoxPlot2_SB({Data.C57_Sleep.FzTime./Data.C57_Sleep.FzProp,Data.CD1_Sleep.FzTime./Data.CD1_Sleep.FzProp,Data.Ctrl_Sleep.FzTime./Data.Ctrl_Sleep.FzProp},Cols,[1:3],...
    ExpNames([3,4,5]),'showsigstar','all','paired',0)
ylabel('sleep latency(s)')

%% Look at spectra
figure
subplot(121)
for i =1:5
    plot([-5:-1],[-5:-1],'color',Cols{i},'linewidth',5)
    hold on
end
fLow = [1+0.076:0.076:20-0.076];
g= shadedErrorBar(fLow,nanmean(Data.CD1_Exp.AllSpec_Lo),stdError(Data.CD1_Exp.AllSpec_Lo));
g.patch.FaceColor = Cols{1};
hold on
g= shadedErrorBar(fLow,nanmean(Data.C57_Exp.AllSpec_Lo),stdError(Data.C57_Exp.AllSpec_Lo));
g.patch.FaceColor = Cols{2};
g= shadedErrorBar(fLow,nanmean(Data.C57_Sleep.AllSpec_Lo),stdError(Data.C57_Sleep.AllSpec_Lo));
g.patch.FaceColor = Cols{3};
g= shadedErrorBar(fLow,nanmean(Data.CD1_Sleep.AllSpec_Lo),stdError(Data.CD1_Sleep.AllSpec_Lo));
g.patch.FaceColor = Cols{4};
g= shadedErrorBar(fLow,nanmean(Data.Ctrl_Sleep.AllSpec_Lo),stdError(Data.Ctrl_Sleep.AllSpec_Lo));
g.patch.FaceColor = Cols{5};
xlim([0 20])
legend(ExpNames)
xlabel('Frequency (Hz)')
ylabel('Power (AU)')
makepretty

subplot(122)
for i =1:2
    plot([-5:-1],[-5:-1],'color',Cols{i},'linewidth',5)
    hold on
end
plot(fLow,(Data.CD1_Exp.AllSpec_Lo),'color', Cols{1})
hold on
plot(fLow,(Data.C57_Exp.AllSpec_Lo),'color', Cols{2})
makepretty
xlim([0 20])
legend(ExpNames(1:2))
xlabel('Frequency (Hz)')
ylabel('Power (AU)')


%% Proportionn of time above and below 4Hz
Sess = fieldnames(Data);
Lim =  4.5,
for ss  = 1:length(Sess)
    for mm = 1:length(Data.(Sess{ss}).BreathFreq)
        ProSafeLike{ss}(mm) = nanmean(Data.(Sess{ss}).BreathFreq{mm}<Lim);
        if isnan(Data.(Sess{ss}).BreathFreq{mm})
            ProSafeLike{ss}(mm) = NaN;
        end
    end
end

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB(ProSafeLike,Cols,[1:5],...
    ExpNames,'showsigstar','sig','paired',0)
ylabel('proportionn safe likke')
makepretty
title('all mice')

% Only mie that froze in both cases - paired statistics
matchedmice = 1;
clear PropSafe_CD1_matched PropSafe_C57_matched
for mm = 1 :length(Data.CD1_Exp.MouseId)
    
    matched_C57_mouse = find(Data.C57_Exp.MouseId==Data.CD1_Exp.MouseId(mm),1,'last');
    if not(isempty(matched_C57_mouse)) & not(isnan(sum(Data.CD1_Exp.BreathFreq{mm}))) & not(isnan(sum(Data.C57_Exp.BreathFreq{matched_C57_mouse})))
        PropSafe_CD1_matched(matchedmice) = nanmean(Data.CD1_Exp.BreathFreq{mm}<Lim);
        PropSafe_C57_matched(matchedmice) = nanmean(Data.C57_Exp.BreathFreq{matched_C57_mouse}<Lim);
        mouseId_matched(matchedmice) = Data.CD1_Exp.MouseId(mm);
        
        matchedmice = matchedmice+1;
    end
end

subplot(132)
MakeSpreadAndBoxPlot2_SB({PropSafe_CD1_matched,PropSafe_C57_matched},Cols(1:2),[1:2],...
    ExpNames,'showsigstar','all','paired',1)
ylim([0 1.5])
ylabel('prop safe like')
makepretty
title('paired mice')

subplot(133)
for ss  = 1:2%length(Sess)
    for mm = 1:length(Data.(Sess{ss}).BreathFreq)
        [Y,X] = hist(Data.(Sess{ss}).BreathFreq{mm},[0.5:0.5:15]);
        Y = Y/sum(Y);
        HistBreathing{ss}(mm,:) = Y;
        if isnan(Data.(Sess{ss}).BreathFreq{mm})
            HistBreathing{ss}(mm,:) = nan(1,length([0.5:0.5:15]));
        end
    end
    stairs([0.5:0.5:15],nanmean(HistBreathing{ss}),'color',Cols{ss})
    hold  on
end
xlim([0 10 ])
xlabel('Frequency (Hz)')
ylabel('Proportion of time')
legend(ExpNames(1:2))
makepretty

% Correlations
matchedmice = 1;
clear InVar XVal R_REM P_REM R_Sl P_Sl
for mm = 1 :length(Data.CD1_Exp.MouseId)
    
    matched_C57_mouse = find(Data.C57_Exp.MouseId==Data.CD1_Exp.MouseId(mm),1,'last');
    matched_Sleep_mouse = find(Data.C57_Sleep.MouseId==Data.CD1_Exp.MouseId(mm),1,'first');
    
    
    if not(isempty(matched_C57_mouse)) & not(isempty(matched_Sleep_mouse))
        date_C57 = eval(Data.CD1_Exp.FileLoc{mm}(33:40));
        date_sleep = eval(Data.C57_Sleep.FileLoc{matched_Sleep_mouse}(33:40));
        if date_C57 == date_sleep
            %             disp(Data.CD1_Exp.FileLoc{mm})
            %             disp(Data.C57_Exp.FileLoc{matched_C57_mouse})
            %             disp(Data.C57_Sleep.FileLoc{matched_Sleep_mouse})
            InVar.TimeFzTot(matchedmice) = Data.CD1_Exp.FzTime(mm) +  Data.C57_Exp.FzTime(matched_C57_mouse) +  Data.C57_Sleep.FzTime(matched_Sleep_mouse);
            InVar.TimeFzSensExp(matchedmice) = Data.CD1_Exp.FzTime(mm) +  Data.C57_Exp.FzTime(matched_C57_mouse);
            InVar.TimeFzSleep(matchedmice) = Data.C57_Sleep.FzTime(matched_Sleep_mouse);
            
            InVar.TimeFzSfTypeTot(matchedmice) = nansum(Data.CD1_Exp.BreathFreq{mm}<Lim) +  nansum(Data.C57_Exp.BreathFreq{matched_C57_mouse}<Lim)+  nansum(Data.C57_Sleep.BreathFreq{matched_Sleep_mouse}<Lim);
            InVar.TimeFzSfTypeSensExp(matchedmice) = nansum(Data.CD1_Exp.BreathFreq{mm}<Lim) +  nansum(Data.C57_Exp.BreathFreq{matched_C57_mouse}<Lim);
            InVar.TimeFzSfTypeSleep(matchedmice) = nansum(Data.C57_Sleep.BreathFreq{matched_Sleep_mouse}<Lim);
            
            % Deal with NaNs
            if isnan(Data.CD1_Exp.BreathFreq{mm})
                CD1_Val = NaN;
            else
                CD1_Val = nanmean(Data.CD1_Exp.BreathFreq{mm}<Lim);
            end
            if isnan(Data.C57_Exp.BreathFreq{matched_C57_mouse})
                C57_Val = NaN;
            else
                C57_Val = nanmean(Data.C57_Exp.BreathFreq{matched_C57_mouse}<Lim);
            end
            if isnan(Data.C57_Sleep.BreathFreq{matched_Sleep_mouse})
                Sleep_Val = NaN;
            else
                Sleep_Val = nanmean(Data.C57_Sleep.BreathFreq{matched_Sleep_mouse}<Lim);
            end
            
            InVar.PropFzSfTypeTot(matchedmice) = nanmean([CD1_Val,C57_Val,Sleep_Val]);
            InVar.PropFzSfTypeSensExp(matchedmice) = nanmean([CD1_Val,C57_Val]);
            InVar.PropFzSfTypeSleep(matchedmice) = (Sleep_Val);
            
              % Deal with NaNs
            if isnan(Data.CD1_Exp.BreathFreq{mm})
                CD1_Val = NaN;
            else
                CD1_Val = nanmean(Data.CD1_Exp.BreathFreq{mm});
            end
            if isnan(Data.C57_Exp.BreathFreq{matched_C57_mouse})
                C57_Val = NaN;
            else
                C57_Val = nanmean(Data.C57_Exp.BreathFreq{matched_C57_mouse});
            end
            if isnan(Data.C57_Sleep.BreathFreq{matched_Sleep_mouse})
                Sleep_Val = NaN;
            else
                Sleep_Val = nanmean(Data.C57_Sleep.BreathFreq{matched_Sleep_mouse});
            end
            
            InVar.MnBreathFreqTot(matchedmice) = nanmean([CD1_Val,C57_Val,Sleep_Val]);
            InVar.MnBreathFreqSensExp(matchedmice) = nanmean([CD1_Val,C57_Val]);
            InVar.MnBreathFreqSleep(matchedmice) = (Sleep_Val);
            
            
%             InVar.MnBreathFreqTot(matchedmice) =nanmean([Data.CD1_Exp.Params_SVM(mm,1),Data.C57_Exp.Params_SVM(matched_C57_mouse,1),Data.C57_Sleep.Params_SVM(matched_Sleep_mouse,1)]);
%             InVar.MnBreathSensExp(matchedmice) =nanmean([Data.CD1_Exp.Params_SVM(mm,1),Data.C57_Exp.Params_SVM(matched_C57_mouse,1)]);
%             InVar.MnBreathFreqSleep(matchedmice) = Data.C57_Sleep.Params_SVM(matched_Sleep_mouse,1);
            
            REMProp(matchedmice) = Data.C57_Sleep.REMProp(matched_Sleep_mouse);
            SleepProp(matchedmice) = Data.C57_Sleep.SleepProp(matched_Sleep_mouse);
            
            matchedmice = matchedmice+1;
        end
    end
end


allvar = fieldnames(InVar);
for v = 1:length(allvar)
    [R_REM(v),P_REM(v)] = corr(InVar.(allvar{v})',REMProp','rows','complete','type','Spearman');
    [R_Sl(v),P_Sl(v)] = corr(InVar.(allvar{v})',SleepProp','rows','complete','type','Spearman');
    Dat(v,:) = InVar.(allvar{v});
end

figure
subplot(211)
for ii = 1:length(R_REM)
    bar(ii+floor((ii-1)/3),R_REM(ii),'FaceColor',[0.6 0.6 0.6]), hold on
    XVal(ii) = ii+floor((ii-1)/3);

      if P_REM(ii)<0.01
        text(XVal(ii),R_REM(ii)*1.5,'**','FontSize',20)
    elseif  P_REM(ii)<0.05
                text(XVal(ii),R_REM(ii)*1.5,'*','FontSize',20)
      end
    
end
ylim([-1.5 1.5])
makepretty
set(gca,'XTick',XVal,'XTickLabel',allvar)
ylabel('R')
title('Correlation with REM')

subplot(212)
for ii = 1:length(R_Sl)
    bar(ii+floor((ii-1)/3),R_Sl(ii),'FaceColor',[0.6 0.6 0.6]), hold on
    XVal(ii) = ii+floor((ii-1)/3);
    if P_Sl(ii)<0.01
        text(XVal(ii),R_Sl(ii)*1.5,'**','FontSize',20)
    elseif  P_Sl(ii)<0.05
                text(XVal(ii),R_Sl(ii)*1.5,'*','FontSize',20)
    end
end
ylim([-1.5 1.5])
makepretty
ylabel('R')
title('Correlation with Sleep')
set(gca,'XTick',XVal,'XTickLabel',allvar)

figure
subplot(221)
plot(InVar.PropFzSfTypeSensExp,SleepProp,'.')
hold on
makepretty
[R,P] = corr(SleepProp',InVar.PropFzSfTypeSensExp','rows','complete','type','Spearman');
ylabel('Sleep/Total')
xlabel('Prop Fz Sf Type during Sesne Exp')
title(['R=' num2str(R) ' P=' num2str(P)])

subplot(222)
plot(InVar.PropFzSfTypeSleep,SleepProp,'.')
hold on
makepretty
[R,P] = corr(SleepProp',InVar.PropFzSfTypeSleep','rows','complete','type','Spearman');
ylabel('Sleep/Total')
xlabel('Prop Fz Sf Type during Sleep session')
title(['R=' num2str(R) ' P=' num2str(P)])


subplot(223)
plot(InVar.PropFzSfTypeSensExp,REMProp,'.')
hold on
makepretty
[R,P] = corr(REMProp',InVar.PropFzSfTypeSensExp','rows','complete','type','Spearman');
ylabel('REM/Sleep')
xlabel('Prop Fz Sf Type during Sesne Exp')
title(['R=' num2str(R) ' P=' num2str(P)])

subplot(224)
plot(InVar.PropFzSfTypeSleep,REMProp,'.')
hold on
makepretty
[R,P] = corr(REMProp',InVar.PropFzSfTypeSleep','rows','complete','type','Spearman');
ylabel('REM/Sleep')
xlabel('Prop Fz Sf Type during Sleep session')
title(['R=' num2str(R) ' P=' num2str(P)])


figure
plot(SleepProp,REMProp,'.')
hold on
makepretty
[R,P] = corr(SleepProp',REMProp','rows','complete','type','Spearman');
xlabel('Sleep/Total')
ylabel('REM/Sleep')
title(['R=' num2str(R) ' P=' num2str(P)])



%%  Correelate witth sleep



% 
% %% data corrections
% Fields = fieldnames(CD1_CD1);
% for ff = 1:length(Fields)
%     plot([CD1_CD1.(Fields{ff})])
% end
% 
% 
% 
% %%%%
% clear SmoothGamma LFP channel
% load('ChannelsToAnalyse/Bulb_deep.mat')
% load(['LFPData/LFP',num2str(channel),'.mat'])
% 
% FilGamma=FilterLFP(LFP,[50 70],1024);
% HilGamma=hilbert(Data(FilGamma));
% H=abs(HilGamma);
% tot_ghi=Restrict(tsd(Range(LFP),H),Epoch);
% 
% % smooth gamma power
% SmoothGamma=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
% save('StateEpochSB.mat','SmoothGamma')
% 
% 
% 
% 
% %%%
% mouse_num = 1;
% clear CD1_CD1
% 
% 
% mouse_num = 1;
% for dd = 1:length(Dir_CD1_C57cage)
%     for ddd = 1:length(Dir_CD1_C57cage{dd}.path)
%         cd(Dir_CD1_C57cage{dd}.path{ddd}{1});
%         
%         if not(exist('B_High_Spectrum.mat'))
%             clear SmoothGamma LFP channel
%             load('ChannelsToAnalyse/Bulb_deep.mat')
%             load(['LFPData/LFP',num2str(channel),'.mat'])
%             
%             %             FilGamma=FilterLFP(LFP,[50 70],1024);
%             %             HilGamma=hilbert(Data(FilGamma));
%             %             H=abs(HilGamma);
%             %
%             %             % smooth gamma power
%             %             SmoothGamma=tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
%             %             save('StateEpochSB.mat','SmoothGamma')
%             HighSpectrum([cd filesep],chB,'B');
%             
%             
%         end
%     end
% end
% 
% 
% mm=20 --> weird
% 
% mm=13 --> weird