clear all
%% This coed is a simplified version of 
% /home/pinky/Documents/PrgGithub/EmbReact/AnalysesPapier_BagurMaheo/SocielDefeat/AnalyseSocialDefeat_CompareUmaze.m
% to get just the pannels we need for the paper


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
MakeSpreadAndBoxPlot2_SB({Data.CD1_Exp.Params_SVM(:,1),Data.C57_Exp.Params_SVM(:,1)},Cols([1,2]),[1:2],...
    ExpNames([1,2]),'showsigstar','all','paired',0)
ylim([0 8])
ylabel('mean OB freq')
makepretty
title('all mice')

figure
MakeSpreadAndBoxPlot2_SB({Data.CD1_Exp.Params_SVM(:,4),Data.C57_Exp.Params_SVM(:,4)},Cols([1,2]),[1:2],...
    ExpNames([1,2]),'showsigstar','all','paired',0)
ylim([0 1.2])
ylabel('ripples / sec')
makepretty
title('all mice')


% Correlations
Lim = 4.5;
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
            InVar.TimeFzSkTypeSensExp(matchedmice) = nansum(Data.CD1_Exp.BreathFreq{mm}>Lim) +  nansum(Data.C57_Exp.BreathFreq{matched_C57_mouse}>Lim);
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
plot(InVar.PropFzSfTypeSensExp,SleepProp,'.')
hold on
makepretty
[R,P] = corr(SleepProp',InVar.PropFzSfTypeSensExp','rows','complete','type','Spearman');
ylabel('Sleep/Total')
xlabel('Prop Fz Sf Type during Sesne Exp')
title(['R=' num2str(R) ' P=' num2str(P)])



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
