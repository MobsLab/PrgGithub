
%%%%
voie=cell(1,7);
voie{1}='21';
voie{2}='23';
voie{3}='20';
voie{4}='22';
voie{5}='31';
voie{6}='29';
voie{7}='24';

for v=1:7
    v
    load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/LFPData/LFP',voie{v},'.mat'))
    load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/StateEpoch.mat'))
    load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/behavResources.mat'))
    load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/NoiseEpochs_21.mat'))
    
    LFPtest=ResampleTSD(LFP,250);
    A=load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/entropy6_',voie{v},'.mat'));
    A=struct2array(A);
    entropy=tsd(A(:,1)*10000,A(:,2));
    
    std1=1.5; %peak frequencies
    smoothfact=10; %smooth frequency
    std2=0.5;
    std2_high=2; %times domain  - at least one peak
    std3=1; %freq domain
    std4=2; %entropy
    peak_no_single_freq=3;
    peak_no_multi_freq=3;
    inter_freq_interval=0.2;
    min_spindle_length=0.4;
    min_num_peaks_freq=1;
    min_num_peaks_high=0;
    min_num_peaks=2;
    min_inter_spindle=0.3;
    min_num_peaks_ent=1;
    
    %Peak fct
    Epoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
    globalvar_sq=std(Data(Restrict(LFPtest, Epoch)).^2);
    globalmean_sq=mean(Data(Restrict(LFPtest, Epoch)).^2);
    entropyvar=std(Data(Restrict(entropy, Epoch)));
    entropymean=mean(Data(Restrict(entropy, Epoch)));
    
    [tpeaks,tDeltaP2,tDeltaT2,t,brst]=FindExtremPeaks(LFPtest,std1,Epoch);
    Fs=1/median(diff(Range(LFPtest,'s')));
    
    %find 3 consecutive peaks
    alltimes=[Range(tDeltaT2,'s') ;Range(tDeltaP2,'s')];
    allfreq=[Data(tDeltaT2) ;Data(tDeltaP2)];
    
    time_freq_bef=[alltimes allfreq];
    time_freq_after=[];
    for j=1:10
        time_freq_int=time_freq_bef(time_freq_bef(:,2)==2*j+1,:);
        time_freq_int_sorted=sort(time_freq_int,1);
        brst = burstinfo_2(time_freq_int_sorted(:,1), 1/(2*j+1),inf,peak_no_single_freq);
        Epoch=intervalSet(brst.t_start, brst.t_end);
        time_freq_rest=tsd(time_freq_int_sorted(:,1),time_freq_int_sorted(:,2));
        time_freq_rest=Restrict(time_freq_rest, Epoch);
        time_freq_after=[time_freq_after ; [Range(time_freq_rest) Data(time_freq_rest)]];
    end
    
    %merge across freq
    time_freq_all=sortrows(time_freq_after,1);
    brst_all_freq = burstinfo_2(time_freq_all(:,1), inter_freq_interval,inf,peak_no_multi_freq);
    display(strcat('number of ROI  ', num2str(length(brst_all_freq.t_start))));
    
    %     get rid of shorties
    brst_all_freq.t_start=brst_all_freq.t_start(brst_all_freq.dur>min_spindle_length);
    brst_all_freq.t_end=brst_all_freq.t_end(brst_all_freq.dur>min_spindle_length);
    brst_all_freq.n=brst_all_freq.n(brst_all_freq.dur>min_spindle_length);
    brst_all_freq.dur=brst_all_freq.dur(brst_all_freq.dur>min_spindle_length);
    display(strcat('number of ROI after elimination of short events ', num2str(length(brst_all_freq.t_start))));
    
    
    Epoch=intervalSet(brst_all_freq.t_start, brst_all_freq.t_end);
    time_freq_final_rest=tsd(time_freq_all(:,1),time_freq_all(:,2));
    time_freq_final_rest=Restrict(time_freq_final_rest, Epoch);
    time_freq_final=[Range(time_freq_final_rest) Data(time_freq_final_rest)];
%     
%         plot(Range(LFP), Data(LFP))
%         hold on
%         scatter(time_freq_bef(:,1)*10000,time_freq_bef(:,2)*100+3000,'r')
%         scatter(time_freq_after(:,1)*10000,time_freq_after(:,2)*100+5000,'k')
%         scatter(time_freq_final(:,1)*10000,time_freq_final(:,2)*100+7000,'g')
%         a=0;
%     
%         a=a+1; xlim([a*0.5e6 0.5e6*(a+1)])
%     
    
    target=4; %seconds
    nopeak=[];
    %     get rid of 1/f sections and too small amplitudes
    for k=2:length(brst_all_freq.t_start)-1
        if mod(k,100)==0
            display(strcat(num2str(k),' vus sur ', num2str(length(brst_all_freq.t_start))))
        end
        interval=brst_all_freq.t_end(k)-brst_all_freq.t_start(k);
        if interval<target
            up=((target-interval)/2);
            down=((target-interval)/2);
            if (brst_all_freq.t_end(k)+up)>brst_all_freq.t_start(k+1)
                up=((brst_all_freq.t_start(k+1)-brst_all_freq.t_end(k))/2);
            end
            if (brst_all_freq.t_start(k)-down)<brst_all_freq.t_end(k-1)
                down=((brst_all_freq.t_start(k)-brst_all_freq.t_end(k-1))/2);
            end
            Epoch=intervalSet((brst_all_freq.t_start(k)-down)*10000,(brst_all_freq.t_end(k)+up)*10000);
        else
            Epoch=intervalSet(brst_all_freq.t_start(k)*10000,brst_all_freq.t_end(k)*10000);
        end
        y=Data(Restrict(LFPtest,Epoch));
        time=Range(Restrict(LFPtest,Epoch));
        y=y-mean(y);
        L=length(y);
        NFFT=2^nextpow2(L);
        Y = fft(y,NFFT)/L;
        f = Fs/2*linspace(0,1,NFFT/2);
        pow=f'.*abs(Y(1:NFFT/2)*2);
        ind1=find(f>22, 1, 'first');
        ind2=find(f>60, 1, 'first');
        pow=pow(1:ind2);
        smoothpow=smooth(pow,smoothfact);
        f=f(1:ind2);
        var=mean(smoothpow)+std3*std(smoothpow);
        
        %         finding peaks in frequency domain
        deriv_freq=diff(smoothpow(1:ind1))';
        deriv1_freq = [deriv_freq 0];
        deriv2_freq = [0 deriv_freq];
        PeaksIdx_freq = find(deriv1_freq < 0 & deriv2_freq > 0);
        Peaks_freq = smoothpow(PeaksIdx_freq);
        PeaksTime_freq=f(PeaksIdx_freq);
        PeaksTime_freq=PeaksTime_freq(Peaks_freq>var);
        Peaks_freq=Peaks_freq(Peaks_freq>var);
        
        %         finding peaks in time domain
        Epoch_tight=intervalSet(brst_all_freq.t_start(k)*10000,brst_all_freq.t_end(k)*10000);
        ysq=Data(Restrict(LFPtest,Epoch_tight));
        timesq=Range(Restrict(LFPtest,Epoch_tight));
        ysq=ysq'.^2;
        deriv_time=diff(ysq);
        deriv1_time = [deriv_time 0];
        deriv2_time = [0 deriv_time];
        PeaksIdx_time = find(deriv1_time < 0 & deriv2_time > 0);
        Peaks_time = ysq(PeaksIdx_time);
        PeaksTime_time=timesq(PeaksIdx_time);
        
        
        PeaksTime_time_high=PeaksTime_time(Peaks_time>(globalvar_sq*std2_high+globalmean_sq));
        Peaks_time_high=Peaks_time(Peaks_time>(globalvar_sq*std2_high+globalmean_sq));
        PeaksTime_time=PeaksTime_time(Peaks_time>(globalvar_sq*std2+globalmean_sq));
        Peaks_time=Peaks_time(Peaks_time>(globalvar_sq*std2+globalmean_sq));
        
        %         is there a change in entropy?
        Epoch_tight=intervalSet(brst_all_freq.t_start(k)*10000,brst_all_freq.t_end(k)*10000);
        time_pe=Range(Restrict(entropy,Epoch_tight),'s');
        pe=Data(Restrict(entropy,Epoch_tight));
        deriv_pe=diff(pe');
        deriv1_pe = [deriv_pe 0];
        deriv2_pe = [0 deriv_pe];
        PeaksIdx_pe = find(deriv1_pe > 0 & deriv2_pe < 0);
        Peaks_val_pe=pe(PeaksIdx_pe);
        PeaksIdx_high_pe=PeaksIdx_pe(Peaks_val_pe<(entropymean-std4*entropyvar));
        
        
        if size(Peaks_freq,1)>min_num_peaks_freq & size(Peaks_time_high,2)>min_num_peaks_high & size(PeaksIdx_high_pe,2)>min_num_peaks_ent & size(Peaks_time,2)>min_num_peaks
            nopeak=[nopeak k];
        ysq=Data(Restrict(LFPtest,Epoch));
        timesq=Range(Restrict(LFPtest,Epoch));
        ysq=ysq'.^2;
        deriv_time=diff(ysq);
        deriv1_time = [deriv_time 0];
        deriv2_time = [0 deriv_time];
        PeaksIdx_time = find(deriv1_time < 0 & deriv2_time > 0);
        Peaks_time = ysq(PeaksIdx_time);
        PeaksTime_time=timesq(PeaksIdx_time);
            brst = burstinfo_2(PeaksTime_time_high, 0.2*10000,inf,4);
            brst.t_start=brst.t_start(brst.dur/10000>min_spindle_length);
            brst.t_end=brst.t_end(brst.dur/10000>min_spindle_length);
            if length(brst.t_start)>0
            brst_all_freq.t_start=[brst_all_freq.t_start(1:k-1); brst.t_start/10000 ;brst_all_freq.t_start(k+length(brst.t_start):end)];
            brst_all_freq.t_end=[brst_all_freq.t_end(1:k-1) ;brst.t_end/10000 ;brst_all_freq.t_end(k+length(brst.t_start):end)];
% %             else
%             brst_all_freq.t_start=[brst_all_freq.t_start(1:k-1); NaN ;brst_all_freq.t_start(k+length(brst.t_start):end)];
%             brst_all_freq.t_end=[brst_all_freq.t_end(1:k-1) ;NaN ;brst_all_freq.t_end(k+length(brst.t_start):end)];
            end
            
        end
         
%  figure(1)
%             clf(1)
%             subplot(4,1,1)
%             plot(time/10000,y)
%             hold on
%             scatter(time_freq_final(:,1),zeros(1,length(time_freq_final(:,1))), 50,'c')
%             xlim([time(1)/10000 time(end)/10000])
%             hold on
%             plot(brst_all_freq.t_start(k),0,'.','color','r','linewidth',5)
%             plot(brst_all_freq.t_end(k),0,'.','color','r','linewidth',5)
%             title(num2str(size(Peaks_freq,1)>min_num_peaks_freq & size(Peaks_time_high,2)>min_num_peaks_high & size(PeaksIdx_high_pe,2)>min_num_peaks_ent))
%             subplot(4,1,2)
%             plot(timesq/10000,ysq)
%             hold on
%             scatter(PeaksTime_time_high/10000,Peaks_time_high,'g')
%             plot(timesq/10000,ones(1,length(timesq))*(globalvar_sq*std2_high+globalmean_sq),'c')
%             plot(timesq/10000,ones(1,length(timesq))*(globalvar_sq*std2+globalmean_sq),'g')
%             plot(brst_all_freq.t_start(k),0,'.','color','r','linewidth',5)
%             plot(brst_all_freq.t_end(k),0,'.','color','r','linewidth',5)
%             subplot(4,1,3)
%             plot(f,pow)
%             xlim([0 50])
%             hold on
%             plot(f,smoothpow,'r','linewidth',3)
%             plot(f,ones(length(f))*1*var,'k')
%             plot(f,ones(length(f))*2*var,'c')
%             scatter(PeaksTime_freq,Peaks_freq)
%             subplot(4,1,4)
%             plot(time_pe,pe)
%             hold on
%             plot(time_pe,ones(length(time_pe))*(entropymean-std4*entropyvar),'c')
%             plot(brst_all_freq.t_start(k),entropymean,'.','color','r','linewidth',5)
%             plot(brst_all_freq.t_end(k),entropymean,'.','color','r','linewidth',5)
%             scatter(time_pe(PeaksIdx_high_pe),pe(PeaksIdx_high_pe),10,'k')
%             xlim([time(1)/10000 time(end)/10000])
%             pause           
%         
    end
    
    display(strcat('number of ROI after frequency, aplitude and entropy cleaning', num2str(length(nopeak))));
    
    brst_all_freq_nonoise.t_start=brst_all_freq.t_start(nopeak);
    brst_all_freq_nonoise.t_end=brst_all_freq.t_end(nopeak);
    
%     brst_all_freq_nonoise.t_start=brst_all_freq_nonoise.t_start(find(isnan(brst_all_freq_nonoise.t_start)));
%     brst_all_freq_nonoise.t_end=brst_all_freq_nonoise.t_end(find(isnan(brst_all_freq_nonoise.t_end)));
    brst_all_freq_nonoise.tdur=  brst_all_freq_nonoise.t_end-  brst_all_freq_nonoise.t_start;
    
    Epoch=intervalSet(brst_all_freq_nonoise.t_start, brst_all_freq_nonoise.t_end);
    time_freq_final_rest=tsd(time_freq_final(:,1),time_freq_final(:,2));
    time_freq_final_rest=Restrict(time_freq_final_rest, Epoch);
    time_freq_final=[Range(time_freq_final_rest) Data(time_freq_final_rest)];
    
    clear event1
    
    for i=1:length(brst_all_freq_nonoise.t_start)
        event1.time(2*i-1)=brst_all_freq_nonoise.t_start(i);
        event1.time(2*i)=brst_all_freq_nonoise.t_end(i);
        event1.description{2*i-1}='spinstart';
        event1.description{2*i}='spinstop';
        
    end
    SaveEvents(strcat('Sophie_spindles.evt.s', voie{v}),event1)
    
    
end




