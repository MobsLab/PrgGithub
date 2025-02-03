function [Mt,tpsT,PeriodRespi,NbRespi,Namemanipe]=ZAPRespi2(Nsouris,Mt,tpsT,NbRespi,PeriodRespi,Namemanipe,State,Freqq,Fillt,resc,fac)

%[Mt,tpsT,Namemanipe]=ZAPRespi2(Nsouris,Mt,tpsT,NbRespi,PeriodRespi,Namemanipe,Fillt,Freqq,State,resc,fac)
% inputs:
% State = Vigilance state 'SWS' 'REM' 'Wake' (default 'SWS')
% Freqq = Effect on LFP (Freqq==0) or power (on sepcified frequencies, use [30 65] or [65 120])
% Fillt = Effect on raw LFP (Fillt=0) or filtered LFP (Fillt=[freq min ... freq max]) !!!!! only if Freqq=0 !!!
% resc = 1 rescale the value of power (ie see only the presence of  modulation)

%% Check inputs
%--------------------------------------------------------------------------
if ~exist('State','var')
    State='SWS';
end
%--------------------------------------------------------------------------
if ~exist('Fillt','var')
    Fillt=0;
end
%--------------------------------------------------------------------------
if ~exist('Freqq','var')
    Freqq=0;
end
%--------------------------------------------------------------------------
if ~exist('resc','var')
    resc=0;
end
%--------------------------------------------------------------------------
if ~exist('fac','var')
    fac=2E4;
end
%--------------------------------------------------------------------------

%% start
Namemanipe{Nsouris}=pwd;

try
    LFP;
catch
    load LFPData
    load StateEpoch
end

listTnames={'Bulb_deep' 'PFCx_deep' 'PaCx_deep' 'dHPC_deep'};

%--------------------------------------------------------------------------

%         try
%             ListLFP;
%         catch
%             try
%                 load listLFP
%                 ListLFP=listLFP;
%             catch
%                 load ListLFP
%             end
%
%         end
%
%         try
%             listBulb=listLFP.channels{strcmp(listLFP.name,'Bulb')};
%         catch
%             listBulb=[];
%         end
%         listPFC=listLFP.channels{strcmp(listLFP.name,'PFCx')};
%         listPar=listLFP.channels{strcmp(listLFP.name,'PaCx')};
%         listAud=listLFP.channels{strcmp(listLFP.name,'AuCx')};
%         listHpc=listLFP.channels{strcmp(listLFP.name,'dHPC')};
%
%     if length(listBulb)>1
%     listT=[listBulb listPFC listPar listAud listHpc];
%     else
%     listT=[listPFC listPar listAud listHpc];
%     disp('no bulb')
%     end




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


listT=[];
for ind_listTnames=1:length(listTnames)
    clear channel;
    load(['ChannelsToAnalyse/',listTnames{ind_listTnames},'.mat']);
    if ~exist('channel','var') || (exist('channel','var') && isempty(channel))
        listT=[listT, -1];
        disp(['No LFP ',listTnames{ind_listTnames}])
    else
        listT=[listT, channel];
    end
end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

[zeroCrossTsd,AmplitudeRespi,zeroCross,zeroMeanValue]=FindZeroCross(RespiTSD,[0 7]);

if 0
    ParameterRespi=AmplitudeRespi;
else
    temp=Range(zeroCrossTsd);
    tdiff=diff(zeroCross);
    if mean(tdiff(1:2:end))<mean(tdiff(2:2:end))
        ParameterRespi=ts(temp(1:2:end));
    else
        ParameterRespi=ts(temp(2:2:end));
    end
end

if strcmp(State,'SWS')
    td=Range(Restrict(ParameterRespi,SWSEpoch));
elseif strcmp(State,'REM')
    td=Range(Restrict(ParameterRespi,REMEpoch));
elseif strcmp(State,'Wake')
    td=Range(Restrict(ParameterRespi,and(MovEpoch,ThetaEpoch)));
end

AmpDiff=tsd(td(2:end),diff(td)/10);
%AmpDiff=tsd(td(1:end-1),diff(td)/10);
%
% ddiffTD=diff(td)/10;
% AmpDiff=tsd(td(3:2:end),ddiffTD(2:2:end));

figure('color',[1 1 1]),hold on

for i=[1:15]
    try
        smallDiff1=thresholdIntervals(AmpDiff,(i)*50,'Direction','Below');
        smallDiff2=thresholdIntervals(AmpDiff,(i-1)*50,'Direction','Above');
        smallDiff=and(smallDiff1,smallDiff2);
        if length(Fillt)>1
            RespiTSDplot=FilterLFP(RespiTSD,Fillt,128);
        else
            RespiTSDplot=RespiTSD;
        end
        [m,s,tps]=mETAverage(Range(Restrict(AmpDiff,smallDiff)),Range(RespiTSDplot),-Data(RespiTSDplot),1,2000);
        Mt{Nsouris,1,i}=m;
        tpsT{Nsouris,1,i}=tps;
        NbRespi{Nsouris,i}=Range(Restrict(AmpDiff,smallDiff));
        PeriodRespi{Nsouris,i}=[(i-1)*50,(i)*50];%ms
        plot(tps,i/100+m,'color',[ i/16 0 (16-i)/16],'linewidth',2)
    end
end
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
set(gcf,'position', [200    95   522   883])
title(['Breathing ', State])
line([-750 0],[0.15 0],'color','k','linewidth',2)
ylim([0 0.2])


di=0;
Nelec=1;

if 1
    for num=listT
        
        Nelec=Nelec+1;
        
        try
            
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
            
            
            
            figure('color',[1 1 1]),hold on
            for i=[1:15]
                try
                    smallDiff1=thresholdIntervals(AmpDiff,(i)*50,'Direction','Below');
                    smallDiff2=thresholdIntervals(AmpDiff,(i-1)*50,'Direction','Above');
                    smallDiff=and(smallDiff1,smallDiff2);
                    [m,s,tps]=mETAverage(Range(Restrict(AmpDiff,smallDiff)),Range(Fil),Data(Fil),1,2000);
                    
                    Mt{Nsouris,Nelec,i}=m;
                    tpsT{Nsouris,Nelec,i}=tps;
                    
                    if length(Freqq)>1
                        if resc
                            plot(tps,i/5E3+rescale(m,0,2E-4),'color',[0.6 0.6 0.6],'linewidth',1)
                            plot(tps,i/5E3+SmoothDec(rescale(m,0,2E-4),15),'color',[0 i/16 (16-i)/16],'linewidth',2)
                        else
                            plot(tps,i/5E3+m/fac,'color',[0.6 0.6 0.6],'linewidth',1)
                            plot(tps,i/5E3+SmoothDec(m/fac,15),'color',[0 i/16 (16-i)/16],'linewidth',2)
                        end
                    else
                        plot(tps,i/5E3+m,'color',[0 i/16 (16-i)/16],'linewidth',2)
                    end
                end
            end
            set(gcf,'position', [680    95   522   883])
            yl=ylim;
            line([0 0],yl,'color',[0.7 0.7 0.7])
            line([-750 0],[3*1E-3 0],'color','k','linewidth',2)
            line([100 100],[3*1E-3 0],'color',[0.7 0.7 0.7],'linewidth',2)
            try
                if ismember(num,listLFP.channels{strcmp(listLFP.name,'PFCx')})
                    title([num2str(num),' PFC ',State])
                elseif ismember(num,listLFP.channels{strcmp(listLFP.name,'dHPC')})
                    title([num2str(num),' dHpc ',State])
                elseif ismember(num,listLFP.channels{strcmp(listLFP.name,'PaCx')})
                    title([num2str(num),' Par Cx ',State])
                elseif ismember(num,listLFP.channels{strcmp(listLFP.name,'AuCx')})
                    title([num2str(num),' Aud Cx ',State])
                elseif ismember(num,listLFP.channels{strcmp(listLFP.name,'Bulb')})
                    title([num2str(num),' Bulb ',State])
                end
            end
            %title([num2str(num),' ',State])
            ylim([0 4E-3])
        end
    end
    
end
