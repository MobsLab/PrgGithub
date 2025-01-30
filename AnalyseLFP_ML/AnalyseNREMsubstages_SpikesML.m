%AnalyseNREMsubstages_SpikesML
%
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%colori=[0.5 0.5 0.5;0 0 0 ;0.5 0.2 0.1;0.1 0.7 0 ;0.7 0.2 0.8 ; 1 0.5 0.8 ;1 0 1;0.7 0.2 0.8 ; 1 0.5 0.8 ;1 0 1];
colori=[0 0 1;0.5 0.5 0.8;0.5 0.5 0.5;0 0 0; 0.7 0.2 1 ; 1 0.2 0.8 ;1 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0];
NamesEp={'SLEEP','NREM','WAKE','REM','N1','N2','N3','N1wd','N2wd','N3wd','Total'}; 
savFig=1;
Windo=3;% in sec (default =1)
if floor(Windo)==Windo, titw=sprintf('%ds',Windo); else, titw=sprintf('%dms',floor(Windo*1E3));end
timeZT=[0:0.5:12];%h  
tps=0:0.05:1; % sample on rescales periods

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
nameAnaly=['Analyse_SpikesNREMStages_',titw,'.mat'];
doNew=1;
if doNew==1
    nameAnaly=[nameAnaly(1:24),'New',nameAnaly(25:end)];
    Dir=PathForExperimentsMLnew('Spikes');
    FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_Spikes';
elseif doNew==2
    nameAnaly=[nameAnaly(1:24),'NewDown',nameAnaly(25:end)];
    Dir=PathForExperimentsMLnew('SpikesDownStates');
    FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_SpikesDown';
else
    FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NeuronFiringRate';
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
    Dir=RestrictPathForExperiment(Dir,'nMice',[243 244 251]);
end
% order mice
[mice,a,b]=unique(Dir.name);
orderind=sortrows([1:length(Dir.path);b']',2);
orderind=orderind(:,1)';
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
PlotIndiv=0;
if PlotIndiv, figure('Color',[1 1 1],'Unit','normalized','Position',[0.12 0.34 0.45 0.6]);end

%res='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';

try
    load([res,'/',nameAnaly]);
    AllZTz;PAllN;
    disp([nameAnaly,' has been loaded.'])
catch
    %%%%%%%%%%%%%%%%%%%%%%%%%% INITIATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    AllN=[]; AllNz=[]; globalAllN=[];
    AllZT=nan(800,length(NamesEp),length(timeZT)-1);
    AllZTz=AllZT; globalAllZT=AllZT; 
    for p=1:4, 
        PAllN{p,1}=[]; PAllN{p,2}=[];
        PAllZT{p,1}=AllZT; PAllZT{p,2}=AllZT;
    end
    MouseMan=nan(1000,1);
    LNZT=0;
    DurEpZT=nan(length(Dir.path),length(NamesEp),length(timeZT)-1);
    Mtrio={};
    
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{orderind(man)})
        cd(Dir.path{orderind(man)})
        
        
        % %%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE SLEEP REM N1 N2 N3 NamesStages SleepStages
        try
            % Substages
            disp('- RunSubstages.m')
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages]=RunSubstages;close;
            % define SLEEP and NREM
            NREM=or(or(N1,N2),N3);
            NREM=mergeCloseIntervals(NREM,10);
            SLEEP=or(NREM,REM);
            SLEEP=mergeCloseIntervals(SLEEP,10);
            Total=or(SLEEP,WAKE);
            Total=mergeCloseIntervals(Total,10);
        end
        
        
        if exist('WAKE','var')
            % %%%%%%%%%%%%%%%%%%%%%% GET SPIKES %%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear S numNeurons
            % Get PFCx Spikes
            [S,numNeurons,numtt,TT]=GetSpikesFromStructure('PFCx');
            % remove MUA from the analysis
            nN=numNeurons;
            for s=1:length(numNeurons)
                if TT{numNeurons(s)}(2)==1
                    nN(nN==numNeurons(s))=[];
                end
            end
            
            % %%%%%%%%%%%%%%%%%%% POISSON CHECK %%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear Spoi
            disp('Calculating Poisson spikes')
            for s=1:length(nN)
                tsN=S{nN(s)};
                Tm=[min(Range(tsN,'s')),max(Range(tsN,'s'))];
                lambda= length(Range(tsN))/diff(Tm);
                T=poissonKB(lambda, diff(Tm));
                tsP=ts((Tm(1)+T)*1E4);
                % decreasing FR poisson
                tinc=Range(tsP).*[1:0.2/(length(Range(tsP))-1):1.2]';% 20%increase interval
                tsPinc=ts(tinc*Tm(2)*1E4/max(tinc));
                % increasing FR poisson
                tdec=Range(tsP).*[1.2:-0.2/(length(Range(tsP))-1):1]';% 20%decrease interval
                tsPdec=ts(sort(tdec)*Tm(2)*1E4/max(tdec));
                
                Spoi{s,1}=tsN;
                Spoi{s,2}=tsP;
                Spoi{s,3}=tsPinc;
                Spoi{s,4}=tsPdec;
            end
            
            %%%%%%%%%%%%%%%%%%%% GET Down states %%%%%%%%%%%%%%%%%%%%%%%%
            clear Down RemoDown N1wd N2wd N3wd
            disp('Get Down states')
            if exist('DownSpk.mat','file')
                load DownSpk.mat Down
            else
                Down=FindDown(S,nN,NREM,10,0.01,1,0,[0 85],1);
                SWSEpoch=NREM; neu=nN;
                save DownSpk.mat Down SWSEpoch neu
            end
            RemoDown=intervalSet(Start(Down)-100,Stop(Down)+100);
            N1wd=N1-RemoDown; N1wd=mergeCloseIntervals(N1wd,1);
            N2wd=N2-RemoDown; N2wd=mergeCloseIntervals(N2wd,1);
            N3wd=N3-RemoDown; N3wd=mergeCloseIntervals(N3wd,1);
            
            % %%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%%
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(Dir.path{man});
            rgZT=Range(NewtsdZT);
            
            manDate=str2num(Dir.path{man}(strfind(Dir.path{man},'/201')+[1:8]));
            if manDate>20160701, hlightON(man)=9; else, hlightON(man)=8;end
            timeZTman=hlightON(man)+timeZT;%h
            
            if ~isempty(nN)
                % %%%%%%%%%%%%%%%%%%%%%%% GET FR %%%%%%%%%%%%%%%%%%%%%%%%%%
                % calculate instataneous firing rate
                t_step=0:0.05:max(Range(SleepStages,'s'));
                iFR=nan(length(nN),length(t_step)); iFRz=iFR;
                for p=1:4, PiFR{p,1}=iFR; PiFR{p,2}=iFR; end
                for s=1:length(nN)
                    iFR(s,:)=hist(Range(S{nN(s)},'s'),t_step);
                    iFRz(s,:)=zscore(hist(Range(S{nN(s)},'s'),t_step));
                    for p=1:4
                        PiFR{p,1}(s,:)=hist(Range(Spoi{s,p},'s'),t_step); 
                        PiFR{p,2}(s,:)=zscore(hist(Range(Spoi{s,p},'s'),t_step));
                    end
                end
                iFRz=tsd(t_step*1E4,iFRz'); 
                iFR=tsd(t_step*1E4,iFR');
                for p=1:4  
                    PiFR{p,1}=tsd(t_step*1E4,PiFR{p,1}'); 
                    PiFR{p,2}=tsd(t_step*1E4,PiFR{p,2}'); 
                end
                % ATTENTION Zscore sur tout !!
                %iFRz=tsd(t_step*1E4,zscore(InstantFR'));  
                
                % plot FR across all session + polysomno
                if 0
                    figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.2 0.4 0.8]), 
                    subplot(311),imagesc(t_step,1:length(nN),InstantFR);
                    title('FR (Hz)');caxis([0 10]);%colorbar;
                    subplot(312),imagesc(t_step,1:length(nN),Data(iFRz)');
                    title('FR zscore');caxis([-2 2]);%colorbar;
                    subplot(313),PlotPolysomnoML(N1,N2,N3,or(or(N1,N2),N3),REM,WAKE,gcf);
                    % save and close
                    saveFigure(gcf,sprintf('AnalyseNREM-FRallNeurons%d',man),[FolderToSave,'/AllNeurons']);
                    close
                end
            
                % %%%%%%%%%%%%%%% GET FR PER STAGES %%%%%%%%%%%%%%%%%%%%%%%
                temp=nan(length(nN),length(NamesEp));
                tempFRz=temp; tempFR=temp; 
                for p=1:4, PtempFR{p,1}=temp;PtempFR{p,2}=temp;end
                tempZT=nan(length(nN),length(NamesEp),length(timeZT)-1);
                tempZTFRz=tempZT; tempZTFR=tempZT;
                for p=1:4, PtempZTFR{p,1}=tempZT;PtempZTFR{p,2}=tempZT;end
                 %per 1/2hours
                disp('... Getting FR per stages')
                for n=1:length(NamesEp)
                    % -----------------------------------------------------
                    % get epoch big enough
                    clear epoch
                    eval(['epoch=',NamesEp{n},';']); disp(NamesEp{n})
                    i_sto=Stop(epoch,'s');    
                    i_sto=i_sto(Stop(epoch,'s')-Start(epoch,'s')>Windo);
                    dE=sum(Stop(epoch,'s')-Start(epoch,'s'));
                    %disp([NamesStages{n},sprintf(' duration = %1.0fmin',dE/60)])
                    
                    % -----------------------------------------------------
                    % firing rate indiv neurons
                    tempFRz(:,n)=mean(Data(Restrict(iFRz,epoch)));
                    tempFR(:,n)=mean(Data(Restrict(iFR,epoch)));
                    for p=1:4
                        PtempFR{p,1}(:,n)=mean(Data(Restrict(PiFR{p,1},epoch)));
                        PtempFR{p,2}(:,n)=mean(Data(Restrict(PiFR{p,2},epoch)));
                    end
                    for s=1:length(nN)
                        temp(s,n)=length(Range(Restrict(S{nN(s)},epoch)))/dE;
                    end
                    
                    % -----------------------------------------------------
                    % FR over time 
                    
                    for su=1:length(timeZTman)-1
                        st1=rgZT(min((find(Data(NewtsdZT)-timeZTman(su)*3600*1E4>0))));
                        st2=rgZT(min((find(Data(NewtsdZT)-timeZTman(su+1)*3600*1E4>0))));
                        if ~isempty(st1) && isempty(st2),st2=max(rgZT);end
                        
                        epochZT=and(epoch,intervalSet(st1,st2));
                        dEZT=sum(Stop(epochZT,'s')-Start(epochZT,'s'));
                        DurEpZT(man,n,su)=dEZT;
                        if dEZT~=0
                            % firing rate indiv neurons
                            tempZTFRz(:,n,su)=mean(Data(Restrict(iFRz,epochZT)));
                            tempZTFR(:,n,su)=mean(Data(Restrict(iFR,epochZT)));
                            for p=1:4
                                PtempZTFR{p,1}(:,n,su)=mean(Data(Restrict(PiFR{p,1},epochZT)));
                                PtempZTFR{p,2}(:,n,su)=mean(Data(Restrict(PiFR{p,2},epochZT)));
                            end
                            
                            for s=1:length(nN)
                                tempZT(s,n,su)=length(Range(Restrict(S{nN(s)},epochZT)))/dEZT;
                            end
                        end
                    end
                end
                % store
                globalAllN=[globalAllN;temp];
                AllN=[AllN;tempFR];
                AllNz=[AllNz;tempFRz];
                for p=1:4 
                    PAllN{p,1}=[PAllN{p,1};PtempFR{p,1}]; 
                    PAllN{p,2}=[PAllN{p,2};PtempFR{p,2}];
                end
               
                globalAllZT(LNZT+(1:length(nN)),:,:)=tempZT;
                AllZT(LNZT+(1:length(nN)),:,:)=tempZTFR;
                AllZTz(LNZT+(1:length(nN)),:,:)=tempZTFRz;
                for p=1:4
                    PAllZT{p,1}(LNZT+(1:length(nN)),:,:)=PtempZTFR{p,1}; 
                    PAllZT{p,2}(LNZT+(1:length(nN)),:,:)=PtempZTFR{p,2};
                end
                MouseMan(LNZT+(1:length(nN)))=orderind(man);
                
                LNZT=LNZT+length(nN);
                
                
                % %%%%%%%%%%%%%%% GET FR AT TRANSITION %%%%%%%%%%%%%%%%
                resNamesEp={'WAKE','REM','N1','N2','N3'};
                
                Stages=[];
                for n=1:length(resNamesEp)
                    eval(['epoch=',resNamesEp{n},';'])
                    Stages=[Stages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
                end
                Stages=sortrows(Stages,1);
                s_mat=[Stages,[0;Stages(1:end-1,3)],[0;0;Stages(1:end-2,3)]];
                
                disp('... Getting FR per trio of transition. WAIT!')
                for n_i=1:length(resNamesEp)
                    for n_j=1:length(resNamesEp)
                        for n_k=1:length(resNamesEp)
                            if n_i~=n_j && n_k~=n_j
                                ind=find(s_mat(:,5)==n_i & s_mat(:,4)==n_j & s_mat(:,3)==n_k);
                                
                                % get time of small episod
                                Ii=intervalSet(s_mat(ind-2,1)*1E4,s_mat(ind-2,2)*1E4);
                                Ij=intervalSet(s_mat(ind-1,1)*1E4,s_mat(ind-1,2)*1E4);
                                Ik=intervalSet(s_mat(ind,1)*1E4,s_mat(ind,2)*1E4);
                                
                                % get spectrum of each trio of episods
                                tempz=nan(length(ind),length(nN),3*length(tps));
                                for i=1:length(ind)
                                    % Ii
                                    rg=Range(Restrict(iFRz,subset(Ii,i)));
                                    FRzTran=tsd(0:1/(length(rg)-1):1,Data(Restrict(iFRz,subset(Ii,i))));
                                    try tempz(i,:,1:length(tps))=Data(Restrict(FRzTran,tps))';end
                                    
                                    % Ij
                                    rg=Range(Restrict(iFRz,subset(Ij,i)));
                                    FRzTran=tsd(0:1/(length(rg)-1):1,Data(Restrict(iFRz,subset(Ij,i))));
                                    try tempz(i,:,length(tps)+1:2*length(tps))=Data(Restrict(FRzTran,tps))';end
                                    
                                    % Ik
                                    rg=Range(Restrict(iFRz,subset(Ik,i)));
                                    FRzTran=tsd(0:1/(length(rg)-1):1,Data(Restrict(iFRz,subset(Ik,i))));
                                    try tempz(i,:,2*length(tps)+1:end)=Data(Restrict(FRzTran,tps))';end
                                end
                                Mtrio{man,n_i,n_j,n_k}=tempz;
                            end
                        end
                    end
                end
                disp('Done.')
            else
                disp('No PFCx neurons');
            end
        end
    end
    AllZT=AllZT(1:LNZT,:,:);
    AllZTz=AllZTz(1:LNZT,:,:);
    globalAllZT=globalAllZT(1:LNZT,:,:);
    for p=1:4
        PAllZT{p,1}=PAllZT{p,1}(1:LNZT,:,:);
        PAllZT{p,2}=PAllZT{p,2}(1:LNZT,:,:);
    end
    
    %saving
    save([res,'/',nameAnaly],'Dir','Windo','NamesEp','tps','timeZT','globalAllN','globalAllZT',...
        'AllN','AllNz','AllZT','AllZTz','PAllN','PAllZT','Mtrio','resNamesEp','DurEpZT','MouseMan','hlightON');
    if PlotIndiv,saveFigure(gcf,'AnalyseNREM_PFCxFR_indiv',FolderToSave);end
end

%man=1;


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<< FR, all neurons <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.7 0.9]), numF=gcf;

tempName=NamesEp([1:5,8,6,9,7,10]);
if 0% N1 N2 N3 with down states removed
    AA=AllN(:,[1:5,8,6,9,7,10])*10;
    BB=AllNz(:,[1:5,8,6,9,7,10]);
else %poisson
    p=1;
    AA=PAllN{p,1}(:,[1:5,8,6,9,7,10])*10;
    BB=PAllN{p,2}(:,[1:5,8,6,9,7,10]);
end

subplot(3,4,1),PlotErrorBarN(AA,0,0);% /10 cf step of 0.1s 
title('FR globaly calculated');set(gca,'Yscale','log');
set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);

subplot(3,4,5),boxplot(log10(AA));%
set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45); 
title('FR globaly calculated'); ylim([log10(0.01) log10(100)])
set(gca,'Ytick',log10([0.01,0.1 1 10 100])),set(gca,'YtickLabel',{'10^-2','10^-1','10^0','10^1','10^2'})

subplot(3,4,9),PlotErrorBarN(BB,0,0);title('FR zscore')
set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);



subplot(3,4,2),bar(nanmean(BB));title(sprintf('FR zscore (n=%d)',sum(isnan(nanmean(BB,2))==0)))
hold on,errorbar(nanmean(BB),stdError(BB),'+k'); ylim([-0.09 0.16]);xlim([0.3 length(tempName)+0.7])
set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);

% find REM neurons and WAKE neurons
i1=find(strcmp(tempName,'WAKE'));i2=find(strcmp(tempName,'REM'));
ratioRW=AA(:,i2)./AA(:,i1);

subplot(3,4,6),bar(nanmean(BB(find(ratioRW<1),:)))
hold on,errorbar(nanmean(BB(find(ratioRW<1),:)),stdError(BB(find(ratioRW<1),:)),'+k')
set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); ylim([-0.09 0.16]); set(gca,'XtickLabelRotation',45);
title(sprintf('FR zscore, REM < WAKE (n=%d)',length(find(ratioRW<1)))); xlim([0.3 length(tempName)+0.7])

subplot(3,4,10),bar(nanmean(BB(find(ratioRW>1),:)))
hold on,errorbar(nanmean(BB(find(ratioRW>1),:)),stdError(BB(find(ratioRW>1),:)),'+k')
set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); ylim([-0.09 0.16]); set(gca,'XtickLabelRotation',45);
title(sprintf('FR zscore, REM > WAKE (n=%d)',length(find(ratioRW>1)))); xlim([0.3 length(tempName)+0.7])

% stats
leg={' ','Pooled Ttest2: '};
leg1={' ','Pooled Ttest2: '};
leg2={' ','Pooled Ttest2: '};
for n=1:length(tempName)
    legtemp=[tempName{n},' vs '];
    legtemp1=[tempName{n},' vs '];
    legtemp2=[tempName{n},' vs '];
    for n2=n+1:length(tempName)
        if length(legtemp)>70
            leg=[leg,legtemp];leg1=[leg1,legtemp1];leg2=[leg2,legtemp2];
            legtemp='      '; legtemp1='      '; legtemp2='      '; 
        end
        [H,p]=ttest2(BB(:,n),BB(:,n2));
        legtemp=[legtemp,sprintf([tempName{n2},': p=%1.3f, '],p)];
        [H,p]=ttest2(BB(find(ratioRW<1),n),BB(find(ratioRW<1),n2));
        legtemp1=[legtemp1,sprintf([tempName{n2},': p=%1.3f, '],p)];
        [H,p]=ttest2(BB(find(ratioRW>1),n),BB(find(ratioRW>1),n2));
        legtemp2=[legtemp2,sprintf([tempName{n2},': p=%1.3f, '],p)];
    end
    if n<length(tempName), 
        leg=[leg,legtemp];leg1=[leg1,legtemp1];leg2=[leg2,legtemp2];
    end
end
subplot(3,4,3:4), text(-0.1,0.5,leg); axis off
subplot(3,4,7:8), text(-0.1,0.5,leg1); axis off
subplot(3,4,11:12), text(-0.1,0.5,leg2); axis off
%saveFigure(numF.Number,'AnalyseNREM-FRchangeNeuronsREMandWAKE',FolderToSave);
%saveFigure(numF.Number,'AnalyseNREM-FRchangeNeuronsREMandWAKE-Down',FolderToSave);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< Repartition FR change <<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.8 0.9]),numF=gcf;
xbin=[-0.6:1.2/99:0.6];
L=1:length(tempName);
for n=1:length(L)
    for n2=1:length(L)
        if n~=n2
            subplot(length(L),length(L),length(L)*(n-1)+n2), hold on,
            ratioRW=log10(AllN(:,L(n))./AllN(:,L(n2)));
            [y,x]=hist(ratioRW,xbin); xlim([-1 1])
            bar(x,100*y/sum(y),'k')
            plot(x,smooth(100*y/sum(y),5),'r'); 
            xlim([-0.5 0.5]);
            title(['FR ',tempName{L(n)},' / ',tempName{L(n2)}]); 
            line([0 0],[0 max(y)],'Color',[0.5 0.5 0.5])
            ylim([0 max(100*y/sum(y))])
            if n==length(L), xlabel('log10(ratio)');end
        end
    end
end
%saveFigure(numF.Number,'AnalyseNREM-FRchangeDistribution',FolderToSave);


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< ZT evol, types of neurons <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% not good
%valZT=[11,12.5;16.5,18];
%valZT=[9.5,11;16.5,18];
valZT=[1,2.5;8.5,10];
idZT=find(ismember(timeZT,valZT));
indEp=3:7;%:10;
%indEp=[3:4,8:10];
%indEp=1:4;
tempName=NamesEp(:,indEp);

do=1; % neuron type
%do=2; % low and high FR neurons
%do=3; % unchanged, increasing, decreasing neurons
%do=4; % neuron type, prefered btween N1 N2 or N3 only

pp=1; %% pp=1 normal, 2 poisson, 3 decreasing poisson, 4 increasing poisson
ppAllN=PAllN{pp,1};
ppZTz=PAllZT{pp,2};
if do==1  % neuron type
    %MAT=AllNz(:,indEp);
    MAT=10*AllN(:,indEp);
    %MAT=zscore(10*ppAllN(:,indEp)')';
    [BE,idx]=max(MAT');
    
    B=MAT; for b=1:size(B,1),B(b,idx(b))=nan;end
    [BE,idx2]=max(B'); clear Didx
    for b=1:size(MAT,1),Didx(b)=100*MAT(b,idx2(b))/MAT(b,idx(b));end 
    
    B=MAT; for b=1:size(B,1),B(b,idx(b))=nan; B(b,idx2(b))=nan;end
    [BE,idx3]=max(B');clear Didx2
    for b=1:size(MAT,1),Didx2(b)=100*MAT(b,idx3(b))/MAT(b,idx2(b));end
    
    nEp=[NamesEp(:,indEp),{'All'},{'N2/N3'}];
    for n=1:5
        %lis{n}=find(idx==n);
        lis{n}=find(idx==n & Didx<75);
    end
    lis{n+1}=1:size(MAT,1);
    lis{n+2}=find(idx>3 & idx2>3 & Didx>=85 & Didx2<85);
     
elseif do==2 % low and high FR neurons
    MAT=zscore(10*ppAllN(:,indEp)')';
    [BE,idx]=sort(nanmean(10*ppAllN(:,indEp),2));
    clear lis
    fract=1/6;
    lis{1}=idx(1:ceil(fract*length(idx))); % weak FR
    fr1=nanmean(nanmean(10*ppAllN(lis{1},indEp),2));
    lis{2}=idx(length(idx)-ceil(fract*length(idx))+1:length(idx)); % High FR
    fr2=nanmean(nanmean(10*ppAllN(lis{2},indEp),2));
    lis{3}=1:size(ppAllN,1);
    nEp={sprintf('weak FR av=%1.1fHz',fr1),sprintf('High FR av=%1.1fHz',fr2),'All'};
    
elseif do==4 % low and high FR neurons
    MAT=10*AllN(:,5:7);
    [BE,idx]=max(MAT');
    B=MAT; for b=1:size(B,1),B(b,idx(b))=nan;end
    
    [BE,idx2]=max(B'); clear Didx
    for b=1:size(MAT,1),Didx(b)=100*MAT(b,idx2(b))/MAT(b,idx(b));end 
    B=MAT; for b=1:size(B,1),B(b,idx(b))=nan; B(b,idx2(b))=nan;end
    
    nEp=[NamesEp(:,5:7),{'All'}];
    for n=1:5
        lis{n}=find(idx==n & Didx<90);
    end
    lis{n+1}=1:size(MAT,1);
else
    ppZTz=PAllZT{1,2};
    %temp=squeeze(ppZTz(:,strcmp(NamesEp,'WAKE'),:));
    temp=squeeze(ppZTz(:,strcmp(NamesEp,'Total'),:));
    %temp=squeeze(ppZTz(:,strcmp(NamesEp,'SLEEP'),:));
    Early=nanmean(temp(:,find(timeZT(1:end-1)<2)),2);
    Late=nanmean(temp(:,find(timeZT(1:end-1)>6.5)),2);
    Change=Early-Late;clear lis
    lis{1}=find(Change<0.05 & Change>-0.05); %unchanged
    lis{2}=find(Change<-0.05); % increase
    lis{3}=find(Change>0.05); % decrease
    nEp={'unchanged','increasing','decreasing'};
end

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.9 0.8]), numF=gcf;
clear matbar matbarSD
for Nn=1:length(lis)
    idN=lis{Nn};
    clear matbar matbarSD 
    leg={'Ttest2: '};
    for n=1:length(tempName)
        AA=squeeze(ppZTz(idN,indEp(n),:));
        
        tempZT1=nanmean(AA(:,idZT(1):idZT(2)-1),2);
        tempZT2=nanmean(AA(:,idZT(3):idZT(4)-1),2);
        matbar(1,n)=nanmean(tempZT1);
        matbarSD(1,n)=stdError(tempZT1);
        matbar(2,n)=nanmean(tempZT2);
        matbarSD(2,n)=stdError(tempZT2);
        
        subplot(3,length(nEp),Nn),hold on,
        errorbar(timeZT(3:end-3),nanmean(AA(:,3:end-2)),stdError(AA(:,3:end-2)),'Color',colori(indEp(n),:),'Linewidth',2)
        ylabel('zscore FR'); xlabel('ZT Time (h)'); xlim([min(timeZT),max(timeZT)])
        ylim([-0.17 0.35])
        % stats
        [H,p]=ttest2(tempZT1,tempZT2);
        if p<0.05, leg=[leg,sprintf(['* ',tempName{n},' : p=%1.3f, '],p)]; else, leg=[leg,sprintf([tempName{n},' : p=%1.3f, '],p)];end
        
        % Spierman
        if 0 % all points
            aa=ones(size(AA,1),1)*timeZT(3:end-3);
            x=aa(~isnan(AA));y=AA(~isnan(AA));
            [r,p]=corr(x,y,'type','Spearman');
        else % correlation on mean values
            x=timeZT(3:end-3);y=nanmean(AA(:,3:end-2),1);
            x(isnan(y))=[];y(isnan(y))=[];
            [r,p]=corr(x',y','type','Spearman');
        end
        
        if p<0.05, leg=[leg,sprintf(['     * spearman r=%1.1f, p=%1.3f, '],r,p)]; else, leg=[leg,sprintf(['     spearman r=%1.1f, p=%1.3f, '],r,p)]; end
    end
    
    if Nn==length(lis), legend(tempName); if do==2, title('Poisson generated neurons') ;end;end
    set(gca,'Xtick',1:2:11);
    
    subplot(3,length(nEp),length(nEp)+Nn), hold on, 
    bar(matbar');ylabel('zscore FR');
    errorbar([[1:length(tempName)]-0.15;[1:length(tempName)]+0.15]',matbar',matbarSD','+k')
    ylim([-0.15 0.28]); xlim([0.5 0.5+length(tempName)])
    set(gca,'Xtick',1:length(indEp)),set(gca,'XtickLabel',tempName);set(gca,'XtickLabelRotation',45); 
    if Nn==1, legend({sprintf('%1.1f-%1.1fh',timeZT(idZT(1)),timeZT(idZT(2))),...
        sprintf('%1.1f-%1.1fh',timeZT(idZT(3)),timeZT(idZT(4)))}); end
    subplot(3,length(nEp),Nn),title(sprintf(['neuron ',nEp{Nn},' (n=%d)'],length(idN)))
    
    subplot(3,length(nEp),2*length(nEp)+Nn),
    if 1
        text(0,0.4,leg); axis off
    else
        bar(nanmean(MAT(idN,:),1));ylabel('zscore FR'); hold on,
        errorbar([1:length(tempName)],nanmean(MAT(idN,:),1),stdError(MAT(idN,:)),'+k')
        xlim([0.5 0.5+length(tempName)])
    set(gca,'Xtick',1:length(indEp)),set(gca,'XtickLabel',tempName);set(gca,'XtickLabelRotation',45); 
    end
end
colormap gray
%saveFigure(numF.Number,'AnalyseNREM-ZTEvolFRzscorePerGroups',FolderToSave);
%saveFigure(numF.Number,'AnalyseNREM-ZTEvolFRzPerGroups-HighLow',FolderToSave);

%% absolute FR
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.9 0.8]), numF=gcf;
ppAllN=PAllN{pp,1};
ppZTz=PAllZT{pp,2};
for Nn=1:max(length(lis),6)
    idN=lis{Nn};
    clear matFR matFRz
    for n=1:length(tempName)
        matFR(1:length(idN),n)=10*AllN(idN,indEp(n));
        matFRz(1:length(idN),n)=AllNz(idN,indEp(n));
%         matFR(1:length(idN),n)=ppAllN(idN,indEp(n));
%         matFRz(1:length(idN),n)=ppZTz(idN,indEp(n));
    end
    subplot(3,length(lis),length(lis)+Nn),bar(nanmean(matFR));%
    hold on, errorbar(1:5,nanmean(matFR),stdError(matFR),'+k')
    
    subplot(3,length(lis),Nn),boxplot(log10(matFR));
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
    if Nn==1, ylabel('FR (Hz)');end; %ylim([log10(0.01) log10(100)])
    %set(gca,'Ytick',log10([0.01,0.1 1 10 100])),set(gca,'YtickLabel',{'10^-2','10^-1','10^0','10^1','10^2'})
    title(sprintf(['neuron ',nEp{Nn},' (n=%d)'],length(idN)))
    %PlotErrorBarN_KJ
    pval=nan(4,4); stats = []; groups = cell(0);
    for c1=1:5, for c2=c1+1:5
            try,idx=find(~isnan(matFR(:,c1)) & ~isnan(matFR(:,c2)));
                [h,p]= ttest2(matFR(idx,c1),matFR(idx,c2)); pval(c1,c2)=p; pval(c2,c1)=p;
                if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
            end; end;end
    stats(stats>0.05)=nan; sigstar(groups,stats)
    
    subplot(3,length(lis),2*length(lis)+Nn),bar(nanmean(matFRz,1));%
    hold on, errorbar(1:length(indEp),nanmean(matFRz),stdError(matFRz),'+k')
    title(sprintf(['neuron ',nEp{Nn},' (n=%d)'],length(idN)))
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
    %PlotErrorBarN_KJ
    pval=nan(4,4); stats = []; groups = cell(0);
    for c1=1:5, for c2=c1+1:5
            try,idx=find(~isnan(matFRz(:,c1)) & ~isnan(matFRz(:,c2)));
                [h,p]= ttest2(matFRz(idx,c1),matFRz(idx,c2)); pval(c1,c2)=p; pval(c2,c1)=p;
                if h==1, groups{length(groups)+1}=[c1 c2]; stats = [stats p];end
            end; end;end
    stats(stats>0.05)=nan; sigstar(groups,stats)
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< types of ZT evol, neurons <<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

ppZTz=PAllZT{1,2};
temp=squeeze(ppZTz(:,strcmp(NamesEp,'WAKE'),:));
%temp=squeeze(ppZTz(:,strcmp(NamesEp,'SLEEP'),:));
Early=nanmean(temp(:,find(timeZT(1:end-1)<11)),2);
Late=nanmean(temp(:,find(timeZT(1:end-1)>15.5)),2);

Change=Early-Late;
clear lis
%figure, hist(Change,[-0.75:0.03:0.75]); xlim([-0.73 0.73])
lis{1}=find(Change<0.05 & Change>-0.05); %unchanged
lis{2}=find(Change<-0.1); % increase
lis{3}=find(Change>0.1); % decrease
nEp={'unchanged','increasing','decreasing'};

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.15 0.5 0.8])
%indEp=[1:5,8,6,9,7,10];
indEp=[1:7];
tempName=NamesEp(indEp);
[BE,idx]=max(PAllN{1,2}(:,3:7)');
for li=1:length(lis)
    AA=AllN(lis{li},indEp)*10;
    BB=AllNz(lis{li},indEp);
    idN=idx(lis{li});
    clear Mat
    for n=1:5, Mat(n)=100*length(find(idN==n))/length(lis{li});end
    
    subplot(3,3,li),boxplot(log10(AA));%
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
    ylabel('FR global'); ylim([log10(0.01) log10(100)])
    set(gca,'Ytick',log10([0.01,0.1 1 10 100])),set(gca,'YtickLabel',{'10^-2','10^-1','10^0','10^1','10^2'})
    title(sprintf([nEp{li},' (n=%d)'],length(lis{li})))
    
    subplot(3,3,li+3),bar(nanmean(BB));ylabel('FR zscore')
    hold on,errorbar(nanmean(BB),stdError(BB),'+k'); ylim([-0.11 0.13]);xlim([0.3 length(tempName)+0.7])
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
    
    subplot(3,3,li+6),bar(Mat); xlabel('neuron type')
    set(gca,'Xtick',1:5),set(gca,'XtickLabel',NamesEp(3:7)); set(gca,'XtickLabelRotation',45);
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<< global FR, evolution across day <<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% look at firing rate
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.15 0.5 0.7]), numF=gcf;
indEp=1:7;
AA=100*AllN(:,indEp)./[AllN(:,find(strcmp(NamesEp,'WAKE')))*ones(1,length(indEp))];
% mean FR for substages, normalized by WAKE

subplot(2,3,1),bar(nanmean(AA)), colormap('Gray')
hold on,errorbar(nanmean(AA),nanstd(AA)/sqrt(length(AllN(:,1))),'+k')
ylabel('FR (% WAKE)')
Nexpe=length(unique(Dir.path));
Nmouse=length(unique(Dir.name));
title({'Firing rates across sleep',sprintf('(%d neurons, N=%dmice, n=%ddays)',length(AllN(:,1)),Nmouse,Nexpe)});
set(gca,'Xtick',1:length(indEp)),set(gca,'XtickLabel',NamesEp(indEp)); 
set(gca,'XtickLabelRotation',45); xlim([0.5 0.5+length(indEp)])

% control duration
subplot(2,3,2:3), hold on,
for n=1:length(indEp)
    %temp=100*squeeze(DurEpZT(:,indEp(n),:))./squeeze(DurEpZT(:,find(strcmp(NamesEp,'SLEEP')),:));
    temp=squeeze(DurEpZT(:,n,:));
    errorbar(timeZT(1:end-1),nanmean(temp),nanstd(temp)/sqrt(length(AllN(:,1))),'Color',colori(indEp(n),:),'Linewidth',2)
end
xlim([timeZT(1)-0.5 timeZT(end-1)+0.5]); ylabel('duration stages (s)')
legend(NamesEp(indEp)); title('Evolution across day time'); xlabel('Time of the day (h)')

% FR across the day, zscore per neuron
dozscore=1;
if dozscore
    tit='(zscore per neurons)';
%     for s=1:length(AllN(:,1))
%         temp=squeeze(AllZT(s,:,:));
%         Mat(s,1:size(AllZT,2),1:size(AllZT,3))=zscore(temp);
%     end
    Mat=AllZTz;
else
    Mat=AllZT; tit='(Hz)';
end
subplot(2,3,5:6), hold on,
tempW=squeeze(Mat(:,find(strcmp(NamesEp,'WAKE')),:));
Matbar=nan(length(indEp),5);
for n=1:length(indEp)
    temp=squeeze(Mat(:,indEp(n),:));
    %errorbar(nanmean(100*temp./(tempW(:,1)*ones(1,5)),1),nanstd(100*temp./(tempW(:,1)*ones(1,5)))/sqrt(length(AllN(:,1))),'Color',colori(n,:),'Linewidth',2)
    errorbar(timeZT(1:end-1),nanmean(temp,1),stdError(temp),'Color',colori(indEp(n),:),'Linewidth',2)
    A=[nanmean(temp(:,1:4),2),nanmean(temp(:,end-3:end),2)];
    Matbar(n,1:2)=[nanmean(A(:,1)),nanmean(A(:,2))];
    Matbar(n,3:4)=[nanstd(A(:,1)),nanstd(A(:,2))]./sqrt(length(AllN(:,1)));
    a=find(~isnan(A(:,1)) & ~isnan(A(:,2)));
    [h,Matbar(n,5)]= ttest2(A(a,1),A(a,2));
end
ylabel(['FR ',tit]); xlim([timeZT(1)-0.5,timeZT(end-1)+0.5])
title('Evolution across day time');xlabel('Time of the day (h)')

subplot(2,3,4), hold on,
bar(Matbar(:,1:2))
hold on, errorbar([(1:length(indEp))-0.15;(1:length(indEp))+0.15],Matbar(:,1:2)',Matbar(:,3:4)','+k')
legend({sprintf('%dh-%dh',timeZT(1),timeZT(5)),sprintf('%dh-%dh',timeZT(end-4),timeZT(end))})
set(gca,'Xtick',1:length(indEp)),set(gca,'XtickLabel',NamesEp(indEp));set(gca,'XtickLabelRotation',45); 
%saveFigure(numF.Number,'AnalyseNREM-ZTEvolFRzscoreAll',FolderToSave);



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< PCA on FR across stages <<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

MAT=zscore(10*AllN(:,3:7)')';
tempName=NamesEp(3:7);

[r,p]=corrcoef(MAT);
[V,L]=pcacov(r);
[BE,id]=sort(V(:,1));

figure('color',[1 1 1],'Unit','normalized','Position',[0.1 0.2 0.5 0.3]), numF=gcf;
subplot(1,2,1),imagesc(r(id,id)),caxis([-1 1])
set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
set(gca,'Ytick',1:length(tempName)), set(gca,'YtickLabel',tempName(id))
title('PCA corr coeff, dim 1'); colorbar
subplot(1,2,2),imagesc(log10(p(id,id))),
set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
set(gca,'Ytick',1:length(tempName)), set(gca,'YtickLabel',tempName(id))
title('PCA corr coeff pval, dim 1'); caxis([log10(0.0001) 0])
colormap('jet')
colorbar('Ticks',log10([0.0001 0.001 0.01 0.05]),'TickLabels',{'0.0001' '0.001' '0.01' '0.05'})
%saveFigure(numF.Number,'AnalyseNREM-PCAonFR',FolderToSave);
  
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< FR zscore according to Neuron type <<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if 0
    MAT=AllNz(:,[3:5,8,6,9,7,10]);
    tempName=NamesEp([3:5,8,6,9,7,10]);
    if 1 % N1 N2 N3
        [BE,idx]=max(MAT(:,[1:3,5,7])');
        nEp=[NamesEp(:,3:7),{'All'}];
    else % N1 N2 N3 with down states removed
        [BE,idx]=max(MAT(:,[1:2,4,6,8])');
        nEp=[tempName(:,[1:2,4,6,8]),{'All'}];
    end
else
    if 1 % N1 N2 N3 
        tempName=NamesEp(3:7);
        MAT=AllNz(:,3:7);
    else % N1 N2 N3 with down states removed
        tempName=NamesEp([3,4,8:10]);
        MAT=AllNz(:,[3,4,8:10]);
    end
    nEp=[tempName,{'N2/N3'},{'All'}]; 
    [BE,idx]=max(MAT');
    B=MAT; for b=1:size(B,1),B(b,idx(b))=nan;end
    [BE,idx2]=max(B');clear Didx 
    for b=1:size(MAT,1),Didx(b)=100*MAT(b,idx2(b))/MAT(b,idx(b));end
    
    B=MAT; for b=1:size(B,1),B(b,idx(b))=nan; B(b,idx2(b))=nan;end
    [BE,idx3]=max(B');clear Didx2
    for b=1:size(MAT,1),Didx2(b)=100*MAT(b,idx3(b))/MAT(b,idx2(b));end
end
if 1 % FRzscore in second preferred stage <75% preferred stage
    for n=1:5, lis{n}=find(idx==n & Didx<75); end
    lis{n+1}=find(idx>3 & idx2>3 & Didx>=75 & Didx2<75);
else % no restriction
    for n=1:5, lis{n}=find(idx==n); end
    lis{n+1}=find(idx>3 & idx2>3);
end
lis{n+2}=1:size(MAT,1);

% -----------------------------
% interneurons and pyramidal proportion for each neuron type
clear MatClass
for i=1:length(nEp)
    v=lis{i};
    MatClass(i,1)=length(find(NeurTyp(v)==1));%pyr
    MatClass(i,2)=length(find(NeurTyp(v)==-1));%int
    MatClass(i,3)=sum(isnan(NeurTyp(v)));
end
if 0
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.8 0.8]),numF=gcf;
    bar(100*MatClass./(sum(MatClass,2)*ones(1,3)),'stacked'); ylim([0 100]);
    legend({'Pyr','int','undef'}); colormap('gray');
    set(gca,'Xtick',1:length(nEp)), set(gca,'XtickLabel',nEp);
end
% -----------------------------
figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.8 0.8]),numF=gcf;
for i=1:length(nEp)
    v=lis{i};
    %plot
    subplot(2,length(nEp),i), PlotErrorBar(MAT(v,:),0);
    title(['max in ',nEp{i},', n=',num2str(length(v))]); ylim([-0.16 0.28])
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45); 
    if i==1,ylabel('FR zscore');end
    % stats
    legt={'ttest'};legr={'ranksum'};
    for n1=1:length(tempName)
        for n2=n1+1:length(tempName)
            [H,p]=ttest2(MAT(v,n1),MAT(v,n2));
            legt=[legt,sprintf([tempName{n1},' vs ',tempName{n2},': p=%1.3f, '],p)];
            p=ranksum(MAT(v,n1),MAT(v,n2));
            legr=[legr,sprintf([tempName{n1},' vs ',tempName{n2},': p=%1.3f, '],p)];
        end
    end
    %subplot(2,length(nEp),length(nEp)+i), text(0,0.5,[legt,' ',legr]); axis off
    subplot(2,length(nEp),length(nEp)+i), text(0,0.5,legt); axis off
end

%saveFigure(numF.Number,'AnalyseNREM-FRforNeuronTypes',FolderToSave);
%saveFigure(numF.Number,'AnalyseNREM-FRforNeuronTypesDown',FolderToSave);

% -----------------------------
% plotErrorBarN - illisible
if 0
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.8 0.8]),numF=gcf;
    for i=1:length(nEp)-1
        v=lis{i};
        try A=100*MAT(v,:)./(MAT(v,i)*ones(1,5)); catch, A=100*MAT(v,:)./(mean(MAT(v,4:5),2)*ones(1,5)); end
        
        subplot(1,length(nEp)-1,i), PlotErrorBarN(A,0,1);
        title(['max in ',nEp{i},', n=',num2str(length(v))]);
        set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName); set(gca,'XtickLabelRotation',45);
        if i==1,ylabel('FR zscore');end
    end
end

% -----------------------------
%% RepartitionSecondMax
figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.8 0.8]),numF=gcf;
for i=1:length(nEp)-2
    v=lis{i};
    try A=100*MAT(v,:)./(MAT(v,i)*ones(1,5)); catch, A=100*MAT(v,:)./(mean(MAT(v,4:5),2)*ones(1,5)); end
    B=A; B(:,i)=nan;
    [BE,ida]=max(B');
    Deux=[];
    for nv=1:length(v)
        Deux(nv)=B(nv,ida(nv));
    end
    subplot(2,length(nEp)-2,i),
    hist(Deux,[-52:5:100]); xlim([-50 100]);
    title(['max in ',nEp{i},', n=',num2str(length(v))]);
    if i==1,ylabel('#neuron');end
    xlabel('Diff max - second max (%max)')
    hold on, line([75 75],ylim,'Color','r')
    
    subplot(2,length(nEp)-2,length(nEp)-2+i), na=zeros(5,1);
    for a=1:5, na(a,1)=100*length(find(ida==a))/length(v);end
    na(find(na==0))=0.001;
    pie(na'); 
    title(sprintf('pyr/int/NaN:  %d/%d/%d',MatClass(i,1),MatClass(i,2),MatClass(i,3)))
end
legend(tempName); 
colori=[0.5 0.5 0.5;0 0 0; 0.6 0.1 1 ; 1 0.3 1 ;1 0 0;];
colormap(colori)
%saveFigure(numF.Number,'AnalyseNREM-NeuronTypes-RepartitionSecondMax',FolderToSave);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< FR raw according to Neuron type <<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


figure('Color',[1 1 1],'Unit','normalized','Position',[0.05 0.22 0.95 0.8]),numF=gcf;
TypState=[3,4,8:10];
for tst=1:length(TypState)
    MAT2=10*AllN(:,TypState(tst));
    DD=nan(length(nEp),600);
    
    legt={'ttest:'};
    for n1=1:length(nEp)
        v=lis{n1};
        DD(n1,1:length(v))=MAT2(v);
        for n2=n1+1:length(nEp)
            v2=lis{n2};
            [H,p]=ttest2(MAT2(v),MAT2(v2));
            N1=sum(~isnan(MAT2(v))); N2=sum(~isnan(MAT2(v2))); 
            legt=[legt,sprintf([nEp{n1},' vs ',nEp{n2},' : p=%1.3f, (n=%d/%d)'],p,N1,N2)];
%             p=ranksum(MAT(v,n1),MAT(v,n2));
%             legr=[legr,sprintf([nEp{n1},' vs ',nEp{n2},': p=%1.3f, '],p)];
        end
    end
    
    subplot(2,length(TypState),tst)
    boxplot(log10(DD')); 
    set(gca,'Xtick',1:length(nEp)),set(gca,'XtickLabel',nEp); set(gca,'XtickLabelRotation',45); 
    title(['FR during ',NamesEp{TypState(tst)}]); ylim([log10(0.01) log10(100)])
    set(gca,'Ytick',log10([0.01,0.1 1 10 100])),set(gca,'YtickLabel',{'10^-2','10^-1','10^0','10^1','10^2'})
    xlabel('Neuron type')

    subplot(2,length(TypState),length(TypState)+tst),
    text(0,0.5,legt); axis off
end
%saveFigure(numF.Number,'AnalyseNREM_FRperNeuronType',FolderToSave)


%% for info
MultPCA=MAT.*(ones(size(MAT,1),1)*V(:,ppc)');
WDim=sum(MultPCA,1);
for ppc=1
    [BE,id]=sort(V(:,ppc));
    MultPCA=MAT.*(ones(size(MAT,1),1)*V(:,ppc)');
    WDim=sum(MultPCA,1);
   
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.37 0.47]),
    subplot(1,2,1),imagesc(r(id,id)),caxis([-1 1])
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
    set(gca,'Ytick',1:length(tempName)), set(gca,'YtickLabel',tempName(id))
    subplot(1,2,2),imagesc(log10(p(id,id))),
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
    set(gca,'Ytick',1:length(tempName)), set(gca,'YtickLabel',tempName(id))
    
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.37 0.47]),
    subplot(2,3,1),imagesc(r(id,id)),
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
    set(gca,'Ytick',1:length(tempName)), set(gca,'YtickLabel',tempName(id))
    
    subplot(2,3,2), plot(L/sum(L),'ko-'), title('vector contribution')
    subplot(2,3,3), plot(V(:,ppc),'Linewidth',2), title('Vector values')
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
    
    [Bm,idm]=sort(PCAvarR(:,ppc));
    subplot(2,3,4), imagesc(MAT(idm,:)); title('zscore FR')
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
    
    % log, not normalized values
    subplot(2,3,5),imagesc(log(AllN(idm,3:7))), title('log values')
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
    % log, zscored values

    subplot(2,3,6),imagesc(MultPCA(idm,:)); title('MAT * Vector values')
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName(id))
    
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< PCA on FR across stages <<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% PROBLEM : fait sur dimension nb de neurones !
MAT=zscore(10*AllN(:,3:7)')';
tempName=NamesEp(3:7);
%MAT=AllNz(:,3:7);
[r,p]=corrcoef(MAT');
[V,L]=pcacov(r);
SavInd={};
PCAvarR=nan(size(MAT,1),3);
PCAvarP=nan(size(MAT,1),3);
for ppc=1:3
    [BE,id]=sort(V(:,ppc));
    
    MultPCA=MAT.*(V(:,ppc)*ones(1,length(tempName)));
    WDim=sum(MultPCA,1);
    
    for s=1:length(id)
        [rs,ps]=corrcoef(MAT(s,:),WDim);
        PCAvarR(s,ppc)=rs(1,2);
        PCAvarP(s,ppc)=ps(1,2);
    end
    
    SavInd{ppc,1}=[id(1:50),id(end:-1:end-49)];
    SavInd{ppc,2}=MAT(id,:);
    SavInd{ppc,3}=log(10*AllN(id,3:7));
    
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.37 0.47]),
    % matrice corr
    subplot(2,3,1),imagesc(r(id,id)),
    title(sprintf('PCA dim%d',ppc)), xlabel('#neuron'); ylabel('#neuron');
    % PCA vector values
    subplot(2,3,2), plot(L/sum(L),'ko-'), title('vector contribution')
    % plot some values along pca dim 1
    subplot(2,3,3), plot(AllN(id(1:50),3),AllN(id(1:50),4),'.k')
    hold on, plot(AllN(id(end-50:end),3),AllN(id(end-50:end),4),'.r')
    title(sprintf('sample separated on dim%d',ppc));xlabel('FR Wake');ylabel('FR Rem')
    set(gca,'yscale','log');set(gca,'xscale','log')
    
    % log, not normalized values
    subplot(2,3,4),imagesc(log(AllN(id,:))), title('log values')
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName)
    % log, zscored values
    subplot(2,3,5),imagesc(MAT(id,:)), title('zscore values')
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName)
    % mean
    subplot(2,3,6),plot(mean(MAT(id(1:50),:)),'k','Linewidth',2),
    hold on, plot(mean(MAT(id(end-50:end),:)),'r','Linewidth',2),
    title('mean FR'); legend({'50first','50last'})
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName)
    % save figure
    %     if savFig, saveFigure(gcf,['AnalyseNREM_pfcFRpca_dim',num2str(ppc)],FolderToSave);end
    
    % plot stage by stage correlation
    if 0
        figure('Color',[1 1 1],'Unit','normalized','Position',[0.28 0.18 0.3 0.67])
        for i=1:length(NamesEp)
            for j=1:length(NamesEp)
                subplot(length(NamesEp),length(NamesEp),MatXY(j,i,length(NamesEp))), plot(AllN(id(1:50),i),AllN(id(1:50),j),'.k'),
                if i==1 && j==1, title(sprintf('PCA dim%d',ppc));end
                hold on, plot(AllN(id(end-50:end),i),AllN(id(end-50:end),j),'.r')
                set(gca,'xscale','log');set(gca,'Xtick',[]);if j==length(NamesEp), xlabel({NamesEp{i},' FR (logscale)'});end
                set(gca,'yscale','log');set(gca,'Ytick',[]);if i==1, ylabel({NamesEp{j},' FR (logscale)'});end
            end
        end
        save figure
        if savFig, saveFigure(gcf,['AnalyseNREM_pfcFRpca_CORRdim',num2str(ppc)],FolderToSave);end
    end
end
%% Find neurons significant for the PCA
R=PCAvarR;
%R(PCAvarP>0.05)=NaN;

[BE,id]=max(abs(R),[],2);
pc1p=find(id==1 & R(:,1)>0); % neuron dim1: REM neurons
pc1n=find(id==1 & R(:,1)<0); % neuron dim1: 
pc2p=find(id==2 & R(:,2)>0); % neuron dim2: WAKE neurons
pc2n=find(id==2 & R(:,2)<0); % neuron dim2: N2/N3 neurons
pc3p=find(id==3 & R(:,3)>0); % neuron dim3: N1 neurons
pc3n=find(id==3 & R(:,3)<0); % neuron dim3

figure('Color',[1 1 1]), 
subplot(2,3,1),imagesc(PCAvarR([pc1p;pc1n],:)); title('rcoeff, Dim 1');
subplot(2,3,2),imagesc(PCAvarR([pc2p;pc2n],:));title('rcoeff, Dim 2');
subplot(2,3,3),imagesc(PCAvarR([pc3p;pc3n],:));title('rcoeff, Dim 3');

subplot(2,3,4),imagesc(MAT([pc1p;pc1n],:)); title('FR zscore, Dim 1');
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName)
subplot(2,3,5),imagesc(MAT([pc2p;pc2n],:));title('FR zscore, Dim 2');
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName)
subplot(2,3,6),imagesc(MAT([pc3p;pc3n],:));title('FR zscore, Dim 3');
    set(gca,'Xtick',1:length(tempName)), set(gca,'XtickLabel',tempName)

    
NeurTyp={'nRem','nWak','nN23','nN1'};
nRem=pc1p;
nWak=pc2p;
nN23=pc2n;
nN1=pc3p;
%saveFigure(gcf,'AnalyseNREM-FRpcaGroups',FolderToSave);

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<< Look at FR according to pca neuron types <<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.05 0.7 0.9]), numF=gcf;
tempName=NamesEp(3:7);

for Nn=1:length(NeurTyp)
    eval(['idN=',NeurTyp{Nn},';'])
    AA=AllNz(idN,3:7);
    BB=10*AllN(idN,3:7);
    CC=log10(10*AllN(idN,3:7));
   
    subplot(length(NeurTyp),4,length(NeurTyp)*(Nn-1)+1), 
    bar(nanmean(AA)); title(sprintf(['FR zscore ',NeurTyp{Nn},' (n=%d)'],length(idN)))
    hold on,errorbar(nanmean(AA),stdError(AA),'+k'); ylim([-0.2 0.35])
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName)
    
    subplot(length(NeurTyp),4,length(NeurTyp)*(Nn-1)+3),
    boxplot(BB);title(sprintf(['log FR ',NeurTyp{Nn},' (n=%d)'],length(idN)));%ylim([0 20])
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName)
    
    subplot(length(NeurTyp),4,length(NeurTyp)*(Nn-1)+4),
    boxplot(CC);title(sprintf(['log FR ',NeurTyp{Nn},' (n%d)'],length(idN)));ylim([-1.5 2])
    set(gca,'Xtick',1:length(tempName)),set(gca,'XtickLabel',tempName)
    
    % stats
    leg={'Ttest2: '};
    for n=1:length(tempName)
        for n2=n+1:length(tempName)
            [H,p]=ttest2(AA(:,n),AA(:,n2));
            leg=[leg,sprintf([tempName{n},' vs ',tempName{n2},': p=%1.3f, '],p)];
        end
    end
    subplot(length(NeurTyp),4,length(NeurTyp)*(Nn-1)+2), text(-0.1,0.5,leg); axis off
end
%saveFigure(numF.Number,'AnalyseNREM-pfcFRzscorePerGroups',FolderToSave);


%% look at FR over night
% does it decrease globally as shown in the litterature?

figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.06 0.45 0.8]),
for n=1:length(NamesEp)
    clear Mat Matbar
    Mat2=squeeze(AllZT(:,n,:));% whole sleep
    Matbar=[nanmean(Mat2(:,1:4),2),nanmean(Mat2(:,end-3:end),2)];% beg and end of the night
    [Y,X]=hist(log(Matbar(:,2)./Matbar(:,1)),100);
    
    subplot(2,ceil(length(NamesEp)/2),n),plot(X,Y,'.-','Linewidth',2)
    hold on, line([0 0],ylim,'Color',[0.5 0.5 0.5])
    ylabel('log(FR2/FR1)'); title(sprintf([NamesEp{n},': Epoch1 = %dh-%dh, Epoch2 = %dh-%dh'],timeZT(1),timeZT(5),timeZT(end-4),timeZT(end)))
    ylim([0 40]); xlim([-4 4])
    text(0.5,max(ylim)*0.8,'increase of FR')
    text(1,max(ylim)*0.7,sprintf('--> (%d/%d)',sum(Y(X>0)),sum(Y)))
    id=Matbar(find(Matbar(:,2)./Matbar(:,1)>1),1);
    text(0.5,max(ylim)*0.6,sprintf('meanFRi %1.1fHz',mean(id)))
    text(0.5,max(ylim)*0.5,sprintf('medianFRi %1.1fHz',median(id)))
    text(-3.5,max(ylim)*0.8,'decrease of FR')
    text(-3,max(ylim)*0.7,sprintf('(%d/%d) <--',sum(Y(X<0)),sum(Y)))
    id=Matbar(find(Matbar(:,2)./Matbar(:,1)<1),1);
    text(-3.5,max(ylim)*0.6,sprintf('meanFRi %1.1fHz',mean(id)))
    text(-3.5,max(ylim)*0.5,sprintf('medianFRi %1.1fHz',median(id)))
end

if savFig, saveFigure(gcf,'AnalyseNREM-DistribtionFRchangeAllNeurons',FolderToSave);end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<< FR, correlation ZT1, ZT2 <<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% FR across the day, zscore per neuron
SpecialFolder='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/NeuronFiringRate/CorrelationZTaccordingToRatioFR';
Mat=AllZT;
for n1=1:length(NamesEp)
    temp1=nanmean(squeeze(Mat(:,n1,1:4)),2);
    for n2=n1+1:length(NamesEp)
        temp2=nanmean(squeeze(Mat(:,n2,1:4)),2);
        ratio=log10(temp1./temp2);
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.4 0.6]),
        for n=1:length(NamesEp)
            subplot(2,4,n+1), hold on,
            temp=squeeze(Mat(:,n,:));
            ZT1=nanmean(temp(:,1:4),2);
            ZT2=nanmean(temp(:,end-3:end),2); % average on ZT1 and ZT2
            scatter(ZT1,ZT2,20,ratio,'fill'); 
            caxis(nanmean(ratio)+[-2*nanstd(ratio),2*nanstd(ratio)])
            set(gca,'xscale','log');set(gca,'yscale','log')
            line(xlim,xlim,'Color',[0.5 0.5 0.5])
            xlabel(sprintf('FR %1.1f-%1.1fh',timeZT(1),timeZT(4)));
            ylabel(sprintf('FR %1.1f-%1.1fh',timeZT(end-3),timeZT(end)));
            title(NamesEp{n}); xlim([1/1E2 1E2]); ylim([1/1E2 1E2]);
        end
        subplot(2,4,1),scatter(ZT1,ZT2,20,ratio,'fill');
        caxis(nanmean(ratio)+[-2*nanstd(ratio),2*nanstd(ratio)])
        colorbar; title(['Color = log10(FR ',NamesEp{n1},' / FR ',NamesEp{n2},')'])
        if savFig, saveFigure(gcf,['AnalyseNREM-FRchangeZTcorrelation-RatioZT1',NamesEp{n1},'on',NamesEp{n2}],SpecialFolder);end
    end
end
















%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%           OLD FIGURES - MAY NOT WORK !!!
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


%% look at neuron depending on FR increase WAKE->REM
temp=squeeze(AllZT(:,1,:));
[A,id]=sort(AllN(:,strcmp(NamesEp,'REM'))./AllN(:,strcmp(NamesEp,'WAKE')));
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.1 0.45 0.8]),
clear Matbar
for n=1:length(NamesEp)
    temp=squeeze(Mat(:,n,:));
    subplot(3,length(NamesEp),[n,n+length(NamesEp)]), imagesc(temp(id,:)); title(NamesEp{n})
    set(gca,'Xtick',1:2:length(timeZT)-1),set(gca,'XtickLabel',timeZT(1:2:end-1))
    Matbar(1,1:2)=[nanmean(nanmean(temp(id(1:50),1:4),2)),nanmean(nanmean(temp(id(1:50),end-3:end),2))];
    Matbar(2,1:2)=[nanmean(nanmean(temp(id(end-49:end),1:4),2)),nanmean(nanmean(temp(id(end-49:end),end-3:end),2))];
    Matbar(1,3:4)=[nanstd(nanmean(temp(id(1:50),1:4),2)),nanstd(nanmean(temp(id(1:50),end-3:end),2))]./sqrt(length(AllN(:,1)));
    Matbar(2,3:4)=[nanstd(nanmean(temp(id(end-49:end),1:4),2)),nanstd(nanmean(temp(id(end-49:end),end-3:end),2))]./sqrt(length(AllN(:,1)));
    
    subplot(3,length(NamesEp),2*length(NamesEp)+n), bar(Matbar(:,1:2))
    hold on, errorbar([(1:2)-0.15;(1:2)+0.15],Matbar(:,1:2)',Matbar(:,3:4)','+k')
    set(gca,'Xtick',1:2),set(gca,'XtickLabel',{'high','low'})
    xlabel('FRrem/FRwake'); title(NamesEp{n}); ylim([-1 1.5])
end
legend({sprintf('%dh-%dh',timeZT(1),timeZT(5)),sprintf('%dh-%dh',timeZT(end-4),timeZT(end))})
subplot(3,length(NamesEp),length(NamesEp)*[0,1]+1),ylabel('#neuron, ordered by global FRrem/FRwake')
subplot(3,length(NamesEp),length(NamesEp)*[0,1]+3),xlabel('Time of the day (h)');
subplot(3,length(NamesEp),length(NamesEp)*2+1),ylabel('zscore FR'); 

% save figure
if savFig, saveFigure(gcf,'AnalyseNREM-FRacrossNightRatioWakeRem',FolderToSave);end








%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% quantify REMcells and WAKEcells
if 0
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.1 0.28 0.4 0.57])
    subplot(2,6,1),PlotErrorBarN(AllNz,0,0);
    set(gca,'Xtick',1:5), set(gca,'XtickLabel',NamesStages(1:5))
    title(sprintf('All neurons (n=%d)',size(AllNz,1)))
    for i=1:5
        ind=find(AllNz(:,i)>1.2);
        subplot(2,6,1+i),PlotErrorBarN(AllNz(ind,:),0,1);
        set(gca,'Xtick',1:5), set(gca,'XtickLabel',NamesStages(1:5))
        title([NamesStages{i},sprintf('zscore>1 (n=%d)',length(ind))])
    end
    subplot(2,6,7:8),hist(AllNz(:,2)-AllNz(:,1),50);
    title('zscoreREM-WAKE'); line([0 0],ylim,'Color','k')
    subplot(2,6,9:10),hist(AllNz(:,2)-AllNz(:,3),50);
    title('zscoreREM-N1'); line([0 0],ylim,'Color','k')
    subplot(2,6,11:12),hist(AllNz(:,2)-AllNz(:,5),50);
    title('zscoreREM-N3'); line([0 0],ylim,'Color','k')
end
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% PCA on transition
L=size(MiFR,2)-5;

for i=1:length(NamesStages)
    for j=1:length(NamesStages)
        if i~=j
            Mat=[];
            %transition i->j
            disp(['... transitions ',NamesStages{i},'->',NamesStages{j}])
            for man=1:length(Dir.path)
                % for info MiFR(:,1:5)=[orderind(man) i j transition_ij nN(s)]
                numN=unique(MiFR(MiFR(:,1)==man & MiFR(:,2)==i & MiFR(:,3)==j,5));
                if ~isempty(numN)
                    for n=1:length(numN)
                        % average transition of the same neuron
                        ind=find(MiFR(:,1)==man & MiFR(:,2)==i & MiFR(:,3)==j & MiFR(:,5)==numN(n));
                        temp=MiFR(ind,6:end);
                        Mat=[Mat;mean(temp,1)];
                        % display
                        if 0
                            if n==1, figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.3 0.8]);end
                            subplot(ceil(sqrt(length(numN))),ceil(sqrt(length(numN))),n), hold on,
                            plot(-Windo:0.1:Windo,SmoothDec(mean([temp,temp(end)],1),2)','Linewidth',2)
                            title(sprintf('Neuron #%d',n)); line([0 0],[-1 1],'Color','k');
                            line([-1 1]*Windo,[0 0],'Color','r','LineStyle','--'); ylim([-1 1])
                            if n==2, text(0,max(ylim)*1.8,[sprintf(' n = %d transitions ',size(temp,1)),NamesStages{i},'->',NamesStages{j}]);end
                        end
                    end
                end
            end
            if ~isempty(Mat)
                % do PCA on transition i->j
                try
                    [r,p]=corrcoef(Mat');
                    [V,L]=pcacov(r);
                catch
                    Mat(find(std(Mat')'==0),:)=[];
                    [r,p]=corrcoef(Mat');
                    [V,L]=pcacov(r);
                end
                
                if size(V,1)>100
                    figure('Color',[1 1 1],'Unit','normalized','Position',[0.09 0.22 0.3 0.6])
                    % plot PCA results
                    for ppc=1:4
                        [BE,id]=sort(V(:,ppc));
                        % matrice corr
                        subplot(4,5,5*(ppc-1)+1),imagesc(r(id,id)),
                        title(sprintf('PCA dim%d',ppc)), ylabel('#neuron');
                        % PCA vector values
                        subplot(4,5,5*(ppc-1)+2), plot(L/sum(L),'ko-'), title([NamesStages{i},'->',NamesStages{j}])
                        % plot some values along pca dim 1
                        subplot(4,5,5*(ppc-1)+3), plot(Mat(id(1:50),1),Mat(id(1:50),2),'.k')
                        hold on, plot(Mat(id(end-50:end),1),Mat(id(end-50:end),2),'.r')
                        title(sprintf('sample separated on dim%d',ppc));
                        % log, not normalized values
                        subplot(4,5,5*(ppc-1)+4),imagesc(-Windo+0.1:0.1:Windo,1:length(id),Mat(id,:)), title('zscore values')
                        xlabel('Time (s)'); line([0 0],ylim,'Color','k'); caxis([-0.5 0.5]);xlim([-Windo,Windo])
                        % mean
                        subplot(4,5,5*(ppc-1)+5),plot(-Windo+0.1:0.1:Windo,mean(Mat(id(1:50),:)),'k','Linewidth',2),
                        hold on, plot(-Windo+0.1:0.1:Windo,mean(Mat(id(end-50:end),:)),'r','Linewidth',2),
                        title('zscore FR');xlim([-Windo,Windo])
                        xlabel('Time (s)'); ylim([-0.5 0.5]);line([0 0],ylim,'Color','k')
                    end
                end
            end
        end
    end
end






%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% display correlation between substages FR 
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.17 0.025 0.35 0.85])
for i=1:length(NamesStages)
    
    for j=1:length(NamesStages)
        if i~=j
            subplot(length(NamesStages),length(NamesStages),(i-1)*length(NamesStages)+j)
            %x=log10(AllN(:,i));
            %y=log10(AllN(:,j));
            x=AllN(:,i);
            y=AllN(:,j);
            
            plot(x,y,'.k')
            xlabel(NamesStages{i},'Color',colori(i,:))
            ylabel(NamesStages{j},'Color',colori(j,:))
            lim=[min([x',y']),max([x',y'])];
            hold on, line(lim,lim,'Color','k')
            xlim(lim); ylim(lim);
            
            p= polyfit(x,y,1);
            line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color',colori(i,:),'Linewidth',2)
            [r,p]=corrcoef(x,y);
            text(max(xlim)*0.1+min(xlim),max(ylim), sprintf('r=%0.1f, p=%0.3f',r(1,2),p(1,2)),'Color',colori(i,:))            
        end
    end
end
if savFig, saveFigure(gcf,'AnalyseNREM_PFCxFRcorr',FolderToSave);end

%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% display correlation between substages FR, normed by stage
for No=1:length(NamesStages)
    stageNorm=No; % rem
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.17 0.025 0.3 0.7])
    for i=1:length(NamesStages)
        for j=1:length(NamesStages)
            if i>j && i~=stageNorm && j~=stageNorm
                subplot(length(NamesStages),length(NamesStages),(i-1)*length(NamesStages)+j)
                x=log10(AllN(:,i)./AllN(:,stageNorm)); x(x==inf | x==-inf)=NaN;
                y=log10(AllN(:,j)./AllN(:,stageNorm)); y(y==inf | y==-inf)=NaN;
                plot(x,y,'.k')
                xlabel([NamesStages{i},' / ',NamesStages{stageNorm}],'Color',colori(i,:))
                ylabel([NamesStages{j},' / ',NamesStages{stageNorm}],'Color',colori(j,:))
                lim=[-1,1];
                hold on, line(lim,lim,'Color','k')
                xlim(lim); ylim(lim);
                if i==1 & j==2, title(['log10 state / ',NamesStages{stageNorm}]);end
                p= polyfit(x,y,1);
                line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color',colori(i,:),'Linewidth',2)
                [r,p]=corrcoef(x,y);
                text(max(xlim)*0.1+min(xlim),max(ylim), sprintf('r=%0.1f, p=%0.3f',r(1,2),p(1,2)),'Color',colori(i,:))
            end
        end
    end
    if savFig, saveFigure(gcf,['AnalyseNREM_PFCxFRcorr-Normby',NamesStages{stageNorm}],FolderToSave);end
end
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% display correlation between FR at transitions
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.17 0.025 0.35 0.85])
for i=1:length(NamesStages)
    
    for j=1:length(NamesStages)
        if i~=j
            ind=find(ALL(:,2)==i & ALL(:,3)==j);
            %ind=find(ALL(:,1)==man & ALL(:,2)==i & ALL(:,3)==j);
            if ~isempty(ind)
                subplot(length(NamesStages),length(NamesStages),(i-1)*length(NamesStages)+j)
                x=ALL(ind,5);
                y=ALL(ind,6);
                %c=ALL(ind,1);
                %scatter(x,y,c,c)
                plot(x,y,'.k')
                xlabel(NamesStages{i},'Color',colori(i,:))
                ylabel(NamesStages{j},'Color',colori(j,:))
                lim=[min([x',y']),max([x',y'])];
                hold on, line(lim,lim,'Color','k')
                xlim(lim); ylim(lim);
                
                p= polyfit(x,y,1);
                line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color',colori(i,:),'Linewidth',2)
                [r,p]=corrcoef(x,y);
                text(max(xlim)*0.1+min(xlim),max(ylim), sprintf('r=%0.1f, p=%0.3f',r(1,2),p(1,2)),'Color',colori(i,:))
            end
            if i==1 || i==j+1,title([NamesStages{i},'->',NamesStages{j}]);end
            
        end
    end
end
if savFig, saveFigure(gcf,['AnalyseNREM_PFCxFRcorrAtTransition_',titw],FolderToSave);end


%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% display %of increase
Y=log10(ALL(:,6)./ALL(:,5));
%Y=100*(ALL(:,6)-ALL(:,5))./ALL(:,5);
m=max(ALL(:,4));
N=m*ALL(:,1)+ALL(:,4);
L=length(NamesStages);
figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.2 0.4 0.4]);numF=gcf;
for i=1:L
    figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.2 0.3 0.7]);
    MATY=nan(length(N),L);
    for j=1:L
        ind=find(ALL(:,2)==i & ALL(:,3)==j);
        %ind=find(ALL(:,1)==man & ALL(:,2)==i & ALL(:,3)==j);
        MATY(N(ind),j)=Y(ind);
    end
    MATY(MATY==inf)=NaN;
    MATY(MATY==-inf)=NaN;
    
    for j=1:L
        for ji=1:L
            if j~=ji && i~=j && i~=ji
                subplot(L,L,(j-1)*L+ji)
                x=MATY(~isnan(MATY(:,j))& ~isnan(MATY(:,ji)),j);
                y=MATY(~isnan(MATY(:,j))& ~isnan(MATY(:,ji)),ji);
                plot(x,y,'.k')
                xlabel([NamesStages{i},'->',NamesStages{j}],'Color',colori(j,:))
                ylabel([NamesStages{i},'->',NamesStages{ji}],'Color',colori(ji,:))
                xlim([-1 1]);ylim([-1 1]);
                line([0 0],ylim,'Color','k')
                line(xlim,[0 0],'Color','k')
                p= polyfit(x,y,1);
                line([min(x),max(x)],p(2)+[min(x),max(x)]*p(1),'Color',colori(i,:),'Linewidth',2)
                [r,p]=corrcoef(x,y);
                text(max(xlim)*0.1+min(xlim),max(ylim), sprintf('r=%0.1f, p=%0.3f',r(1,2),p(1,2)),'Color',colori(i,:))
                
            end
        end
    end
    if savFig, saveFigure(gcf,['AnalyseNREM_corrPFCxFRIncreaseAtTransitFrom',NamesStages{i},'_',titw],FolderToSave);end
    
    figure(numF),subplot(1,length(NamesStages),i)
    PlotErrorBarN(MATY,0,0);
    title(['From ',NamesStages{i},' to...'])
    set(gca,'Xtick',1:length(NamesStages)); set(gca,'XtickLabel',NamesStages)
    if i==1, ylabel(['% increase between ',num2str(Windo),'s before and after transition']);end
    ylim([-1 1])
end
if savFig, saveFigure(gcf,['AnalyseNREM_PFCxFRIncreaseAtTransition_',titw],FolderToSave);end

%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% display pooled data
figure('Color',[1 1 1],'Unit','normalized','Position',[0.2 0.2 0.55 0.45]);
subplot(1,L+1,1), PlotErrorBarN(FR,0,1); title('median FR (n=13,N=4)')
set(gca,'Xtick',1:5); set(gca,'XtickLabel',NamesStages)
ylabel('Firing rates (spk/s)');
for i=1:L
    tempNorm=squeeze(FRnorm(:,:,i));
    subplot(1,L+1,i+1), PlotErrorBarN(tempNorm,0,1);title(['median(log10(.../',NamesStages{i},'))'])
    set(gca,'Xtick',1:5); set(gca,'XtickLabel',NamesStages)
end
if savFig, saveFigure(gcf,'AnalyseNREM_PFCxFR',FolderToSave);end


%%

na=zeros(5,1);
    for a=1:5, na(a,1)=100*length(find(ida==a))/length(v);end
    na(find(na==0))=0.001;
    pie(na'); 
         
                        
                        
                        