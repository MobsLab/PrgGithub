
%% sessions
SessNames={'Calibration_Eyeshock'};

Dir=PathForExperimentsEmbReact(SessNames{1});

for d=1:length(Dir.path)-3
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end

for mouse =1:length(Mouse)
    CalibSess.(Mouse_names{mouse}) = Dir.path{mouse};
end


%% data
clear OB_Sp_Fz FzDur Respi_Fz
for mouse=1:length(Mouse)
    for sess=1:length(CalibSess.(Mouse_names{mouse}))
        try
            load([CalibSess.(Mouse_names{mouse}){sess} 'ExpeInfo.mat'])
            int = ExpeInfo.StimulationInt*2+1;
            clear Behav Sp_tsd Spectro FreezeEpoch
            load([CalibSess.(Mouse_names{mouse}){sess} 'B_Low_Spectrum.mat'])
            Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
            load([CalibSess.(Mouse_names{mouse}){sess} 'behavResources.mat'], 'FreezeEpoch')
            
            FreezeEpoch = and(FreezeEpoch , intervalSet(50e4 , 130e4));
            
            OB_Sp_Fz(mouse,int,:) = nanmean(Data(Restrict(Sp_tsd , FreezeEpoch)));
            if sum(DurationEpoch(FreezeEpoch))/1e4~=0
%                 FzDur(mouse,int) = sum(DurationEpoch(Behav.FreezeAccEpoch))/1e4;
                FzDur(mouse,int) = sum(DurationEpoch(FreezeEpoch))/1e4;
            else
                FzDur(mouse,int) = .1;
            end
            [a,b] = max(squeeze(OB_Sp_Fz(mouse,int,27:end)));
            if b~=1
                Respi_Fz(mouse,int) = Spectro{3}(b+26);
            else
                Respi_Fz(mouse,int) = NaN;
            end
        catch
            Respi_Fz(mouse,int) = NaN;
            FzDur(mouse,int) = NaN;
        end
    end
    for sess=length(CalibSess.(Mouse_names{mouse}))+1:11
        OB_Sp_Fz(mouse,sess,:) = NaN;
        FzDur(mouse,sess) = NaN;
        Respi_Fz(mouse,sess) = NaN;
    end
    disp(mouse)
end
FzDur(FzDur==0) = NaN;
OB_Sp_Fz(OB_Sp_Fz==0) = NaN;
Respi_Fz(Respi_Fz==0) = NaN;

FzDur(28,11) = NaN;
Respi_Fz(49,:) = NaN;
FzDur(:,1)=NaN;
% for mouse=1:length(Mouse)
%     try
%         FzDur_interp(mouse,:) = interp1(linspace(0,1,sum(~isnan(FzDur(mouse,:)))) , FzDur(mouse,1:sum(~isnan(FzDur(mouse,:)))) , linspace(0,1,5));
%         Respi_Fz_interp(mouse,:) = interp1(linspace(0,1,sum(~isnan(Respi_Fz(mouse,:)))) , Respi_Fz(mouse,1:sum(~isnan(Respi_Fz(mouse,:)))) , linspace(0,1,5));
%     end
% end
% FzDur_interp(sum((FzDur_interp==0)')==5,:)=NaN;
% Respi_Fz_interp(Respi_Fz_interp==0)=NaN;


%% figures
figure
subplot(121)
Data_to_use = movmean(FzDur',2,'omitnan')'./80;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([0:.5:9] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
xlabel('increasing voltage (a.u.)'), ylabel('Fz duration (prop)'), xlim([0 5.5])
makepretty

subplot(122)
Data_to_use = movmean(Respi_Fz',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([0:.5:9] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
xlabel('increasing voltage (a.u.)'), ylabel('Breathing (Hz)')
makepretty
xlim([0 5.5]), ylim([0 7.5])



figure
subplot(121)
Data_to_use = movmean(FzDur(1:38,:)',2,'omitnan')'./80;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([0:.5:9] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
xlabel('increasing voltage (a.u.)'), ylabel('Fz duration (prop)'), xlim([0 4.5])
makepretty

subplot(122)
Data_to_use = movmean(Respi_Fz(1:38,:)',2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([0:.5:9] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
xlabel('increasing voltage (a.u.)'), ylabel('Breathing (Hz)')
makepretty
xlim([0 4.5]), ylim([0 8])



figure
Data_to_use = movmean(FzDur(1:38,:)'./80,2,'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([0:.5:9] , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
xlabel('increasing voltage (a.u.)'), ylabel('Fz duration (prop)'), xlim([0 5.5])
makepretty

Data_to_use = movmean(FzDur(39:80,:)',2,'omitnan')'./80;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([0:.5:9] , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
xlabel('increasing voltage (a.u.)'), ylabel('Fz duration (s)'), xlim([0 5.5])
makepretty

Data_to_use = movmean(FzDur(81:122,:)',2,'omitnan')'./80;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([0:.5:9] , Mean_All_Sp , Conf_Inter ,'-g',1); hold on;
xlabel('increasing voltage (a.u.)'), ylabel('Fz duration (s)'), xlim([0 5.5])
makepretty

ylim([0 .3])
f=get(gca,'Children'); legend([f(12),f(8),f(4)],'SB','BM 1st half PhD','BM 2nd half PhD');



%% tools
figure
for sess=1:10
    subplot(2,5,sess)
    plot(Spectro{3} , squeeze(nanmean(OB_Sp_Fz(:,sess,:))))
end

figure
plot(nanmean(FzDur))





%%
for mouse=1:length(Mouse)
    for sess=1:length(CalibSess.(Mouse_names{mouse}))
        try
            cd(CalibSess.(Mouse_names{mouse}){sess})
            clear channel MovAcctsd NewMovAcctsd FreezeAccEpoch
            if exist('B_Low_Spectrum.mat')~=2
                load('ChannelsToAnalyse/Bulb_deep.mat')
                LowSpectrumSB(pwd,channel,'B')
            end
            if exist('behavResources_SB.mat')~=2
                load('behavResources.mat')
                if mouse<41
                    th_immob_Acc=1e7;
                else
                    th_immob_Acc=1.7e7;
                end
                NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),30));
                FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
                FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
                FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,2*1e4);
                Behav.FreezeAccEpoch = FreezeAccEpoch;
                save('behavResources_SB.mat','Behav')
            end
        end
        disp([mouse sess])
    end
end


