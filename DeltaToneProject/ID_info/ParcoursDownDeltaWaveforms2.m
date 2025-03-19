%ParcoursDownDeltaWaveforms2
% 06.09.2016 KJ
%
% generate graphs to describe records
%   - PFCx LFP mean curve, synchronized on up>down or down>up (DownLFPAveragePFCx)
%   - PaCx LFP mean curve, synchronized on up>down or down>up (DownLFPAveragePaCx)
%   - MoCx LFP mean curve, synchronized on up>down or down>up (DownLFPAverageMoCx)
%   - 
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

for p=1:length(Dir.path)
    try
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


        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% LFP sync on down states
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
        down_duration = End(Down)-Start(Down);

        nb_down=length(start_down);
        [~, idx_down_sorted] = sort(down_duration,'ascend');
        if nb_down >= 1000
           small_down = idx_down_sorted(1:500);
           big_down = idx_down_sorted(end-499:end);
        else
            halfsize = floor(nb_down/2);
            small_down = idx_down_sorted(1:halfsize);
            big_down = idx_down_sorted(end-halfsize+1:end);
        end 


        %% PFCx - plotRipRaw : LFP synchonized on down states
        Ms_start_small = PlotRipRaw(LFPsup,start_down(small_down)/1E4,1000); close
        Ms_start_big = PlotRipRaw(LFPsup,start_down(big_down)/1E4,1000); close
        Ms_end_small = PlotRipRaw(LFPsup,end_down(small_down)/1E4,1000); close
        Ms_end_big = PlotRipRaw(LFPsup,end_down(big_down)/1E4,1000); close 
        Md_start_small = PlotRipRaw(LFPdeep,start_down(small_down)/1E4,1000); close
        Md_start_big = PlotRipRaw(LFPdeep,start_down(big_down)/1E4,1000); close
        Md_end_small = PlotRipRaw(LFPdeep,end_down(small_down)/1E4,1000); close
        Md_end_big = PlotRipRaw(LFPdeep,end_down(big_down)/1E4,1000); close
        err=4; %column ind of the std error

        figure('color',[1 1 1]),
        subplot(2,2,1), hold on
        plot(Ms_start_small(:,1),Ms_start_small(:,2),'r','linewidth',2), hold on 
        plot(Ms_start_small(:,1),Ms_start_small(:,2)+Ms_start_small(:,err),'r','linewidth',1), hold on 
        plot(Ms_start_small(:,1),Ms_start_small(:,2)-Ms_start_small(:,err),'r','linewidth',1), hold on
        plot(Ms_start_big(:,1),Ms_start_big(:,2),'k','linewidth',2), hold on 
        plot(Ms_start_big(:,1),Ms_start_big(:,2)+Ms_start_big(:,err),'k','linewidth',1), hold on 
        plot(Ms_start_big(:,1),Ms_start_big(:,2)-Ms_start_big(:,err),'k','linewidth',1), hold on
        line([0 0],get(gca,'YLim'));
        title('up>down - Sup Layer : short(r) vs long(k) down state'), hold on

        subplot(2,2,2), hold on
        plot(Ms_end_small(:,1),Ms_end_small(:,2),'r','linewidth',2), hold on 
        plot(Ms_end_small(:,1),Ms_end_small(:,2)+Ms_end_small(:,err),'r','linewidth',1), hold on 
        plot(Ms_end_small(:,1),Ms_end_small(:,2)-Ms_end_small(:,err),'r','linewidth',1), hold on
        plot(Ms_end_big(:,1),Ms_end_big(:,2),'k','linewidth',2), hold on 
        plot(Ms_end_big(:,1),Ms_end_big(:,2)+Ms_end_big(:,err),'k','linewidth',1), hold on 
        plot(Ms_end_big(:,1),Ms_end_big(:,2)-Ms_end_big(:,err),'k','linewidth',1), hold on
        line([0 0],get(gca,'YLim'));
        title('down>up - Sup Layer : short(r) vs long(k) down state'), hold on

        subplot(2,2,3), hold on
        plot(Md_start_small(:,1),Md_start_small(:,2),'r','linewidth',2), hold on 
        plot(Md_start_small(:,1),Md_start_small(:,2)+Md_start_small(:,err),'r','linewidth',1), hold on 
        plot(Md_start_small(:,1),Md_start_small(:,2)-Md_start_small(:,err),'r','linewidth',1), hold on  
        plot(Md_start_big(:,1),Md_start_big(:,2),'k','linewidth',2), hold on 
        plot(Md_start_big(:,1),Md_start_big(:,2)+Md_start_big(:,err),'k','linewidth',1), hold on 
        plot(Md_start_big(:,1),Md_start_big(:,2)-Md_start_big(:,err),'k','linewidth',1), hold on 
        line([0 0],get(gca,'YLim'));
        title('up>down - Deep Layer : short(r) vs long(k) down state'), hold on

        subplot(2,2,4), hold on
        plot(Md_end_small(:,1),Md_end_small(:,2),'r','linewidth',2), hold on 
        plot(Md_end_small(:,1),Md_end_small(:,2)+Md_end_small(:,err),'r','linewidth',1), hold on 
        plot(Md_end_small(:,1),Md_end_small(:,2)-Md_end_small(:,err),'r','linewidth',1), hold on
        plot(Md_end_big(:,1),Md_end_big(:,2),'k','linewidth',2), hold on 
        plot(Md_end_big(:,1),Md_end_big(:,2)+Md_end_big(:,err),'k','linewidth',1), hold on 
        plot(Md_end_big(:,1),Md_end_big(:,2)-Md_end_big(:,err),'k','linewidth',1), hold on 
        line([0 0],get(gca,'YLim'));
        title('down>up - Deep Layer : short(r) vs long(k) down state'), hold on

        suplabel(['LFP (PFCx) average triggered on up-down transitions (' Dir.title{p} ')' ],'t');

        %save figure
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
        savefig(['DownLFPAveragePFCx' Dir.title{p}])
        close


        %% PaCx - plotRipRaw : LFP synchonized on down states
        Ms_start_small = PlotRipRaw(PACsup,start_down(small_down)/1E4,1000); close
        Ms_start_big = PlotRipRaw(PACsup,start_down(big_down)/1E4,1000); close
        Ms_end_small = PlotRipRaw(PACsup,end_down(small_down)/1E4,1000); close
        Ms_end_big = PlotRipRaw(PACsup,end_down(big_down)/1E4,1000); close 
        Md_start_small = PlotRipRaw(PACdeep,start_down(small_down)/1E4,1000); close
        Md_start_big = PlotRipRaw(PACdeep,start_down(big_down)/1E4,1000); close
        Md_end_small = PlotRipRaw(PACdeep,end_down(small_down)/1E4,1000); close
        Md_end_big = PlotRipRaw(PACdeep,end_down(big_down)/1E4,1000); close
        err=4; %column ind of the std error

         figure('color',[1 1 1]),
        subplot(2,2,1), hold on
        plot(Ms_start_small(:,1),Ms_start_small(:,2),'r','linewidth',2), hold on 
        plot(Ms_start_small(:,1),Ms_start_small(:,2)+Ms_start_small(:,err),'r','linewidth',1), hold on 
        plot(Ms_start_small(:,1),Ms_start_small(:,2)-Ms_start_small(:,err),'r','linewidth',1), hold on
        plot(Ms_start_big(:,1),Ms_start_big(:,2),'k','linewidth',2), hold on 
        plot(Ms_start_big(:,1),Ms_start_big(:,2)+Ms_start_big(:,err),'k','linewidth',1), hold on 
        plot(Ms_start_big(:,1),Ms_start_big(:,2)-Ms_start_big(:,err),'k','linewidth',1), hold on
        line([0 0],get(gca,'YLim'));
        title('up>down - Sup Layer : short(r) vs long(k) down state'), hold on

        subplot(2,2,2), hold on
        plot(Ms_end_small(:,1),Ms_end_small(:,2),'r','linewidth',2), hold on 
        plot(Ms_end_small(:,1),Ms_end_small(:,2)+Ms_end_small(:,err),'r','linewidth',1), hold on 
        plot(Ms_end_small(:,1),Ms_end_small(:,2)-Ms_end_small(:,err),'r','linewidth',1), hold on
        plot(Ms_end_big(:,1),Ms_end_big(:,2),'k','linewidth',2), hold on 
        plot(Ms_end_big(:,1),Ms_end_big(:,2)+Ms_end_big(:,err),'k','linewidth',1), hold on 
        plot(Ms_end_big(:,1),Ms_end_big(:,2)-Ms_end_big(:,err),'k','linewidth',1), hold on
        line([0 0],get(gca,'YLim'));
        title('down>up - Sup Layer : short(r) vs long(k) down state'), hold on

        subplot(2,2,3), hold on
        plot(Md_start_small(:,1),Md_start_small(:,2),'r','linewidth',2), hold on 
        plot(Md_start_small(:,1),Md_start_small(:,2)+Md_start_small(:,err),'r','linewidth',1), hold on 
        plot(Md_start_small(:,1),Md_start_small(:,2)-Md_start_small(:,err),'r','linewidth',1), hold on  
        plot(Md_start_big(:,1),Md_start_big(:,2),'k','linewidth',2), hold on 
        plot(Md_start_big(:,1),Md_start_big(:,2)+Md_start_big(:,err),'k','linewidth',1), hold on 
        plot(Md_start_big(:,1),Md_start_big(:,2)-Md_start_big(:,err),'k','linewidth',1), hold on 
        line([0 0],get(gca,'YLim'));
        title('up>down - Deep Layer : short(r) vs long(k) down state'), hold on

        subplot(2,2,4), hold on
        plot(Md_end_small(:,1),Md_end_small(:,2),'r','linewidth',2), hold on 
        plot(Md_end_small(:,1),Md_end_small(:,2)+Md_end_small(:,err),'r','linewidth',1), hold on 
        plot(Md_end_small(:,1),Md_end_small(:,2)-Md_end_small(:,err),'r','linewidth',1), hold on
        plot(Md_end_big(:,1),Md_end_big(:,2),'k','linewidth',2), hold on 
        plot(Md_end_big(:,1),Md_end_big(:,2)+Md_end_big(:,err),'k','linewidth',1), hold on 
        plot(Md_end_big(:,1),Md_end_big(:,2)-Md_end_big(:,err),'k','linewidth',1), hold on 
        line([0 0],get(gca,'YLim'));
        title('down>up - Deep Layer : short(r) vs long(k) down state'), hold on

        suplabel(['LFP (PaCx) average triggered on up-down transitions (' Dir.title{p} ')' ],'t');

        %save figure
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
        savefig(['DownLFPAveragePaCx' Dir.title{p}])
        close


        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %% MUA sync on delta
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %% PFCx
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

        % deltas
        thresh_delta = thD * std_diff;
        all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
        DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
        tmp_deltas = (Start(DeltaOffline) + End(DeltaOffline)) / 2;
        delta_width = End(DeltaOffline) - Start(DeltaOffline);

        nb_delta=length(tmp_deltas);
        [~, idx_delta_sorted] = sort(delta_width,'ascend');
        if nb_delta >= 1000
           small_delta = idx_delta_sorted(1:500);
           big_delta = idx_delta_sorted(end-499:end);
        else
            halfsize = floor(nb_delta/2);
            small_delta = idx_delta_sorted(1:halfsize);
            big_delta = idx_delta_sorted(end-halfsize+1:end);
        end 

        % plotRipRaw : MUA synchonized on delta waves
        Mm_small_pfc=PlotRipRaw(MUA,tmp_deltas(small_delta)/1E4,1000); close
        Mm_big_pfc=PlotRipRaw(MUA,tmp_deltas(big_delta)/1E4,1000); close



        %% PaCx
        k=1;
        for i=0.1:0.1:4
            distance(k)=std(Data(PACdeep)-i*Data(PACsup));
            k=k+1;
        end
        Factor=find(distance==min(distance))*0.1;
        EEGsleepDiff=ResampleTSD(tsd(Range(PACdeep),Data(PACdeep) - Factor*Data(PACsup)),100);
        Filt_diff = FilterLFP(EEGsleepDiff, freqDelta, 1024);
        pos_filtdiff = max(Data(Filt_diff),0);
        std_diff = std(pos_filtdiff(pos_filtdiff>0));  % std that determines thresholds

        % deltas
        thresh_delta = thD * std_diff;
        all_cross_thresh = thresholdIntervals(tsd(Range(Filt_diff), pos_filtdiff), thresh_delta, 'Direction', 'Above');
        DeltaOffline = dropShortIntervals(all_cross_thresh, minDeltaDuration * 10); % crucial element for noise detection.
        tmp_deltas = (Start(DeltaOffline) + End(DeltaOffline)) / 2;
        delta_width = End(DeltaOffline) - Start(DeltaOffline);

        nb_delta=length(tmp_deltas);
        [~, idx_delta_sorted] = sort(delta_width,'ascend');
        if nb_delta >= 1000
           small_delta = idx_delta_sorted(1:500);
           big_delta = idx_delta_sorted(end-499:end);
        else
            halfsize = floor(nb_delta/2);
            small_delta = idx_delta_sorted(1:halfsize);
            big_delta = idx_delta_sorted(end-halfsize+1:end);
        end 

        % plotRipRaw : MUA synchonized on delta waves
        Mm_small_pac=PlotRipRaw(MUA,tmp_deltas(small_delta)/1E4,1000); close
        Mm_big_pac=PlotRipRaw(MUA,tmp_deltas(big_delta)/1E4,1000); close

        %% plot
        err=4; %column ind of the std error
        figure('color',[1 1 1]),
        subplot(1,2,1), hold on
        plot(Mm_small_pfc(:,1),Mm_small_pfc(:,2),'r','linewidth',2), hold on 
        plot(Mm_small_pfc(:,1),Mm_small_pfc(:,2)+Mm_small_pfc(:,err),'r','linewidth',1), hold on 
        plot(Mm_small_pfc(:,1),Mm_small_pfc(:,2)-Mm_small_pfc(:,err),'r','linewidth',1), hold on 
        plot(Mm_big_pfc(:,1),Mm_big_pfc(:,2),'b','linewidth',2), hold on 
        plot(Mm_big_pfc(:,1),Mm_big_pfc(:,2)+Mm_big_pfc(:,err),'b','linewidth',1), hold on 
        plot(Mm_big_pfc(:,1),Mm_big_pfc(:,2)-Mm_big_pfc(:,err),'b','linewidth',1), hold on
        set(gca,'ylim',[0 3]);
        line([0 0],get(gca,'YLim'));
        title('PFCx : short(r) vs large(b)'), hold on

        subplot(1,2,2), hold on
        plot(Mm_small_pac(:,1),Mm_small_pac(:,2),'r','linewidth',2), hold on 
        plot(Mm_small_pac(:,1),Mm_small_pac(:,2)+Mm_small_pac(:,err),'r','linewidth',1), hold on 
        plot(Mm_small_pac(:,1),Mm_small_pac(:,2)-Mm_small_pac(:,err),'r','linewidth',1), hold on 
        plot(Mm_big_pac(:,1),Mm_big_pac(:,2),'b','linewidth',2), hold on 
        plot(Mm_big_pac(:,1),Mm_big_pac(:,2)+Mm_big_pac(:,err),'b','linewidth',1), hold on 
        plot(Mm_big_pac(:,1),Mm_big_pac(:,2)-Mm_big_pac(:,err),'b','linewidth',1), hold on
        set(gca,'ylim',[0 3]);
        line([0 0],get(gca,'YLim'));
        title('PaCx : short(r) vs large(b)'), hold on

        suplabel(['MUA average triggered on delta detection (' Dir.title{p} ')' ],'t');

        %save figure
        cd('/home/mobsjunior/Dropbox/Kteam/Projets KarimJr/Projet Delta/Figures Projet DeltaFeedback/IDfigures')
        savefig(['MuaSyncDelta' Dir.title{p}])
        close
        
    catch
        disp('error for this session')
    end
    
end











