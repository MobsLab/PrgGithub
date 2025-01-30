%AnalyseNREMsubstages_SpikesTrioEvol
%
% list of related scripts in NREMstages_scripts.m 

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
colori=[0 1 0;0.5 0.5 0.5;0 0 0 ;0.5 0.2 0.1;0.1 0.7 0 ;0.7 0.2 0.8 ; 1 0.5 0.8 ;1 0 1  ];
NamesEp={'SLEEP','NREM','WAKE','REM','N1','N2','N3','Total','N1wd','N2wd','N3wd'}; 
savFig=1;
Windo=0;% in sec remove moment of transition
if floor(Windo)==Windo, titw=sprintf('%ds',Windo); else, titw=sprintf('%dms',floor(Windo*1E3));end 
%tps=0:0.05:1; % sample on rescales periods
tps=0:0.01:1;
smo=''; if size(tps,2)==101,smo='smo';end
    
nameAnaly=['Analyse_SpikesTrioEvolNew_',titw,smo,'.mat'];
res1='/media/DataMOBsRAID/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_Spikes';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% <<<<<<<<<<<<<<<<<<<<< DIRECTORIES OF EXPE <<<<<<<<<<<<<<<<<<<<<<<<<<<

try load([res,'/Analyse_SpikesNREMStagesNew_3s.mat'],'Dir'); catch, load([res1,'/Analyse_SpikesNREMStagesNew_3s.mat'],'Dir'); end
[mice,a,b]=unique(Dir.name);
orderind=sortrows([1:length(Dir.path);b']',2);
orderind=orderind(:,1)';

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


try
    load([res,'/',nameAnaly]);
    disp([nameAnaly,' has been loaded.'])
catch
    %%%%%%%%%%%%%%%%%%%%%%%%%% INITIATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tit{1}='Wake-NREM-Wake';
    tit{2}='NREM-REM-NREM';
    tit{3}='N2-N3-N2';
    tit{4}='N3-N2-N3';
    tit{5}='N2-N1-N2';
    tit{6}='Wake-N1-N2';
    tit{7}='N2wd-N3wd-N2wd';
    tit{8}='N3wd-N2wd-N3wd';
    tit{9}='NREM-REMshort-NREM';
    tit{10}='NREM-REMmed-NREM';
    tit{11}='NREM-REMlong-NREM';
    titVar={'eWNW','eNRN','e232','e323','e212','eW12','e232wd','e323wd','eNRN1','eNRN2','eNRN3'};
    
    for ep=1:length(tit)*3, for p=1:4, TrioN{ep,p}=nan(100,3*length(tps),800);end;end
    for ep=1:length(tit)*3, TrioDelt{ep}=nan(100,3*length(tps),length(Dir.path));end
    for ep=1:length(NamesEp), StageEv{ep}=nan(1000,length(tps),800);end
    Spoi={};EpochsTrio={}; MouseMan=nan(1000,1);
    NeurTyp=nan(800,1);
    LNZT=0; AllN=[];
    for p=1:4, PAllN{p}=[]; end
    
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{orderind(man)})
        cd(Dir.path{orderind(man)})
        
        
        % %%%%%%%%%%%%%%%%%% GET SUBSTAGES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        clear WAKE SLEEP REM N1 N2 N3 NamesStages SleepStages
        try
            % Substages
            disp('- RunSubstages.m')
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages;close;
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
            clear S nN
            % Get PFCx Spikes
            load('SpikeData.mat','S');
            [S,nN,numtt,TT]=GetSpikesFromStructure('PFCx',S,pwd,1);
            % remove MUA from the analysis
            
            % %%%%%%%%%%%%%%%%%%%%%% GET Inter/Pyr %%%%%%%%%%%%%%%%%%%%%%%%
            if ~exist('MeanWaveform.mat','file')
                [FilenameXml,PathName]=uigetfile('*.xml','Select FilenameXml');
                GetWFInfo(pwd,[PathName,FilenameXml])
            end
            DropBoxLocation=which('AnalyseNREMsubstages_SpikesTrioEvol.m');
            DropBoxLocation=DropBoxLocation(1:strfind(DropBoxLocation,'Kteam')+5);
            %WfId=IdentifyWaveforms(pwd,FilenamDropBox(1:strfind(FilenamDropBox,'Dropbox')-1),1,1:length(numNeurons));
            clear W BestElec WFMat
            load('MeanWaveform.mat','W','BestElec');
            for s=1:length(nN)
                WFMat(1:32,s)=W{nN(s)}(BestElec{nN(s)},:);
            end
            WfId=SortMyWaveforms(WFMat,DropBoxLocation,0);
            WfId(abs(WfId)==0.5)=NaN;
        
            NeurTyp(LNZT+[1:length(nN)])=WfId;
         
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
                 
            % %%%%%%%%%%%%%%%%%%%%%%%% get delta %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [tDelta,DeltaEpoch]=GetDeltaML;
            Dpfc=ts(tDelta);
            
            % %%%%%%%%%%%%%%%%%%% POISSON CHECK %%%%%%%%%%%%%%%%%%%%%%%%%%%
            clear Spoi
            disp('Calculating Poisson spikes...')
            for s=1:length(nN)
                tsN=S{nN(s)};
                Tm=[min(Range(tsN,'s')),max(Range(tsN,'s'))];
                lambda= length(Range(tsN))/diff(Tm);
                T=poissonKB(lambda, diff(Tm));
                tsP=ts((Tm(1)+T)*1E4);
                % increasing poisson
                tinc=Range(tsP).*[1:0.2/(length(Range(tsP))-1):1.2]';% 20%increase
                tsPinc=ts(tinc*Tm(2)*1E4/max(tinc));
                % decreasing poisson
                tdec=Range(tsP).*[1.2:-0.2/(length(Range(tsP))-1):1]';% 20%decrease
                tsPdec=ts(sort(tdec)*Tm(2)*1E4/max(tdec));
                
                Spoi{s,1}=tsN;
                Spoi{s,2}=tsP;
                Spoi{s,3}=tsPinc;
                Spoi{s,4}=tsPdec;
            end
            
            % %%%%%%%%%%%%%%%%%%%%%% GET ZT %%%%%%%%%%%%%%%%%%%%%%%%%%%
            disp('... loading rec time with GetZT_ML.m')
            NewtsdZT=GetZT_ML(pwd);
            manDate=str2num(Dir.path{man}(strfind(Dir.path{man},'/201')+[1:8]));
            if manDate>20160701, hlightON(man)=9; else, hlightON(man)=8;end
            
            h_start=mod(min(Data(NewtsdZT))/3600/1E4,24)-hlightON(man);
            delays=([1 3.5 8 10.5]-h_start)*3600*1E4;
            Epoch1=intervalSet(max(delays(1),0),max(delays(2),0)); % 9h-11h30 (hlightON=8h)
            Epoch2=intervalSet(max(delays(3),0),max(delays(4),0)); % 16h-18h30
            
            
            % %%%%%%%%%%%%%%%%%%%%%% triolet %%%%%%%%%%%%%%%%%%%%%%%%%%%
            %titVar={'eWNW','eNRN','e232','e323','e212','eW12','e232wd','e323wd','eNRN1','eNRN2','eNRN3'};
            
            % WAKE - NREM -WAKE
            tmerge=5;%
            tREM=mergeCloseIntervals(REM,tmerge*1E4);
            tNREM=mergeCloseIntervals(NREM,tmerge*1E4)-tREM;
            tWAKE=mergeCloseIntervals(WAKEnoise,tmerge*1E4)-tNREM-tREM;
            tSw=[Start(tREM),Stop(tREM),Stop(tREM,'s')-Start(tREM,'s'),ones(length(Start(tREM)),1)];%1 REM
            tSw=[tSw; [Start(tNREM),Stop(tNREM),Stop(tNREM,'s')-Start(tNREM,'s'),2*ones(length(Start(tNREM)),1)]]; %2 NREM
            tSw=[tSw; [Start(tWAKE),Stop(tWAKE),Stop(tWAKE,'s')-Start(tWAKE,'s'),3*ones(length(Start(tWAKE)),1)]];% 3 WAKE
            [B,id]=sort(tSw(:,1));
            tSw=tSw(id,:);
            tSw(1:end-1,5:6)=tSw(2:end,3:4);
            tSw(1:end-2,7:8)=tSw(3:end,3:4);
            
            id=find(tSw(:,4)==3 & tSw(:,6)==2 & tSw(:,8)==3 & tSw(:,3)>8 & tSw(:,5)>15 & tSw(:,7)>8);% 8s WAKE, 15s NREM
            eWNW=nan(length(id),4);
            for i=1:length(id);
                eWNW(i,1:4)=[tSw(id(i)+[0:2],1)',tSw(id(i)+2,2)];
            end
            
            % -------------------------------------------------------------
            % NREM -REM -NREM
            REMdurs=[9 19 20 30 31 ];
            id=find(tSw(:,4)==2 & tSw(:,6)==1 & tSw(:,8)==2 & tSw(:,3)>15 & tSw(:,5)>15 & tSw(:,7)>15);% 15s NREM, 15s REM
            id1=find(tSw(:,4)==2 & tSw(:,6)==1 & tSw(:,8)==2 & tSw(:,3)>12 & tSw(:,5)>9 & tSw(:,5)<19 & tSw(:,7)>12);% 12s NREM, 10-15s REM
            id2=find(tSw(:,4)==2 & tSw(:,6)==1 & tSw(:,8)==2 & tSw(:,3)>12 & tSw(:,5)>20 & tSw(:,5)<30 & tSw(:,7)>12);% 12s NREM, 17-22s REM
            id3=find(tSw(:,4)==2 & tSw(:,6)==1 & tSw(:,8)==2 & tSw(:,3)>12 & tSw(:,5)>31 & tSw(:,7)>12);% 12s NREM, >24s REM
            eNRN=nan(length(id),4); for i=1:length(id); eNRN(i,1:4)=[tSw(id(i)+[0:2],1)',tSw(id(i)+2,2)]; end
            eNRN1=nan(length(id1),4); for i=1:length(id1); eNRN1(i,1:4)=[tSw(id1(i)+[0:2],1)',tSw(id1(i)+2,2)]; end
            eNRN2=nan(length(id2),4); for i=1:length(id2); eNRN2(i,1:4)=[tSw(id2(i)+[0:2],1)',tSw(id2(i)+2,2)]; end
            eNRN3=nan(length(id3),4); for i=1:length(id3); eNRN3(i,1:4)=[tSw(id3(i)+[0:2],1)',tSw(id3(i)+2,2)]; end
            % -------------------------------------------------------------
            % N2 - N3- N2
            %NamesEp={'SLEEP','NREM','WAKE','REM','N1','N2','N3','Total','N1wd','N2wd','N3wd'}; 
            Sw=[];
            for n=3:7 % WAKE REM N1 N2 N3
                eval(['epoch=',NamesEp{n},';'])
                Sw=[Sw; [Start(epoch),Stop(epoch),Stop(epoch,'s')-Start(epoch,'s'),n*ones(length(Start(epoch)),1)] ];
            end
            [B,id]=sort(Sw(:,1));
            Sw=Sw(id,:);
            Sw(1:end-1,5:6)=Sw(2:end,3:4);
            Sw(1:end-2,7:8)=Sw(3:end,3:4);
            
            id=find(Sw(:,4)==6 & Sw(:,6)==7 & Sw(:,8)==6 & Sw(:,3)>5 & Sw(:,5)>5 & Sw(:,7)>5);% 5s N2, 5s N3
            e232=nan(length(id),4);
            for i=1:length(id);
                e232(i,1:4)=[Sw(id(i)+[0:2],1)',Sw(id(i)+2,2)];
            end
            
            % -------------------------------------------------------------
            % N3 - N2- N3
            id=find(Sw(:,4)==7 & Sw(:,6)==6 & Sw(:,8)==7 & Sw(:,3)>5 & Sw(:,5)>5 & Sw(:,7)>5);% 5s N2, 5s N3
            e323=nan(length(id),4);
            for i=1:length(id);
                e323(i,1:4)=[Sw(id(i)+[0:2],1)',Sw(id(i)+2,2)];
            end
            
            % -------------------------------------------------------------
            % N2 - N1- N2
            id=find(Sw(:,4)==6 & Sw(:,6)==5 & Sw(:,8)==6 & Sw(:,3)>5 & Sw(:,5)>5 & Sw(:,7)>5);% 5s N2, 5s N3
            e212=nan(length(id),4);
            for i=1:length(id);
                e212(i,1:4)=[Sw(id(i)+[0:2],1)',Sw(id(i)+2,2)];
            end
            
            % -------------------------------------------------------------
            % WAKE - N1- N2
            id=find(Sw(:,4)==3 & Sw(:,6)==5 & Sw(:,8)==6 & Sw(:,3)>5 & Sw(:,5)>5 & Sw(:,7)>5);% 5s N2, 5s N3
            eW12=nan(length(id),4);
            for i=1:length(id);
                eW12(i,1:4)=[Sw(id(i)+[0:2],1)',Sw(id(i)+2,2)];
            end
            
            % -------------------------------------------------------------
            % N2 - N3- N2
            %NamesEp={'SLEEP','NREM','WAKE','REM','N1','N2','N3','Total','N1wd','N2wd','N3wd'}; 
            Sw=[];
            for n=[3:4,9:11] % WAKE REM N1 N2 N3
                eval(['epoch=',NamesEp{n},';'])
                Sw=[Sw; [Start(epoch),Stop(epoch),Stop(epoch,'s')-Start(epoch,'s'),n*ones(length(Start(epoch)),1)] ];
            end
            [B,id]=sort(Sw(:,1));
            Sw=Sw(id,:);
            Sw(1:end-1,5:6)=Sw(2:end,3:4);
            Sw(1:end-2,7:8)=Sw(3:end,3:4);
            
            id=find(Sw(:,4)==10 & Sw(:,6)==11 & Sw(:,8)==10 & Sw(:,3)>5 & Sw(:,5)>5 & Sw(:,7)>5);% 5s N2, 5s N3
            e232wd=nan(length(id),4);
            for i=1:length(id);
                e232wd(i,1:4)=[Sw(id(i)+[0:2],1)',Sw(id(i)+2,2)];
            end
            
            % -------------------------------------------------------------
            % N3 - N2- N3
            id=find(Sw(:,4)==11 & Sw(:,6)==10 & Sw(:,8)==11 & Sw(:,3)>5 & Sw(:,5)>5 & Sw(:,7)>5);% 5s N2, 5s N3
            e323wd=nan(length(id),4);
            for i=1:length(id);
                e323wd(i,1:4)=[Sw(id(i)+[0:2],1)',Sw(id(i)+2,2)];
            end
            
            
            % -------------------------------------------------------------
            % -------------------------------------------------------------
            %titVar={'eWNW','eNRN','e232','e323','e212','eW12','e232wd','e323wd'};
            for ti=1:length(tit)
                eval(['epo=',titVar{ti},';'])
                EpochsTrio{man,ti}=epo;
                EpochsTrio{man,length(tit)+ti}=epo(epo(:,1)>=Start(Epoch1) & epo(:,4)<Stop(Epoch1),:);
                EpochsTrio{man,2*length(tit)+ti}=epo(epo(:,1)>=Start(Epoch2) & epo(:,4)<Stop(Epoch2),:);
            end

            
            if ~isempty(nN)
                % %%%%%%%%%%%%%%%%%%%%%%% GET FR %%%%%%%%%%%%%%%%%%%%%%%%%%
                % calculate instataneous firing rate
                t_step=0:0.05:max(Range(SleepStages,'s'));
                iFR=nan(length(nN),length(t_step)); 
                for p=1:4, PiFRz{p}=iFR; end
                for s=1:length(nN)
                    iFR(s,:)=hist(Range(S{nN(s)},'s'),t_step);
                    for p=1:4, PiFRz{p}(s,:)=zscore(hist(Range(Spoi{s,p},'s'),t_step)); end
                end
                iFR=tsd(t_step*1E4,iFR');
                for p=1:4, PiFRz{p}=tsd(t_step*1E4,PiFRz{p}'); end
                
                %delta
                t_stepD=0:2:max(Range(SleepStages,'s'));
                iDelt=tsd(t_stepD*1E4,hist(Range(Dpfc,'s'),t_stepD)');
                
                for ep=1:size(EpochsTrio,2)
                    Epo=EpochsTrio{man,ep};
                    tempD=TrioDelt{ep};
                    for p=1:4
                        tempz=TrioN{ep,p};
                        
                        for n=1:size(Epo,1)
                            for i=1:3
                                Ii=intervalSet(Epo(n,i)+Windo*1E4,Epo(n,i+1)-Windo*1E4);
                                % FR
                                rg=Range(Restrict(PiFRz{p},Ii));
                                FRzTran=tsd(0:1/(length(rg)-1):1,Data(Restrict(PiFRz{p},Ii)));
                                try tempz(n,(i-1)*length(tps)+1:i*length(tps),LNZT+(1:length(nN)))=Data(Restrict(FRzTran,tps));end
                                
                                if p==1% delta
                                    rg=Range(Restrict(iDelt,Ii));
                                    DzTran=tsd(0:1/(length(rg)-1):1,Data(Restrict(iDelt,Ii)));
                                    if Stop(Ii)-Start(Ii)>2*1E4, tempD(n,(i-1)*length(tps)+1:i*length(tps),man)=Data(Restrict(DzTran,tps));end
                                end
                            end
                        end
                        TrioN{ep,p}=tempz;
                    end
                    TrioDelt{ep}=tempD;
                end
               
                % firing indiv neuron to know neuron type
                tempFR=nan(length(nN),length(NamesEp));
                for p=1:4, PtempFRz{p}=tempFR;end
                
                for n=1:length(NamesEp)
                    clear epoch
                    eval(['epoch=',NamesEp{n},';']); disp(NamesEp{n})
                    for p=1:4, PtempFRz{p}(:,n)=mean(Data(Restrict(PiFRz{p},epoch))); end
                    tempFR(:,n)=mean(Data(Restrict(iFR,epoch)));
                    
                    % evol single epochs
                    tempEv=StageEv{n};
                    for ep=1:min(1000,length(Start(epoch)))
                        Ii=subset(epoch,ep);
                        Ii=intervalSet(Start(Ii)+Windo*1E4,Stop(Ii)-Windo*1E4);
                        rg=Range(Restrict(PiFRz{1},Ii));
                        FRzEv=tsd(0:1/(length(rg)-1):1,Data(Restrict(PiFRz{1},Ii)));
                        try tempEv(ep,:,LNZT+(1:length(nN)))=Data(Restrict(FRzEv,tps));end
                    end
                    StageEv{n}=tempEv;
                    
                end
                for p=1:4, PAllN{p}=[PAllN{p};PtempFRz{p}]; end
                AllN=[AllN;tempFR];
                MouseMan(LNZT+(1:length(nN)))=orderind(man);
                
                LNZT=LNZT+length(nN);
            end
        end
    end
    
    %saving
    save([res,'/',nameAnaly],'-v7.3','Dir','Windo','NamesEp','tps','TrioN','TrioDelt','EpochsTrio','LNZT',...
        'PAllN','Windo','NeurTyp','AllN','StageEv','MouseMan','tit','hlightON','REMdurs');
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% tit{1}='Wake-NREM-Wake';
% tit{2}='NREM-REM-NREM';
% tit{3}='N2-N3-N2';
% tit{4}='N3-N2-N3';
% tit{5}='N2-N1-N2';
% tit{6}='Wake-N1-N2';
% tit{7}='N2wd-N3wd-N2wd';
% tit{8}='N3wd-N2wd-N3wd';
% tit{9}='NREM-REMshort-NREM';
% tit{10}='NREM-REMmed-NREM';
% tit{11}='NREM-REMlong-NREM';
            
p=1;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.7 0.6]), numF=gcf;
for ep=1:6
    tempz=TrioN{3*(ep-1)+1,p};
    Mat=nan(LNZT,3*length(tps));
    for nN=1:LNZT
        A=squeeze(tempz(:,:,nN));
        Mat(nN,:)=nanmean(A,1);
    end
    subplot(2,3,ep), hold on
    errorbar([tps-1,tps,tps+1],nanmean(Mat,1),stdError(Mat),'Linewidth',2)
    xlim([-1 2]); title(tit{ep})
    line([0 0],ylim,'Color',[0.5 0.5 0.5])
    line([1 1],ylim,'Color',[0.5 0.5 0.5])
    xlabel('Normalized period'); ylabel('FR zscore')
end

%saveFigure(numF.Number,'FRzscoreTrio',FolderToSave);

%% 
% ----------------------- inputs --------------------------------
smo=3;
indEp=1:7;
pp=1; %% pp=1 normal, 2 poisson, 3 decreasing poisson, 4 increasing poisson
ppAllN=PAllN{pp};

NameEpI='All'; iI=[4,3,2];% 1:8
%NameEpI='All'; iI=[2,9:11]; 
%NameEpI='Deb';iI=9:16;
%NameEpI='Fin';iI=17:24;

do=1; %neuron type
%do=2; %neuron type only for pyramidal
%do=3; %increasing or decreasing neurons
%do=4; %delta waves
clear lis ValSav
% ---------------------------------------------------------------
tempName=NamesEp(indEp);
for i=1:length(tit), id=strfind(tit{i},'-'); id=[0,id,length(tit{i})+1]; for j=1:length(id)-1, tit2{i,j}=tit{i}(id(j)+1:id(j+1)-1);end;end

if do==1 % neuron type
    [BE,idx]=max(ppAllN(:,3:7)');
    nEp=[];for i=3:7, nEp=[nEp,{['neuron ',NamesEp{i}]}];end; nEp=[nEp,'All neuron']; 
    for n=1:5
        lis{n}=find(idx==n);
    end
    lis{n+1}=1:size(ppAllN,1);
    
elseif do==2 % neuron type for pyramidal
    [BE,idx]=max(ppAllN(:,3:7)');
    nEp=[];for i=3:7, nEp=[nEp,{['PYR ',NamesEp{i}]}];end; nEp=[nEp,'All PYR'];
    for n=1:5
        lis{n}=find(idx==n & NeurTyp(1:length(idx))'==1);
    end
    lis{n+1}=1:size(ppAllN,1);
    
elseif do==3 % increasing or decreasing neurons
    try load([res,'/Analyse_SpikesNREMStagesNew_3s.mat'],'PAllZT','timeZT'); catch, load([res1,'/Analyse_SpikesNREMStagesNew_3s.mat'],'PAllZT','timeZT'); end
    ppZTz=PAllZT{1,2};
    %temp=squeeze(ppZTz(:,strcmp(NamesEp,'WAKE'),:));
    temp=squeeze(ppZTz(:,strcmp(NamesEp,'Total'),:));
    %temp=squeeze(ppZTz(:,strcmp(NamesEp,'SLEEP'),:));
    Early=nanmean(temp(:,find(timeZT(1:end-1)<3)),2);
    Late=nanmean(temp(:,find(timeZT(1:end-1)>7)),2);
    Change=Early-Late;clear lis
    lis{1}=find(Change<0.05 & Change>-0.05); %unchanged
    lis{2}=find(Change<-0.1); % increase
    lis{3}=find(Change>0.1); % decrease
    nEp={'unchanged','increasing','decreasing'};
    
else %delta
    lis{1}=1:length(Dir.path);
    nEp={'delta'};
end

%
for ep=1:length(iI)
    for li=1:length(lis); leg{li}=[];end
    if do==4
        L=length(iI);
        if ep==1;figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.85 0.6]), numF(ep)=gcf; end
        tempD=TrioDelt{iI(ep)};
        clear Nevt; for man=1:length(Dir.path), Nevt(man)=size(EpochsTrio{man,iI(ep)},1);end
        if size(tempD,1)==length(Dir.path)
            tempz=nan(size(tempD,2),size(tempD,3),length(Dir.path));
            for man=1:length(Dir.path)
                Mat=squeeze(tempD(man,:,:));
                tempz(:,:,man)=Mat;
            end
        else
            tempz=tempD;
        end
    else
        L=length(lis);
        figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 length(lis)*0.15 0.6]), numF(ep)=gcf;
        tempz=TrioN{iI(ep),pp};
    end
    
    yl=[];yl2=[];legStat={};
    for li=1:length(lis)
        if do==4, l=ep; else, l=li;end
        idN=lis{li};
        Mat=nan(length(idN),3*length(tps));
        
        for nN=1:length(idN)
            A=squeeze(tempz(:,:,idN(nN)));
            A(isnan(nanmean(A,2)),:)=[];
            if strcmp(NameEpI,'Deb')
                A=A(1:floor(size(A,1)/4),:);
            elseif strcmp(NameEpI,'Fin')
                A=A(3*floor(size(A,1)/4):end,:);
            end
            Mat(nN,:)=nanmean(A,1);
        end
        subplot(2,L,l), hold on
        %errorbar([tps-1,tps,tps+1],nanmean(Mat,1),stdError(Mat),'Linewidth',2)
        plot([tps-1,tps,tps+1],smooth(nanmean(Mat,1),smo),'k','Linewidth',2)
        plot([tps-1,tps,tps+1],smooth(nanmean(Mat,1)+stdError(Mat),smo),'k')
        plot([tps-1,tps,tps+1],smooth(nanmean(Mat,1)-stdError(Mat),smo),'k')
        xlim([-1 2]); %ylim([-1 1.5]); 
        ylabel('FR zscore'); xlabel(tit{iI(ep)})
        try xlabel({tit{iI(ep)},sprintf('evt = %1.0f +/-%1.0f',mean(Nevt),std(Nevt))}); end
        if do==4, ylabel('occurrence (Hz)'); ylim([-0.1 2]);end; 
        yl=[yl,ylim];
        %leg{li}=[leg{li},sprintf(' (n=%d)',length(idN))];
        title(sprintf([nEp{li},' (n=%d)'],length(idN)))
        
        % stats
        A=Mat(:,4:length(tps)-3); %before
        B=Mat(:,length(tps)+[4:length(tps)-3]); %middle
        B1=Mat(:,length(tps)+[4:floor(length(tps)/4)]);% first quarter
        B2=Mat(:,2*length(tps)+[-floor(length(tps)/4):-3]);% last quarter
        C=Mat(:,2*length(tps)+[4:length(tps)-3]);%before
        M=[nanmean(A,2),nanmean(B1,2),nanmean(B2,2),nanmean(C,2)];
        if do==1 && li==6, ValSav{ep}=M;end
            
        % correlation slope
        A(isnan(mean(A,2)),:)=[];B(isnan(mean(B,2)),:)=[];C(isnan(mean(C,2)),:)=[];
        pA= polyfit(ones(size(A,1),1)*tps(4:end-3),A,1);
        pB= polyfit(ones(size(B,1),1)*tps(4:end-3),B,1);
        pC= polyfit(ones(size(C,1),1)*tps(4:end-3),C,1);
        
        line([tps(4),tps(end-3)]-1,pA(2)+[tps(4),tps(end-3)]*pA(1),'Color','b','Linewidth',2)
        [r,p]=corrcoef(ones(size(A,1),1)*tps(4:end-3),A);if p(1,2)<0.05, ad='*';else, ad='';end
        legStat{li,1}=sprintf([ad,'r=%0.2f, p=%0.3f'],r(1,2),p(1,2));
        
        line([tps(4),tps(end-3)],pB(2)+[tps(4),tps(end-3)]*pB(1),'Color','b','Linewidth',2)
        [r,p]=corrcoef(ones(size(B,1),1)*tps(4:end-3),B); if p(1,2)<0.05, ad='*';else, ad='';end
        legStat{li,2}=sprintf(['  ',ad,'r=%0.2f, p=%0.3f'],r(1,2),p(1,2));
        
        line(1+[tps(4),tps(end-3)],pC(2)+[tps(4),tps(end-3)]*pC(1),'Color','b','Linewidth',2)
        [r,p]=corrcoef(ones(size(C,1),1)*tps(4:end-3),C);if p(1,2)<0.05, ad='*';else, ad='';end
        legStat{li,3}=sprintf(['    ',ad,'r=%0.2f, p=%0.3f'],r(1,2),p(1,2));
        
        % delay
        MatP=nan(4,length(tps)-6);
        for tp=1:length(tps)-6
            [~,p]=ttest(nanmean(A,2),B(:,tp));
            if p<0.05, MatP(1,tp)=1;end
            [~,p]=ttest(nanmean(A,2),C(:,tp));
            if p<0.05, MatP(2,tp)=1;end
            [~,p]=ttest(nanmean(B(:,1:3),2),B(:,tp));
            if p<0.05, MatP(3,tp)=1;end
            [~,p]=ttest(nanmean(B(:,1:3),2),C(:,tp));
            if p<0.05, MatP(4,tp)=1;end
        end
        plot([tps(4:end-3),tps(4:end-3)+1],[MatP(1,:),MatP(2,:)]*1.1*min(nanmean(Mat,1)),'.g')
        plot([tps(4:end-3),tps(4:end-3)+1],[MatP(3,:),MatP(4,:)]*1.2*min(nanmean(Mat,1)),'.r')
        line([-1 2],nanmean(nanmean(A,2))*[1 1],'Color',[0.5 0.5 0.5])
        
        % bar plots
        subplot(2,L,L+l), hold on,
        %PlotErrorBarN_KJ(M,'showPoints',0,'newfig',0);
        errorbar(1:4,nanmean(M,1),stdError(M),'ok','Linewidth',2)
        line(2:3, nanmean(M(:,2:3),1),'Color','k')
        set(gca,'Xtick',1:4); set(gca,'XtickLabel',{tit2{iI(ep),1},[tit2{iI(ep),2},'-deb'],[tit2{iI(ep),2},'-fin'],tit2{iI(ep),3}});
        set(gca,'XtickLabelRotation',45); xlim([0 5]); %ylim([-1 1.5]); yl2=[yl2,ylim]; 
        title(sprintf([nEp{li},' (n=%d)'],length(idN)))
        pval=addSigStarML(M);%PlotErrorBarN_KJ
    end
    
    for li=1:length(lis), subplot(2,L,li),
        ylim([-0.04 0.02]); %ylim([min(yl) max(yl)]);
        text(-0.8,max(yl)*0.8,legStat(li,:),'Color','b')
        line([0 0],ylim,'Color',[0.5 0.5 0.5])
        line([1 1],ylim,'Color',[0.5 0.5 0.5])
    end
    %saveFigure(numF(ep).Number,sprintf(['FRzscoreTrio',NameEpI,'-NeuronType%d_',tit2{ep,1},tit2{ep,2},tit2{ep,3}],do),FolderToSave)
end

%% imagesc KB
figure('Color',[1 1 1]); numF=gcf;
for ep=1:2;
    tempz=TrioN{iI(ep),pp};
    l=length(lis);
    idN=lis{length(lis)};
    Mat=nan(length(idN),3*length(tps));
    
    for nN=1:length(idN)
        A=squeeze(tempz(:,:,idN(nN)));
        A(isnan(nanmean(A,2)),:)=[];
        if strcmp(NameEpI,'Deb')
            A=A(1:floor(size(A,1)/4),:);
        elseif strcmp(NameEpI,'Fin')
            A=A(3*floor(size(A,1)/4):end,:);
        end
        Mat(nN,:)=nanmean(A,1);
    end
    xp=[tps-1,tps,tps+1];
    [BE,id]=sort(nanmean(Mat(:,10:20)')-nanmean(Mat(:,25:40)'));
    subplot(1,2,ep), imagesc(xp,1:length(idN),Mat(id,:)), axis xy
    hold on
    plot(xp,150+smooth(2000*nanmean(Mat(id(1:100),:)),3),'k','linewidth',2)
    plot(xp,300+smooth(2000*nanmean(Mat(id(200:300),:)),3),'k','linewidth',2)
    plot(xp,400+smooth(2000*nanmean(Mat(id(350:450),:)),3),'k','linewidth',2)
    plot(xp,500+smooth(2000*nanmean(Mat(id(520:555),:)),3),'k','linewidth',2)
    caxis([-0.35 0.65]); xlim([-1 2])
    line([0 0],ylim,'color','k')
    line([1 1],ylim,'color','k')
    xlabel(tit{iI(ep)})
end
%saveFigure(numF.Number,'FRzscoreTrio_AllNeur_imagesc',FolderToSave)


%%
if exist('ValSav','var')
    figure('Color',[1 1 1]);numF=gcf;
    MBar=nan(length(iI),2); Mstd=MBar; clear A B
    for ep=1:length(iI)
        M=ValSav{ep};
        subplot(2,4,ep),
        errorbar(1:4,nanmean(M,1),stdError(M),'ok','Linewidth',2)
        line(2:3, nanmean(M(:,2:3),1),'Color','k'); title(tit{iI(ep)})
        set(gca,'Xtick',1:4); if ep==1,ylabel('FR zscore');end
        set(gca,'XtickLabel',{tit2{iI(ep),1},[tit2{iI(ep),2},'-deb'],[tit2{iI(ep),2},'-fin'],tit2{iI(ep),3}});
        set(gca,'XtickLabelRotation',45); xlim([0 5]); pval=addSigStarML(M);
        
        A{ep}=M(:,4)-M(:,1); namM{1}='POST-PRE';
        B{ep}=M(:,3)-M(:,2); namM{2}='END-BEG';
        MBar(ep,1)=nanmean(A{ep}); Mstd(ep,1)=stdError(A{ep});
        MBar(ep,2)=nanmean(B{ep}); Mstd(ep,2)=stdError(B{ep});
    end
    subplot(2,4,5:6)
    bar(MBar'); colormap('pink')
    if length(iI)==3, hold on, errorbar([0.77 1 1.23 1.77 2 2.23],MBar(:),Mstd(:),'+k');end
    if length(iI)==2, hold on, errorbar([0.85 1.15 1.85 2.15],MBar(:),Mstd(:),'+k');end
    legend(tit{iI})
    set(gca,'Xtick',1:2);set(gca,'XtickLabel',namM) 
    p1= signrank(A{1},A{2});p2= signrank(B{1},B{2});
    text(1,0.5*max(ylim),sprintf('p=%1.3f',p1))
    text(2,0.5*max(ylim),sprintf('p=%1.3f',p2))
    ylabel('FR zscore'); 
end
%saveFigure(numF.Number,'diffFRzscoreTrioBars',FolderToSave)

%%

smo=1;
doEp=2:7; 
for n=1:length(doEp)
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.6 0.2]), numF(n)=gcf;
    tempEv=StageEv{doEp(n)};

    for li=1:length(lis)
        idN=lis{li};
        Mat=nan(length(idN),length(tps));
        for nN=1:length(idN)
            A=squeeze(tempEv(:,:,idN(nN)));
            Mat(nN,:)=nanmean(A,1);
        end
        subplot(1,6,li), hold on
        %errorbar([tps-1,tps,tps+1],nanmean(Mat,1),stdError(Mat),'Linewidth',2)
        plot(tps,smooth(nanmean(Mat,1),smo),'Color',colori{1},'Linewidth',2)
        plot(tps,smooth(nanmean(Mat,1)+stdError(Mat),smo),'Color',colori{1})
        plot(tps,smooth(nanmean(Mat,1)-stdError(Mat),smo),'Color',colori{1})
        xlim([0 1]); yl=[yl,ylim];
        xlabel(NamesEp{doEp(n)}); ylabel('FR zscore');
        %leg{li}=[leg{li},sprintf(' (n=%d)',length(idN))];
        title({nEp{li},sprintf('(n=%d)',length(idN))})
     
        % stats
        B=Mat(:,4:length(tps)-3); %middle
        B1=Mat(:,4:floor(length(tps)/4));% first quarter
        B2=Mat(:,length(tps)+[-floor(length(tps)/4):-3]);% last quarter
        
        % correlation slope
        B(isnan(mean(B,2)),:)=[];
        pB= polyfit(ones(size(B,1),1)*tps(4:end-3),B,1);
        line([tps(4),tps(end-3)],pB(2)+[tps(4),tps(end-3)]*pB(1),'Color','b','Linewidth',2)
        [r,p]=corrcoef(ones(size(B,1),1)*tps(4:end-3),B); if p(1,2)<0.05, ad='*';else, ad='';end
        legStat{li}=sprintf(['r=%0.2f, ',ad,'p=%0.3f'],r(1,2),p(1,2));
        
    end
    for li=1:length(lis), subplot(1,6,li),
        ylim([min(yl) max(yl)]); 
        text(0.1,max(yl)*0.8,{legStat{li}(1:8),legStat{li}(9:end)},'Color','b')
    end
    saveFigure(numF(n).Number,sprintf(['FRzscoreEvolIntra',NamesEp{doEp(n)},'-NeuronType%d'],do),FolderToSave)
end




