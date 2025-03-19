%%ToneDuringDownStateEffectMeanDur
% 22.03.2018 KJ
%
%
% see
%   
%


clear


a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150416/Breath-Mouse-243-244-16042015/Mouse243'; % 16-04-2015 > random tone effect  - Mouse 243 (delay 200ms!! of M244 detection)
Dir.delay{a}=0.2; Dir.name{a}='Mouse243'; Dir.date{a}='16042015';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150417/Breath-Mouse-243-244-17042015/Mouse244'; % 17-04-2015 > random tone effect  - Mouse 244 (delay 200ms!! of M243 detection)
Dir.delay{a}=0.2; Dir.name{a}='Mouse244'; Dir.date{a}='17042015';


figure, hold on

for p=1:length(Dir.path)

    cd(Dir.path{p})

    clearvars -except Dir p 
    
    %load
    load('DownState.mat')
    st_down = Start(down_PFCx);
    end_down = End(down_PFCx);
    down_duration = End(down_PFCx) - Start(down_PFCx);

    %tones
    load('DeltaSleepEvent.mat', 'TONEtime2')
    tones_tmp = TONEtime2 + Dir.delay{p}*1E4;
    ToneEvent = ts(tones_tmp);
    nb_tones = length(tones_tmp);

    
    %% delay

    %delay
    down_rep = repmat(st_down,1,length(tones_tmp));
    end_rep = repmat(end_down,1,length(tones_tmp));
    tones_rep = repmat(tones_tmp',length(st_down),1);

    delay_rep = tones_rep - down_rep;    
    delay_rep(delay_rep>(end_rep-down_rep))=nan;
    delay_rep(delay_rep<0)=nan;
    
    
    [delay_tonedown, id_max] = max(delay_rep,[],2);
    %ids of events
    idx_down = ~isnan(delay_tonedown);

    DurationTone = down_duration(idx_down)/10;
    DurationNo = down_duration(~idx_down)/10;
    Dur = {DurationTone, DurationNo};
    labels={'tone inside','no tone'};
    
    
    subplot(1,2,p), hold on
    PlotErrorBarN_KJ(Dur, 'newfig',0,'paired',0,'showPoints',1);
    set(gca,'xtick',1:2,'xticklabel',labels);
    title(Dir.name{p})
    
    
end







