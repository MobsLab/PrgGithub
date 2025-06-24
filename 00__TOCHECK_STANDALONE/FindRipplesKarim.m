function Rip=FindRipplesKarim(LFP,Epoch,par)
%    
%Rip=FindRipplesKarim(LFP,Epoch)

try
    Epoch;
catch
    rg=Range(LFP);
    Epoch=intervalSet(rg(1),rg(end));
end

try
    par;
catch
    par=[5,7];
end

   clear Rip
        clear ripples
        Rip=[];
        for i=1:length(Start(Epoch))
  %          try
        %     lfp=Restrict(LFPt{numLFP},subset(SWSEpoch,i));
        %     rg=Start(subset(SWSEpoch,i));
           % lfp=tsd(Range(lfp)-rg(1),Data(lfp));
        %     [spiStartstemp, spiEndstemp, spiPeakstemp] = findSpindles(lfp, thspindles1, thspindles2);
        %[spiPeakstemp] = findSpindles2(lfp, thspindles1,thspindles2);
        Filsp=FilterLFP(Restrict(LFP,subset(Epoch,i)),[120 200],96);
        rgFilsp=Range(Filsp,'s');
        filtered=[rgFilsp-rgFilsp(1) Data(Filsp)];
        % [ripples,stdev,noise] = FindRipples(filtered,'durations',[600 500
        % 6000],'thresholds',[2 7]);
        [ripples,stdev,noise] = FindRipples(filtered,'thresholds',par,'durations',[30 30 100]);
        ripples(:,1:3)=ripples(:,1:3)+rgFilsp(1);
        Rip=[Rip;ripples];
        % length(Range(spiPeakstemp))
        % spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
        % spiStarts=[spiStarts; Range(spiStartstemp)+rg(1)];
        % spiEnds=[spiEnds; Range(spiEndstemp)+rg(1)];
        %spiPeaks=[spiPeaks; Range(spiPeakstemp)+rg(1)];
   %         end
        end
