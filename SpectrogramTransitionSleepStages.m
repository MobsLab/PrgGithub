%SpectrogramTransitionSleepStages

%[params,movingwin,suffix]=SpectrumParametersML('low');
%ComputeSpectrogram_newML(movingwin,params,InfoLFP,'PFCx','All',suffix);
    
%load('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244/SpectrumDataL/Spectrum41.mat')

try
    logplot;
catch
    logplot=1;
end

try
    smo;
catch
    smo=0.7;
end

try
    ca;
catch
    ca=[30 50];
end

lim=15;

load StateEpochSB Wake SWSEpoch REMEpoch

try
    Sp;
    t;
    f;
catch
    % load H_Low_Spectrum
    load B_High_Spectrum
    Sp=Spectro{1};t=Spectro{2}; f=Spectro{3};

end

figure('color',[1 1 1]), numfig=gcf;
subplot(3,1,1)
SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);

if 1

        rg=Range(SleepStages);
        stg=Data(SleepStages);


        idx=find(abs(diff(stg))>0);
        TrWakeSWS=[];
        TrSWSWake=[];
        TrSWSREM=[];  
        TrREMWake=[];
        TrREMSWS=[];
        
        for i=1:length(idx)
            try
            if stg(idx(i)-2)==4&stg(idx(i)+2)==1
            TrWakeSWS=[TrWakeSWS;rg(idx(i))];
            end
            if stg(idx(i)-2)==1&stg(idx(i)+2)==4
            TrSWSWake=[TrSWSWake;rg(idx(i))];
            end
            if stg(idx(i)-2)==1&stg(idx(i)+2)==3
            TrSWSREM=[TrSWSREM;rg(idx(i))];
            end
            if stg(idx(i)-2)==3&stg(idx(i)+2)==4
            TrREMWake=[TrREMWake;rg(idx(i))];
            end
            if stg(idx(i)-2)==3&stg(idx(i)+2)==1
            TrREMSWS=[TrREMSWS;rg(idx(i))];
            end
            end
        end

        Stsd=tsd(t*1E4,Sp);
        %figure('color',[1 1 1]),
        %subplot(5,1,1),AverageSpectrogram(Stsd,f,ts(TrWakeSWS),100,500,2,1);title('Transition Wake => SWS')
        %subplot(5,1,2),AverageSpectrogram(Stsd,f,ts(TrSWSWake),100,500,2,1);title('Transition SWS => Wake')
        %subplot(5,1,3),AverageSpectrogram(Stsd,f,ts(TrSWSREM),100,500,2,1);title('Transition SWS => REM')
        %subplot(5,1,4),AverageSpectrogram(Stsd,f,ts(TrREMWake),100,500,2,1);title('Transition REM => Wake')
        %subplot(5,1,5),AverageSpectrogram(Stsd,f,ts(TrREMSWS),100,500,2,1,logplot);title(['Transition REM => SWS, ',num2str(length(TrREMSWS))])
        figure('color',[1 1 1]),
        subplot(5,1,1),AverageSpectrogram(Stsd,f,ts(TrWakeSWS),100,500,2,smo,logplot);title(['Transition Wake => SWS, ',num2str(length(TrWakeSWS))]); if logplot==1; caxis([ca(1) ca(2)]), end 
        subplot(5,1,2),AverageSpectrogram(Stsd,f,ts(TrSWSWake),100,500,2,smo,logplot);title(['Transition SWS => Wake, ',num2str(length(TrSWSWake))]); if logplot==1; caxis([ca(1) ca(2)]), end 
        subplot(5,1,3),AverageSpectrogram(Stsd,f,ts(TrSWSREM),100,500,2,smo,logplot);title(['Transition SWS => REM, ',num2str(length(TrSWSREM))]); if logplot==1; caxis([ca(1) ca(2)]), end 
        subplot(5,1,4),AverageSpectrogram(Stsd,f,ts(TrREMWake),100,500,2,smo,logplot);title(['Transition REM => Wake, ',num2str(length(TrREMWake))]); if logplot==1; caxis([ca(1) ca(2)]), end 
        subplot(5,1,5),AverageSpectrogram(Stsd,f,ts(TrREMSWS),100,500,2,smo,logplot);title(['Transition REM => SWS, ',num2str(length(TrREMSWS))]); if logplot==1; caxis([ca(1) ca(2)]), end 

end


%******************************************
% cleaning ********************************
%******************************************


[REMEpochC,WakeC,idbad]=CleanREMEpoch(SleepStages);
SleepStagesC=PlotSleepStage(WakeC,SWSEpoch,REMEpochC);close

[WakeC2,TotalNoiseEpochC,Dur]=CleanWakeNoise(SleepStagesC);
SleepStagesC2=PlotSleepStage(WakeC2,SWSEpoch,REMEpochC);close

[SWSEpochC3,REMEpochC3,WakeC3]=CleanSWSREM(SleepStagesC2,SWSEpoch,REMEpochC,WakeC2,lim);

figure(numfig),
subplot(3,1,2)
SleepStagesC3=PlotSleepStage(WakeC3,SWSEpochC3,REMEpochC3,0);

rg=Range(SleepStagesC3);
stg=Data(SleepStagesC3);



%******************************************
%******************************************



idx=find(abs(diff(stg))>0);
TrWakeSWS=[];
TrSWSWake=[];
TrSWSREM=[];  
TrREMWake=[];
TrREMSWS=[];
for i=1:length(idx)
    try
    if stg(idx(i)-2)==4&stg(idx(i)+2)==1
    TrWakeSWS=[TrWakeSWS;rg(idx(i))];
    end
    if stg(idx(i)-2)==1&stg(idx(i)+2)==4
    TrSWSWake=[TrSWSWake;rg(idx(i))];
    end
    if stg(idx(i)-2)==1&stg(idx(i)+2)==3
    TrSWSREM=[TrSWSREM;rg(idx(i))];
    end
    if stg(idx(i)-2)==3&stg(idx(i)+2)==4
    TrREMWake=[TrREMWake;rg(idx(i))];
    end
    if stg(idx(i)-2)==3&stg(idx(i)+2)==1
    TrREMSWS=[TrREMSWS;rg(idx(i))];
    end
    end
end


Stsd=tsd(t*1E4,Sp);
figure('color',[1 1 1]),
subplot(5,1,1),AverageSpectrogram(Stsd,f,ts(TrWakeSWS),100,500,2,smo,logplot);title(['Transition Wake => SWS, ',num2str(length(TrWakeSWS))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,2),AverageSpectrogram(Stsd,f,ts(TrSWSWake),100,500,2,smo,logplot);title(['Transition SWS => Wake, ',num2str(length(TrSWSWake))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,3),AverageSpectrogram(Stsd,f,ts(TrSWSREM),100,500,2,smo,logplot);title(['Transition SWS => REM, ',num2str(length(TrSWSREM))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,4),AverageSpectrogram(Stsd,f,ts(TrREMWake),100,500,2,smo,logplot);title(['Transition REM => Wake, ',num2str(length(TrREMWake))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,5),AverageSpectrogram(Stsd,f,ts(TrREMSWS),100,500,2,smo,logplot);title(['Transition REM => SWS, ',num2str(length(TrREMSWS))]); if logplot==1; caxis([ca(1) ca(2)]), end 




%******************************************
%******************************************


figure(numfig),
subplot(3,1,3)
[REMEpochC4,WakeC4,SWSEpochC4,SleepStagesC4,ToTalNoiseEpochC4,DurRealign]=RealignREM(WakeC3,SWSEpochC3,REMEpochC3,2);

DurRealign

rg=Range(SleepStagesC4);
stg=Data(SleepStagesC4);






idx=find(abs(diff(stg))>0);
TrWakeSWS=[];
TrSWSWake=[];
TrSWSREM=[];  
TrREMWake=[];
TrREMSWS=[];
for i=1:length(idx)
    try
    if stg(idx(i)-2)==4&stg(idx(i)+2)==1
    TrWakeSWS=[TrWakeSWS;rg(idx(i))];
    end
    if stg(idx(i)-2)==1&stg(idx(i)+2)==4
    TrSWSWake=[TrSWSWake;rg(idx(i))];
    end
    if stg(idx(i)-2)==1&stg(idx(i)+2)==3
    TrSWSREM=[TrSWSREM;rg(idx(i))];
    end
    if stg(idx(i)-2)==3&stg(idx(i)+2)==4
    TrREMWake=[TrREMWake;rg(idx(i))];
    end
    if stg(idx(i)-2)==3&stg(idx(i)+2)==1
    TrREMSWS=[TrREMSWS;rg(idx(i))];
    end
    end
end


Stsd=tsd(t*1E4,Sp);
figure('color',[1 1 1]),
subplot(5,1,1),AverageSpectrogram(Stsd,f,ts(TrWakeSWS),100,500,2,smo,logplot);title(['Transition Wake => SWS, ',num2str(length(TrWakeSWS))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,2),AverageSpectrogram(Stsd,f,ts(TrSWSWake),100,500,2,smo,logplot);title(['Transition SWS => Wake, ',num2str(length(TrSWSWake))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,3),AverageSpectrogram(Stsd,f,ts(TrSWSREM),100,500,2,smo,logplot);title(['Transition SWS => REM, ',num2str(length(TrSWSREM))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,4),AverageSpectrogram(Stsd,f,ts(TrREMWake),100,500,2,smo,logplot);title(['Transition REM => Wake, ',num2str(length(TrREMWake))]); if logplot==1; caxis([ca(1) ca(2)]), end 
subplot(5,1,5),AverageSpectrogram(Stsd,f,ts(TrREMSWS),100,500,2,smo,logplot);title(['Transition REM => SWS, ',num2str(length(TrREMSWS))]); if logplot==1; caxis([ca(1) ca(2)]), end 





%******************************************
%******************************************

if 0


        dur=End(SWSEpoch,'s')-Start(SWSEpoch,'s');
        id=find(dur<lim);
        SleepStagesS=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1,1,subset(SWSEpoch,id));

        rg=Range(SleepStagesS);
        stg=Data(SleepStagesS);


        idx=find(abs(diff(stg))>0);
        TrWakeSWS=[];
        TrSWSWake=[];
        TrSWSREM=[];  
        TrREMWake=[];
        for i=1:length(idx)
            try
            if stg(idx(i)-2)==4&stg(idx(i)+2)==2
            TrWakeSWS=[TrWakeSWS;rg(idx(i))];
            end
            if stg(idx(i)-2)==2&stg(idx(i)+2)==4
            TrSWSWake=[TrSWSWake;rg(idx(i))];
            end
            if stg(idx(i)-2)==2&stg(idx(i)+2)==3
            TrSWSREM=[TrSWSREM;rg(idx(i))];
            end
            if stg(idx(i)-2)==3&stg(idx(i)+2)==4
            TrREMWake=[TrREMWake;rg(idx(i))];
            end
            end
        end

        Stsd=tsd(t*1E4,Sp);
        AverageSpectrogram(Stsd,f,ts(TrWakeSWS),100,500,1,1);title('Transition Wake => SWS')
        AverageSpectrogram(Stsd,f,ts(TrSWSWake),100,500,1,1);title('Transition SWS => Wake')
        AverageSpectrogram(Stsd,f,ts(TrSWSREM),100,500,1,1);title('Transition SWS => REM')







        dur=End(SWSEpochC3,'s')-Start(SWSEpochC3,'s');
        id=find(dur<lim);
        SleepStagesS=PlotSleepStage(Wake,SWSEpoch,REMEpoch,1,1,subset(SWSEpochC3,id));

        rg=Range(SleepStagesS);
        stg=Data(SleepStagesS);


        idx=find(abs(diff(stg))>0);
        TrWakeSWS=[];
        TrSWSWake=[];
        TrSWSREM=[];  
        TrREMWake=[];
        for i=1:length(idx)
            try
            if stg(idx(i)-2)==4&stg(idx(i)+2)==2
            TrWakeSWS=[TrWakeSWS;rg(idx(i))];
            end
            if stg(idx(i)-2)==2&stg(idx(i)+2)==4
            TrSWSWake=[TrSWSWake;rg(idx(i))];
            end
            if stg(idx(i)-2)==2&stg(idx(i)+2)==3
            TrSWSREM=[TrSWSREM;rg(idx(i))];
            end
            if stg(idx(i)-2)==3&stg(idx(i)+2)==4
            TrREMWake=[TrREMWake;rg(idx(i))];
            end
            end
        end

        Stsd=tsd(t*1E4,Sp);
        AverageSpectrogram(Stsd,f,ts(TrWakeSWS),100,500,1,1);title('Transition Wake => SWS')
        AverageSpectrogram(Stsd,f,ts(TrSWSWake),100,500,1,1);title('Transition SWS => Wake')
        AverageSpectrogram(Stsd,f,ts(TrSWSREM),100,500,1,1);title('Transition SWS => REM')


end

