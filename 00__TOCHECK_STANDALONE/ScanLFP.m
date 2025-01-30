function [Specgram,t,f,Spectrogram,channelSpecgram]=ScanLFP(LFP,voie,resamp,params,movingwin)


try
   voie;
   if isempty(voie)
       LFPtemp=LFP;
        voie=1;
        clear LFP
        LFP{1}=LFPtemp;
   end
catch
    LFPtemp=LFP;
    voie=1;
    clear LFP
    LFP{1}=LFPtemp;
end


try
   resamp;
   if isempty(resamp)
       resamp=1;
   end
catch
    resamp=1;
end



tic

try 
    params
catch
%     lfp=LFP{voie(1)};
%     params.Fs=1/median(diff(Range(lfp,'s')));
    params.trialave=0;
    params.err=[1 0.0500];
    params.pad=2;
    params.fpass=[0 200];
    %params.fpass=[0 50];
    %params.tapers=[2 3];
    params.tapers=[3 5];
end

try
    movingwin;
    catch
    movingwin=[4 1];
end

for i=1:length(voie)
    
    lfp=LFP{voie(i)};
    rg=Range(lfp);
    if resamp>1
    re=resamp;
    lfpr=resample(Data(lfp),1,re);
    tpsr=[1:length(lfpr)];
    tpsr=rescale(tpsr,rg(1),rg(end));
    else
        lfpr=Data(lfp);
        tpsr=Range(lfp);
    end
    
    lfp=tsd(tpsr,lfpr);
    params.Fs=1/median(diff(Range(lfp,'s')));
    [Specgram{i},t,f]=mtspecgramc(Data(lfp),movingwin,params);
    channelSpecgram{i}=voie(i);

end


for i=1:length(voie)
    Spectrogram{i}=tsd(t*1E4,Specgram{i});
end
Spectrogram=tsdArray(Spectrogram);


if length(Specgram)/2==floor(length(Specgram)/2)
    
    Nu=length(Specgram);
    
else
    Nu=length(Specgram)+1;
    
end



if length(Specgram)==4

        figure('Color',[1 1 1]), 
        subplot(4,2,1), imagesc(t,f,10*log10(Specgram{1}')), axis xy, title('tetrode 1')
        subplot(4,2,3), imagesc(t,f,10*log10(Specgram{2}')), axis xy, title('tetrode 2')
        subplot(4,2,5), imagesc(t,f,10*log10(Specgram{3}')), axis xy, title('tetrode 3')
        subplot(4,2,7), imagesc(t,f,10*log10(Specgram{4}')), axis xy, title('tetrode 4')

        subplot(4,2,[2,4,6,8]),hold on
        plot(f,mean(Specgram{1})/max(mean(Specgram{1})),'linewidth',2)
        hold on, plot(f,mean(Specgram{2})/max(mean(Specgram{2})),'r','linewidth',2)
        hold on, plot(f,mean(Specgram{3})/max(mean(Specgram{3})),'k','linewidth',2)
        hold on, plot(f,mean(Specgram{4})/max(mean(Specgram{4})),'g','linewidth',2), title('blue 1, red 2, black 3, green 4')

else

        figure('Color',[1 1 1]), 

        for i=1:length(Specgram)

        subplot(Nu,2,i*2-1), imagesc(t,f,10*log10(Specgram{i}')), axis xy, title(['voie ',num2str(i)])    

        end
        
        

        
        subplot(Nu,2,[2:2:2*Nu]),hold on
        
        for i=1:length(Specgram)    
        hold on, plot(f,mean(Specgram{i})/max(mean(Specgram{i})),'linewidth',2,'Color',[i/length(Specgram) (length(Specgram)-i)/length(Specgram), 0])
        end
        
        
        
end



tp=toc;
if tp<60
    disp(['duration: ',num2str(tp),' sec'])
else
    disp(['duration: ',num2str(tp/60),' min'])    
end


    disp(['Freq: ',num2str(params.Fs),' Hz'])

