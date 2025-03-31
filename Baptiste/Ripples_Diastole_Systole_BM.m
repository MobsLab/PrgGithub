
clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Mouse=[483 484 485 490 507 508 509 567 569 666 668 669 739 777 849 1170 1171 1189 1391 1392 1393 1394 1224 1225 1226];
Session_type={'Cond'};
States={'All','Shock','Safe'};
sta=[3 5 6];
Moment={'Start','Peak','Stop'};
window_size=.5;

figure
for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            
            % Phase analysis
%             channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'EKG');
%             LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
            
%             FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep_withnoise');
            
%             LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
%             Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
%             RipplesFz.All.(Session_type{sess}).(Mouse_names{mouse}) = Range(Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})));
            
%             clear rip_time rand_time R R2
%             rip_time = RipplesFz.All.(Session_type{sess}).(Mouse_names{mouse});
%             clear R2; R2 = Range(LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse}));
            
%             SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse})=FilterLFP(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}),[8 13],1024);
%             PhaseThetaPre.(Session_type{sess}).(Mouse_names{mouse})=tsd(Range(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse})) , angle(hilbert(Data(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}))))*180/pi+180);
%             PhaseTheta.(Session_type{sess}).(Mouse_names{mouse})=tsd(linspace(0,sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))),length(LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse})))...
%                 , angle(hilbert(Data(Restrict(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))))*180/pi+180);
%             for rip=1:size(rip_time,1)
%                 FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(rip) = sum(DurationEpoch(and(intervalSet(0,rip_time(rip)) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))));
%             end
            
            clear DIFF, DIFF = diff(FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse}));
            DIFF = DIFF(randperm(length(DIFF)));
            rand_time = sort([FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(mouse) FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(2:end)+DIFF]);
            DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}) , ts(FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})));
            DistribPhase_rand.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}) , ts(rand_time));
            
            h=histogram(Data(DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
            if sum(h.Values)>50
                DistribPhase_rip_All.(Session_type{sess})(mouse,:) = h.Values/sum(h.Values);
            end
            DistribPhase_rip_All.(Session_type{sess})(DistribPhase_rip_All.(Session_type{sess})==0)=NaN;
            
            h2=histogram(Data(DistribPhase_rand.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
            if sum(h2.Values)>50
                DistribPhase_rand_All.(Session_type{sess})(mouse,:) = h2.Values/sum(h2.Values);
            end
            DistribPhase_rand_All.(Session_type{sess})(DistribPhase_rand_All.(Session_type{sess})==0)=NaN;
            
            
            % LFP analysis
%             HeartBeat.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartbeat');
%             
%             channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'EKG');
%             LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
%             LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
%             
%             clear channel, channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'rip');
%             LFP_rip.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
%             LFP_rip_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_rip.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
%             
%             clear channel, channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'EMG');
%             LFP_EMG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
%             LFP_EMG_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_EMG.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
%             
%             clear channel, channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'bulb_deep');
%             LFP_bulb.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
%             LFP_bulb_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_bulb.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            
        end
        disp(Mouse_names{mouse})
    end
end

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    clear R; R = Range(HeartBeat.(Session_type{sess}).(Mouse_names{mouse}));
    for rip=1:size(RipplesFz.All.(Session_type{sess}).(Mouse_names{mouse}) ,1) % for each ripples
        % check that only freezing around ripple using SmallEpoch
        SmallEpoch = intervalSet(RipplesFz.All.(Session_type{sess}).(Mouse_names{mouse})(rip)-window_size*1e4 , RipplesFz.All.(Session_type{sess}).(Mouse_names{mouse})(rip)+window_size*1e4);
        if and(DurationEpoch(SmallEpoch)/1e4==1 , ~isempty(Data(Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)))) % studied window is only freezing
            %
            LFP_EKG_FzEp.All(mouse,rip,:) = interp1(linspace(0,1,length(Data(Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)))) , Data(Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)) , linspace(0,1,1000));
            LFP_rip_FzEp.All(mouse,rip,:) = interp1(linspace(0,1,length(Data(Restrict(LFP_rip.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)))) , Data(Restrict(LFP_rip.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)) , linspace(0,1,1000));
%             LFP_bulb_FzEp.All(mouse,rip,:) = interp1(linspace(0,1,length(Data(Restrict(LFP_bulb.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)))) , Data(Restrict(LFP_bulb.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)) , linspace(0,1,1000));
            try, LFP_EMG_FzEp.All(mouse,rip,:) = interp1(linspace(0,1,length(Data(Restrict(LFP_EMG.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)))) , Data(Restrict(LFP_EMG.(Session_type{sess}).(Mouse_names{mouse}) , SmallEpoch)) , linspace(0,1,1000)); end
            %
        end
    end
    LFP_EKG_FzEp.All(LFP_EKG_FzEp.All==0)=NaN;
    LFP_rip_FzEp.All(LFP_rip_FzEp.All==0)=NaN;
    LFP_bulb_FzEp.All(LFP_bulb_FzEp.All==0)=NaN;
    try, LFP_EMG_FzEp.All(LFP_EMG_FzEp.All==0)=NaN; end
    
    disp(Mouse_names{mouse})
end
LFP_EKG_FzAll = nanmean(LFP_EKG_FzEp.All,2);
LFP_rip_FzAll = nanmean(LFP_rip_FzEp.All,2);
LFP_bulb_FzAll = nanmean(LFP_bulb_FzEp.All,2);
LFP_EMG_FzAll = nanmean(LFP_EMG_FzEp.All,2);


I=1:50;
for i=I
    [h,p1(i)]=ttest(DistribPhase_rip_All.Cond(:,i) , DistribPhase_rand_All.Cond(:,i));
    [p2(i), h, stats]=ranksum(DistribPhase_rip_All.Cond(:,i) , DistribPhase_rand_All.Cond(:,i));
    [h,p3(i)]=ttest(DistribPhase_rip_All.Cond(:,i) , ones(25,1)*.02);
end

for mouse=13%:length(Mouse)
    Filt_LFP_High = FilterLFP(LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse}) , [30 200] , 1024);
    for bin=1:50
        SmallEp = and(thresholdIntervals(PhaseThetaPre.(Session_type{sess}).(Mouse_names{mouse}),round((bin-1)*(360/50)),'Direction','Above') , thresholdIntervals(PhaseThetaPre.(Session_type{sess}).(Mouse_names{mouse}),round((bin)*(360/50)),'Direction','Below'));
        EKG_binned.(Session_type{sess}).(Mouse_names{mouse})(bin) = nanmedian(Data(Restrict(Filt_LFP_High , SmallEp)));
    end
    disp(Mouse_names{mouse})
end


   
    
%% figures
% LFP triggered on ripples peak
Cols={[0.8500 0.3250 0.0980],[0.4660 0.6740 0.1880],[0 0.4470 0.7410],[1 1 0]};

figure
Data_to_use = LFP_EKG_FzAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{1}; h.patch.FaceColor=Cols{1}; h.edge(1).Color=Cols{1}; h.edge(2).Color=Cols{1};

Data_to_use = LFP_rip_FzAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{2}; h.patch.FaceColor=Cols{2}; h.edge(1).Color=Cols{2}; h.edge(2).Color=Cols{2};

Data_to_use = LFP_bulb_FzAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{3}; h.patch.FaceColor=Cols{3}; h.edge(1).Color=Cols{3}; h.edge(2).Color=Cols{3};

Data_to_use = LFP_EMG_FzAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{4}; h.patch.FaceColor=Cols{4}; h.edge(1).Color=Cols{4}; h.edge(2).Color=Cols{4};

l=vline(0); set(l,'LineWidth',2)
xlabel('time (s)'), ylabel('amplitude (a.u.)')
f=get(gca,'Children'); l=legend([f(13),f(9),f(5),f(1)],'EKG','rip','Bulb','EMG');
makepretty_BM



% explicative figure for EKG phasing
figure
plot(Range(LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse}),'s') , Data(LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse})))
hold on
plot(Range(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}),'s') , Data(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}))*3)
plot(Range(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}),'s') , Data(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}))*8)
xlim([100 101]), xlabel('time (s)')
legend('LFP EKG','Filtered signal','Phase')

figure
h=histogram(Data(DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
xlabel('phase (deg)'), ylabel('occurence')


% 
figure
subplot(5,1,1:2)
plot(EKG_binned.(Session_type{sess}).(Mouse_names{13}),'k')
makepretty
axis off

subplot(5,1,3:5)
Data_to_use = DistribPhase_rip_All.Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
l=hline(.02); set(l,'LineWidth',2)

Data_to_use = DistribPhase_rand_All.Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
l=hline(.02); set(l,'LineWidth',2)


xlabel('phase (a.u.)'), ylabel('proba (a.u.)')
try, plot(I(p1<.05)/50,.028,'*k'), end
try, plot(I(p2<.05)/50,.029,'*k'), end
try, plot(I(p3<.05)/50,.027,'*r'), end
f=get(gca,'Children'); l=legend([f(13),f(9)],'rip times','rand times');
makepretty_BM


%% using PasePref
for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'EKG');
        LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
        VHigh_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_VHigh');
        
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','fz_epoch_withsleep_withnoise');
        
        LFP_EKG_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        VHigh_Spec_Fz.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(VHigh_Spec.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
    end
end

LFP = tsd(linspace(0,sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}))),length(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}))) , Data(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse})));
R = linspace(0,sum(DurationEpoch(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse})))/1e4 , length(VHigh_Spec_Fz.(Session_type{sess}).(Mouse_names{mouse})));

[P,f,VBinnedPhase] = PrefPhaseSpectrum(LFP , Data(VHigh_Spec_Fz.(Session_type{sess}).(Mouse_names{mouse})) , R , RangeVHigh , [6 15] , 10); 



figure
imagesc([VBinnedPhase VBinnedPhase+360] , f , SmoothDec([P' P'],.5)), axis xy
ylim([100 200])
caxis([30 6e2])
colormap jet









%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Sleep

clear all
GetAllSalineSessions_BM
GetEmbReactMiceFolderList_BM
Mouse=[483 484 485 490 507 508 509 567 569 666 668 669 739 777 849 1170 1171 1189 1391 1392 1393 1394 1224 1225 1226];
Session_type={'(Session_type{sess})'};
States={'All','Shock','Safe'};
sta=[3 5 6];
Moment={'Start','Peak','Stop'};
window_size=.5;

Session_type={'(Session_type{sess})','sleep_post'};
for sess=1:length(Session_type) 
    [OutPutData2.(Session_type{sess}) , Epoch2.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples');
end


clear Mouse_names
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try % are you sure ?
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
        if length(UMazeSleepSess.(Mouse_names{mouse}))==3
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
        else
            try
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
            catch % for 11203... grrr
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            end
        end
    end
end



for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=2:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            
            % Phase analysis
            channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'EKG');
            LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
            
            LFP_EKG_NREM.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,4});
            try
                RipplesNREM.All.(Session_type{sess}).(Mouse_names{mouse}) = Range(Restrict(OutPutData2.(Session_type{sess}).ripples.ts{mouse,4} , Epoch2.(Session_type{sess}){mouse,4}));
            catch
                RipplesNREM.All.(Session_type{sess}).(Mouse_names{mouse}) = ts([]);
            end
            
            clear rip_time rand_time R R2
            rip_time = RipplesNREM.All.(Session_type{sess}).(Mouse_names{mouse});
            clear R2; R2 = Range(LFP_EKG_NREM.(Session_type{sess}).(Mouse_names{mouse}));
            
            SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse})=FilterLFP(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}),[8 13],1024);
            PhaseThetaPre.(Session_type{sess}).(Mouse_names{mouse})=tsd(Range(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse})) , angle(hilbert(Data(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}))))*180/pi+180);
            PhaseTheta.(Session_type{sess}).(Mouse_names{mouse})=tsd(linspace(0,sum(DurationEpoch(Epoch2.(Session_type{sess}){mouse,4})),length(LFP_EKG_NREM.(Session_type{sess}).(Mouse_names{mouse})))...
                , angle(hilbert(Data(Restrict(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,4}))))*180/pi+180);
            for rip=1:size(rip_time,1)
                NREMTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(rip) = sum(DurationEpoch(and(intervalSet(0,rip_time(rip)) , Epoch2.(Session_type{sess}){mouse,4})));
            end
            
            clear DIFF, DIFF = diff(NREMTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse}));
            DIFF = DIFF(randperm(length(DIFF)));
            rand_time = sort([NREMTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(mouse) NREMTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(2:end)+DIFF]);
            DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}) , ts(NREMTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})));
            DistribPhase_rand.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}) , ts(rand_time));
            
            h=histogram(Data(DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
            if sum(h.Values)>50
                DistribPhase_rip_All.(Session_type{sess})(mouse,:) = h.Values/sum(h.Values);
            end
            DistribPhase_rip_All.(Session_type{sess})(DistribPhase_rip_All.(Session_type{sess})==0)=NaN;
            
            h2=histogram(Data(DistribPhase_rand.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
            if sum(h2.Values)>50
                DistribPhase_rand_All.(Session_type{sess})(mouse,:) = h2.Values/sum(h2.Values);
            end
            DistribPhase_rand_All.(Session_type{sess})(DistribPhase_rand_All.(Session_type{sess})==0)=NaN;
            
        end
        disp(Mouse_names{mouse})
    end
end





for mouse=1:length(Mouse)
    try
        Filt_LFP_High = FilterLFP(LFP_EKG_NREM.(Session_type{sess}).(Mouse_names{mouse}) , [30 200] , 1024);
        for bin=1:50
            SmallEp = and(thresholdIntervals(PhaseThetaPre.(Session_type{sess}).(Mouse_names{mouse}),round((bin-1)*(360/50)),'Direction','Above') , thresholdIntervals(PhaseThetaPre.(Session_type{sess}).(Mouse_names{mouse}),round((bin)*(360/50)),'Direction','Below'));
            EKG_binned.(Session_type{sess}).(Mouse_names{mouse})(bin) = nanmedian(Data(Restrict(Filt_LFP_High , SmallEp)));
        end
    end
    disp(Mouse_names{mouse})
end


   
    
%% figures
Cols={[0.8500 0.3250 0.0980],[0.4660 0.6740 0.1880],[0 0.4470 0.7410],[1 1 0]};

figure
Data_to_use = LFP_EKG_NREMAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{1}; h.patch.FaceColor=Cols{1}; h.edge(1).Color=Cols{1}; h.edge(2).Color=Cols{1};

Data_to_use = LFP_rip_NREMAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{2}; h.patch.FaceColor=Cols{2}; h.edge(1).Color=Cols{2}; h.edge(2).Color=Cols{2};

Data_to_use = LFP_bulb_NREMAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{3}; h.patch.FaceColor=Cols{3}; h.edge(1).Color=Cols{3}; h.edge(2).Color=Cols{3};

Data_to_use = LFP_EMG_NREMAll;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
h=shadedErrorBar(linspace(-.5,.5,1000) , runmean(Mean_All_Sp,20) , runmean(Conf_Inter,20),'-k',1); hold on;
h.mainLine.Color=Cols{4}; h.patch.FaceColor=Cols{4}; h.edge(1).Color=Cols{4}; h.edge(2).Color=Cols{4};

l=vline(0); set(l,'LineWidth',2)
xlabel('time (s)'), ylabel('amplitude (a.u.)')
f=get(gca,'Children'); l=legend([f(13),f(9),f(5),f(1)],'EKG','rip','Bulb','EMG');
makepretty_BM



figure
plot(Range(LFP_EKG_NREM.(Session_type{sess}).(Mouse_names{mouse}),'s') , Data(LFP_EKG_NREM.(Session_type{sess}).(Mouse_names{mouse})))
hold on
plot(Range(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}),'s') , Data(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}))*3)
plot(Range(SgnFiltre0.(Session_type{sess}).(Mouse_names{mouse}),'s') , Data(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}))*8)
xlim([100 101]), xlabel('time (s)')
legend('LFP EKG','Filtered signal','Phase')

figure
h=histogram(Data(DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
xlabel('phase (deg)'), ylabel('occurence')



load('/media/nas7/ProjetEmbReact/DataEmbReact/EKG_trace.mat')

figure
subplot(5,1,1:2)
plot(EKG_binned.Cond.(Mouse_names{13}),'k')
makepretty
axis off

subplot(5,1,3:5)
Data_to_use = DistribPhase_rip_All.(Session_type{sess});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
l=hline(.02); set(l,'LineWidth',2)

Data_to_use = DistribPhase_rand_All.(Session_type{sess});
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
l=hline(.02); set(l,'LineWidth',2)

I=1:50;
for i=I
    [h,p1(i)]=ttest(DistribPhase_rip_All.(Session_type{sess})(:,i) , DistribPhase_rand_All.(Session_type{sess})(:,i));
    [p2(i), h, stats]=ranksum(DistribPhase_rip_All.(Session_type{sess})(:,i) , DistribPhase_rand_All.(Session_type{sess})(:,i));
    try, [h,p3(i)]=ttest(DistribPhase_rip_All.(Session_type{sess})(:,i) , ones(25,1)*.02); catch; [h,p3(i)]=ttest(DistribPhase_rip_All.(Session_type{sess})(:,i) , ones(24,1)*.02); end
end

xlabel('phase (a.u.)'), ylabel('proba (a.u.)')
plot(I(p1<.05)/50,.028,'*k')
try, plot(I(p2<.05)/50,.029,'*k'), end
plot(I(p3<.05)/50,.027,'*r')
% f=get(gca,'Children'); l=legend([f(13),f(9)],'rip times','rand times');
makepretty_BM
title(Session_type{sess})



%% using PasePref
for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        channel = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'EKG');
        LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',channel);
        VHigh_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','H_VHigh');
        
        Epoch2.(Session_type{sess}){mouse,4} = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','NREM_epoch_withsleep_withnoise');
        
        LFP_EKG_NREM.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,4});
        VHigh_Spec_NREM.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(VHigh_Spec.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,4});
        
    end
end

LFP = tsd(linspace(0,sum(DurationEpoch(Epoch2.(Session_type{sess}){mouse,4})),length(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}))) , Data(LFP_EKG.(Session_type{sess}).(Mouse_names{mouse})));
R = linspace(0,sum(DurationEpoch(Epoch2.(Session_type{sess}){mouse,4}))/1e4 , length(VHigh_Spec_NREM.(Session_type{sess}).(Mouse_names{mouse})));

[P,f,VBinnedPhase] = PrefPhaseSpectrum(LFP , Data(VHigh_Spec_NREM.(Session_type{sess}).(Mouse_names{mouse})) , R , RangeVHigh , [6 15] , 10); 



figure
imagesc([VBinnedPhase VBinnedPhase+360] , f , SmoothDec([P' P'],.5)), axis xy
ylim([100 200])
caxis([30 6e2])
colormap jet





%% generate more random times
figure
for i=1:20
    for sess=1:length(Session_type)
        Sessions_List_ForLoop_BM
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
                
                clear DIFF, DIFF = diff(FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse}));
                DIFF = DIFF(randperm(length(DIFF)));
                rand_time = sort([FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(mouse) FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})(2:end)+DIFF]);
                DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}) , ts(FzTimeFromRipples.(Session_type{sess}).(Mouse_names{mouse})));
                DistribPhase_rand.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(PhaseTheta.(Session_type{sess}).(Mouse_names{mouse}) , ts(rand_time));
                
                h=histogram(Data(DistribPhase_rip.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
                if sum(h.Values)>50
                    DistribPhase_rip_All.(Session_type{sess})(mouse,:) = h.Values/sum(h.Values);
                end
                DistribPhase_rip_All.(Session_type{sess})(DistribPhase_rip_All.(Session_type{sess})==0)=NaN;
                
                h2=histogram(Data(DistribPhase_rand.(Session_type{sess}).(Mouse_names{mouse})),'BinLimits',[0 360],'NumBins',50);
                if sum(h2.Values)>50
                    DistribPhase_rand_All2{i}.(Session_type{sess})(mouse,:) = h2.Values/sum(h2.Values);
                end
                DistribPhase_rand_All2{i}.(Session_type{sess})(DistribPhase_rand_All2{i}.(Session_type{sess})==0)=NaN;
                
            end
            disp(Mouse_names{mouse})
        end
    end
end

D=[];
for i=1:20
    D=[D ; DistribPhase_rand_All2{i}.Cond];
end



I=1:50;
for i=I
    [h,p1(i)]=ttest2(DistribPhase_rip_All.Cond(:,i) , D(:,i));
    [p2(i), h, stats]=ranksum(DistribPhase_rip_All.Cond(:,i) , D(:,i));
    [h,p3(i)]=ttest(DistribPhase_rip_All.Cond(:,i) , ones(25,1)*.02);
end







figure
subplot(5,1,1:2)
plot(EKG_binned.(Session_type{sess}).(Mouse_names{13}),'k')
makepretty
axis off

subplot(5,1,3:5)
Data_to_use = DistribPhase_rip_All.Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
l=hline(.02); set(l,'LineWidth',2)

Data_to_use = D;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;
l=hline(.02); set(l,'LineWidth',2)


xlabel('phase (a.u.)'), ylabel('proba (a.u.)')
plot(I(p1<.05)/50,.028,'*k')
plot(I(p2<.05)/50,.029,'*k')
plot(I(p3<.05)/50,.027,'*r')
f=get(gca,'Children'); l=legend([f(17),f(13)],'rip times','rand times');
makepretty_BM








figure
subplot(5,1,1:2)
plot(EKG_binned.(Session_type{sess}).(Mouse_names{13}),'k')
makepretty
axis off

subplot(5,1,3:5)
Data_to_use = DistribPhase_rip_All.Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , Mean_All_Sp , Conf_Inter ,'-r',1); hold on;
l=hline(.02); set(l,'LineWidth',2)

Data_to_use = D;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmedian(Data_to_use);
shadedErrorBar(linspace(0,1,50) , Mean_All_Sp , Conf_Inter ,'-k',1); hold on;
l=hline(.02); set(l,'LineWidth',2)

xlabel('phase (a.u.)'), ylabel('proba (a.u.)')
plot(I(p1<.05)/50,.028,'*k')
plot(I(p2<.05)/50,.029,'*k')
plot(I(p3<.05)/50,.027,'*r')
f=get(gca,'Children'); l=legend([f(17),f(13)],'rip times','rand times');
makepretty_BM


