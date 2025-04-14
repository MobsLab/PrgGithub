function [Spi,stdev]=FindSpindlesKarim(LFP,fre,Epoch,sd)

try
    sd;
   
    if sd==0
        
     if sum(End(Epoch,'s')-Start(Epoch,'s'))>12000
    
        rg=Range(EPoch);
        Epoch2=intervalSet(0, rg/3);
        Epoch2=and(Epoch,Epoch2);
    else
        Epoch2=Epoch;
        
    end
    
    signal = Data(Restrict(FilterLFP(LFP,fre,512),Epoch2));

    frequency=round(1/median(diff(Range(LFP,'s'))));

    frequency=1250;
    windowLength = frequency/1250*11;

    squaredSignal = signal.^2;
    window = ones(windowLength,1)/windowLength;
    %normalizedSquaredSignal = unity(Filter0(window,sum(squaredSignal,2)));
    keep=[];
    sd=[];


    [normalizedSquaredSignal,sd] = unity(Filter0(window,sum(squaredSignal,2)),sd,keep);
    
    
    end
    
    
catch
    
sd=4E5;
%vari=8E5;
%vari=12E5;
end




try
    vari;
catch  
%     vari=std(Data(Restrict(FilterLFP(LFP,fre,512),Epoch)));
    vari=sd;
end

%LFP=ResampleTSD(LFP,250);

smo=2;
stdev=[];

try
    Epoch;
catch
    rg=Range(LFP);
    Epoch=intervalSet(rg(1),rg(end));
end
    
        clear Spi
        clear ripples
        Spi=[];
        for i=1:length(Start(Epoch))
            
              try
                 
                 
        %     lfp=Restrict(LFPt{numLFP},subset(SWSEpoch,i));
        %     rg=Start(subset(SWSEpoch,i));
           % lfp=tsd(Range(lfp)-rg(1),Data(lfp));
        %     [spiStartstemp, spiEndstemp, spiPeakstemp] = findSpindles(lfp, thspindles1, thspindles2);
        %[spiPeakstemp] = findSpindles2(lfp, thspindles1,thspindles2);
        Filsp=FilterLFP(Restrict(LFP,subset(Epoch,i)),fre,1024);
        rgFilsp=Range(Filsp,'s');
        filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
        % [ripples,stdev,noise] = FindRipples(filtered,'durations',[600 500
        % 6000],'thresholds',[2 7]);
%        [ripples,stdev(i),noise] = FindRipples(filtered,'durations',[600 500 6000],'stdev',vari,'thresholds',[3 5]);

         [ripples,stdev,noise] = FindspindlesMarie(filtered,'durations',[300 600 6000],'stdev',vari,'thresholds',[0.8 2.5],'frequency',round(1/median(diff(rgFilsp))));%,'show','on');
        ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
        Spi=[Spi;ripples];
        % length(Range(spiPeakstemp))
        % spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
        % spiStarts=[spiStarts; Range(spiStartstemp)+rg(1)];
        % spiEnds=[spiEnds; Range(spiEndstemp)+rg(1)];
        %spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
             
               end
             
        end
        
   
   if length(Spi)<10
       
  %var=4E5;
       
      clear Spi
        clear ripples
        Spi=[];
        for i=1:length(Start(Epoch))
             try
        %     lfp=Restrict(LFPt{numLFP},subset(SWSEpoch,i));
        %     rg=Start(subset(SWSEpoch,i));
           % lfp=tsd(Range(lfp)-rg(1),Data(lfp));
        %     [spiStartstemp, spiEndstemp, spiPeakstemp] = findSpindles(lfp, thspindles1, thspindles2);
        %[spiPeakstemp] = findSpindles2(lfp, thspindles1,thspindles2);
        Filsp=FilterLFP(Restrict(LFP,subset(Epoch,i)),fre,1024);
        rgFilsp=Range(Filsp,'s');
        filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
        % [ripples,stdev,noise] = FindRipples(filtered,'durations',[600 500
        % 6000],'thresholds',[2 7]);
%         [ripples,stdev,noise] = FindRipples(filtered,'durations',[600 500
%         6000],'stdev',vari,'thresholds',[3 5]);
        [ripples,stdev(i),noise] = FindspindlesMarie(filtered,'durations',[600 500 6000],'thresholds',[3 5],'frequency',round(1/median(diff(rgFilsp))));
        ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
        Spi=[Spi;ripples];
        % length(Range(spiPeakstemp))
        % spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
        % spiStarts=[spiStarts; Range(spiStartstemp)+rg(1)];
        % spiEnds=[spiEnds; Range(spiEndstemp)+rg(1)];
        %spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
             end
        end  
       
       
   end
   
   
   
   
   
   

function y = Filter0(b,x)

if size(x,1) == 1
	x = x(:);
end

if mod(length(b),2)~=1
	error('filter order should be odd');
end

shift = (length(b)-1)/2;

[y0 z] = filter(b,1,x);

y = [y0(shift+1:end,:) ; z(1:shift,:)];

function [U,stdA] = unity(A,sd,restrict)

if ~isempty(restrict),
	meanA = mean(A(restrict));
	stdA = std(A(restrict));
else
	meanA = mean(A);
	stdA = std(A);
end
if ~isempty(sd),
	stdA = sd;
end

U = (A - meanA)/stdA;



        
        
        
        
   %M=PlotRipRaw(LFP,Spi(:,2),300);
   
%    
%    SpiEpoch=intervalSet(Spi(:,1)*1E4,Spi(:,3)*1E4);
% 
% 
% tPeaksT=[];
% peakValue=[];
% peakMeanValue=[];
% zeroCrossT=[];
% zeroMeanValue=[];
% ST=[];
%     
% for i=1:length(Start(SpiEpoch))
%     
%     Filt_EEGd = FilterLFP(Restrict(LFP,SpiEpoch), [4 20], 1024);
% 
%     eegd=Data(Restrict(Filt_EEGd,subset(SpiEpoch,i)))';
%     td=Range(Restrict(Filt_EEGd,subset(SpiEpoch,i)),'s')';
% 
%     de = diff(eegd);
%     de1 = [de 0];
%     de2 = [0 de]; 
%     %finding peaks
%     upPeaksIdx = find(de1 < 0 & de2 > 0);
%     downPeaksIdx = find(de1 > 0 & de2 < 0); 
%     PeaksIdx = [upPeaksIdx downPeaksIdx];
%     PeaksIdx = sort(PeaksIdx);
%     Peaks = eegd(PeaksIdx);
%     tPeaks=td(PeaksIdx);
%     peakMeanValuetemp=mean([eegd(PeaksIdx-1);eegd(PeaksIdx);eegd(PeaksIdx+1)]);
%     tPeaksT=[tPeaksT,tPeaks];
%     peakValue=[peakValue,Peaks];
%     peakMeanValue=[peakMeanValue,peakMeanValuetemp];
%    
%        
%     eegdplus1=[0 eegd];
%     eegdplus0=[eegd 0];
%     zeroCross1=find(eegdplus0<0 & eegdplus1>0);
%     zeroCross2=find(eegdplus0>0 & eegdplus1<0);    
%     zeroCrossIdx = [zeroCross1 zeroCross2];
%     zeroCrossIdx = sort(zeroCrossIdx);
%     zeroCross=td(zeroCrossIdx);
%     zeroCrossT=[zeroCrossT,zeroCross];
%     
%     for ii=2:length(zeroCrossIdx)-1
% %         try
%        zeroMeanValuetemp(ii)=max(abs(eegd(zeroCrossIdx(ii-1):zeroCrossIdx(ii+1)))); 
% %         end
% 
%     end
%     zeroMeanValuetemp(length(zeroCrossIdx))=zeroMeanValuetemp(length(zeroCrossIdx)-1);
%     zeroMeanValuetemp(1)=zeroMeanValuetemp(2);
%     zeroMeanValue=[zeroMeanValue,zeroMeanValuetemp];
%     clear zeroMeanValuetemp
% 
%     datatemp=Data(Restrict(LFP,subset(SpiEpoch,i)));
%     datatemp=datatemp-mean(datatemp);
%     datatemp2=Data(Restrict(Filt_EEGd,subset(SpiEpoch,i)));
%     reliab(i)=floor(sqrt(sum(abs(datatemp.^2-datatemp2.^2)))/length(datatemp)); 
%     
% %     [S,f]=mtspectrumc(datatemp,params);
% %     [BE,id]=max(smooth(S(find(f>3.5):end),smo));
% %     ftemp=f(find(f>3.5):end);
% %     fmax=ftemp(id);
% %     freq=[0:0.5:38];
% %     Stsd=tsd(f,S);
% %     Sh=Restrict(Stsd,freq);
% %     ST=[ST;Data(Sh)']; 
%     
% %     [BE,id]=max(smooth(S(find(f>3.5&f<25):end),smo));
% %     ftemp=f(find(f>3.5&f<25):end);
% %     fmax=ftemp(id);
%     
% %     Stemp=smooth(S/max(S)*10,smo);
% %     Stemp=Stemp(find(f>3.5&f<25));
% %     de = diff(Stemp)';
% %     de1 = [de 0];
% %     de2 = [0 de]; 
% %     upPeaksIdx = find(de1 < 0 & de2 > 0);
% %     [BE,id]=max(Stemp(upPeaksIdx));
% %     fpeaks=ftemp(upPeaksIdx(id));
% %     
% %     if length(fpeaks)>0
% %     fmax=fpeaks;
% %     end
%     
%     tPeakstemp=tPeaksT(find(tPeaksT>Start(subset(SpiEpoch,i),'s') & tPeaksT<End(subset(SpiEpoch,i),'s')));
%     zeroCrosstemp=zeroCrossT(find(zeroCrossT>Start(subset(SpiEpoch,i),'s') & zeroCrossT<End(subset(SpiEpoch,i),'s')));
%      freq=[0:0.5:38];
%     h1=hist(1./(diff(tPeakstemp)*2),freq);
%     h2=hist(1./(diff(zeroCrosstemp)*2),freq);  
%     [BE,id]=max(smooth(h1,smo));
%     fmax2=freq(id);
%     [BE,id]=max(smooth(h2,smo));
%     fmax3=freq(id);
%     
%     Bilan(i,1)=reliab(i);
%     Bilan(i,2)=fmax2;
%     Bilan(i,3)=fmax3; 
% 
%     
%     clear tPeaks
%     clear Peaks
%     clear zeroCross
% end
%   
% zeroCrossT = sort(zeroCrossT);
% 
% size(Spi,1)
% 
% id=find(Bilan(:,1)<85&Bilan(:,2)<20&Bilan(:,3)<20); 
% SpiC=Spi(id,:);
% size(SpiC,1)
% %    figure('color',[1 1 1]), hold on
% % for i=1:length(LFP)
% % plot(Range(LFP{i},'s'),fac*Data(LFP{i})/1000+fac*i+fac*2.5,'k')
% % end
% % yl=ylim;
% % line([Spind(:,1) Spind(:,3)],yl,'color','r','linewidth',2)


   