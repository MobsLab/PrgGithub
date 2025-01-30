% AnalyseNREMsubstages_ORspikes.m
%
% see also
% 1. AnalyseNREMsubstagesML.m
% 2. AnalyseNREMsubstages_transitionML.m
% 3. AnalyseNREMsubstages_transitionprobML.m
% 4. AnalyseNREMsubstages_EvolRescaleML.m
% 5. AnalyseNREMsubstages_OBslowOscML.m
% 6. AnalyseNREMsubstages_EvolSlowML.m
% 7. AnalyseNREMsubstages_mergeDropML.m
% 8. AnalyseNREMsubstages_SpikesML.m
% 9. AnalyseNREMsubstages_MultiParamMatrix.m
% 10. AnalyseNREMsubstages_SpikesAndRhythms.m
% 11. AnalyseNREMsubstages_SpectrumML.m
% 12. AnalyseNREMsubstages_Rhythms.m
% 13. AnalyseNREMsubstages_N1evalML.m
% 14. AnalyseNREMsubstages_TrioTransitionML.m
% 15. AnalyseNREMsubstages_TrioTransRescaleML.m
% 16. AnalyseNREMsubstages_OBX.m
% 17. AnalyseNREMsubstages_SpikesInterPyrML.m
% 18. AnalyseNREMsubstagesdKOML.m
% 19. AnalyseNREMsubstages_SD.m
% 20. AnalyseNREMsubstages_SWA.m
% 21. AnalyseNREMsubstages_OR.m
% 22. AnalyseNREMsubstages_SD24h.m
% 23. AnalyseNREMsubstages_ORspikes.m
% CaracteristicsSubstagesML.m



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

colori=[0.5 0.5 0.5;0 0 1 ;0.5 0.2 0.1;0.1 0.7 0 ;0 0 0;0.7 0.2 1 ; 1 0.5 0.8 ;0.9 0 0.9  ];
Windo=2;% in sec (default =1) window to include epochs
timeZT=[9:21];   

nameAnaly=sprintf('AnalyNREMsubstages_ORspikes_%ds.mat',floor(Windo));
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_OR_spikes';
savFigure=1;

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
nameSessions{1}='BSL';
nameSessions{2}='ORhab';
nameSessions{3}='ORtest';

% ------------ 393 ------------ 
Dir{1,1}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160704';
Dir{1,2}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160705';
Dir{1,3}='/media/DataMOBsRAID/ProjetNREM/Mouse393/20160706';

% ------------ 394 ------------ 
Dir{2,1}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160704';
Dir{2,2}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160705';
Dir{2,3}='/media/DataMOBsRAID/ProjetNREM/Mouse394/20160706';

% ------------ 402 ------------ 
Dir{3,1}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160822';
Dir{3,2}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160823';
Dir{3,3}='/media/DataMOBsRAID/ProjetNREM/Mouse402/20160824';

% ------------ 403 ------------ 
Dir{4,1}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160822';
Dir{4,2}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160823';
Dir{4,3}='/media/DataMOBsRAID/ProjetNREM/Mouse403/20160824';

% ------------ 450 ------------ 
Dir{5,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse450/20161010';
%Dir{5,2}='/media/DataMOBsRAID/ProjetNREM/Mouse450/20161011';
%Dir{5,3}='/media/DataMOBsRAID/ProjetNREM/Mouse450/20161012';

% ------------ 451 ------------ 
Dir{6,1}='/media/DataMOBsRAIDN/ProjetNREM/Mouse451/20161010';
%Dir{6,2}='/media/DataMOBsRAID/ProjetNREM/Mouse451/20161011';
%Dir{6,3}='/media/DataMOBsRAID/ProjetNREM/Mouse451/20161012';


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< GET EXISTING DATA <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

try
    load([res,'/',nameAnaly]);
    AllZTz;
    disp([nameAnaly,' has been loaded.'])
catch 
    %%%%%%%%%%%%%%%%%%%%%%%%%% INITIATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AllZT=nan(300,10,length(timeZT)-1);
    AllZTz=nan(300,10,length(timeZT)-1);
    AllCrRIP=nan(300,101); % see IdentityNeuronsML/CrossCorrKB
    LNZT=0;
    for a=1:size(Dir,1), for i=1:3, nameMouse{a,i}='NaN';end;end
    MATneuron=[]; DurEpZT=[];
    MATnames={'Dir','Cond','#Mouse','#Neuron','#tet','#tetN','Pyr\Int','FR','PrefSubstage','FRsubstages...','FRsubzscore...'};
    % save
    save([res,'/',nameAnaly],'MATnames','Dir','colori','Windo','timeZT','nameSessions');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
for a=1:size(Dir,1)
    for i=1:3
        try
            % %%%%%%%%%%%%%%%%%% GET EXPERIMENTS %%%%%%%%%%%%%%%%%%%%%%
            disp(' ');disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ')
            disp(Dir{a,i});cd(Dir{a,i});
            nameMouse{a,i}=Dir{a,i}(max(strfind(Dir{a,i},'Mouse'))+[0:7]);
            if exist([saveFolder,'/IdentityNeuronsML_M',nameMouse{a,i}(6:8),'-',nameSessions{i}],'dir')
                error('Exists! skip');
            end
            
            indMAT=[a,i,str2num(nameMouse{a,i}(6:8))];
            
            % %%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%
            clear option WAKE SLEEP REM N1 N2 N3 NamesStages SleepStages
            try
                % Substages
                disp('- RunSubstages.m')
                [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages;close;
                % define SLEEP and NREM
                NREM=or(or(N1,N2),N3);
                NREM=mergeCloseIntervals(NREM,10);
                SLEEP=or(NREM,REM);
                SLEEP=mergeCloseIntervals(SLEEP,10);
            end
            option.WAKE = WAKE;% ~~~~~>IdentityNeuronsML
            option.REM = REM;% ~~~~~>IdentityNeuronsML
            option.NREM = NREM; % ~~~~~>IdentityNeuronsML
            option.N1 = N1;% ~~~~~>IdentityNeuronsML
            option.N2 = N2;% ~~~~~>IdentityNeuronsML
            option.N3 = N3;% ~~~~~>IdentityNeuronsML
            
            % %%%%%%%%%%%%%%%%%%%%% GET RIPPLES %%%%%%%%%%%%%%%%%%%%%%%
            wholeEpoch=or(SLEEP,WAKE);
            wholeEpoch=mergeCloseIntervals(wholeEpoch,10);
            wholeEpoch=CleanUpEpoch(wholeEpoch);
            disp('getting AllRipplesdHPC25.mat');
            [dHPCrip,EpochRip]=GetRipplesML(wholeEpoch,NREM);
            try option.RIP=ts(dHPCrip(:,2)*1E4);end
            
            % %%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%%
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML;
            rgZT=Range(NewtsdZT);
            %h_deb(a)=mod(min(Data(NewtsdZT)/1E4)/3600,24)*3600;
            option.ZT = NewtsdZT; % ~~~~~>IdentityNeuronsML
            option.timeZT = timeZT;
            option.Windo = Windo;
            
            % %%%%%%%%%%%%%%%%%%%%%% GET SPIKES %%%%%%%%%%%%%%%%%%%%%%%
            clear S numNeurons
            % Get PFCx Spikes
            [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
            % remove MUA from the analysis
            nN=numNeurons;
            MATtemp=[];
            for s=1:length(numNeurons)
                if TT{numNeurons(s)}(2)==1
                    nN(nN==numNeurons(s))=[];
                else
                    MATtemp=[MATtemp ; indMAT,numNeurons(s),TT{numNeurons(s)}(1),TT{numNeurons(s)}(2)];
                end
            end
            option.TT =TT(nN); % ~~~~~>IdentityNeuronsML
            
            % %%%%%%%%%%%%% GET Neuronal type (inter vs pyr) %%%%%%%%%%
            if ~exist('MeanWaveform.mat','file')
                PathName=[pwd,'/']; FilenameXml=ls('*.xml'); 
                %[FilenameXml,PathName]=uigetfile('*.xml','Select FilenameXml');
                GetWFInfo(pwd,[PathName,FilenameXml])
            end
            
            try [WfId,W]=IdentifyWaveforms(pwd,'/home/mobsyoda',1,1:length(numNeurons));
            catch,[WfId,W]=IdentifyWaveforms(pwd,'/media/DISK_1',1,1:length(numNeurons));
            end
            WfId(abs(WfId)==0.5)=NaN;
            % ------------------
            % add to MAT
            MATtemp(:,7)=WfId(find(ismember(numNeurons,nN)));
            option.waveform =W(nN); % ~~~~~>IdentityNeuronsML
            
            % %%%%%%%%%%%%%%%%%%% GET POSITIONS %%%%%%%%%%%%%%%%%%%%%
            if ~isempty(strfind(nameSessions{i},'OR'))
                clear X Y ImageRef mask
                load behavResources X Y ImageRef mask
                option.X = X;  % ~~~~~>IdentityNeuronsML
                option.Y = Y; % ~~~~~>IdentityNeuronsML
                option.ref = double(ImageRef); % ~~~~~>IdentityNeuronsML
                option.mask = double(mask);
                
                % %%%%%%%%%%%%%%%%%% GET PLACE FIELD %%%%%%%%%%%%%%%%%%
                if 0
                    vT=Range(X,'s');vX=Data(X);vY=Data(Y);
                    pas=1/mean(diff(vT))/5; %5Hz
                    Speed=sqrt(diff(vX(1:pas:end)).^2+diff(vY(1:pas:end)).^2)./diff(vT(1:pas:end));
                    Speed=SmoothDec(Speed',1);
                    
                    V=tsd(vT(1:pas:end)*1E4,[Speed;Speed(end)]);
                    the=percentile(Data(V),50); % default 60
                    Mvt=thresholdIntervals(V, the,'Direction','Above');
                    Immob=thresholdIntervals(V, the,'Direction','Below');
                    
                    TrackEpoch=intervalSet(min(Range(X)),max(Range(X)));
                    for s=1:length(nN)
                        try
                            [map,mapS,stats,px,py]=PlaceField(Restrict(S{nN(s)},TrackEpoch),Restrict(X,TrackEpoch),Restrict(Y,TrackEpoch),'smoothing',2,'size',50);
                            hold on; title(['Neuron ',num2str(nN(s))]);
                            
                            %[mapMv,mapSMv,statsMv,pxMv,pyMv]=PlaceField(Restrict(S{nN(s)},Mvt),Restrict(X,Mvt),Restrict(Y,Mvt),'smoothing',3,'size',50);
                            %hold on; plot(Range(V,'s'),Data(V),'Color',[0.5 0.5 0.5]); line(xlim,the*[1 1],'Color','k','Linewidth',2)
                            legend({'X','Y','Spikes','V','MvtThresh'},'Location','BestOutside')
                            title(['RestrictOnMovements; Neuron ',num2str(nN(s))]); xlabel(pwd)
                        end
                    end
                end
                
            end
            
            %%%%%%%%%%%%%%% LOAD LFP OB, PFC, HPCrip %%%%%%%%%%%%%%%%%%
            option.HPC=tsd([],[]); % ~~~~~>IdentityNeuronsML
            option.PFC=tsd([],[]); % ~~~~~>IdentityNeuronsML
            option.OB=tsd([],[]); % ~~~~~>IdentityNeuronsML
            try
                clear chtemp; chtemp=load('ChannelsToAnalyse/dHPC_deep.mat');
                clear temp; temp=load(sprintf('LFPData/LFP%d.mat',chtemp.channel));
                option.HPC=temp.LFP; disp('LFP HPC loaded.')
            end
            try
                clear chtemp; chtemp=load('ChannelsToAnalyse/PFCx_deep.mat');
                clear temp; temp=load(sprintf('LFPData/LFP%d.mat',chtemp.channel));
                option.PFC=temp.LFP; disp('LFP PFC loaded.')
            end
            try
                clear chtemp; chtemp=load('ChannelsToAnalyse/Bulb_deep.mat');
                clear temp; temp=load(sprintf('LFPData/LFP%d.mat',chtemp.channel));
                option.OB=temp.LFP; disp('LFP OB loaded.')
            end
            
            %%%%%%%%%%%%%%%%%% IdentityNeuronsML %%%%%%%%%%%%%%%%%%%%%%
            [DirFigure,Epochs,NamesEp,FR,FRz,FR2,DurEp,ZTFR,ZTFRz,ZTFR2,CrRip,tCr] = IdentityNeuronsML(S(nN),option);
            movefile(DirFigure,sprintf([DirFigure(1:strfind(DirFigure,date)-1),'M%d-',nameSessions{i}],indMAT(3)))
            % ------------------
            % add to MAT
            MATtemp(:,8)=FR;
            [m,B]=max(FRz');
            MATtemp(:,9)=B';
            MATtemp(:,10:10+2*length(NamesEp)-1)=[FR2,FRz];
            
            MATneuron=[MATneuron;MATtemp];
            
            AllZT(LNZT+(1:length(nN)),1:length(NamesEp),:)=ZTFR;
            AllZTz(LNZT+(1:length(nN)),1:length(NamesEp),:)=ZTFRz;
            try AllCrRIP(LNZT+(1:length(nN)),:)=CrRip;end
            LNZT=size(MATneuron,1);
            
            indM=[]; for n=1:length(NamesEp), indM=[indM ; indMAT,n];end
            DurEpZT=[DurEpZT; [indM, DurEp] ];
            
            % %%%%%%%%%%%%%%%%%%%%%%%%% PLOT %%%%%%%%%%%%%%%%%%%%%%%%%%
            if 1
                figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.4 0.8]),
                for n=1:length(NamesEp)
                    ttd=20*squeeze(ZTFR(:,n,:));
                    ttdz=squeeze(ZTFRz(:,n,:));
                    subplot(5,2,1:2), hold on,
                    errorbar(timeZT(1:end-1),nanmean(ttd,1),stdError(ttd),'Linewidth',2,'Color',colori(n,:))
                    
                    subplot(5,2,3:4), hold on,
                    errorbar(timeZT(1:end-1),nanmean(ttdz,1),stdError(ttdz),'Linewidth',2,'Color',colori(n,:))
                    
                    if n>2
                        prefN=find(MATtemp(:,9)==n);
                        if ~isempty(prefN)
                            subplot(5,2,2+n), hold on,
                            for nn=3:length(NamesEp)
                                Prefttdz=squeeze(ZTFRz(prefN,nn,:));
                                if length(prefN)<2,  plot(timeZT(1:end-1),nanmean(Prefttdz,2),'Linewidth',(n==nn)+1,'Color',colori(nn,:))
                                else, errorbar(timeZT(1:end-1),nanmean(Prefttdz,1),stdError(Prefttdz),'Linewidth',(n==nn)+1,'Color',colori(nn,:))
                                end
                            end
                        end
                        title(sprintf(['Neuron max in ',NamesEp{n},' (n=%d, avFR=%1.1fHz)'],length(prefN),mean(MATtemp(prefN,8))));
                        xlim([timeZT(1),timeZT(end-1)]);
                    end
                end
                subplot(5,2,1:2),title(pwd); ylabel('FR (Hz)');xlim([timeZT(1),timeZT(end-1)]);
                subplot(5,2,3:4),title(sprintf('n=%d neurons',length(nN)));ylabel('FR (zscore)');
                xlim([timeZT(1),timeZT(end-1)]);legend(NamesEp);
                numF=gcf;
                saveFigure(numF.Number,sprintf('AnalyORspikes_Day%dCond%d',a,i),saveFolder);
            end
            disp('Done.')
            
            % %%%%%%%%%%%%%%%%%%%%%%%%% SAVE %%%%%%%%%%%%%%%%%%%%%%%%%%
            disp(['Saving in ',nameAnaly])
            save([res,'/',nameAnaly],'-append','AllZTz','AllZT','DurEpZT','MATneuron','nameMouse','AllCrRIP');
            if ~isempty(tCr), save([res,'/',nameAnaly],'-append','tCr'); end
            
        catch
            
            if exist([saveFolder,'/IdentityNeuronsML_M',nameMouse{a,i}(6:8),'-',nameSessions{i}],'dir')
                disp('Done.');
            else
                disp('PROBLEM ! skip'); %keyboard;
            end
        end
    end
end

