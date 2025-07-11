%RespirationByDeltaML

% inputs:
% DisSingle = 1 to display LFP at single Delta wave time, 0 otherwise
% sav = 1 to save figures, 0 otherwise



%% initialize
namestruct={'PaCx','PFCx'};
DeltaType={'tDeltaP2','tDeltaT2'};

DisSingle=0;
sav=1;

FolderToSaveFigure='/media/DataMOBsRAID5/ProjetAstro/DataPlethysmo/Analyse_DeltaRespi';
res=pwd;
nameFigure=['RespiByDelta_',res(max(strfind(pwd,'Mouse')):end)];

try nameFigure(strfind(nameFigure,'/'))='-';end


%% load Delta and RespiTSD

load('LFPData.mat','RespiTSD')
for ss=1:length(namestruct)
    eval(['load(''Delta',namestruct{ss},'.mat'')'])
    
    %% load LFPs
    eval(['load(''ChannelsToAnalyse/',namestruct{ss},'_deep.mat'')'])
    eval(['load(''LFPData/LFP',num2str(channel),'.mat'')']);
    LFPdeep=LFP;
    eval(['load(''ChannelsToAnalyse/',namestruct{ss},'_sup.mat'')'])
    eval(['load(''LFPData/LFP',num2str(channel),'.mat'')']);
    LFPsup=LFP;
    
    %% types of Delta and structures
    for dd=1:length(DeltaType)
        
        disp(['Computing ',DeltaType{dd},' from ',namestruct{ss},'...'])
        
        try
            eval(['tDelta=',DeltaType{dd},';']);
            %% display LFP at single Delta wave time
            if DisSingle
                figure, plot(Range(LFPdeep,'s'),Data(LFPdeep))
                hold on, plot(Range(LFPsup,'s'),Data(LFPsup)+1/1E3,'r')
                legend({[namestruct{ss},'-deep'],[namestruct{ss},'-sup']})
                
                tpsDelta=Range(tDelta,'s');
                for i=1:length(tpsDelta)
                    xlim([tpsDelta(i)-7,tpsDelta(i)+7])
                    line([tpsDelta(i) tpsDelta(i)],[-1 2]/1E3,'Color','g')
                    pause
                end
            end
            
            
            %% compute Respiration averaged on Delta waves
            tbins=4;nbbins=300;
            [mDsup,sDsup,tpsDsup]=mETAverage(Range(tDelta), Range(LFPsup),Data(LFPsup),tbins,nbbins);
            [mDdeep,sDdeep,tpsDdeep]=mETAverage(Range(tDelta), Range(LFPdeep),Data(LFPdeep),tbins,nbbins);
            [mRespi,sRespi,tpsRespi]=mETAverage(Range(tDelta), Range(RespiTSD),Data(RespiTSD),tbins,nbbins);
            
            
            %% display averaged
            
            if dd==1 && ss==1
                figure('Color',[1 1 1]), numF=gcf; 
            end
            
            subplot(2,2,(dd-1)*2+ss)
            % 5% values LFP et Respi
            [n,xout]=hist(Data(LFPsup),100); Ratiosup=xout([min(find(n>sum(n)*0.01)),max(find(n>sum(n)*0.01))]);
            plot(tpsDsup,mDsup,'Color','b','linewidth',2)
            
            [n,xout]=hist(Data(LFPdeep),100); Ratiodeep=xout([min(find(n>sum(n)*0.05)),max(find(n>sum(n)*0.05))]);
            hold on, plot(tpsDdeep,mDdeep*diff(Ratiosup)/diff(Ratiodeep),'k','linewidth',2),
            
            [n,xout]=hist(Data(RespiTSD),100); RatioRespi=xout([min(find(n>sum(n)*0.05)),max(find(n>sum(n)*0.05))]);
            plot(tpsRespi,mRespi*diff(Ratiosup)/diff(RatioRespi),'r','linewidth',2),
            
            legend({'Sup','deep','Respi'})
            xlim([-1 1]*nbbins*tbins/2); ylabel('Amplitude (normalized)')
            xlabel(['Respi by ',namestruct{ss},' ',DeltaType{dd},' event (n=',num2str(length(Range(tDelta))),')'])
            title(nameFigure)
            
            % sd
            hold on, plot(tpsDsup,mDsup+sDsup,'Color','b'), plot(tpsDsup,mDsup-sDsup,'Color','b'),
            hold on, plot(tpsDdeep,mDdeep+sDdeep,'Color','k'), plot(tpsDdeep,mDdeep-sDdeep,'Color','k'),
            hold on, plot(tpsRespi,mRespi+sRespi,'Color','r'), plot(tpsRespi,mRespi-sRespi,'Color','r'),
            
        end
    end
end

%% save Figures
if sav
    saveFigure(numF,nameFigure,FolderToSaveFigure)
end