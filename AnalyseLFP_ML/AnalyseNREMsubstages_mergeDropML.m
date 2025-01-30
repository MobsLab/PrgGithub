%AnalyseNREMsubstages_mergeDropML.m
% use 5s merge/drop for wake and sleep 
% list of related scripts in NREMstages_scripts.m 

%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
colori=[0.5 0.2 0.1;0.1 0.7 0 ; 0.8 0 0.7 ; 1 0 1 ;0.7 0.2 0.8];
res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
analyName='Analyse_mergeDropML.mat';
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir1=RestrictPathForExperiment(Dir1,'nMice',[251 252 243 244]);

Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);
mice=unique(Dir.name);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<< LOAD ALL RAW SWS AND REM <<<<<<<<<<<<<<<<<<<<<<<<<<
comparSpectrum=0;

clear MovMat
try
    load([res,'/',analyName]);
    disp([analyName,' already exists, loading...'])
    MovMAT;
catch
    MovMAT={};
    
    for man=1:length(Dir.path)
        disp(Dir.path{man})
        cd(Dir.path{man})
        
        if 0
            clear InfoLFP
            load LFPData/InfoLFP.mat InfoLFP
            a=find(strcmp(InfoLFP.structure,'EMG'));
            if ~isempty(a)
                disp('YES !!!')
            else
                disp('no EMG')
            end
        end
        
        clear ImmobEpoch MovEpoch ThetaEpoch
        clear TotalNoiseEpoch GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch
        clear Mmov MovThresh ThetaRatioTSD ThetaThresh Movtsd MovAcctsd useMovAcctsd
        clear t Sp f channel
        try
            %get row periods of movement
            load('StateEpoch.mat','MovThresh','ThetaEpoch','ThetaRatioTSD','ThetaThresh')
            
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % %%%%%%%%%%%%%%% ReCompute Mmov and MovThresh %%%%%%%%%%%%%%%%%%%%
            load('behavResources.mat','Movtsd','useMovAcctsd','MovAcctsd');
            if exist('useMovAcctsd','var') && useMovAcctsd==1
                Movtsd=tsd(double(Range(MovAcctsd)),double(Data(MovAcctsd)));
            end
            Movtsd=tsd(double(Range(Movtsd)),double(Data(Movtsd)));
            % Sophie code to fit gaussian (Bimodpapier.m)
            rg=Range(Movtsd);
            val=SmoothDec(Data(Movtsd),5);
            disp(['Freq movment = ',num2str(1/mean(diff(rg/1E4))),' Hz'])
            Mmov=tsd(rg(1:10:end),val(1:10:end)-min(0,min(val)));
            % check
            Ep1=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
            figure, subplot(2,1,1), plot(Range(Mmov,'s'),Data(Mmov),'k')
            hold on, plot(Range(Restrict(Mmov,Ep1),'s'),Data(Restrict(Mmov,Ep1)),'g')
            
            MovThresh=GetGammaThresh(Data(Mmov));close
            MovThresh=exp(MovThresh);
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            ImmobEpoch=thresholdIntervals(Mmov,MovThresh,'Direction','Below');
            MovEpoch=thresholdIntervals(Mmov,MovThresh,'Direction','Above');
            ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above');
            % check
            hold on, subplot(2,1,2), plot(Range(Mmov,'s'),Data(Mmov),'k')
            hold on, plot(Range(Restrict(Mmov,ImmobEpoch),'s'),Data(Restrict(Mmov,ImmobEpoch)),'g')
            ok=input('are you ok with new threshold? 1/0 ');
            
            if ok==1
                % load noise
                load('StateEpoch.mat','GndNoiseEpoch','NoiseEpoch','WeirdNoiseEpoch')
                TotalNoiseEpoch=or(or(GndNoiseEpoch,NoiseEpoch),WeirdNoiseEpoch);
                TotalNoiseEpoch=CleanUpEpoch(TotalNoiseEpoch);
                
                % stock all epochs
                MovMAT{man,1}=MovEpoch;
                MovMAT{man,2}=ImmobEpoch;
                MovMAT{man,3}=ThetaEpoch;
                MovMAT{man,4}=TotalNoiseEpoch;
                
                load('ChannelsToAnalyse/PFCx_deep.mat','channel')
                if ~isempty(channel) && comparSpectrum
                    disp('Loading Spectrogram... wait !')
                    eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'');']);
                    Sptsd=tsd(t*1E4,Sp);
                    
                    figure('color',[1 1 1],'Unit','normalized','Position',[0.2 0.2 0.4 0.5])
                    subplot(3,3,1:3),
                    imagesc(t,f,10*log10(Sp)'), axis xy, caxis([20 65]); title(pwd)
                    
                    subplot(3,3,[4,7]),hold on,
                    plot(f,mean(Data(Restrict(Sptsd,ImmobEpoch))),'Color','r','Linewidth',2); title('PFCx spectrum')
                    plot(f,mean(Data(Restrict(Sptsd,MovEpoch))),'Color','k','Linewidth',2);
                    plot(f,mean(Data(Restrict(Sptsd,ThetaEpoch))),'Color','g','Linewidth',2);
                    legend({'Immob','Mov','Theta'}); yl=[min(ylim),max(ylim)*1.2]; ylim(yl);xlabel('Frequency (Hz)')
                    
                    subplot(3,3,[5,8]),hold on; leg={'Mov'};
                    plot(f,mean(Data(Restrict(Sptsd,MovEpoch))),'Color','k','Linewidth',2);
                    colori=colormap('jet');
                    for x=1:10
                        Ep1=dropShortIntervals(ImmobEpoch,2*x*1E4); leg=[leg,{sprintf('%ds-%ds',2*(x-1),2*x)}];
                        Ep2=dropShortIntervals(ImmobEpoch,2*(x-1)*1E4);
                        plot(f,mean(Data(Restrict(Sptsd,CleanUpEpoch(Ep2-Ep1)))),'Color',colori(64-3*x,:),'Linewidth',2);
                    end
                    legend(leg); title('Spectrum according to immob duration');ylim(yl);xlabel('Frequency (Hz)')
                    
                    subplot(3,3,[6,9]),hold on; leg={'Immob'};
                    plot(f,mean(Data(Restrict(Sptsd,ImmobEpoch))),'Color','r','Linewidth',2);
                    colori=colormap('jet');
                    for x=1:10
                        Ep1=dropShortIntervals(MovEpoch,2*x*1E4); leg=[leg,{sprintf('%ds-%ds',2*(x-1),2*x)}];
                        Ep2=dropShortIntervals(MovEpoch,2*(x-1)*1E4);
                        plot(f,mean(Data(Restrict(Sptsd,CleanUpEpoch(Ep2-Ep1)))),'Color',colori(3*x,:),'Linewidth',2);
                    end
                    legend(leg); title('Spectrum according to mov duration');ylim(yl);xlabel('Frequency (Hz)')
                    saveFigure(gcf,[sprintf('MergeDrop%d-',man),Dir.name{man}],'/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NREMstagesMergeDrop/')
                    close
                end
                
            end
            
        catch
            disp('No StateEpoch.mat')
            %         try
            %             load('StateEpochSB.mat','REMEpoch','SWSEpoch','wakeper');
            %             SWSEpoch;
            %             disp('using StateEpochSB.mat')
            %         end
        end
    end
    disp(['saving in ',analyName])
    save([res,'/',analyName],'Dir','MovMAT');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< LOAD ALL RAW SWS AND REM <<<<<<<<<<<<<<<<<<<<<<<<<
nameEpoch={'WakeEpoch','SleepEpoch','SImEpoch','ThetaEpoch','Immob','MovMAT{man,2}'};
for n=1:length(nameEpoch), DurDif{n,1}=[];DurDif{n,2}=[];end
for man=1:length(Dir.path)
    clear MovEpoch WakeEpoch Immob SleepEpoch SImEpoch ThetaEpoch
    MovEpoch= MovMAT{man,1};
    Immob= MovMAT{man,2};
    
    if ~isempty(MovEpoch) && ~isempty(Immob) && ~ismember(man,[41, 42])
        ThetaEpoch= MovMAT{man,3};
        TotalNoiseEpoch= MovMAT{man,4};
        
        % remove noise from epoch
        Immob=Immob-TotalNoiseEpoch;
        Immob=mergeCloseIntervals(Immob,3*1E4);% include small movement <3s in sleep
        Immob=dropShortIntervals(Immob,1*1E4); % drop very short immobility <1s
        Immob=CleanUpEpoch(Immob);
        
        SleepEpoch=dropShortIntervals(Immob,15*1E4); % remove short periods of immob <15s
        SleepEpoch=CleanUpEpoch(SleepEpoch);
        
        SImEpoch=Immob-SleepEpoch;
        SImEpoch=CleanUpEpoch(SImEpoch);

        WakeEpoch=(MovEpoch-TotalNoiseEpoch)-Immob;
        WakeEpoch=CleanUpEpoch(WakeEpoch);
        
        ThetaEpoch=ThetaEpoch-TotalNoiseEpoch;
        ThetaEpoch=CleanUpEpoch(ThetaEpoch);
        
        for n=1:length(nameEpoch)
            eval(['stp=Stop(',nameEpoch{n},',''s''); stt=Start(',nameEpoch{n},',''s'');'])
            DurDif{n,1}=[DurDif{n,1};[man*ones(length(stp),1),stp-stt]];
            DurDif{n,2}=[DurDif{n,2};[man*ones(length(stp)-1,1),stt(2:end)-stp(1:end-1)]];
        end
    end
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<< DISPLAY & ANALYSE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

%% all duration
figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.4 0.7])
for n=1:length(nameEpoch)
    subplot(2,length(nameEpoch),n),hold on,
    [htemp1,btemp1]=hist(log(DurDif{n,1}(:,2)),100);%title([nameEpoch{n},' Duration']);
    plot(btemp1,htemp1,'k'),title([nameEpoch{n},' Duration']);
    line(log(mean(DurDif{n,1}(:,2)))*[1 1],ylim+0.001,'Color','r')
    if n==1, ylabel('Distribution');end;  xlabel('Log(duration)')
    text(log(mean(DurDif{n,1}(:,2))),max(ylim)*0.8,sprintf(' mean = %1.1fs',mean(DurDif{n,1}(:,2))),'Color','r')
    line(log(median(DurDif{n,1}(:,2)))*[1 1],ylim+0.001,'Color','m')
    text(log(median(DurDif{n,1}(:,2))),max(ylim)*0.9,sprintf(' median = %1.1fs',median(DurDif{n,1}(:,2))),'Color','m')
    
    subplot(2,length(nameEpoch),length(nameEpoch)+n),hold on,
    [htemp2,btemp2]=hist(DurDif{n,1}(:,2),0:0.5:150);%title([nameEpoch{n},' Duration']);xlim([0 148]);
    plot(btemp2,htemp2,'k'),title([nameEpoch{n},' Duration']);xlim([0 148]);
    line(mean(DurDif{n,1}(:,2))*[1 1],ylim+0.001,'Color','r')
    if n==1, ylabel('Distribution');end;  xlabel('duration')
    text(mean(DurDif{n,1}(:,2)),max(ylim)*0.8,sprintf(' mean = %1.1fs',mean(DurDif{n,1}(:,2))),'Color','r')
    line(median(DurDif{n,1}(:,2))*[1 1],ylim+0.001,'Color','m')
    text(median(DurDif{n,1}(:,2)),max(ylim)*0.9,sprintf(' median = %1.1fs',median(DurDif{n,1}(:,2))),'Color','m')
    set(gca,'xscale','log')
end

%% duration per mouse
for mi=1:length(mice)
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.4 0.7])
    ind=find(strcmp(mice{mi},Dir.name)); ok=0;
    try
        for n=1:length(nameEpoch)
                ix=find(ismember(DurDif{n,1}(:,1),ind));
            if ~isempty(ix)
                subplot(2,length(nameEpoch),n),hold on,
                hist(log(DurDif{n,1}(ix,2)),20);title([nameEpoch{n},' Duration']);
                line(log(mean(DurDif{n,1}(ix,2)))*[1 1],ylim,'Color','r')
                if n==1, ylabel('Distribution');end;  xlabel('Log(duration)')
                text(log(mean(DurDif{n,1}(ix,2))),max(ylim)*0.8,sprintf(' mean = %1.1fs',mean(DurDif{n,1}(ix,2))),'Color','r')
                line(log(median(DurDif{n,1}(ix,2)))*[1 1],ylim,'Color','m')
                text(log(median(DurDif{n,1}(ix,2))),max(ylim)*0.9,sprintf(' median = %1.1fs',median(DurDif{n,1}(ix,2))),'Color','m')
                ok=ok+1;
                subplot(2,length(nameEpoch),length(nameEpoch)+n),hold on,
                hist(DurDif{n,1}(ix,2),0:4:150);title([nameEpoch{n},' Duration']);xlim([0 145]);
                line(mean(DurDif{n,1}(ix,2))*[1 1],ylim,'Color','r')
                if n==1, ylabel(['Distribution     ',Dir.name{ind(1)}]);end;  xlabel('duration')
                text(mean(DurDif{n,1}(ix,2)),max(ylim)*0.8,sprintf(' mean = %1.1fs',mean(DurDif{n,1}(ix,2))),'Color','r')
                line(median(DurDif{n,1}(ix,2))*[1 1],ylim,'Color','m')
                text(median(DurDif{n,1}(ix,2)),max(ylim)*0.9,sprintf(' median = %1.1fs',median(DurDif{n,1}(ix,2))),'Color','m')
            end
        end
        if ok==0, close;end
    catch
        keyboard
    end
end

%% intervals
figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.4 0.7])
for n=1:length(nameEpoch)
    
    subplot(2,length(nameEpoch),n),hold on,
    hist(log(DurDif{n,2}(:,2)),100);title([nameEpoch{n},'intervals']); xlabel('Log(intervals)')
    line(log(mean(DurDif{n,2}(:,2)))*[1 1],ylim,'Color','r')
    text(log(mean(DurDif{n,2}(:,2))),max(ylim)*0.8,sprintf(' mean = %1.1fs',mean(DurDif{n,2}(:,2))),'Color','r')
    line(log(median(DurDif{n,2}(:,2)))*[1 1],ylim,'Color','m')
    text(log(median(DurDif{n,2}(:,2))),max(ylim)*0.9,sprintf(' median = %1.1fs',median(DurDif{n,2}(:,2))),'Color','m')
    
    subplot(2,length(nameEpoch),length(nameEpoch)+n),hold on,
    hist(DurDif{n,2}(:,2),0:2:150);title([nameEpoch{n},'intervals']);xlim([0 147])
    line(mean(DurDif{n,2}(:,2))*[1 1],ylim,'Color','r'); xlabel('intervals')
    text(mean(DurDif{n,2}(:,2)),max(ylim)*0.8,sprintf(' mean = %1.1fs',mean(DurDif{n,2}(:,2))),'Color','r')
    line(median(DurDif{n,2}(:,2))*[1 1],ylim,'Color','m')
    text(median(DurDif{n,2}(:,2)),max(ylim)*0.9,sprintf(' median = %1.1fs',median(DurDif{n,2}(:,2))),'Color','m')
end








