%FindSpindlesRipples

Rip=1;
Spindd=1;
load StateEpoch
load behavResources

try
    num(1);
    numLFP=num(1);
catch
    numLFP=2;
end

try
    num(2);
    numLFPrip=num(2);
catch
    numLFPrip=2;
end



% LFPa{1}=LFPt{16}; %auditory cortex
% LFPa{2}=LFPt{18}; % Pfc
% LFPa{3}=LFPt{21}; % hpc
% LFPa{4}=LFPt{22}; % hpc
% LFPa{5}=LFPt{5}; %bulb
% LFPa{6}=LFPt{19}; %pfc 
 
% st=Start(LPSEpoch,'s');
% en=End(LPSEpoch,'s');
% length(Restrict(spits,intervalSet(0,st(1)*1E4)))/st(1)
% length(Restrict(spits,intervalSet(st(1)*1E4,en(end)*1E4)))/(en(end)-st(1))




if Spindd

load LFPPFCx
LFPp=LFP;
clear LFP
        %thspindles1=4;
        %thspindles2=15;
        % clear spiPeaks
        % spiPeaks=[];
        % spiStarts=[];
        % spiEnds=[];
        clear Spi
        clear ripples
        Spi=[];
        for i=1:length(Start(SWSEpoch))
            try
        %     lfp=Restrict(LFPt{numLFP},subset(SWSEpoch,i));
        %     rg=Start(subset(SWSEpoch,i));
           % lfp=tsd(Range(lfp)-rg(1),Data(lfp));
        %     [spiStartstemp, spiEndstemp, spiPeakstemp] = findSpindles(lfp, thspindles1, thspindles2);
        %[spiPeakstemp] = findSpindles2(lfp, thspindles1,thspindles2);
        Filsp=FilterLFP(Restrict(LFPp{numLFP},subset(SWSEpoch,i)),[4 20],1024);
        rgFilsp=Range(Filsp,'s');
        filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
        % [ripples,stdev,noise] = FindRipples(filtered,'durations',[600 500
        % 6000],'thresholds',[2 7]);
        [ripples,stdev,noise] = FindRipples(filtered,'durations',[600 500 6000],'stdev',8E5,'thresholds',[3 5]);
        ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
        Spi=[Spi;ripples];
        % length(Range(spiPeakstemp))
        % spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
        % spiStarts=[spiStarts; Range(spiStartstemp)+rg(1)];
        % spiEnds=[spiEnds; Range(spiEndstemp)+rg(1)];
        %spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
            end
        end
        
   spits=ts(Spi(:,2)*1E4);
%    try     
%        
%        st=Start(LPSEpoch,'s');
%        en=End(LPSEpoch,'s');
%        bef=length(Restrict(spits,intervalSet(0,st(1)*1E4)))/st(1);
%        aft=length(Restrict(spits,intervalSet(st(1)*1E4,en(end)*1E4)))/(en(end)-st(1));
%        disp(' ')
%        disp(['Spindles frequency  before LPS: ',num2str(bef),' Hz'])
%        disp(['Spindles frequency   after LPS: ',num2str(aft),' Hz'])   
%    end
%    
%     try     
%  
%        st=Start(VEHEpoch,'s');
%        en=End(VEHEpoch,'s');
%        bef=length(Restrict(spits,intervalSet(0,st(1)*1E4)))/st(1);
%        aft=length(Restrict(spits,intervalSet(st(1)*1E4,en(end)*1E4)))/(en(end)-st(1));
%        disp(' ')
%        disp(['Spindles frequency  before Veh: ',num2str(bef),' Hz'])
%        disp(['Spindles frequency   after Veh: ',num2str(aft),' Hz'])   
%     end
   
    
end




if Rip

        load LFPdHPC
        LFPh=LFP;
        clear LFP
        thspindles1=4;
        thspindles2=15;

        % clear spiPeaks
        % spiPeaks=[];
        % spiStarts=[];
        % spiEnds=[];
        clear Rip
        clear ripples
        Rip=[];
        for i=1:length(Start(SWSEpoch))
            try
        %     lfp=Restrict(LFPt{numLFP},subset(SWSEpoch,i));
        %     rg=Start(subset(SWSEpoch,i));
           % lfp=tsd(Range(lfp)-rg(1),Data(lfp));
        %     [spiStartstemp, spiEndstemp, spiPeakstemp] = findSpindles(lfp, thspindles1, thspindles2);
        %[spiPeakstemp] = findSpindles2(lfp, thspindles1,thspindles2);
        Filsp=FilterLFP(Restrict(LFPh{numLFPrip},subset(SWSEpoch,i)),[120 200],1024);
        rgFilsp=Range(Filsp,'s');
        filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
        % [ripples,stdev,noise] = FindRipples(filtered,'durations',[600 500
        % 6000],'thresholds',[2 7]);
        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',[3 5],'durations',[30 30 100]);
        ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
        Rip=[Rip;ripples];
        % length(Range(spiPeakstemp))
        % spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
        % spiStarts=[spiStarts; Range(spiStartstemp)+rg(1)];
        % spiEnds=[spiEnds; Range(spiEndstemp)+rg(1)];
        %spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
            end
        end

         ripts=ts(Rip(:,2)*1E4);
%    try     
%        
%        st=Start(LPSEpoch,'s');
%        en=End(LPSEpoch,'s');
%        bef=length(Restrict(ripts,intervalSet(0,st(1)*1E4)))/st(1);
%        aft=length(Restrict(ripts,intervalSet(st(1)*1E4,en(end)*1E4)))/(en(end)-st(1));
%        disp(' ')
%        disp(['Ripples frequency  before LPS: ',num2str(bef),' Hz'])
%        disp(['Ripples frequency   after LPS: ',num2str(aft),' Hz'])   
%    end
%    
%     try     
%  
%        st=Start(VEHEpoch,'s');
%        en=End(VEHEpoch,'s');
%        bef=length(Restrict(ripts,intervalSet(0,st(1)*1E4)))/st(1);
%        aft=length(Restrict(ripts,intervalSet(st(1)*1E4,en(end)*1E4)))/(en(end)-st(1));
%        disp(' ')
%        disp(['Ripples frequency  before Veh: ',num2str(bef),' Hz'])
%        disp(['Ripples frequency   after Veh: ',num2str(aft),' Hz'])   
%     end

end


if 0
    
a=10;

figure, 
set(gcf,'position',[199 577 1798 420])

a=a+10*1E4;Epoch=intervalSet(a,a+10*1E4);
hold on, plot(Range(Restrict(LFPt{numLFP},Epoch)),Data(Restrict(LFPt{numLFP},Epoch)),'color',[0.7 0.7 0.7])
filtemp=FilterLFP(Restrict(LFPt{numLFP},Epoch),[5 10],1024);
hold on, plot(Range(filtemp),Data(filtemp)-5000,'color',[0 0 0.5])
filtemp2=FilterLFP(Restrict(LFPt{numLFP},Epoch),[10 17],1024);
hold on, plot(Range(filtemp2),Data(filtemp2)+5000,'color',[0.5 0 0])
plot(Range(Restrict(LFPt{numLFP},and(SWSEpoch,Epoch))),Data(Restrict(LFPt{numLFP},and(SWSEpoch,Epoch))),'k')
Epoch1s=intervalSet(a,a+1*1E4);
plot(Range(Restrict(LFPt{numLFP},Epoch1s)),Data(Restrict(LFPt{numLFP},Epoch1s)),'color','r')
hold on, plot(Range(Restrict(LFPt{numLFP2},Epoch)),Data(Restrict(LFPt{numLFP2},Epoch))-1E4,'color',[0.2 0.2 0.2])
try
    hold on, plot(Range(Restrict(LFPt{numLFPrip},Epoch)),Data(Restrict(LFPt{numLFPrip},Epoch))+1E4,'b')
end
try
    hold on, plot(Rip(:,2)*1E4,ones(length(Rip),1)*2.3E4,'bo','markerfacecolor','b')
hold on, plot(Rip(:,3)*1E4,ones(length(Rip),1)*2.3E4,'ro')
hold on, plot(Rip(:,1)*1E4,ones(length(Rip),1)*2.3E4,'go')
end
hold on, plot(Spi(:,2)*1E4,-ones(length(Spi),1)*0.5E4,'bo','markerfacecolor','b')
hold on, plot(Spi(:,3)*1E4,-ones(length(Spi),1)*0.5E4,'ro')
hold on, plot(Spi(:,1)*1E4,-ones(length(Spi),1)*0.5E4,'go')
xlim([a a+10E4])
ylim([-20000 25000])



% 
% a=xlim;
% a=a+10E4; xlim([a a+10E4])
% a=a(1); a=a+10E4; xlim([a a+10E4])
% a=a+10E4; xlim([a a+10E4])
% 
% 
% 
% 
% 
% 
% M=PlotRipRaw(LFPt{numLFP},Spi,2000);
% 
% spiPeaks=ts(sort(spiPeaks));
% M=PlotRipRaw(LFPt{numLFP},Range(spiPeaks,'s'),2000);
% 

% figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPt{numLFP}, ts(Spi(:,2)*1E4), -15000, +15000,'BinSize',500);
% M=Data(matVal)';
% C=corrcoef(M(:,1450:2000)');
% 

end



if 0
    
    
figure, [fh, rasterAx, histAx, matVal] = ImagePETH(LFPt{numLFP}, ts(Spi(:,2)*1E4), -15000, +15000,'BinSize',1000);close
M=Data(matVal)';
C=corrcoef(M(:,2100:2500)');

C(isnan(C))=0;
[V,L]=pcacov(C);
pc=V(:,1);
[BE,id]=sort(pc);

% figure, imagesc(M(id,:))
% caxis([-4E3 8E3])

M=Data(matVal)';

M(M>5E3)=5E3;
M(M<-5E3)=-5E3;

Mtsd=tsd(Range(matVal),M');
Mftsd=FilterLFP(Mtsd,[10 25]);

Mf=Data(Mftsd)';

le=size(M,1);

% 
% figure, imagesc(M(id,:)),caxis([-5E3 5E3])
% figure, imagesc(Mf(id,:)),caxis([-5E3 5E3])
% 
% %figure, imagesc(SmoothDec(Mf(id,:),[3 3])),caxis([-5E3 5E3])
% 
% 
% figure, plot(Range(matVal,'ms'),mean(M(1:le/3,:))), hold on, plot(Range(matVal,'ms'),mean(M(2*le/3:le,:)),'r'),title('pre/post')
% figure, plot(Range(matVal,'ms'),mean(Mf(1:le/3,:))), hold on, plot(Range(matVal,'ms'),mean(Mf(2*le/3:le,:)),'r'),title('pre/post filtered')
% 
% figure, plot(Range(matVal,'ms'),mean(M(id(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(M(id(2*le/3:le),:)),'r'),title('pca reorganized')
% figure, plot(Range(matVal,'ms'),mean(Mf(id(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(Mf(id(2*le/3:le),:)),'r'),title('pca reorganized (filtered)')



C=corrcoef(Mf(:,1950:2100)');

C(isnan(C))=0;
[V,L]=pcacov(C);
pc=V(:,1);
[BE,idf]=sort(pc);


% 
% figure, imagesc(M(idf,:)),caxis([-5E3 5E3])
% figure, imagesc(Mf(idf,:)),caxis([-5E3 5E3])
% 
% %figure, imagesc(SmoothDec(Mf(id,:),[3 3])),caxis([-5E3 5E3])

% 
% figure, plot(Range(matVal,'ms'),mean(M(1:le/3,:))), hold on, plot(Range(matVal,'ms'),mean(M(2*le/3:le,:)),'r'),title('pre/post')
% figure, plot(Range(matVal,'ms'),mean(Mf(1:le/3,:))), hold on, plot(Range(matVal,'ms'),mean(Mf(2*le/3:le,:)),'r'),title('pre/post filtered')
% 
% figure, plot(Range(matVal,'ms'),mean(M(idf(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(Mf(id(2*le/3:le),:)),'r'),title('pca reorganized on high frequencies')
% figure, plot(Range(matVal,'ms'),mean(Mf(idf(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(Mf(idf(2*le/3:le),:)),'r'),title('pca reorganized on high frequencies (filtered)')
% 





figure, [fh, rasterAx, histAx, matVal2] = ImagePETH(LFPt{numLFP2}, ts(Spi(:,2)*1E4), -15000, +15000,'BinSize',1000);close

M2=Data(matVal2)';

M2tsd=tsd(Range(matVal2),M2');
M2ftsd=FilterLFP(M2tsd,[10 25]);

M2f=Data(M2ftsd)';

% 
% figure, imagesc(M2(idf,:)),caxis([-5E3 5E3])
% figure, imagesc(M2f(idf,:)),caxis([-5E3 5E3])
% 
% %figure, imagesc(SmoothDec(Mf(id,:),[3 3])),caxis([-5E3 5E3])
% 
% 
% figure, plot(Range(matVal2,'ms'),mean(M2(1:le/3,:))), hold on, plot(Range(matVal2,'ms'),mean(M2(2*le/3:le,:)),'r'),title('pre/post EEG')
% figure, plot(Range(matVal2,'ms'),mean(M2f(1:le/3,:))), hold on, plot(Range(matVal2,'ms'),mean(M2f(2*le/3:le,:)),'r'),title('pre/post filtered EEG')
% 
% figure, plot(Range(matVal2,'ms'),mean(M2(idf(1:le/3),:))), hold on, plot(Range(matVal2,'ms'),mean(M2f(id(2*le/3:le),:)),'r'),title('pca reorganized on high frequencies EEG')
% figure, plot(Range(matVal2,'ms'),mean(M2f(idf(1:le/3),:))), hold on, plot(Range(matVal2,'ms'),mean(M2f(idf(2*le/3:le),:)),'r'),title('pca reorganized on high frequencies EEG (filtered)')









le=size(M,1);
figure, plot(Range(matVal,'ms'),mean(M(1:le/3,:))), hold on, plot(Range(matVal,'ms'),mean(M(2*le/3:le,:)),'r'),title('pre/post')
plot(Range(matVal2,'ms'),mean(M2(1:le/3,:)),'k'), hold on, plot(Range(matVal2,'ms'),mean(M2(2*le/3:le,:)),'g'),title('pre/post EEG')
xlim([-500 500])
figure, plot(Range(matVal,'ms'),mean(Mf(1:le/3,:))), hold on, plot(Range(matVal,'ms'),mean(Mf(2*le/3:le,:)),'r'),title('pre/post filtered')
plot(Range(matVal2,'ms'),mean(M2f(1:le/3,:)),'k'), hold on, plot(Range(matVal2,'ms'),mean(M2f(2*le/3:le,:)),'g'),title('pre/post filtered EEG')
xlim([-500 500])

figure, plot(Range(matVal,'ms'),mean(M(id(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(Mf(id(2*le/3:le),:)),'r'),title('pca reorganized')
plot(Range(matVal2,'ms'),mean(M2(id(1:le/3),:)),'k'), hold on, plot(Range(matVal2,'ms'),mean(M2f(id(2*le/3:le),:)),'g'),title('pca reorganized EEG')
xlim([-500 500])
figure, plot(Range(matVal,'ms'),mean(Mf(id(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(Mf(id(2*le/3:le),:)),'r'),title('pca reorganized (filtered)')
plot(Range(matVal2,'ms'),mean(M2f(id(1:le/3),:)),'k'), hold on, plot(Range(matVal2,'ms'),mean(M2f(id(2*le/3:le),:)),'g'),title('pca reorganized (filtered)')
xlim([-500 500])

figure, plot(Range(matVal,'ms'),mean(M(idf(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(Mf(idf(2*le/3:le),:)),'r'),title('pca reorganized on high frequencies')
plot(Range(matVal2,'ms'),mean(M2(idf(1:le/3),:)),'k'), hold on, plot(Range(matVal2,'ms'),mean(M2f(idf(2*le/3:le),:)),'g'),title('pca reorganized on high frequencies EEG')
xlim([-500 500])
figure, plot(Range(matVal,'ms'),mean(Mf(idf(1:le/3),:))), hold on, plot(Range(matVal,'ms'),mean(Mf(idf(2*le/3:le),:)),'r'),title('pca reorganized on high frequencies (filtered)')
plot(Range(matVal2,'ms'),mean(M2f(idf(1:le/3),:)),'k'), hold on, plot(Range(matVal2,'ms'),mean(M2f(idf(2*le/3:le),:)),'g'),title('pca reorganized on high frequencies EEG (filtered)')
xlim([-500 500])
% 
% 124805210
% 121305210
% 
% 79005210
% 77105210
% 74105210
% 53205210
% 45905210


end

