% AnalyseOBsubstages_SleepCycle.m
%
% see also:
% 1. AnalyseOBsubstages_Bilan.m
% 2. AnalyseOBsubstages_BilanRespi.m
% 3. AnalyseOBsubstages_NREMsubstages.m
% 4. AnalyseOBsubstages_NREMsubstagesPlethysmo.m
% 5. AnalyseOBsubstages_Rhythms.m
% 6. AnalyseOBsubstages_SleepCycle.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages';
res='/media/DataMOBsRAID/ProjetAstro/AnalyseOBsubstages/AnalysesOB';

ZTh=[11,12.5; 16.5,18]*3600;%en second
freq=[2 4];

SavFig=1;

colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

strains=unique(Dir.group);
NamesStages={'WAKE','REM','N1','N2','N3'};

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<< OB spectrum at transitions <<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% ---------------------- compute ---------------------------
clear MatBAR
try 
    load([res,'/',Analyname]); MatBAR;
    disp([Analyname,' already exists. Loaded.'])
   
catch
    
    MatBAR=nan(6,length(Dir.path),length(NamesStages),3);
    MatSP=nan(6,length(Dir.path),length(NamesStages),length(Xbin));
    MatSpZT=nan(4,length(Dir.path),length(NamesStages),length(Xbin));
    %
    for man=1:length(Dir.path)
        %
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        %%%%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE REM N1 N2 N3 noise
        disp('- RunSubstages.m')
        try  [WAKE,REM,N1,N2,N3,~,~,noise]=RunSubstages;close; end
        if exist('WAKE','var')
            
            
            %%%%%%%%%%%%%%%%%% GET OB spectrum %%%%%%%%%%%%%%%%%%%
            clear channel Sp t f
            disp('... loading low Spectrum Bulb_deep')
            load ChannelsToAnalyse/Bulb_deep.mat channel
            eval(['load SpectrumDataL/Spectrum',num2str(channel),'.mat Sp t f'])
            SpOB=tsd(t*1E4,Sp);
            
            %%%%%%%%%%%%%%%%% trig at starts and ends %%%%%%%%%%%%%%%%%%%%
            NamesStages={'REM','N3','WAKE'};
            for nn=1:length(NamesStages)
                eval(['epoch=',NamesStages{nn},';'])
                epoch=mergeCloseIntervals(epoch,5*1E4);
                epoch=dropShortIntervals(epoch,5*1E4);
                Sta=Start(epoch);Sto=Stop(epoch);
                Good=find(Sta>5*1E4 & Sto<max(t)*1E4);
                Sta=Sta(Good); Sto=Sto(Good);
                
                Ista=intervalSet(Sta-5*1E4,Sta+5*1E4);
                Isto=intervalSet(Sto-5*1E4,Sto+5*1E4);
                MatSta=zeros(50,length(f));
                MatSto=zeros(50,length(f));
                MatBar=nan(length(Sta),4);
                for s=1:length(Sta)
                    tempSta=Data(Restrict(SpOB,subset(Ista,s)));
                    MatSta=MatSta+tempSta;
                    MatBar(s,1)=mean(mean(tempSta(1:25,f>=freq(1) & f<freq(2))));
                    MatBar(s,2)=mean(mean(tempSta(26:50,f>=freq(1) & f<freq(2))));
                    tempSto=Data(Restrict(SpOB,subset(Isto,s)));
                    MatSto=MatSto+tempSto;
                    MatBar(s,3)=mean(mean(tempSto(1:25,f>=freq(1) & f<freq(2))));
                    MatBar(s,4)=mean(mean(tempSto(26:50,f>=freq(1) & f<freq(2))));
                end
                MatSta=MatSta/length(Sta);
                MatSto=MatSto/length(Sta);
                
                % display
                if ploIndiv
                    if nn==1, figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.35 0.4]),end
                    subplot(2,length(NamesStages),nn), imagesc(-5:1/51:5,f,10*log10(MatSta')); axis xy;
                    line([0 0],ylim,'Color',[0.5 0.5 0.5]); caxis([30 65])
                    title(sprintf(['Averaged FT power at Begining of ',NamesStages{nn},', n=%d'],length(Sta)))
                    ylabel('Frequency (Hz)'); xlabel('Time (s)')
                    subplot(2,length(NamesStages),length(NamesStages)+nn), imagesc(-5:1/51:5,f,10*log10(MatSto')); axis xy;
                    line([0 0],ylim,'Color',[0.5 0.5 0.5]); caxis([30 65])
                    title(sprintf(['Averaged FT power at End of ',NamesStages{nn},', n=%d'],length(Sto)))
                    ylabel('Frequency (Hz)');xlabel('Time (s)')
                end
            end
        else
            disp('Problem. Skip')
        end
    end
end
