% ParcoursRipplesDeltaInfo
% 14.09.2016 KJ
%
% generate graphs to describe records
%   - Average curve of ripples
%   - Hypnograms (substages) with the density of delta, ripples, delta with/without ripples
%


Dir=PathForExperimentsDeltaIDfigures;

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
thresh_rip = [5 7];
duration_rip = [30 30 100];
binsize_distrib = 20E4; % 20s
ripdown_thresh = 0.2E4; % 200ms

for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)

        %% load
        load StateEpochSB SWSEpoch Wake
        load ChannelsToAnalyse/dHPC_rip
        eval(['load LFPData/LFP',num2str(channel)])
        HPCrip=LFP;
        clear LFP
        clear channel
        %tones
        try
            load('DeltaSleepEvent.mat', 'TONEtime2')
            delay = Dir.delay{p}*1E4; %in 1E-4s
        catch
            TONEtime2 = [0];
            delay = 0;
        end
        ToneEvent = Restrict(ts(TONEtime2 + delay),SWSEpoch);
        nb_tones = length(ToneEvent);
        %Down states
        load newDownState Down
        start_down = Start(Down); 
        %Ripples
        load newRipHPC Ripples_tmp
        
             
        %% Ripples average
        Mripples_large = PlotRipRaw(HPCrip,Ripples_tmp(:,2),250); close
        Mripples_short = PlotRipRaw(HPCrip,Ripples_tmp(:,2),50); close
          
        %Plot
        err=4; %column ind of the std error
        figure('color',[1 1 1]),
        subplot(1,2,1), hold on
        plot(Mripples_large(:,1),Mripples_large(:,2),'r','linewidth',2), hold on 
        plot(Mripples_large(:,1),Mripples_large(:,2)+Mripples_large(:,err),'r','linewidth',1), hold on 
        plot(Mripples_large(:,1),Mripples_large(:,2)-Mripples_large(:,err),'r','linewidth',1), hold on 
        line([0 0],get(gca,'YLim')), hold on
        title('Mean ripples signal : -250 +250 ms'), hold on
        subplot(1,2,2), hold on
        plot(Mripples_short(:,1),Mripples_short(:,2),'r','linewidth',2), hold on 
        plot(Mripples_short(:,1),Mripples_short(:,2)+Mripples_short(:,err),'r','linewidth',1), hold on 
        plot(Mripples_short(:,1),Mripples_short(:,2)-Mripples_short(:,err),'r','linewidth',1), hold on 
        line([0 0],get(gca,'YLim')), hold on
        title('Mean ripples signal : -50 +50 ms'), hold on
        
        suplabel(['Mean ripples signal (' Dir.title{p} ')' ],'t');
        
        %save figure
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
        savefig(['RipplesAverage' Dir.title{p}])
        close
        
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        %% Distribution of down states and ripples
        
        %down with or without ripples
        clear down_norip
        clear down_rip
        peak_ripples = Ripples_tmp(:,2)*1E4; %ripples peak in E-4s
        a=1;b=1;
        for i=1:length(start_down)
            last_rip=find(peak_ripples<start_down(i),1,'last');
            if ~isempty(last_rip)
                if (start_down(i) - peak_ripples(last_rip)) < ripdown_thresh
                    down_rip(a) = start_down(i);
                    a=a+1;
                else
                    down_norip(b)=start_down(i);
                    b=b+1;
                end
            end
        end
        
        % down and ripples density
        ST1{1}=ts(Start(Down));
        try
            ST1=tsdArray(ST1);
        end
        Q=MakeQfromS(ST1,binsize_distrib);
        QDown=tsd(Range(Q),full(Data(Q)));

        ST2{1}=ts(down_rip);
        try
            ST2=tsdArray(ST2);
        end
        Q=MakeQfromS(ST2,binsize_distrib);
        QDownRip=tsd(Range(Q),full(Data(Q)));

        ST3{1}=ts(down_norip);
        try
            ST3=tsdArray(ST3);
        end
        Q=MakeQfromS(ST3,binsize_distrib);
        QDownNoRip=tsd(Range(Q),full(Data(Q)));

        ST4{1}=ts(peak_ripples);
        try
            ST4=tsdArray(ST4);
        end
        Q=MakeQfromS(ST4,binsize_distrib);
        QRip=tsd(Range(Q),full(Data(Q)));
        
        
        %% Substages
        
        load NREMepochsML.mat op NamesOp Dpfc Epoch noise
        [EP,NamesEP]=DefineSubStages(op,noise);
        N1=EP{1}; N2=EP{2}; N3=EP{3}; REM=EP{4}; WAKE=EP{5}; SWS=EP{6}; swaOB=EP{8};
        Rec=or(or(SWS,REM),WAKE);
        Epochs={WAKE,REM,N1,N2,N3};
        num_substage=[4 3 2 1.5 1]; %ordinate in graph
        
        colori=[0.5 0.2 0.1; 0.1 0.7 0 ; 0.5 0.3 1; 1 0.5 1 ;0.8 0 0.7 ];
        indtime=min(Start(Rec)):500:max(Stop(Rec));
        timeTsd=tsd(indtime,zeros(length(indtime),1));
        SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
        rg=Range(timeTsd);

        for ep=1:length(Epochs)
            idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
            SleepStages(idx)=num_substage(ep);
        end
        SleepStages=tsd(rg,SleepStages');
        
        %% plot Substages and densities  
        smoothing = 0;
        figure('color',[1 1 1]),
        subplot(3,1,1), hold on,
        ylabel_substage = {'N3','N2','N1','REM','WAKE'};
        ytick_substage = [1 1.5 2 3 4]; %ordinate in graph
        plot(Range(SleepStages,'s'),Data(SleepStages),'k'), hold on,
        for ep=1:length(Epochs)
            plot(Range(Restrict(SleepStages,Epochs{ep}),'s'),Data(Restrict(SleepStages,Epochs{ep})),'.','Color',colori(ep,:)), hold on,
        end
        xlim([0 max(Range(SleepStages,'s'))]), ylim([0.5 5]), set(gca,'Ytick',ytick_substage,'YTickLabel',ylabel_substage), hold on,
        title('Hypnogram'); xlabel('Time (s)')
    
        subplot(3,1,2), hold on,
        plot(Range(QDown,'s'),SmoothDec(Data(QDown),smoothing)), plot(Range(QRip,'s'),SmoothDec(Data(QRip),smoothing),'r'), hold on,
        xlim([0 max(Range(SleepStages,'s'))]), hold on,
        xlabel('Time'),title('Delta (blue) & Ripples (red) Quantity'), hold on,
        subplot(3,1,3), hold on,
        plot(Range(QDownRip,'s'),SmoothDec(Data(QDownRip),smoothing),'k'), plot(Range(QDownNoRip,'s'),SmoothDec(Data(QDownNoRip),smoothing),'r'), hold on,
        xlim([0 max(Range(SleepStages,'s'))]), hold on,
        xlabel('Time'),title('Delta Quantity with(k) or without(r) Ripples')
        
        %save figure
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
        savefig(['SubstageDownRipples' Dir.title{p}])
        close
        
        
    catch
        disp('error for this session')
    end
end


