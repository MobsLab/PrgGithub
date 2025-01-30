function spi=RealignSpindlesAd(LFP,spindles)

h = waitbar(0,'Please wait...');
% figure(1),hold on
a=1;
for i=1:size(spindles,1)
     waitbar(i/size(spindles,1),h)
%     spiepoch=intervalSet(spindles(i,1)*1E4,spindles(i,2)*1E4);
   try
       
    spiepoch=intervalSet((spindles(i,1)-0.5)*1E4,(spindles(i,2)+0.5)*1E4);    
    [BE,id]=min(Data(FilterLFP(Restrict(LFP,spiepoch),[10 16],128)));
    [BE2,id2]=max(abs(hilbert(Data(FilterLFP(Restrict(LFP,spiepoch),[10 16],128)))));
    
    [BEb,idb]=min(Data(FilterLFP(Restrict(LFP,spiepoch),[1 20],128)));
    [BE2b,id2b]=max(abs(hilbert(Data(FilterLFP(Restrict(LFP,spiepoch),[1 20],128)))));
    
 %   clf
%     plot(Range(Restrict(LFP,spiepoch),'ms')-rg(1),Data(Restrict(LFP,spiepoch)))
%     hold on, plot(Range((FilterLFP(Restrict(LFP,spiepoch),[2 20],128)),'ms')-rg(1),Data((FilterLFP(Restrict(LFP,spiepoch),[2 20],128))),'r')
%     pause(1)
    rg=Range(Restrict(LFP,spiepoch),'s');

    tpeak(a)=rg(idb);
    amp(a)=BE2b;
    
    tpeak2(a)=rg(id);
    amp2(a)=BE2;
    
    a=a+1;
   end
end
close (h)

spi=spindles;
spi(:,1)=spindles(:,1);
spi(:,2)=tpeak;
spi(:,3)=spindles(:,2);
spi(:,4)=amp;
spi(:,5)=tpeak2;
spi(:,6)=amp2;
spi(:,7)=spindles(:,3);