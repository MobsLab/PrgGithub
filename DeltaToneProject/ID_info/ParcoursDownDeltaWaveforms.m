%ParcoursDownDeltaWaveforms

%Dir=PathForExperimentsDeltaIDfigures;

a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243'; % Mouse 243 - Day 2 - Basal
Dir.delay{a}=0; Dir.condition{a}='Basal';
Dir.title{a}='Mouse243 - 29032015';

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    
    %load data
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP
    load ChannelsToAnalyse/PFCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    LFPsup=LFP;
    clear LFP
    clear channel
    load ChannelsToAnalyse/PaCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    PACdeep=LFP;
    clear LFP
    load ChannelsToAnalyse/PaCx_sup
    eval(['load LFPData/LFP',num2str(channel)])
    PACsup=LFP;
    clear LFP
    clear channel
    
    load StateEpochSB SWSEpoch Wake
    load SpikeData
    eval('load SpikesToAnalyse/PFCx_Neurons')
    NumNeurons=number;
    clear number

    %params
    freqDelta = [1 6];
    thD = 2;
    minDeltaDuration = 50;
    binsize=10;
    thresh0 = 0.7;
    minDownDur = 100;
    maxDownDur = 500;
    mergeGap = 10; % merge
    predown_size = 50;

    %% Multi-Unit activity and down
    T=PoolNeurons(S,NumNeurons);
    ST{1}=T;
    try
        ST=tsdArray(ST);
    end
    Q = MakeQfromS(ST,binsize*10); %binsize*10 to be in E-4s
    MUA = Q;
    Q = Restrict(Q, SWSEpoch);
    %Down
    Down = FindDown2_KJ(Q, 'low_thresh', thresh0, 'minDuration', minDownDur,'maxDuration', maxDownDur, 'mergeGap', mergeGap, 'predown_size', predown_size, 'method', 'mono');
    down_tmp = Start(Down) + (End(Down)-Start(Down)) / 2;
    start_down = Start(Down);
    end_down = End(Down);

    %% Signals
    k=1;
    for i=0.1:0.1:4
        distance(k)=std(Data(LFPdeep)-i*Data(LFPsup));
        k=k+1;
    end
    Factor=find(distance==min(distance))*0.1;
    EEGsleepDiff=ResampleTSD(tsd(Range(LFPdeep),Data(LFPdeep) - Factor*Data(LFPsup)),100);
    Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
    pos_filtdiff = max(Data(Filt_diff),0);
    std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds


    %% deltas
    %diff
    thresh_delta = thD * std_diff;
    all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
    DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
    tmp_deltas = (Start(DeltaOffline) + End(DeltaOffline)) / 2;


    %% plotRipRaw : LFP synchonized on down states
    % LFP signal synchronized on the beginning of down
    nb_down=length(start_down);
    sample_size=min(500,nb_down);
    Md=PlotRipRaw(LFPdeep,start_down(1:sample_size)/1E4,1000); close
    Ms=PlotRipRaw(LFPsup,start_down(1:sample_size)/1E4,1000); close 
    Mdf=PlotRipRaw(LFPdeep,start_down(nb_down-sample_size+1:nb_down)/1E4,1000); close
    Msf=PlotRipRaw(LFPsup,start_down(nb_down-sample_size+1:nb_down)/1E4,1000); close 
    err=4; %column ind of the std error

    figure('color',[1 1 1]),
    subplot(2,2,1), hold on 
    plot(Md(:,1),Md(:,2),'k','linewidth',2), hold on 
    plot(Md(:,1),Md(:,2)+Md(:,err),'k','linewidth',1), hold on 
    plot(Md(:,1),Md(:,2)-Md(:,err),'k','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2),'r','linewidth',2), hold on 
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'r','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'r','linewidth',1), hold on 
    title('deep(k) vs sup(r) : sleep begining'), hold on 

    subplot(2,2,2), hold on
    plot(Mdf(:,1),Mdf(:,2),'k','linewidth',2), hold on 
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'k','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'k','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2),'r','linewidth',2), hold on 
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'r','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'r','linewidth',1), hold on 
    title('deep(k) vs sup(r) : sleep end')

    subplot(2,2,3), hold on
    plot(Md(:,1),Md(:,2),'b','linewidth',2), hold on 
    plot(Md(:,1),Md(:,2)+Md(:,err),'b','linewidth',1), hold on 
    plot(Md(:,1),Md(:,2)-Md(:,err),'b','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2),'m','linewidth',2), hold on 
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'m','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'m','linewidth',1), hold on 
    title('deep layer : sleep begining(b) vs end(m)'), hold on 

    subplot(2,2,4), hold on
    plot(Ms(:,1),Ms(:,2),'b','linewidth',2), hold on 
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'b','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'b','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2),'m','linewidth',2), hold on 
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'m','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'m','linewidth',1), hold on 
    title('sup layer : sleep begining(b) vs end(m)')
    
    suplabel(Dir.title{p},'t');
    %save figure
    cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
    savefig(['StartDownMeanCurves' Dir.title{p}])
    close

    % LFP signal synchronized on the beginning of down
    nb_down=length(end_down);
    sample_size=min(500,nb_down);
    Md=PlotRipRaw(LFPdeep,end_down(1:sample_size)/1E4,1000); close
    Ms=PlotRipRaw(LFPsup,end_down(1:sample_size)/1E4,1000); close 
    Mdf=PlotRipRaw(LFPdeep,end_down(nb_down-sample_size+1:nb_down)/1E4,1000); close
    Msf=PlotRipRaw(LFPsup,end_down(nb_down-sample_size+1:nb_down)/1E4,1000); close 
    err=4; %column ind of the std error


    figure('color',[1 1 1]),
    subplot(2,2,1), hold on 
    plot(Md(:,1),Md(:,2),'k','linewidth',2), hold on 
    plot(Md(:,1),Md(:,2)+Md(:,err),'k','linewidth',1), hold on 
    plot(Md(:,1),Md(:,2)-Md(:,err),'k','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2),'r','linewidth',2), hold on 
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'r','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'r','linewidth',1), hold on 
    title('deep(k) vs sup(r) : sleep begining'), hold on 

    subplot(2,2,2), hold on
    plot(Mdf(:,1),Mdf(:,2),'k','linewidth',2), hold on 
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'k','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'k','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2),'r','linewidth',2), hold on 
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'r','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'r','linewidth',1), hold on 
    title('deep(k) vs sup(r) : sleep end')

    subplot(2,2,3), hold on
    plot(Md(:,1),Md(:,2),'b','linewidth',2), hold on 
    plot(Md(:,1),Md(:,2)+Md(:,err),'b','linewidth',1), hold on 
    plot(Md(:,1),Md(:,2)-Md(:,err),'b','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2),'m','linewidth',2), hold on 
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'m','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'m','linewidth',1), hold on 
    title('deep layer : sleep begining(b) vs end(m)'), hold on 

    subplot(2,2,4), hold on
    plot(Ms(:,1),Ms(:,2),'b','linewidth',2), hold on 
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'b','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'b','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2),'m','linewidth',2), hold on 
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'m','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'m','linewidth',1), hold on 
    title('sup layer : sleep begining(b) vs end(m)')
    
    suplabel(Dir.title{p},'t');
    %save figure
    cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
    savefig(['EndDownMeanCurves' Dir.title{p}])
    close


    %% plotRipRaw : LFP synchonized on delta waves
    nb_delta=length(tmp_deltas);
    sample_size=min(500,nb_delta);
    Md=PlotRipRaw(LFPdeep,tmp_deltas(1:sample_size)/1E4,1000); close
    Ms=PlotRipRaw(LFPsup,tmp_deltas(1:sample_size)/1E4,1000); close 
    Mdf=PlotRipRaw(LFPdeep,tmp_deltas(nb_delta-sample_size+1:nb_delta)/1E4,1000); close
    Msf=PlotRipRaw(LFPsup,tmp_deltas(nb_delta-sample_size+1:nb_delta)/1E4,1000); close 
    err=4; %column ind of the std error


    figure('color',[1 1 1]),
    subplot(2,2,1), hold on 
    plot(Md(:,1),Md(:,2),'k','linewidth',2), hold on 
    plot(Md(:,1),Md(:,2)+Md(:,err),'k','linewidth',1), hold on 
    plot(Md(:,1),Md(:,2)-Md(:,err),'k','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2),'r','linewidth',2), hold on 
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'r','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'r','linewidth',1), hold on 
    title('deep(k) vs sup(r) : sleep begining'), hold on 

    subplot(2,2,2), hold on
    plot(Mdf(:,1),Mdf(:,2),'k','linewidth',2), hold on 
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'k','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'k','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2),'r','linewidth',2), hold on 
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'r','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'r','linewidth',1), hold on 
    title('deep(k) vs sup(r) : sleep end')

    subplot(2,2,3), hold on
    plot(Md(:,1),Md(:,2),'b','linewidth',2), hold on 
    plot(Md(:,1),Md(:,2)+Md(:,err),'b','linewidth',1), hold on 
    plot(Md(:,1),Md(:,2)-Md(:,err),'b','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2),'m','linewidth',2), hold on 
    plot(Mdf(:,1),Mdf(:,2)+Mdf(:,err),'m','linewidth',1), hold on 
    plot(Mdf(:,1),Mdf(:,2)-Mdf(:,err),'m','linewidth',1), hold on 
    title('deep layer : sleep begining(b) vs end(m)'), hold on 

    subplot(2,2,4), hold on
    plot(Ms(:,1),Ms(:,2),'b','linewidth',2), hold on 
    plot(Ms(:,1),Ms(:,2)+Ms(:,err),'b','linewidth',1), hold on 
    plot(Ms(:,1),Ms(:,2)-Ms(:,err),'b','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2),'m','linewidth',2), hold on 
    plot(Msf(:,1),Msf(:,2)+Msf(:,err),'m','linewidth',1), hold on 
    plot(Msf(:,1),Msf(:,2)-Msf(:,err),'m','linewidth',1), hold on 
    title('sup layer : sleep begining(b) vs end(m)')

    suplabel(Dir.title{p},'t');
    %save figure
    cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
    savefig(['DeltaMeanCurves' Dir.title{p}])
    close
    
    %% plotRipRaw : MUA synchonized on delta waves
    nb_delta=length(tmp_deltas);
    sample_size=min(500,nb_delta);
    Mmb=PlotRipRaw(MUA,tmp_deltas(1:sample_size)/1E4,1000); close
    Mmf=PlotRipRaw(MUA,tmp_deltas(nb_delta-sample_size+1:nb_delta)/1E4,1000); close
    err=4; %column ind of the std error

    figure('color',[1 1 1]),
    plot(Mmb(:,1),Mmb(:,2),'k','linewidth',2), hold on 
    plot(Mmb(:,1),Mmb(:,2)+Mmb(:,err),'k','linewidth',1), hold on 
    plot(Mmb(:,1),Mmb(:,2)-Mmb(:,err),'k','linewidth',1), hold on 
    plot(Mmf(:,1),Mmf(:,2),'r','linewidth',2), hold on 
    plot(Mmf(:,1),Mmf(:,2)+Mmf(:,err),'r','linewidth',1), hold on 
    plot(Mmf(:,1),Mmf(:,2)-Mmf(:,err),'r','linewidth',1), hold on 
    title('MUA sync on delta waves : sleep begining(b) vs end(m)')
    %save figure
    cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
    savefig(['MuaDeltaMeanCurves' Dir.title{p}])
    close

    
end

close all









