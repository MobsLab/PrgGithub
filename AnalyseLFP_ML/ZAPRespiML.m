function [Mt,tpsT,PeriodRespi,NbRespi,Namemanipe,Structure]=ZAPRespiML(PathMan,Nsouris,Mt,tpsT,NbRespi,PeriodRespi,State,Freqq,Fillt)

%[Mt,tpsT,PeriodRespi,NbRespi]=ZAPRespiML(PathMan,tpsT,NbRespi,PeriodRespi,State,Freqq,Fillt)
% inputs:
% State = Vigilance state 'SWSEpoch' 'REMEpoch' 'MovEpoch' (default 'SWS')
% Freqq = Effect on LFP (Freqq==0) or power (on sepcified frequencies, use [30 65] or [65 120])
% Fillt = Effect on raw LFP (Fillt=0) or filtered LFP (Fillt=[freq min ... freq max]) !!!!! only if Freqq=0 !!!
% resc = 1 rescale the value of power (ie see only the presence of  modulation)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CHECK INPUTS
%--------------------------------------------------------------------------
if ~exist('State','var')
    State='SWSEpoch';
end
if ~exist('Freqq','var')
    Freqq=0;
end
if ~exist('Fillt','var')
    Fillt=0;
end
%--------------------------------------------------------------------------

Structure={'Bulb_deep' 'PFCx_deep' 'PaCx_deep' 'dHPC_deep'};
fac=[1 3 3 3];
RespiRangePeriod=50*[1:15]; % ms
Namemanipe=PathMan;

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOAD DATA LFP AND RESPI

eval(['TempLoad=load(''',PathMan,'/LFPData.mat'',''LFP'',''NormRespiTSD'',''Frequency'');'])
FreqTSD=TempLoad.Frequency; NormRespiTSD=TempLoad.NormRespiTSD;  LFP=TempLoad.LFP; 
eval(['load(''',PathMan,'/StateEpoch.mat'',''',State,''');']) 
eval(['epoch=',State,';']);

listT=[];
for st=1:length(Structure)
    clear channel;
    eval(['load(''',PathMan,'/ChannelsToAnalyse/',Structure{st},'.mat'');']);
    if ~exist('channel','var') || (exist('channel','var') && isempty(channel))
        listT=[listT, -1];
        disp(['No LFP ',Structure{st}])
    else
        listT=[listT, channel];
    end
end

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RANGE OF BREATHING FREQUENCIES

figure('color',[1 1 1],'position', [200 95 522 883]),hold on

disp('Computing ZAP respi');warning off
for i=1:length(RespiRangePeriod)-1
    try 
        freqH=thresholdIntervals(FreqTSD,1E3/RespiRangePeriod(i),'Direction','Below');
        freqL=thresholdIntervals(FreqTSD,1E3/RespiRangePeriod(i+1),'Direction','Above');
        freqStep=and(and(freqL,freqH),epoch);
        
        %filter respi
        if length(Fillt)>1
            RespiTSDplot=FilterLFP(NormRespiTSD,Fillt,128);
        else
            RespiTSDplot=NormRespiTSD;
        end
        
        [m,s,tps]=mETAverage(Range(Restrict(FreqTSD,freqStep)),Range(RespiTSDplot),-Data(RespiTSDplot),1,2000);
        
        if length(size(Mt))==3 && size(Mt,1)>=Nsouris && size(Mt,3)>=i && ~isempty( Mt{Nsouris,1,i}) 
            % pool data from same mouse. Attention si plus de 2
            % enregistrements pr meme souris: moyenne ponderee !
            fprintf(['av',num2str(i),' '])
            Mt{Nsouris,1,i}=nanmean([m,Mt{Nsouris,1,i}],2);
        else
            Mt{Nsouris,1,i}=m;
        end
        tpsT{Nsouris,1,i}=tps;
        NbRespi{Nsouris,i}=Range(Restrict(FreqTSD,freqStep));
        PeriodRespi{Nsouris,i}=[RespiRangePeriod(i),RespiRangePeriod(i+1)];% ms
        plot(tps,RespiRangePeriod(i)+1.5E5*m,'color',[ i/length(RespiRangePeriod) 0 (length(RespiRangePeriod)-i)/length(RespiRangePeriod)],'linewidth',2)
    catch
        disp('Problem'); keyboard
    end
end
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title(['Breathing ', State])
line([0 700],[0 750],'color','k','linewidth',2)
ylim([0 1E3])


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LFP FOR BREATHING FREQUENCIES
di=0;
Nelec=1;
eval(['load(''',PathMan,'/LFPData/InfoLFP.mat'');']) 

for num=listT(listT~=-1)
    Nelec=Nelec+1;
    
    try
        disp(['Computing ZAP ',InfoLFP.structure{InfoLFP.channel==num}])
        % filter LFP
        if length(Freqq)>1
            Filtemp=FilterLFP(LFP{num},Freqq,128);
            h=hilbert(Data(Filtemp));
            Fil=tsd(Range(Filtemp),zscore(SmoothDec(abs(h),5))*10);
            if di==0
                disp('Power')
                di=1;
            end
        else
            if length(Fillt)>1
                Filtemp=FilterLFP(LFP,Fillt,128);
                Fil=Filtemp{num};
            else
                Fil=LFP{num};
            end
        end
        
        
        % display LFP zap
        figure('color',[1 1 1],'position',[680 95 522 883]), hold on
        for i=1:length(RespiRangePeriod)-1
            try
                freqH=thresholdIntervals(FreqTSD,1E3/RespiRangePeriod(i),'Direction','Below');
                freqL=thresholdIntervals(FreqTSD,1E3/RespiRangePeriod(i+1),'Direction','Above');
                freqStep=and(and(freqL,freqH),epoch);
                
                [m,s,tps]=mETAverage(Range(Restrict(FreqTSD,freqStep)),Range(Fil),Data(Fil),1,2000);

                if length(size(Mt))==3 && size(Mt,1)>=Nsouris && size(Mt,2)>=Nelec && size(Mt,3)>=i && ~isempty( Mt{Nsouris,Nelec,i})
                   Mt{Nsouris,Nelec,i}=nanmean([m,Mt{Nsouris,Nelec,i}],2);
                   fprintf(['av',num2str(i),' '])
                else
                    Mt{Nsouris,Nelec,i}=m;
                end
                tpsT{Nsouris,Nelec,i}=tps;
                
                if length(Freqq)>1
                    plot(tps,RespiRangePeriod(i)+fac(Nelec-1)*1E5*m,'color',[0.6 0.6 0.6],'linewidth',1)
                    plot(tps,RespiRangePeriod(i)+fac(Nelec-1)*1E5*SmoothDec(m,15),'color',[0 i/16 (16-i)/16],'linewidth',2)
                else
                    plot(tps,RespiRangePeriod(i)+fac(Nelec-1)*1E5*m,'color',[0 i/16 (16-i)/16],'linewidth',2)
                end
            catch
                disp('Problem');keyboard
            end
        end
        yl=ylim;
        line([0 0],yl,'color',[0.7 0.7 0.7])
        line([0 700],[0 750],'color','k','linewidth',2)
        
        try
            title([num2str(num),'- ',InfoLFP.structure{InfoLFP.channel==num},', ',State])
        end
        ylim([0 1E3])
    catch
        disp('PROBLEM'); keyboard
    end
end
warning on
