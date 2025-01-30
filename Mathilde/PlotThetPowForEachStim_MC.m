Dir{1}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');
figure
number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    %%
    load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise SmoothTheta
    REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
    SWSEp = mergeCloseIntervals(SWSEpochWiNoise,1E4);
    WakeEp =  mergeCloseIntervals(WakeWiNoise,1E4);
    
    %to get opto stimulations
    [Stim, StimREM, StimSWS, StimWake, Stimts] = FindOptoStim_MC;
    StimR=Range(Restrict(Stimts,REMEp))/1E4; %to get opto stims during REM sleep
    
    load H_Low_Spectrum
    SpectroH=Spectro;
    freqH=SpectroH{3};
    idx1=find(freqH>6&freqH<9);
    sptsdH2= tsd(SpectroH{2}*1e4, SpectroH{1}(:,idx1));
    
    %%
    %     subplot(3,2,i)
    figure,hold on
    for ev = 1:length(StimR)
        Tps=Range(Restrict(sptsdH2,intervalSet(StimR(ev)*1E4-30*1E4,StimR(ev)*1E4+30*1E4)),'s')-StimR(ev);
        ThetPower=nanmean(log(Data(Restrict(sptsdH2,intervalSet(StimR(ev)*1E4-30*1E4,StimR(ev)*1E4+30*1E4))))');
        NormThetPower=ThetPower/mean(ThetPower(50:151));
        
        facThet=mean(ThetPower(50:151));
        stdfacThet=std(ThetPower(50:151));
        
        plot(Tps,NormThetPower,'color',[0.6 0.6 0.6])
        line([Tps(1) Tps(end)],[facThet facThet]/facThet,'color','r','linewidth',1)
        line([Tps(1) Tps(end)],[facThet+stdfacThet facThet+stdfacThet]/facThet,'linestyle',':','linewidth',1)
        line([Tps(1) Tps(end)],[facThet-stdfacThet facThet-stdfacThet]/facThet,'linestyle',':','linewidth',1)
        
        xlim([-30 30])
        line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
        line([10 10],ylim,'color','k','linestyle',':','linewidth',1.5)
        
        pause
        clf
        %plot(Range(Restrict(sptsdH2,intervalSet(StimR(ev)*1E4-30*1E4,StimR(ev)*1E4+30*1E4)),'s')-StimR(ev),ev+nanmean(log(Data(Restrict(sptsdH2,intervalSet(StimR(ev)*1E4-30*1E4,StimR(ev)*1E4+30*1E4))))'),'color',[0.6 0.6 0.6])
    end
  
end

%%
goodStim=[];
badStim=[];
data=[];
ThetPower=[];
thresh=[];
NormThetPower=[];
NormThetPower10sec=[];
idxMinValue=[];
    thresh=std(ThetPower(151:161));

for i = 1:length(StimR)
    ThetPower=[ThetPower;nanmean(log(Data(Restrict(sptsdH2,intervalSet(StimR(i)*1E4-30*1E4,StimR(i)*1E4+30*1E4))))')];
    NormThetPower=[NormThetPower;ThetPower(i,:)/mean(ThetPower(i,50:151))];
    NormThetPower10sec=[NormThetPower10sec;NormThetPower(i,151:161)];

    thresh=[thresh;std(ThetPower(i,151:161))];
    idxMinValue=[idxMinValue;min(NormThetPower10sec(i,:),[],2)];

    
    if thresh>  idxMinValue(i)
        goodStim=[goodStim;StimR(i)];
    else
        badStim=[badStim;StimR(i)];
    end
end

