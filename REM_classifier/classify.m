voieB=9;
voieH=19; % je pense qu'il uat vraiment être dans la pyramidale
% SureSWS=intervalSet([1679,5570]*1e4,[1815,5643]*1e4); for
% DataMOBs/ProjetDPCPX/Mouse051/20121227/BULB-Mouse-51-27122012 - voie 7 et
% H
 %SureSWS=intervalSet([9102,19995]*1e4,[9188,20016]*1e4);  load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/LFPData/LFP',num2str(voieB),'.mat'))
% load data
SureSWS=intervalSet(541*1e4,606*1e4);
load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/LFPData/LFP',num2str(voieB),'.mat'))
load('StateEpoch.mat')
 
params.Fs=1/median(diff(Range(LFP,'s')));params.trialave=0;
params.fpass=[20 200];
params.tapers=[3 5];
movingwin=[0.1 0.005];
params.Fs=1250;
suffix='H';
 
    [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
 save('SpectrumData_S/Spectrum9_high.mat','Sp','t','f')

    sptsd=tsd(t*10000,Sp);
TotalEpoch=intervalSet(t(1)*1e4,t(end)*1e4);
Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;
    Spectr=Restrict(sptsd,Epoch);
    startg=find(f<50,1,'last');
    stopg=find(f>70,1,'first');
    a=Data(Spectr);
    tot_ghi=tsd(Range(Restrict(Spectr,Epoch)),sum(a(:,startg:stopg)')');
 
load(strcat('/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/LFPData/LFP',num2str(voieH),'.mat'))
 
    params.err=[1 0.0500];
params.pad=2;
params.fpass=[0.1 20];
movingwin=[3 0.2];
params.tapers=[3 5];
 
 [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
 save('SpectrumData_S/Spectrum19_low.mat','Sp','t','f')
    sptsd=tsd(t*10000,Sp);
    
    startt=find(f<5,1,'last');
    stopt=find(f>10,1,'first');
    startd=find(f<1.5,1,'last');
    stopd=find(f>4.5,1,'first');
    Spectr=Restrict(sptsd,Epoch);
    a=Data(Spectr);
    tot_td=tsd(Range(Restrict(Spectr,Epoch)),(sum(a(:,startt:stopt)')./sum(a(:,startd:stopd)'))');

    
    m=max((Data(Restrict(tot_td,SureSWS))));
    NewEpoch=thresholdIntervals(tot_td,m);
    
      interEpoch=intervalSet(0,0);
      for k=1:length(start(NewEpoch))
      if abs(start(subset(NewEpoch,k))-stop(subset(NewEpoch,k)))>20000;
          interEpoch=or(interEpoch,subset(NewEpoch,k));
      end
      end
      NewEpoch=interEpoch;

    mergeEpoch=mergeCloseIntervals(NewEpoch,1e5);
      
    New_ghi_int=Restrict(tot_ghi,mergeEpoch);
    Peaks=[];
    Peaktd=[];
    for k=1:length(start(mergeEpoch))
    data=smooth(Data(Restrict(New_ghi_int,subset(mergeEpoch,k))),500)';
    td=Range(Restrict(New_ghi_int,subset(mergeEpoch,k)))';
           
          de = diff(data);
          de1 = [de 0];
          de2 = [0 de];

          %finding peaks
          PeaksIdx = find(de1 < 0 & de2 > 0);

          Peaks = [Peaks data(PeaksIdx)];
      Peaktd=[Peaktd td(PeaksIdx)];

    end
    Peakstsd=tsd(Peaktd',Peaks');
    yy=Peaks;
 yy(yy>mean(yy)+std(yy))=[];
 [h,b]=hist(yy,100);
 Up=[];
 Down=[];
 Ups=[];
 Downs=[];
 temp=SmoothDec(h,2);
 de = diff(temp');
          de1 = [de 0];
          de2 = [0 de];
          upPeaksIdx = find(de1 < 0 & de2 > 0);
          downPeaksIdx = find(de1 > 0 & de2 < 0);
 Up(:,1)=b(upPeaksIdx);
 Up(:,2)=h(upPeaksIdx);
 Down(:,1)=b(downPeaksIdx);
 Down(:,2)=h(downPeaksIdx);
 Ups=sort(Up,2);
Downs=sort(Down,2);
ind=find(Downs(:,2)>Ups(2,1) & Downs(:,2)<Ups(2,2));
nanDowns=nan(length(Downs),2);
nanDowns(ind,:)=Downs(ind,:);
[val,finalind]=min(nanDowns(:,1));
    peak_thresh=nanDowns(finalind,2);
    Peaks_REM_tsd=tsd(Peaktd(Peaks<peak_thresh)',Peaks(Peaks<peak_thresh)');
MyRemEpoch=intervalSet(0,0);
   for k=1:length(start(mergeEpoch))
       
       REMpeaks=size(Data(Restrict(Peaks_REM_tsd,subset(mergeEpoch,k))));
       Wakepeaks=size(Data(Restrict(Peakstsd,subset(mergeEpoch,k))))-size(Data(Restrict(Peaks_REM_tsd,subset(mergeEpoch,k))));
       if REMpeaks>Wakepeaks 
           MyRemEpoch=or(MyRemEpoch,subset(mergeEpoch,k));
       end
   end
%       MyRemEpoch=mergeCloseIntervals(MyRemEpoch,5e5);
      REMEpoch2=MyRemEpoch;
% 
%       for k=1:length(start(MyRemEpoch))
%       if abs(start(subset(MyRemEpoch,k))-stop(subset(MyRemEpoch,k)))>20000;
%           REMEpoch2=or(REMEpoch2,subset(MyRemEpoch,k));
%       end
%       end

    figure
    subplot(4,1,1)
    plot(Range(Restrict(LFP,Epoch),'s'),Data(Restrict(LFP,Epoch)),'b')
  hold on,    plot(Range(Restrict(LFP,REMEpoch),'s'),Data(Restrict(LFP,REMEpoch)),'r')
  
      plot(Range(Restrict(LFP,REMEpoch2),'s'),Data(Restrict(LFP,REMEpoch2))/3,'g')
subplot(4,1,2)
        Epoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
        plot(Range(Restrict(tot_td,Epoch),'s'),Data(Restrict(tot_td,Epoch)),'b')
        hold on
        Epoch=REMEpoch-GndNoiseEpoch-NoiseEpoch;
                plot(Range(Restrict(tot_td,Epoch),'s'),Data(Restrict(tot_td,Epoch)),'G')
Epoch=MovEpoch-GndNoiseEpoch-NoiseEpoch;
                                plot(Range(Restrict(tot_td,Epoch),'s'),Data(Restrict(tot_td,Epoch)),'k')
                                  hold on,    plot(Range(Restrict(tot_td,mergeEpoch),'s'),Data(Restrict(tot_td,mergeEpoch)),'m')

subplot(4,1,3)
 Epoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
        plot(Range(Restrict(tot_ghi,Epoch),'s'),Data(Restrict(tot_ghi,Epoch)),'b')
        hold on
        Epoch=REMEpoch-GndNoiseEpoch-NoiseEpoch;
                plot(Range(Restrict(tot_ghi,Epoch),'s'),Data(Restrict(tot_ghi,Epoch)),'G')
Epoch=MovEpoch-GndNoiseEpoch-NoiseEpoch;
                                plot(Range(Restrict(tot_ghi,Epoch),'s'),Data(Restrict(tot_ghi,Epoch)),'k')
                
    subplot(4,1,4)
    Epoch=TotalEpoch-GndNoiseEpoch-NoiseEpoch;
    plot(Range(Restrict(V,Epoch),'s'),Data(Restrict(V,Epoch)),'b')
  
% 
% for i=1:7
% EpochOK{i}=thresholdIntervals(,m);
% end
% 
% 
%  num=1;
%     clear entot
%     maxdist=percentile(Peaks,70);
%     num=1;
%     for i=10*maxdist/100:maxdist/100:maxdist
%                 
%     Peakslow=Peaks(Peaks<i);
%     [Y,X]=hist(Peakslow,100);
%     Y=Y./sum(Y);
%     plot(X,Y)
% s = fitoptions('Method','NonlinearLeastSquares',...
%                'Lower',[0,0,0],...
%                'Upper',[Inf,Inf,Inf],...
%                'Startpoint',[200 1e5 1e4]);
% f = fittype('a*exp(-((x-b)/c)^2)','options',s);
% [c2,gof2] = fit(X',Y',f);
% output(num,1)=gof2.rsquare;
% output(num,2)=i;
% num=num+1;
%     end