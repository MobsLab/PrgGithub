
% AnalyseNREMsubstages_MultiParamMatrix.m

% see also
% AnalyseNREMsubstages_transitionML.m
% AnalyseNREMsubstages_EvolRescaleML.m
% AnalyseNREMsubstages_mergeDropML.m
% AnalyseNREMsubstages_OBslowOscML.m
% AnalyseNREMsubstages_SpectrumML.m
% AnalyseNREMsubstages_SpikesML.m
% AnalyseNREMsubstages_transitionML.m
% AnalyseNREMsubstages_transitionprobML.m
% AnalyseNREMsubstages_Rhythms.m
% AnalyseNREMsubstages_SpikesAndRhythms
% CaracteristicsSubstagesML.m; %to do !!


res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
%FolderToSave='/home/mobsyoda/Dropbox/MOBs_ProjetBulbe/FIGURES/FigureNREMstages/AnalyMultiVar';
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/AnalyMultiVar';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Dir1=PathForExperimentsDeltaSleepNew('BASAL');
Dir2=PathForExperimentsML('BASAL');
Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
Dir=MergePathForExperiment(Dir1,Dir2);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%load([res,'/AnalySubStagesML.mat'])
load([res,'/AnalySubStagesMLSAV.mat'])
Dir;
disp('Loading AnalySubStagesML.mat...')
doSI=1; %discard small sleep episods
fdelta=[2 4]; % look PFCx and OB spectrum at this freq
ftheta=[6 8]; % look PFCx and HPC spectrum at this freq

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< compute <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
try
    load([res,'/AnalyseNREMaMultivar.mat']);MultMat;
    disp(['AnalyseNREMaMultivar.mat already exists. Loaded.']);
    
catch
    MultMat={};
    
    for man=1:length(Dir.path)
        
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        
        % -----------------
        op=MATepochs(man,1:end-1);
        noise=MATepochs{man,end};
        %         N1=op{1};
        %         N2=op{2};
        %         N3=op{3};
        %         REM=op{4};
        %         WAKE=op{5};
        %         SWS=op{6};
        %         SI=op{7};
        % -----------------
        if ~isempty(op{4})
            if 1
                % merge close REM if interval <30s
                op{4}=mergeCloseIntervals(op{4},30*1E4);
            end
            % -----------------
            % DefineSubStages
            [MATEP,nameEpochs]=DefineSubStages(op,noise,1); % 1 to remove short sleep periods
            %nameEpochs: N1,N2,N3,REM,WAKE,SWS,SI,PFswa,OBswa,TOTSleep,WAKEnoise
            % -----------------
        end
        
        try
            SleepStages=[];
            for n=1:5
                epoch=MATEP{n};
                if doSI, epoch=epoch-MATEP{7};end
                SleepStages=[SleepStages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStages=sortrows(SleepStages,1);
            smat=[SleepStages,[SleepStages(2:end,3);0],[0;SleepStages(1:end-1,3)]];   % start/stop/current/after/before
            
            % -----------------
            Dpfc=MATOSCI{man,1};
            rip=MATOSCI{man,2};
            Spfc=MATOSCI{man,3};
            % -----------------
            % load HPC Channel and spectrum
            disp('Loading dHPC_deep SpectrumDataL, WAIT...')
            clear channel Sp t f
            load('ChannelsToAnalyse/dHPC_deep','channel');
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
            % good Epoch
            GoodEpoch=intervalSet(t(1)*1E4,t(end)*1E4)-noise;
            GoodEpoch=mergeCloseIntervals(GoodEpoch,10);
            % HPC theta
            HPCthetaz=tsd(t*1E4,mean(Sp(:,f>=ftheta(1) & f<ftheta(2)),2));
            HPCthetaz=Restrict(HPCthetaz,GoodEpoch);
            HPCthetaz=tsd(Range(HPCthetaz),zscore(Data(HPCthetaz)));
            
            % -----------------
            % load PFCx Channel and spectrum
            disp('Loading PFCx_deep SpectrumDataL, WAIT...')
            clear channel Sp t f
            load('ChannelsToAnalyse/PFCx_deep','channel');
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
            % PFC theta
            PFCthetaz=tsd(t*1E4,mean(Sp(:,f>=ftheta(1) & f<ftheta(2)),2));
            PFCthetaz=Restrict(PFCthetaz,GoodEpoch);
            PFCthetaz=tsd(Range(PFCthetaz),zscore(Data(PFCthetaz)));
            % PFC delta
            PFCdeltaz=tsd(t*1E4,mean(Sp(:,f>=fdelta(1) & f<fdelta(2)),2));
            PFCdeltaz=Restrict(PFCdeltaz,GoodEpoch);
            PFCdeltaz=tsd(Range(PFCdeltaz),zscore(Data(PFCdeltaz)));
            
            % -----------------
            % load Bulb Channel and spectrum
            disp('Loading Bulb_deep SpectrumDataL, WAIT...')
            clear channel Sp t f
            load('ChannelsToAnalyse/Bulb_deep','channel');
            eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'',''Sp'',''t'',''f'')'])
            % OB delta
            OBdeltaz=tsd(t*1E4,mean(Sp(:,f>=fdelta(1) & f<fdelta(2)),2));
            OBdeltaz=Restrict(OBdeltaz,GoodEpoch);
            OBdeltaz=tsd(Range(OBdeltaz),zscore(Data(OBdeltaz)));
            
            % ------------------
            % tsdZT
            clear NewtsdZT
            load('behavResources.mat','NewtsdZT'); 
            if ~exist('NewtsdZT','var'), keyboard;end
            warning off
            for n=1:5
                %
                epoch=MATEP{n};
                sta=Start(epoch,'s');
                sto=Stop(epoch,'s');
                
                ZTh1=Data(Restrict(NewtsdZT,Start(epoch)))/(3600*1E4);
                ZTh2=Data(Restrict(NewtsdZT,Stop(epoch)))/(3600*1E4);
                
                Mult=nan(length(sta),80);
                for s=1:length(sta)
                    %---------- current stage ----------
                    Mult(s,1)=sto(s)-sta(s); % dur current stage
                    Mult(s,2)=ZTh1(s);% clock time (h) of current stage start
                    Mult(s,3)=ZTh2(s);% clock time (h) of current stage end
                    try Mult(s,4)=ZTh1(s-1);end% clock time (h) of last current stage start
                    try Mult(s,5)=ZTh2(s-1);end% clock time (h) of last current stage end
                    try Mult(s,6)=sta(s)-sta(s-1);end% intervals between current and previous stage start
                    try Mult(s,7)=sto(s)-sto(s-1);end% intervals between current and previous stage end
                    
                    %spectrum
                    Mult(s,8)=mean(Data(Restrict(HPCthetaz,subset(epoch,s))));% theta HPC current stage zscore
                    Mult(s,9)=mean(Data(Restrict(PFCthetaz,subset(epoch,s))));% thetaPFCx current stage zscore
                    Mult(s,10)=mean(Data(Restrict(PFCdeltaz,subset(epoch,s))));% slowPFCx current stage zscore
                    Mult(s,11)=mean(Data(Restrict(OBdeltaz,subset(epoch,s))));% slowOB current stage zscore
                    

                    %---------- between last current stage till now  ----------
                    try
                        %spectrum
                        I=intervalSet(sto(s-1)*1E4,sta(s)*1E4); %intervals between the previous current stage
                        Mult(s,12)=mean(Data(Restrict(HPCthetaz,I)));% theta HPC previous interval
                        Mult(s,13)=mean(Data(Restrict(PFCthetaz,I)));% thetaPFCx previous interval
                        Mult(s,14)=mean(Data(Restrict(PFCdeltaz,I)));% slowPFCx previous interval
                        Mult(s,15)=mean(Data(Restrict(OBdeltaz,I)));% slowOB previous interval
                        %linear regression slowPFCx
                        x=Range(Restrict(PFCdeltaz,I),'s'); y=Data(Restrict(PFCdeltaz,I));
                        pf= polyfit(x,y,1);[r,p]=corrcoef(x,y);
                        Mult(s,16)= pf(1); %slope of increase slowPFCx previous interval
                        Mult(s,17)= r(1,2);%corr coeff of increase slowPFCx previous interval
                        Mult(s,18)= p(1,2);%pvalue of increase slowPFCx previous interval
                    end
                    try
                        %delta ripples spindles on previous interval
                        Mult(s,19)=length(Data(Restrict(Dpfc,I)));% nb Delta on previous interval
                        Mult(s,20)=length(Data(Restrict(rip,I)));% nb Ripples on previous interval
                        Mult(s,21)=length(Data(Restrict(Spfc,I)));% nb Spindles on previous interval
                    end
                    try
                        % nb of passed transition on previous interval
                        for i=1:5
                            if i~=n% start/stop/current/after/before
                                Mult(s,21+i)=length(find(smat(:,1)<sta(s) & smat(:,1)>sto(s-1) & smat(:,3)==n & smat(:,4)==i));% transition n->i
                                Mult(s,26+i)=length(find(smat(:,1)<sta(s) & smat(:,1)>sto(s-1) & smat(:,3)==n & smat(:,5)==i));% transition i->n
                            end
                        end
                    end
                    
                    %---------- tot passed current stage ----------
                    Mult(s,32)=s-1;% nb passed current stage
                    try
                        Mult(s,33)=sum(sto(1:s-1)-sta(1:s-1));% tot dur passed current stage
                        %spectrum
                        I=intervalSet(sta(1:s-1)*1E4,sto(1:s-1)*1E4);
                        Mult(s,34)=mean(Data(Restrict(HPCthetaz,I)));% theta HPC tot passed current stage zscore
                        Mult(s,35)=mean(Data(Restrict(PFCthetaz,I)));% thetaPFCx tot passed current stage zscore
                        Mult(s,36)=mean(Data(Restrict(PFCdeltaz,I)));% slowPFCx tot passed current stage zscore
                        Mult(s,37)=mean(Data(Restrict(OBdeltaz,I)));% slowOB tot passed current stage zscore
                        %linear regression slowPFCx
                        x=Range(Restrict(PFCdeltaz,I),'s'); y=Data(Restrict(PFCdeltaz,I));
                        pf= polyfit(x,y,1);[r,p]=corrcoef(x,y);
                        Mult(s,38)= pf(1); %slope of increase slowPFCx tot passed current stage
                        Mult(s,39)= r(1,2);%corr coeff of increase slowPFCx tot passed current stage
                        Mult(s,40)= p(1,2);%pvalue of increase slowPFCx tot passed current stage
                    end
                    try % oscillations specific to current stage type
                        I=intervalSet(sta(1:s-1)*1E4,sto(1:s-1)*1E4);
                        Mult(s,41)=length(Data(Restrict(Dpfc,I)));% nb total previous Delta
                        Mult(s,42)=length(Data(Restrict(rip,I)));% nb total previous Ripples
                        Mult(s,43)=length(Data(Restrict(Spfc,I)));% nb total previous Spindles
                    end
                    
                    try %---------- stage n-1 ----------
                        ind=find(SleepStages(:,1)==sta(s))-1;
                        Mult(s,44)=SleepStages(ind,3);% previous stage
                        Mult(s,45)=diff(SleepStages(ind,1:2),1,2); % dur previous stage
                        ind2=find(SleepStages(:,3)==Mult(s,12));
                        Mult(s,46)=sum(diff(SleepStages(ind2(ind2<=ind),1:2),1,2));% tot dur previous stage
                        Mult(s,47)=length(ind2(ind2<=ind));% tot nb previous stage
                    end
                    
                    try %---------- stage n-2 ----------
                        ind=find(SleepStages(:,1)==sta(s))-2;
                        Mult(s,48)=SleepStages(ind,3);% stage n-2
                        ind2=find(SleepStages(:,3)==Mult(s,12));
                        Mult(s,49)=sum(diff(SleepStages(ind2(ind2<=ind),1:2),1,2));% tot dur stage n-2
                    end
                    
                    % all oscillations
                    I=intervalSet(0,sta(s)*1E4);
                    Mult(s,50)=length(Data(Restrict(Dpfc,I)));% nb total previous Delta
                    Mult(s,51)=length(Data(Restrict(rip,I)));% nb total previous Ripples
                    Mult(s,52)=length(Data(Restrict(Spfc,I)));% nb total previous Spindles
                    
                    % cum oscillations on previous periods
                    tim=[5,10,30,60, 5*60, 10*60];% previous period in seconds
                    for ti=1:6
                        try
                            I=intervalSet((sta(s)-tim(ti))*1E4,sta(s)*1E4);
                            Mult(s,52+ti)=length(Data(Restrict(Dpfc,I)));% nb Delta in previous tim seconds
                            Mult(s,58+ti)=length(Data(Restrict(rip,I)));% nb Ripples in previous tim seconds
                            Mult(s,64+ti)=length(Data(Restrict(Spfc,I)));% nb Spindles in previous tim seconds
                        end
                    end
                    % nb of passed transition
                    for i=1:5% start/stop/current/after/before
                        if i~=n
                            Mult(s,70+i)=length(find(smat(:,1)<sta(s) & smat(:,3)==n & smat(:,4)==i));% transition n->i
                            Mult(s,75+i)=length(find(smat(:,1)<sta(s) & smat(:,3)==n & smat(:,5)==i));% transition i->n
                        end
                    end
                end
                
                MultMat{man,n}=Mult;
            end
            warning on
        catch
            disp('Problem: Matrix not defined for this experiment')
        end
    end
    disp('Done');
    save([res,'/AnalyseNREMaMultivar.mat'],'MultMat','fdelta','ftheta','Dir','doSI','nameEpochs')
    
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<< Name all var <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if ~exist('info','var')
    clear infoT info
    infoT={'1:11 = Current','12:31 = since last current', '32:43 = total passed current','44:47 = n-1','48:49 = n-2',' '};%,...
    %     '3:6,10:13,19:22,27:30,38:41 = spectrum','42:65 = delta/spindles/ripples',...
    %     '66:75 = nb transition','7:9,14:16,31:33 = regression PFCx slow'};
    
    %---------- current stage ----------
    info{1}='dur (s) current stage';
    info{2}='clock time (h) of current stage start';
    info{3}='clock time (h) of current stage end';
    info{4}='clock time (h) of last current stage start';
    info{5}='clock time (h) of last current stage end';
    info{6}='interval (s) btw last and current stage starts';
    info{7}='interval (s) btw last and current stage ends';
    info{8}='theta HPC current stage zscore';
    info{9}='thetaPFCx current stage zscore';
    info{10}='slowPFCx current stage zscore';
    info{11}='slowOB current stage zscore';
    
    %---------- since last current stage ----------
    info{12}='theta HPC since last current stage';
    info{13}='thetaPFCx since last current stage';
    info{14}='slowPFCx since last current stage';
    info{15}='slowOB since last current stage';
    info{16}='slope Evol slowPFCx since last current stage';
    info{17}='CorrCoeff Evol slowPFCx since last current stage';
    info{18}='pvalue Evol slowPFCx since last current stage';
    info{19}='nb Delta since last current stage';
    info{20}='nb Ripples since last current stage';
    info{21}='nb Spindles since last current stage';
    for i=1:5% start/stop/current/after/before
        info{21+i}=['nb transition stage -> ',nameEpochs{i},', since last current stage'];
        info{26+i}=['nb transition ',nameEpochs{i},' -> stage, since last current stage'];
    end
    
    %---------- tot passed current stage ----------
    info{32}='nb passed current stage';
    info{33}='tot dur passed current stage';
    info{34}='theta HPC tot passed current stage';
    info{35}='thetaPFCx tot passed current stage';
    info{36}='slowPFCx tot passed current stage';
    info{37}='slowOB tot passed current stage';
    info{38}='slope Evol slowPFCx tot passed current stage';
    info{39}='CorrCoeff Evol slowPFCx tot passed current stage';
    info{40}='pvalue Evol slowPFCx tot passed current stage';
    info{41}='nb Delta tot passed current stage';
    info{42}='nb Ripples tot passed current stage';
    info{43}='nb Spindles tot passed current stage';
    
    %---------- stage n-1 ----------
    info{44}='nature previous stage';
    info{45}='dur previous stage';
    info{46}='tot dur previous stage';
    info{47}='tot nb previous stage';
    %---------- stage n-2 ----------
    info{48}='nature stage n-2';
    info{49}='tot dur stage n-2';
    
    %-------- all oscillations ------
    info{50}='nb total previous Delta';
    info{51}='nb total previous Ripples';
    info{52}='nb total previous Spindles';
    % cum oscillations on previous periods
    tim=[5,10,30,60, 5*60, 10*60];% previous period in seconds
    for ti=1:6
        info{52+ti}=['nb Delta in previous ',num2str(tim(ti)),'s'];
        info{58+ti}=['nb Ripples in previous ',num2str(tim(ti)),'s'];
        info{64+ti}=['nb Spindles in previous ',num2str(tim(ti)),'s'];
    end
    % -------- nb of passed transition ------
    for i=1:5% start/stop/current/after/before
        info{70+i}=['nb transition stage -> ',nameEpochs{i}];
        info{75+i}=['nb transition ',nameEpochs{i},' -> stage'];
    end
    info=info';
    
    save([res,'/AnalyseNREMaMultivar.mat'],'-append','info')
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< AnalysMultiVar <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% see AnalysMultiVar_25022016.m from Karim
dozscore=1;
MethodeGLM=2;
if dozscore, MethodeGLM=1;end
MatBeta={};Matp={};
figure('Color',[1 1 1]), numF=gcf;
figure('Color',[1 1 1]), numF2=gcf;
for n=4
    MatBetatemp=nan(length(Dir.path),length(info));
    Matptemp=nan(length(Dir.path),length(info));
    for man=1:length(Dir.path)
        % rename info
        tinfo=info;
        for i=1:length(tinfo)
            id=strfind(tinfo{i},'stage');
            if ~isempty(id)
                tinfo{i}=[tinfo{i}(1:id-1),nameEpochs{n},tinfo{i}(id+5:end)];
            end
            id=strfind(tinfo{i},' zscore');
            if ~isempty(id)
                tinfo{i}(id:id+6)=[];
            end
            id=strfind(tinfo{i},'passed current');
            if ~isempty(id)
                tinfo{i}(id+6:id+13)=[];
            end
            if i<10, tinfo{i}=[tinfo{i},'  ',num2str(i)]; else, tinfo{i}=[tinfo{i},' ',num2str(i)];end
        end
        
        % get data current expe, clean and zscore
        test=MultMat{man,n};
        
        if ~isempty(test)
            
            test(isinf(test))=NaN;
            %         test(isinf(test))=0;
            %         test(isnan(test))=0;
            if dozscore, test=zscore(test,0,1);end
            test(:,find(isnan(nanmean(test,1))))=zeros(size(test,1),length(find(isnan(nanmean(test,1)))));
            x=(test(:,1)); y=(test(:,2:end));
            
            % --------------------------------------------------------------------
            if 0
                % calculate corrcoef & pcacov
                [r,p]=corrcoef(test);
                id=find(~isnan(nanmean(r,2)));
                r=r(id,id);
                [V,L]=pcacov(r);
                [BE,pc]=sort(V(:,1));
                
                % plot
                figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.5 0.4 0.3]),
                subplot(1,4,1:2),imagesc(id,id,r), title(['corrcoef ',nameEpochs{n}])
                subplot(1,4,3), plot(L,'ko-'), title('principal component variances (latent)')
                subplot(1,4,4), plot(V(:,1),'ko-');title('PCA coeff')
                
                figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.01 0.4 0.9]),
                imagesc(r(pc,pc)), title(['pcacov ',nameEpochs{n}])
                set(gca,'Xtick',1:size(r,1));set(gca,'XtickLabel',id(pc),'FontSize',6);
                set(gca,'Ytick',1:size(r,1));set(gca,'YtickLabel',tinfo(id(pc)),'FontSize',6);
            end
            % --------------------------------------------------------------------
            
            if MethodeGLM==1
                [gl,dev,stats] = glmfit(y,x);
                xfit = glmval(gl,y, 'identity');
            elseif MethodeGLM==2
                [gl,dev,stats] = glmfit(y,x,'poisson','link','log');
                xfit = glmval(gl,y, 'log');
            end
            MatBetatemp(man,:)=stats.beta;
            
            % significance
            temp=stats.p;
            id0=find(temp>=0.05);
            id1=find(temp<0.05 & temp>=0.01);
            id2=find(temp<0.01 & temp>=0.001);
            id3=find(temp<0.001 & temp>=0.0001);
            id4=find(temp<0.0001);
            temp(id0)=-5;temp(id1)=1;temp(id2)=2;temp(id3)=3;temp(id4)=4;
            Matptemp(man,:)=temp;
            
            figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.4 0.8]),
            subplot(3,3,1), scatter(x,xfit,100,y(:,1),'.'), ylabel('predicted')
            title(sprintf('fitted expe %1.3f',sqrt(sum((x-xfit).^2))/length(x)))
            line([min(x),max(x)],[min(x),max(x)],'Color',[0.5 0.5 0.5])
            
            subplot(3,3,2), plot(stats.beta,'ko-','markerfacecolor','k')
            id=find(abs(stats.p)<0.05); % find significant correlation
            title([Dir.path(man),{' '},Dir.name(man)])
            hold on, plot(id,stats.beta(id),'go','markerfacecolor','g')
            subplot(3,3,3), text(0,0.5,[{['DURATION of current ',nameEpochs{n},' predicted by:']};' ';tinfo(id)]);axis off
            
            % get expe from same or different mouse
            Umice=unique(Dir.name); Umice(strcmp(Umice,Dir.name{man}))=[];
            aid=1:length(Dir.path);
            id=find(strcmp(Dir.name{man},Dir.name));
            aid(id)=[];
            id(id==man)=[];
            a=0;i=1;
            while a < 3 && i<=length(id)
                % get other expe, clean and zscore
                try
                    test2=MultMat{id(i),n};
                    test2(isinf(test2))=0;
                    test2(isnan(test2))=0;
                    if dozscore, test2=zscore(test2,0,1); end
                    x2=(test2(:,1)); y2=(test2(:,2:end));
                    if MethodeGLM==1
                        xfit2 = glmval(gl,y2, 'identity');
                    elseif MethodeGLM==2
                        xfit2 = glmval(gl,y2, 'log');
                    end
                    subplot(3,3,4+a), plot(x2,xfit2,'k.'),ylabel('predicted')
                    title([Dir.name{id(i)},sprintf(', other expe %1.3f',sqrt(sum((x2-xfit2).^2))/length(x2))])
                    line([min(x2),max(x2)],[min(x2),max(x2)],'Color',[0.5 0.5 0.5])
                    a=a+1;
                end
                i=i+1;
            end
            
            mi=Umice(randperm(length(Umice)));
            a=0;i=1;
            while a < 3
                %get other expe, clean and zscore
                try
                    test2=MultMat{min(find(strcmp(mi{i},Dir.name))),n};
                    test2(isinf(test2))=0;
                    test2(isnan(test2))=0;
                    if dozscore, test2=zscore(test2,0,1); end
                    x2=(test2(:,1)); y2=(test2(:,2:end));
                    if MethodeGLM==1
                        xfit2 = glmval(gl,y2, 'identity');
                    elseif MethodeGLM==2
                        xfit2 = glmval(gl,y2, 'log');
                    end
                    subplot(3,3,7+a), plot(x2,xfit2,'b.'),xlabel('real');ylabel('predicted')
                    title([mi{i},sprintf(' %1.3f',sqrt(sum((x2-xfit2).^2))/length(x2))])
                    line([min(x2),max(x2)],[min(x2),max(x2)],'Color',[0.5 0.5 0.5])
                    a=a+1;
                end
                i=i+1;
            end
            %close;
            % save Figure
            %saveFigure(gcf,['AnalyMultiVar',num2str(man),'-',nameEpochs{n},'-',Dir.name{man}],FolderToSave)
        end
    end
    Matp{n}=Matptemp;
    MatBeta{n}=MatBetatemp;
    figure(numF),subplot(1,5,n)
    imagesc(Matp{n}'), title(nameEpochs{n});caxis([-5 4]); %colorbar;
    xlabel('# Mouse')
    if n==1,set(gca,'Ytick',1:length(tinfo));set(gca,'YtickLabel',tinfo,'FontSize',6);end
    
    % xi only if zscore
    if dozscore
        figure(numF2),subplot(1,5,n)
        idn=find(~isnan(nanmean(MatBeta{n},2)));
        imagesc(MatBeta{n}(idn,:)'), title(nameEpochs{n}); caxis([-10 20]);%colorbar;
        xlabel('# Mouse')
        if n==1,set(gca,'Ytick',1:length(tinfo));set(gca,'YtickLabel',tinfo,'FontSize',6);end
    end
    
    
    if 0% pool mice with similar pattern
        M=MatBetatemp(find(~isnan(nanmean(MatBetatemp,2))),:);
        [r,p]=corrcoef(M');
        [V,L]=pcacov(r);
        pc1=V(:,1);
        [BE,id1]=sort(pc1);
        figure, subplot(1,5,1), imagesc(M), caxis([-10 10])
        subplot(1,5,2),imagesc(r(id1,id1))
        pc2=V(:,4);
        [BE,id2]=sort(pc2);
        subplot(1,5,3), imagesc(r(id2,id2))
        subplot(1,5,4),plot(L,'ko-')
        subplot(1,5,5),hold on, plot(V(:,1),'ko-'),plot(V(:,4),'ro-')
    end
end
%% compile SuperBig matrice sbMat
if 1
    for n=1:5
        sbMat=[];
        for man=1:length(Dir.path)
            sbMat=[sbMat;[MultMat{man,n},man*ones(size(MultMat{man,n},1),1)]];
        end
        eval(['Mat',nameEpochs{n},'=sbMat;'])
    end
    info{end+1}='Expe num DirPath';
    %disp('saving BigMat.mat in dropbox')
    %save('/home/mobsyoda/Dropbox/MOBS_workingON/AnalyseMultivarieMarie/BigMat.mat','MatN1','MatN2','MatN3','MatREM','MatWAKE','info')
end

%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% only one BigMat for all stages, order by occurrence time for each mosue
if 1
    NameStage=nameEpochs(1:5);
    sbMat=[];
    for man=1:length(Dir.path)
        tempsbMat=[];
        for n=1:5
            tempsbMat=[tempsbMat;[MultMat{man,n},n*ones(size(MultMat{man,n},1),1)]];
        end
        try
            tempsbMat=sortrows(tempsbMat,2);% order by clock time current stage start
            sbMat=[sbMat;[tempsbMat,man*ones(size(tempsbMat,1),1)]];
        end
    end
    info{end+1}='Nature Current Stage';
    info{end+1}='Expe num DirPath';
    disp('saving BigMat.mat in dropbox')
    save('/home/mobsyoda/Dropbox/MOBS_workingON/AnalyseMultivarieMarie/BigMatNew.mat','sbMat','info','NameStage','Dir')
end




%% remove short episods
for n=1:5
    eval(['test=Mat',nameEpochs{n},';']);
    test=test(find(test(:,1)>3),:);
    eval(['Mat',nameEpochs{n},'=test;']);
end


%%
% enlever épisodes<10s
% faire matrice pour chaque expe
MethodeGLM=2;
if dozscore, MethodeGLM=1;end
figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.5 0.6]),numfig=gcf;
for n=1:5
    eval(['test=Mat',nameEpochs{n},';']);
    test(isinf(test))=NaN;
    id1=find(nanstd(test)~=0 & ~isnan(nanstd(test)));
    if dozscore, test=zscore(test(:,id1),0,1);end
    id2=find(~isnan(nanmean(test,1)));
    test=test(:,id2);

    x=(test(:,1)); y=(test(:,2:end));
%     x=(test(:,1)); y=(test(:,2:65));
%     idshortREm=find(x<10);
%     x(idshortREm)=[];
%     y(idshortREm,:)=[];
    
    figure, plot(x,y(:,7),'k.'), title(nameEpochs{n})
    set(gca,'xscale','log')
    set(gca,'xtick',[0.1 1 2 3 5 10 50 100 200])
    
    figure(numfig)
    % rename info
    tinfo=info;
    for i=1:length(tinfo)
        id=strfind(tinfo{i},'stage');
        if ~isempty(id)
            tinfo{i}=[tinfo{i}(1:id-1),nameEpochs{n},tinfo{i}(id+5:end)];
        end
        id=strfind(tinfo{i},' zscore');
        if ~isempty(id)
            tinfo{i}(id:id+6)=[];
        end
        id=strfind(tinfo{i},'passed current');
        if ~isempty(id)
            tinfo{i}(id+6:id+13)=[];
        end
        if i<10, tinfo{i}=[tinfo{i},'  ',num2str(i)]; else, tinfo{i}=[tinfo{i},' ',num2str(i)];end
    end
    if dozscore, tinfo=tinfo(id1);end
    tinfo=tinfo(id2);
    
    if MethodeGLM==1
    [gl,dev,stats] = glmfit(y,x);
    xfit = glmval(gl,y, 'identity');
    elseif MethodeGLM==2
    [gl,dev,stats] = glmfit(y,x,'poisson','link','log');
    xfit = glmval(gl,y, 'log');
    elseif MethodeGLM==3   
    [gl,dev,stats] = glmfit(y,x,'normal','link','log');
    xfit = glmval(gl,y, 'log');  
    elseif MethodeGLM==4
    [gl,dev,stats] = glmfit(y,x,'gamma','link','reciprocal');
    xfit = glmval(gl,y, 'reciprocal');
    end
    
    subplot(3,5,n),  scatter(x,xfit,100,y(:,1),'.'); ylabel('predicted')
%     title([nameEpochs{n},sprintf(' fitted expe %1.3f',sqrt(nansum((x-xfit).^2))/length(x))])
    title([nameEpochs{n},sprintf(' fitted expe %1.3f',nanmean(abs((x-xfit))))])
    line([min(x),max(x)],[min(x),max(x)],'Color',[0.5 0.5 0.5])
    
    subplot(3,5,5+n), plot(stats.beta,'ko-','markerfacecolor','k')
    id=find(stats.p<0.05 & abs(stats.beta)>0.5*std(abs(stats.beta))); title([nameEpochs{n},' All mice'])
    hold on, plot(id,stats.beta(id),'go','markerfacecolor','g')
    
    subplot(3,5,10+n),             
    text(0,0.5,[{['DURATION of current ',nameEpochs{n},' predicted by:']};' ';tinfo(id)]);axis off
end

%% conditional 
% get REM just after N2
for n=1:5
figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.1 0.5 0.6]),
    for m=1:5
        eval(['test=Mat',nameEpochs{n},';']);
        test=test(find(test(:,23)==m),:);
        test(isinf(test))=nan; 
        x=(test(:,1)); y=(test(:,2:end));
        try
            % rename info
            tinfo=info;
            for i=1:length(tinfo)
                id=strfind(tinfo{i},'stage');
                if ~isempty(id)
                    tinfo{i}=[tinfo{i}(1:id-1),nameEpochs{n},tinfo{i}(id+5:end)];
                end
                id=strfind(tinfo{i},' zscore');
                if ~isempty(id)
                    tinfo{i}(id:id+6)=[];
                end
                id=strfind(tinfo{i},'passed current');
                if ~isempty(id)
                    tinfo{i}(id+6:id+13)=[];
                end
                if i<10, tinfo{i}=[tinfo{i},'  ',num2str(i)]; else, tinfo{i}=[tinfo{i},' ',num2str(i)];end
            end
            
            [gl,dev,stats] = glmfit(y,x);
            xfit = glmval(gl,y, 'identity');
            subplot(3,5,m),  scatter(x,xfit,100,y(:,1),'.'); ylabel('predicted')
            title([nameEpochs{m},'->',nameEpochs{n},' ',sprintf(' fitted expe %1.3f',sqrt(nansum((x-xfit).^2))/length(x))])
            line([min(x),max(x)],[min(x),max(x)],'Color',[0.5 0.5 0.5])
            
            subplot(3,5,5+m), plot(stats.beta,'ko-','markerfacecolor','k')
            id=find(abs(stats.beta)>2*std(abs(stats.beta))); title([nameEpochs{n},' following ',nameEpochs{m},' All mice'])
            hold on, plot(id,stats.beta(id),'go','markerfacecolor','g')
            
            subplot(3,5,10+m),
            text(0,0.5,[{['DURATION of current ',nameEpochs{n},' predicted by:']};' ';tinfo(id)]);axis off
        end
    end
end