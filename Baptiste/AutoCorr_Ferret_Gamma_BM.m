
clear all
% Dir{1} = PathForExperimentsOB({'Brynza'}, 'freely-moving','none');
Dir{1} = PathForExperimentsOB({'Labneh'}, 'head-fixed','none');

n_wake=1;
n_nrem=1;
n_rem=1;
n_all=1;
max_lag = 1e3; % in s
sm_win = 100; % in s

for sess=1:length(Dir{1}.path)
    clear SmoothGamma TotalNoiseEpoch Wake REMEpoch SWSEpoch
    load([Dir{1}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'TotalNoiseEpoch', 'Wake', 'REMEpoch', 'SWSEpoch')
    load([Dir{1}.path{sess} filesep 'SleepScoring_OBGamma.mat'], 'SmoothGamma')
    load([Dir{1}.path{sess} filesep 'HeartBeatInfo.mat'], 'EKG')
    %     Var = tsd(Range(SmoothGamma) , runmean(Data(SmoothGamma),1e4));
    Var = Restrict(tsd(Range(EKG.HBRate) , runmean(Data(EKG.HBRate),10)) , SmoothGamma);
    bin = .08%median(diff(Range(Var,'s')))*100;
    %     if round(bin,2)==.05
    
    % All
    for ep=1
        
        TSD = Var;
        D = log10(Data(TSD)); D = D(1:100:end); D = D(abs(zscore(D))<6);
        D = moving_zscore(D , round(sm_win/bin));
        R = Range(TSD,'s');
        [r_all(n_all,:) , lag] = xcorr(D(~isnan(D)) , round(max_lag/bin) , 'coeff');
        
        n_all=n_all+1;
    end
    
    % Wake
    Wake = or(Wake , TotalNoiseEpoch);
    Wake = mergeCloseIntervals(Wake , 5e4);
    % figure, hist(DurationEpoch(Wake)/60e4)
    
    %     clear r lag dur st
    for ep=1:length(Start(Wake))
        if DurationEpoch(subset(Wake,ep))>10*60e4
            
            TSD = Restrict(Var , subset(Wake,ep));
            D = log10(Data(TSD)); D = D(1:100:end); D = D(abs(zscore(D))<6);
            D = moving_zscore(D , round(sm_win/bin));
            R = Range(TSD,'s');
            %             dur(n_wake) = DurationEpoch(subset(Wake,ep))/60e4;
            %             st(n_wake) = Start(subset(Wake,ep))/60e4;
            [r_wake(n_wake,:) , lag] = xcorr(D(~isnan(D)) , round(max_lag/bin) , 'coeff');
            %             keyboard
            
            n_wake=n_wake+1;
        end
    end
    
    % figure
    % subplot(131)
    % plot((lag*bin)/60 , r' , 'b')
    % plot((lag*bin)/60 , nanmean(r) , 'g')
    % xlabel('time (min)'), xlim([-3 3])
    %
    
    % NREM
    SWSEpoch = dropShortIntervals(SWSEpoch , 10e4);
    SWSEpoch = mergeCloseIntervals(SWSEpoch , 10e4);
    % figure, hist(DurationEpoch(SWSEpoch)/60e4)
    
    %     clear r lag dur st
    for ep=1:length(Start(SWSEpoch))
        if DurationEpoch(subset(SWSEpoch,ep))>10*60e4
            
            TSD = Restrict(Var , subset(SWSEpoch,ep));
            D = Data(TSD); D = D(1:100:end); D = D(abs(zscore(D))<6);
            D = moving_zscore(D , round(sm_win/bin));
            R = Range(TSD,'s');
            %             dur(n_nrem) = DurationEpoch(subset(SWSEpoch,ep))/60e4;
            %             st(n_nrem) = Start(subset(SWSEpoch,ep))/60e4;
            [r_nrem(n_nrem,:) , lag] = xcorr(D(~isnan(D)) , round(max_lag/bin) , 'coeff');
            %         keyboard
            
            n_nrem=n_nrem+1;
        end
    end
    
    % subplot(132)
    % plot((lag*bin)/60 , r' , 'r')
    % Data_to_use = r;
    % Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    % h=shadedErrorBar((lag*bin)/60 , nanmean(Data_to_use) , Conf_Inter ,'-r',1); hold on;
    % xlabel('time (min)'), xlim([-3 3])
    
    
    
    % REM
    REMEpoch = dropShortIntervals(REMEpoch , 10e4);
    REMEpoch = mergeCloseIntervals(REMEpoch , 10e4);
    % figure, hist(DurationEpoch(REMEpoch)/60e4)
    
    %     clear r lag dur st
    for ep=1:length(Start(REMEpoch))
        if DurationEpoch(subset(REMEpoch,ep))>5*60e4
            
            TSD = Restrict(Var , subset(REMEpoch,ep));
            D = Data(TSD); D = D(1:100:end); D = D(abs(zscore(D))<6);
            D = moving_zscore(D , round(sm_win/bin));
            R = Range(TSD,'s');
            %             dur(n) = DurationEpoch(subset(REMEpoch,ep))/60e4;
            %             st(n) = Start(subset(REMEpoch,ep))/60e4;
            [r_rem(n_rem,:) , lag] = xcorr(D(~isnan(D)) , round(max_lag/bin) , 'coeff');
            %         keyboard
            
            n_rem=n_rem+1;
        end
    end
    
    % subplot(133)
    % plot((lag*bin)/60 , r' , 'g')
    % Data_to_use = r;
    % Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    % h=shadedErrorBar((lag*bin)/60 , nanmean(Data_to_use) , Conf_Inter ,'-g',1); hold on;
    % xlabel('time (min)'), xlim([-3 3])
    
    disp(sess)
    %     end
end


%% figures



r_wake(r_wake==0)=NaN;
r_nrem(r_nrem==0)=NaN;
r_rem(r_rem==0)=NaN;

figure
subplot(131)
Data_to_use = r_wake;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar((lag*bin) , nanmean(Data_to_use) , Conf_Inter ,'-b',1); hold on;
xlabel('time (min)'), xlim([-500 500]), ylim([-.2 .2])
makepretty

subplot(132)
Data_to_use = r_nrem;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar((lag*bin) , nanmean(Data_to_use) , Conf_Inter ,'-r',1); hold on;
xlabel('time (min)'), xlim([-500 500]), ylim([-.2 .2])
makepretty

subplot(133)
Data_to_use = r_rem;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar((lag*bin) , nanmean(Data_to_use) , Conf_Inter ,'-g',1); hold on;
xlabel('time (min)'), xlim([-200 200]), ylim([-.4 .4])
makepretty





figure
plot(r_wake')

figure
plot((lag*bin) , r_nrem')
plot((lag*bin) , r_nrem')

figure
plot(r_rem')





figure
Data_to_use = r_all;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h=shadedErrorBar((lag*bin) , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
xlabel('time (min)'), %xlim([-500 500]), ylim([-.2 .2])
makepretty


%% tools
figure
plot(Range(Restrict(SmoothGamma , Wake),'s')/60 , Data(Restrict(SmoothGamma , Wake)), '.b','MarkerSize',3)
hold on
plot(Range(Restrict(SmoothGamma , SWSEpoch),'s')/60 , Data(Restrict(SmoothGamma , SWSEpoch)), '.r','MarkerSize',3)
plot(Range(Restrict(SmoothGamma , REMEpoch),'s')/60 , Data(Restrict(SmoothGamma , REMEpoch)), '.g','MarkerSize',3)
vline(st)



figure
for i=1:10
    subplot(2,5,i)
    plot((lag*bin)/60 , r(i,:) , 'k')
    title(num2str(dur(i)))
end











