

clear all, close all
Dir = PathForExperimentsERC('UMazePAG');
Mouse = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
Session_type = {'Habituation','sleep_pre','Fear'};

mouse = 1;
for ff = 1:length(Dir.name)
    if ismember(eval(Dir.name{ff}(6:end)),Mouse)
        cd(Dir.path{ff}{1})
        disp(Dir.path{ff}{1})
        
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        clear MovAcctsd tRipples Wake SessionEpoch ShockZoneEpoch SafeZoneEpoch
        
        load('behavResources.mat', 'MovAcctsd', 'SessionEpoch', 'LinearDist')
        D = Data(MovAcctsd); D(1)=1;
        NewMovAcctsd = tsd(Range(MovAcctsd) , runmean_BM(log10(D),30));
        ShockZoneEpoch = thresholdIntervals(LinearDist , .3,'Direction','Below');
        SafeZoneEpoch = thresholdIntervals(LinearDist , .5,'Direction','Above');
        
        
        load('SWR.mat')
        Ripples_Extended.(Mouse_names{mouse}) = tsd(ripples(:,2)*1e4 , ripples);
        RippleShape_tsd = tsd(ripples(:,2)*1e4 ,T);
        try
            load('SleepScoring_OBGamma.mat', 'Wake' , 'Sleep')
        catch
            load('SleepScoring_Accelero.mat', 'Wake' , 'Sleep')
        end
        load('SleepScoring_Accelero.mat', 'TotalNoiseEpoch')
        
%         if or(mouse<7 , mouse>9)
%             load('H_VHigh_Spectrum.mat')
%             HPC_VHigh_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
%             %             HPC_VHigh_Sptsd = CleanSpectro(HPC_VHigh_Sptsd , Spectro{3} , 8);
%         else
%             HPC_VHigh_Sptsd = tsd([],[]);
%         end
        
        try
            ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Ext;
        catch
            try
                ExtEpoch.(Mouse_names{mouse}) =  SessionEpoch.Extinction;
            catch
                try
                    ExtEpoch.(Mouse_names{mouse}) = SessionEpoch.ExploAfter;
                catch
                    ExtEpoch.(Mouse_names{mouse}) = intervalSet([],[]);
                end
            end
        end
        CondEpoch.(Mouse_names{mouse}) =  or(SessionEpoch.Cond1,or(SessionEpoch.Cond2,or(SessionEpoch.Cond3,SessionEpoch.Cond4)));
        FearEpoch.(Mouse_names{mouse}) =  or(CondEpoch.(Mouse_names{mouse}) , ExtEpoch.(Mouse_names{mouse}));
        
        try
            HabEpoch.(Mouse_names{mouse}) = or(SessionEpoch.Hab1 , SessionEpoch.Hab2);
        catch
            HabEpoch.(Mouse_names{mouse}) = SessionEpoch.Hab;
        end
        
%         Sleep1 = dropShortIntervals(and(Sleep , SessionEpoch.PreSleep),30e4);
%         Sleep_Beginning = Start(Sleep1); Sleep_End = Stop(Sleep1);
%         Wake_Before_Sleep_Epoch = intervalSet(0 , Sleep_Beginning(1));
%         Wake_After_Sleep_Epoch = intervalSet(Sleep_Beginning(1) , Sleep_End(end));
        
        for sess=1:3
            if sess==1
                Epoch_to_use = HabEpoch.(Mouse_names{mouse}) - TotalNoiseEpoch;
            elseif sess==2
                Epoch_to_use = SessionEpoch.PreSleep - TotalNoiseEpoch;
            elseif sess==3
                Epoch_to_use = FearEpoch.(Mouse_names{mouse}) - TotalNoiseEpoch;
            end
            
            ControlDuration(mouse,sess) = sum(DurationEpoch(and(Epoch_to_use , Wake)));
            
            clear D
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Restrict(NewMovAcctsd , Epoch_to_use), log10(1.7e7) ,'Direction','Below');
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),2*1E4);
            FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Wake);
            FreezeShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZoneEpoch);
            FreezeSafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZoneEpoch);

            D_Sleep = Data(Restrict(Ripples_Extended.(Mouse_names{mouse}) ,Sleep));
            D = Data(Restrict(Ripples_Extended.(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            D_shock = Data(Restrict(Ripples_Extended.(Mouse_names{mouse}) , FreezeShockEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            D_safe = Data(Restrict(Ripples_Extended.(Mouse_names{mouse}) , FreezeSafeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            
            h=histogram(D(:,4),'BinLimits',[20 180],'NumBins',100);
            HistData_Dur{sess}(mouse,:) = h.Values./sum(h.Values);
            h=histogram(D_shock(:,4),'BinLimits',[20 180],'NumBins',100);
            HistData_DurShock{sess}(mouse,:) = h.Values./sum(h.Values);
            h=histogram(D_safe(:,4),'BinLimits',[20 180],'NumBins',100);
            HistData_DurSafe{sess}(mouse,:) = h.Values./sum(h.Values);
            
            h=histogram(D_Sleep(:,5),'BinLimits',[119 250],'NumBins',100);
            HistData_FreqSleep{sess}(mouse,:) = h.Values./sum(h.Values);
            h=histogram(D(:,5),'BinLimits',[119 250],'NumBins',100);
            HistData_Freq{sess}(mouse,:) = h.Values./sum(h.Values);
            h=histogram(D_shock(:,5),'BinLimits',[119 250],'NumBins',100);
            HistData_FreqShock{sess}(mouse,:) = h.Values./sum(h.Values);
            h=histogram(D_safe(:,5),'BinLimits',[119 250],'NumBins',100);
            HistData_FreqSafe{sess}(mouse,:) = h.Values./sum(h.Values);
            
            h=histogram(D(:,6),'BinLimits',[min(ripples(:,6)) max(ripples(:,6))],'NumBins',100);
            HistData_Amp{sess}(mouse,:) = h.Values./sum(h.Values);
            h=histogram(D_shock(:,6),'BinLimits',[min(ripples(:,6)) max(ripples(:,6))],'NumBins',100);
            HistData_AmpShock{sess}(mouse,:) = h.Values./sum(h.Values);
            h=histogram(D_safe(:,6),'BinLimits',[min(ripples(:,6)) max(ripples(:,6))],'NumBins',100);
            HistData_AmpSafe{sess}(mouse,:) = h.Values./sum(h.Values);
            
            % Get mean ripple shape
            ripple_shape_sleep{sess}(mouse,:) = nanmean(Data(Restrict(RippleShape_tsd,Sleep)))
            ripple_shape_qw{sess}(mouse,:) = nanmean(Data(Restrict(RippleShape_tsd,FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            ripple_shape_shock{sess}(mouse,:) = nanmean(Data(Restrict(RippleShape_tsd,FreezeShockEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
            ripple_shape_safe{sess}(mouse,:) = nanmean(Data(Restrict(RippleShape_tsd,FreezeSafeEpoch.(Session_type{sess}).(Mouse_names{mouse}))));

            FreezeDur{sess}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/ControlDuration(mouse,sess); 
            
            l = linspace(6,8.5,11);
            for thr=1:10
                
                FreezeEpoch1.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Restrict(NewMovAcctsd , Epoch_to_use), l(thr+1) ,'Direction','Below');
                FreezeEpoch2.(Session_type{sess}).(Mouse_names{mouse}) = thresholdIntervals(Restrict(NewMovAcctsd , Epoch_to_use),l(thr),'Direction','Above');
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch1.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch2.(Session_type{sess}).(Mouse_names{mouse}));
%                 FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = mergeCloseIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),0.3*1E4);
%                 FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = dropShortIntervals(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),2*1E4);
                FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Wake);
                
                FreezeAll_Prop{thr,sess}(mouse) = sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/ControlDuration(mouse,sess);
                RipplesOccurence{thr,sess}(mouse) = length(Restrict(tRipples , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))./(sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4);
                RippleInfoTemp = Data(Restrict(Ripples_Extended.(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
                if not(isempty(RippleInfoTemp))
                    RipplesFrequency{thr,sess}(mouse) = nanmean(RippleInfoTemp(:,5));
                else
                    RipplesFrequency{thr,sess}(mouse) = NaN;
                    
                end
                try, VHigh_Sp{thr,sess}(mouse,1:94) = nanmean(Data(Restrict(HPC_VHigh_Sptsd , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))); end
            end
        end
        mouse=mouse+1;
    end
end


for sess=1:3
    for i=1:10
        FreezeProp.(Session_type{sess}){i} = FreezeAll_Prop{i,sess};
        FreezeProp.(Session_type{sess}){i}(FreezeProp.(Session_type{sess}){i}==0) = NaN;
        TimeSpentMotion{sess}(i,:) = FreezeProp.(Session_type{sess}){i};

        RipOccur.(Session_type{sess}){i} = RipplesOccurence{i,sess};
        RipOccur.(Session_type{sess}){i}(RipOccur.(Session_type{sess}){i}==0) = NaN;
        
        RipTot.(Session_type{sess}){i} = FreezeProp.(Session_type{sess}){i}.*RipOccur.(Session_type{sess}){i};
        RipNumb.(Session_type{sess}){i} = (RipTot.(Session_type{sess}){i}.*(ControlDuration(:,sess)'))./1e4;
        
        RipFreq.(Session_type{sess}){i} = RipplesFrequency{i,sess};
        
        Cols{i} = [1-i/10 .5 i/10];
        Legends{i} = ['thr ' num2str(i)];
    end
        RipNumbTot{sess} = nansum([RipNumb.(Session_type{sess}){1} ; RipNumb.(Session_type{sess}){2} ; RipNumb.(Session_type{sess}){3} ;...
            RipNumb.(Session_type{sess}){4} ; RipNumb.(Session_type{sess}){5} ; RipNumb.(Session_type{sess}){6} ; RipNumb.(Session_type{sess}){7}])./(ControlDuration(:,sess)'./3600e4);
end
X = 1:10;


figure
for sess=1:3
    subplot(3,4,1+(sess-1)*4)
    MakeSpreadAndBoxPlot3_SB(FreezeProp.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    ylabel('proportion of time under threshold')
    ylim([0 1])
    
    subplot(3,4,2+(sess-1)*4)
    MakeSpreadAndBoxPlot3_SB(RipOccur.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    ylabel('rip occurence')
    ylim([0 1.4])
    
    subplot(3,4,3+(sess-1)*4)
    MakeSpreadAndBoxPlot3_SB(RipFreq.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    ylabel('rip freq')
    ylim([0 .35])
    
    subplot(3,4,4+(sess-1)*4)
    MakeSpreadAndBoxPlot3_SB(RipNumb.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    ylabel('rip number')
%     ylim([0 .35])
end



figure
figure, [h , MaxPowerValues , Freq_Max] = Plot_MeanSpectrumForMice_BM(Spectro{3}.*VHigh_Sp{2,3} , 'threshold' , 42); close
for sess=1:3
    for i=1:10
        
        subplot(3,10,i+(sess-1)*10)
        try, Plot_MeanSpectrumForMice_BM(Spectro{3}.*VHigh_Sp{i,sess}); end
        xlim([10 250]), ylim([0 3])
    end
end


Cols2 = {[],[.3 .3 .3],[.7 .3 .7]};

figure
subplot(131)
for sess=2:3
    Data_to_use = TimeSpentMotion{sess}';
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp=nanmean(Data_to_use);
    h=shadedErrorBar(linspace(0,1,10) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
    color= Cols2{sess}; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
end
xlabel('Motion (a.u.)'), ylabel('time proportion')
f=get(gca,'Children'); legend([f([5 1])],'Awake homecage','Freezing Maze');
makepretty


subplot(163)
MakeSpreadAndBoxPlot3_SB(FreezeDur(2:3),{[.3 .3 .3],[.7 .3 .7]},[1:2],{'Awake homecage','Freezing Maze'},'showpoints',1,'paired',0);
ylabel('immobility proportion')
makepretty_BM2

subplot(164)
MakeSpreadAndBoxPlot3_SB(RipNumbTot(2:3),{[.3 .3 .3],[.7 .3 .7]},[1:2],{'Awake homecage','Freezing Maze'},'showpoints',1,'paired',0);
ylabel('ripples occurence (#/hour)')
makepretty_BM2

subplot(133)



%% Look at ripple frequency

% QW vs freezing
figure
Data_to_use = HistData_Freq{2};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(120,250,100) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = HistData_FreqShock{sess}; Data_to_use(isnan(nanmean(Data_to_use'))) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use); 
% h=shadedErrorBar(linspace(120,250,100) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20) ,'-k',1); hold on;
% color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
plot(linspace(120,250,100) , runmean(Mean_All_Sp,20) ,'Color',[1 .5 .5]); hold on;
Data_to_use = HistData_FreqSafe{sess};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(120,250,100) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

xlabel('ripples frequency'), ylabel('PDF'), xlim([120 250]), ylim([0 .05])
f=get(gca,'Children'); legend([f([6 5 1])],'Quiet wake','Shock','Safe');
makepretty
v=vline(188,'--'); set(v,'Color',[.7 .3 .7]);
v=vline(167,'--'); set(v,'Color',[.3 .3 .3]);

% Sleep vs frezing
figure
Data_to_use = HistData_FreqSleep{1};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(120,250,100) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
color= [.3 .3 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = HistData_FreqShock{sess}; Data_to_use(isnan(nanmean(Data_to_use'))) = NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use); 
% h=shadedErrorBar(linspace(120,250,100) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20) ,'-k',1); hold on;
% color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
plot(linspace(120,250,100) , runmean(Mean_All_Sp,20) ,'Color',[1 .5 .5]); hold on;
Data_to_use = HistData_FreqSafe{sess};
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(120,250,100) , runmean(Mean_All_Sp,10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;

xlabel('ripples frequency'), ylabel('PDF'), xlim([120 250]), ylim([0 .05])
f=get(gca,'Children'); legend([f([6 5 1])],'Sleep','Shock','Safe');
makepretty
v=vline(188,'--'); set(v,'Color',[.7 .3 .7]);
v=vline(167,'--'); set(v,'Color',[.3 .3 .3]);



%% Show that ripple frequency is consistently higher during freezing for all activity levels
figure
%% Points with too little data (and so huge error bars were removed
%% Our usual thresohld is the 5th point, so here the 4ths since we excluded one
clf
sess=2;
errorbar(l(2:8),cellfun(@nanmean,RipFreq.(Session_type{sess})(2:end-2)),cellfun(@stdError,RipFreq.(Session_type{sess})(2:end-2)),'k')
hold on
sess=3;
errorbar(l(2:8),cellfun(@nanmean,RipFreq.(Session_type{sess})(2:end-2)),cellfun(@stdError,RipFreq.(Session_type{sess})(2:end-2)),'b')
line([l(5) l(5)],ylim,'color','k','linestyle',':')
% xlim([-0.1 1.1])
xlabel('Mov threshold')
ylabel('Ripple frequency')
makepretty

%% Show the raw ripples
figure
tps = M(:,1);

    h=shadedErrorBar(tps, nanmean(ripple_shape_sleep{2}) , stdError(ripple_shape_sleep{2}) ,'-k',1); hold on;
        h=shadedErrorBar(tps, nanmean(ripple_shape_qw{2})-2000 , stdError(ripple_shape_qw{2}) ,'-k',1); hold on;
            h=shadedErrorBar(tps, nanmean(ripple_shape_safe{3})-4000 , stdError(ripple_shape_safe{3}) ,'-b',1); hold on;

    