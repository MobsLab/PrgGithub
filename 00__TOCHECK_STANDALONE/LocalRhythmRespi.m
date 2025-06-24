%LocalRhythmRespi


% cd \\NASDELUXE\DataMOBsRAID5\ProjetAstro
% 
% try   
%     load DataLocalRespi
%     filRespi;
% catch 
%     load LFPData
%     load StateEpoch
% end

try
    LFP;
    filRespiR;
catch
    
        load LFPData
        load StateEpoch
        try
            ListLFP;
        catch
            load ListLFP
        end
try
        listBulb=listLFP.channels{strcmp(listLFP.name,'Bulb')};
catch
    listBulb=[];
end
        listPFC=listLFP.channels{strcmp(listLFP.name,'PFCx')};
        listPar=listLFP.channels{strcmp(listLFP.name,'PaCx')};
        listAud=listLFP.channels{strcmp(listLFP.name,'AuCx')};
        listHpc=listLFP.channels{strcmp(listLFP.name,'dHPC')};

        figure('color',[1 1 1])
        k=1;
        if length(listBulb)>1
        for j=listBulb
        hold on, plot(Range(LFP{j},'s'), Data(LFP{j})+k*3E-4,'b')
        k=k+1;
        end
        end
        for j=listPFC
        hold on, plot(Range(LFP{j},'s'), Data(LFP{j})+k*3E-4,'r')
        k=k+1;
        end
        for j=listPar
        hold on, plot(Range(LFP{j},'s'), Data(LFP{j})+k*3E-4,'color','k')
        k=k+1;
        end
        for j=listAud
        hold on, plot(Range(LFP{j},'s'), Data(LFP{j})+k*3E-4,'color',[0 0.7 1])
        k=k+1;
        end
        for j=listHpc
        hold on, plot(Range(LFP{j},'s'), Data(LFP{j})+k*3E-4,'color',[0.4 0.2 1])
        k=k+1;
        end
        hold on, plot(Range(RespiTSD,'s'), -SmoothDec(Data(RespiTSD)/10,7),'color','k','linewidth',2)
        xlim([600 602])

end

if 1

    lagMax=1000;
    repet=10;

    freqen=[40 100];
     ti='high gamma 40-100Hz';
%     ti='beta 20-40Hz';
 %   ti='theta 5-15Hz';
 %   ti='delta 2-6Hz';
    
    figure('color',[1 1 1])
    %filRespi=FilterLFP(RespiTSD,[1 6],1024);
    filRespi=FilterLFP(RespiTSD,[0.1 30],1024);
    %filRespi=FilterLFP(LFP{5},[0.1 30],1024);
    Freq=1/median(diff(Range(filRespi,'s')));

    if length(listBulb)>1
    listT=[listBulb listPFC listPar listAud listHpc];
    else
    listT=[listPFC listPar listAud listHpc];    
    end
    
    k=1;
    for i=listT

            filPfc=FilterLFP(LFP{i},freqen,128);
 if 1
            Epoch=and(MovEpoch,ThetaEpoch);
            filPfcR=Restrict(filPfc,Epoch);
            filRespiR=Restrict(filRespi,Epoch);
            h=abs(hilbert(Data(Restrict(filPfcR,filRespiR))));
            % [C,lag]=xcorr(zscore(h),Data(filRespiR),lagMax,'coeff');
            try
            [C,lag,P,CPM,CPm]=StatsXcorr(zscore(h),-Data(filRespiR),Freq,repet);
            subplot(4,4,k), hold on
            plot(lag/Freq,C,'r','linewidth',2)
            plot(lag/Freq,CPM,'color',[1 0.7 0.7])
            plot(lag/Freq,CPm,'color',[1 0.7 0.7])
            end
 end
            
 
            Epoch=SWSEpoch;
            %Epoch=REMEpoch;
            %Epoch=and(MovEpoch,ThetaEpoch);

            filPfcR=Restrict(filPfc,Epoch);
            filRespiR=Restrict(filRespi,Epoch);
            h=abs(hilbert(Data(Restrict(filPfcR,filRespiR))));
            %[C,lag]=xcorr(zscore(h),Data(filRespiR),lagMax,'coeff');
            try
            [C,lag,P,CPM,CPm]=StatsXcorr(zscore(h),-Data(filRespiR),Freq,repet);
            subplot(4,4,k), hold on
            plot(lag/Freq,C,'linewidth',2)
            plot(lag/Freq,CPM,'color',[0.7 0.7 0.7])
            plot(lag/Freq,CPm,'color',[0.7 0.7 0.7])
            end

            Epoch=REMEpoch;
            filPfcR=Restrict(filPfc,Epoch);
            filRespiR=Restrict(filRespi,Epoch);
            h=abs(hilbert(Data(Restrict(filPfcR,filRespiR))));
            % [C,lag]=xcorr(zscore(h),Data(filRespiR),lagMax,'coeff');
            try
            [C,lag,P,CPM,CPm]=StatsXcorr(zscore(h),-Data(filRespiR),Freq,repet);
            subplot(4,4,k), hold on
            plot(lag/Freq,C,'k','linewidth',2)
            plot(lag/Freq,CPM,'color',[0.7 0.7 0.7])
            plot(lag/Freq,CPm,'color',[0.7 0.7 0.7])
            end
           
            title(num2str(i))
            k=k+1;
    end

    for i=1:length(LFP)
    subplot(4,4,i),xlim([-0.4 0.4])
    end

    subplot(4,4,1), title(ti)

end
