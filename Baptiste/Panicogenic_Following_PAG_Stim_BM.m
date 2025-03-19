
SessNames={'Calibration'};

Dir=PathForExperimentsEmbReact(SessNames{1});

for d=1:length(Dir.path)
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end


for mouse=8:17
    for sess=1:length(Dir.path{mouse})
        
        cd(Dir.path{mouse}{sess})
        
        clear Spectro OB_Sptsd MovAcctsd tRipples
        try
            load('B_Low_Spectrum.mat'); OB_Sptsd = tsd(Spectro{2}*1e4 , Spectro{1});
        catch
            OB_Sptsd=tsd([],[]);
        end
        try
            load('behavResources.mat', 'MovAcctsd')
            MovAcctsd;
        catch
            load('behavResources.mat', 'Movtsd')
            MovAcctsd=Movtsd;
        end
        try
           load('StateEpochSB.mat', 'TotalNoiseEpoch') 
        end
        try
            load('SWR.mat', 'tRipples')
        end
        load('behavResources.mat', 'FreezeEpoch'); FreezeCamEpoch{mouse,sess} = FreezeEpoch-TotalNoiseEpoch;
        
        load('ExpeInfo.mat', 'ExpeInfo')
        IntVoltage(mouse,sess) = ExpeInfo.StimulationInt; 
        
        try
            Acc{mouse,sess} = MovAcctsd;
            clear NewMovAcctsd
            NewMovAcctsd=tsd(Range(Acc{mouse,sess}),runmean(Data(Acc{mouse,sess}),30));
            FreezeAccEpoch{mouse,sess} = thresholdIntervals(Acc{mouse,sess},1.7e7,'Direction','Below');
            FreezeAccEpoch{mouse,sess} = mergeCloseIntervals(FreezeAccEpoch{mouse,sess},0.3*1e4);
            FreezeAccEpoch{mouse,sess} = dropShortIntervals(FreezeAccEpoch{mouse,sess},2*1e4);
            
            OB_Spec_FzAcc{mouse,sess} = Restrict(OB_Sptsd , FreezeAccEpoch{mouse,sess});
            OB_Spec_FzCam{mouse,sess} = Restrict(OB_Sptsd , FreezeCamEpoch{mouse,sess});
            
            RipplesDensity_FzAcc{mouse,sess} = length(Restrict(tRipples , FreezeAccEpoch{mouse,sess}))/(sum(DurationEpoch(FreezeAccEpoch{mouse,sess}))/1e4);
            RipplesDensity_FzCam{mouse,sess} = length(Restrict(tRipples , FreezeCamEpoch{mouse,sess}))/(sum(DurationEpoch(FreezeCamEpoch{mouse,sess}))/1e4);
            
            TotTime(mouse,sess) = max(Range(MovAcctsd))/1e4;
            TimeFreezingAcc(mouse,sess) = sum(DurationEpoch(FreezeAccEpoch{mouse,sess}))/1e4;
            TimeFreezingCam(mouse,sess) = sum(DurationEpoch(FreezeCamEpoch{mouse,sess}))/1e4;
        end
        
    end
    disp(num2str(mouse))
end


% select the first session when freezing appear
for mouse=1:7
    if mouse==1; sess=5;
    elseif mouse==2; sess=4;
    elseif mouse==3; sess=4;
    elseif mouse==4; sess=3;
    elseif mouse==5; sess=4;
    elseif mouse==6; sess=5;
    elseif mouse==7; sess=2;
    end
    
    clear D
    D = Data(OB_Spec_FzCam{mouse,sess});
    [u,v] = max(nanmean(D(:,26:end)));
    H(mouse,:) = nanmean(D)./u;
    
    Rip(mouse) = RipplesDensity_FzCam{mouse,sess};
    
end

figure
Data_to_use = H(:,20:end);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(Spectro{3}(20:end) , Mean_All_Sp , Conf_Inter , '-r',1); hold on;
xlim([0 10]), xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
a=title('OB mean spectrum following PAG stim during calibration, n=7'); a.FontSize=10;



% Freeze time and respi increasing voltage
for mouse=1:7
    for sess=1:length(Dir.path{mouse})
        
        try
            clear D
            D = Data(OB_Spec_FzCam{mouse,sess});
            [u,v(mouse,sess)] = max(nanmean(D(:,35:end)));
            for i=1:7
                for j=1:10
                try; FreqFz(i,j) = Spectro{3}(v(i,j)+34); end
                end
            end
        end
        
    end
end
FreqFz(FreqFz==Spectro{3}(35)) = NaN;
FreqFz(FreqFz==0) = NaN;

IntVoltage(IntVoltage==0) = NaN;
IntVoltage([1 2 3 6 7],1)=0;

i=1;
for volt=[0 .5 1 1.5 2 2.5 3 4 5]
    
    RankedFzTime(i,1:length(TimeFreezingCam(IntVoltage==volt))) = TimeFreezingCam(IntVoltage==volt);
    RankedFzTime(i,length(TimeFreezingCam(IntVoltage==volt))+1:8) = NaN;
    
    RankedRespi(i,1:length(FreqFz(IntVoltage==volt))) = FreqFz(IntVoltage==volt);
    RankedRespi(i,length(FreqFz(IntVoltage==volt))+1:8) = NaN;
    
    i=i+1;
    
end

for i=0:5
    
    ind = ceil(IntVoltage)==i;
    RankedFzTime(i+1,1:length(TimeFreezingCam(ind))) = TimeFreezingCam(ind);
    RankedFzTime(i+1,length(TimeFreezingCam(ind))+1:11) = NaN;
    
    RankedRespi(i+1,1:length(FreqFz(ind))) = FreqFz(ind);
    RankedRespi(i+1,length(FreqFz(ind))+1:11) = NaN;
        
end
RankedRespi(RankedRespi==0)=NaN;
RankedFzTime(RankedFzTime==0)=NaN;


figure
subplot(121)
Data_to_use = RankedFzTime';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([0:0.5:4] , Mean_All_Sp , Conf_Inter , '-k',1); hold on;
xlabel('Stim voltage (V)'), ylabel('time freezing (s)')
title('Freezing duration')
box off

subplot(122)
Data_to_use = RankedRespi';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar([0:0.5:4] , Mean_All_Sp , Conf_Inter , '-k',1); hold on;
ylim([0 10])
xlabel('Stim voltage (V)'), ylabel('Frequency (Hz)')
title('Breathing')
box off

a=suptitle('Calibration sessions features'); a.FontSize=15;



%% draft
% display movement for all mice and sess
figure
for mouse=1:8
    subplot(2,4,mouse)
    for sess=1:10
        try
            smooth_mov = tsd(Range(Acc{mouse,sess}) , runmean(Data(Acc{mouse,sess}),ceil(3/median(diff(Range(Acc{mouse,sess},'s'))))));
            plot(Data(smooth_mov),'Color',[.1 .1 .1]*(sess-1))
            hold on
        end
    end
end


% display OB mean spec for all mice and sess
figure
for mouse=1:8
    subplot(2,4,mouse)
    for sess=1:10
        try
            plot(Spectro{3} , nanmean(Data(OB_Spec_FzCam{mouse,sess})),'Color',[.1 .1 .1]*(sess-1))
            xlim([0 10])
            hold on
        end
    end
end




