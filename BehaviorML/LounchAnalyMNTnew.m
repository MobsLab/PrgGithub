%% INPUTS
MotherFolder='C:\Users\Karim\Desktop\Data-Electrophy\ProjetOpto';
% toujours construire : ProjetOpto\Mouse127\MNT\Day1


erasePreviousA=0; % 0 to keep existing files, 1 otherwise

%Groups={[152 156 161 163 165 167],[153 155 157 162 164 166]};GroupsName={'CTRL','Deprivation'};
Groups={[171,173:175],[176 177]};GroupsName={'CTRL','newCTRL'};
%Groups={[152 156],[155 157]};GroupsName={'CTRL','Deprivation'};
%Groups={[136 138 139],[152 154 156],[153 155 157]}; % rankau 1er groupsum/
%GroupsName={'Prehab','CTRL','Deprivation'};
A_Mice=unique([Groups{1},Groups{2}]);
A_Days=1:6;
NbtrialPerSession=4;
nameManipe='MNT';
speed_thresh=20;% cm/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% INITIATE
if isempty(strfind(MotherFolder,'/')), mark='\'; else, mark='/'; end
DelayPOS=2;

PosMATTT=[];
MATTT=[];
MATTnames={'Mouse','Day','Session'};
nbGroupParams=[4 13 24 32];
NameGroupParams={'LearningStrength','ReferenceMemory','WorkingMemory'};
MATTnames(4:12)={'Length Session (s)','runned distance(cm)','Speed outside stim (cm/s)',...
    'Average speed (cm/s)','Mean speed (cm/s)','80th speed percentile (cm/s)',...% vitesse apprentissage
    't in Stimulation (s)','%Tsession in stim','%Tvisit in stim'}; % stimulation received
MATTnames(13:23)={'Entry in Rewarded ports (R)','t in R (s)','%Tsession in R','%Tvisit in R',... % good ports
    'Entry in NONrewarded ports (NR)','t in NR (s)','%session t in NR','%Tvisit in NR',... % bad ports
    '%Visit in R','%Visit in NR (REF ERROR)','nb stim'};
MATTnames(24:31)={'nb REentry in R','%Visit REentry in R','%Tvisit REentry in R','%Tsession REentry in R',... % Working memory 
    'nb REentry in NR','%Visit REentry in NR','%Tvisit REentry in NR','%Tsession REentry in NR'};% Working memory 
    
colori={'k' 'b' 'r' 'g' 'm' 'c' 'y'};
coloriMouse=[];
for gg=1:length(Groups)
    for u=1:length(Groups{gg})
        coloriMouse{A_Mice==Groups{gg}(u)}=[(1-1/(u+1))*(rem(gg+1,2)) (1-1/(u+1))*(rem(gg+1,3))/2 0];
    end
end
%if length(A_Mice)<7, coloriMouse=colori; end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPUTE MATTT
for mi=1:length(A_Mice)
    disp(' ')
    disp(['          *   Mouse ',num2str(A_Mice(mi)),'   * ']);
    
    for da=1:length(A_Days)
        disp(['                  - day ',num2str(A_Days(da)),' - '])
        directName=[MotherFolder,mark,'Mouse',num2str(A_Mice(mi)),mark,nameManipe,mark,'Day',num2str(A_Days(da))];
        lis=dir(directName);
        
        for i=3:length(lis)
            temp=lis(i).name;
            if length(temp)>12 && strcmp(temp(end-12:end),'-wideband.mat')
                clear StimInPorts TimeInPorts RewardedPorts TpsStop TpsStart
                temp=temp(1:end-13);
                disp(temp)
                %----------------------------------------------------------
                % is the analysis already performed?
                Do_analysis=1;
                if exist([directName,mark,temp,'-A.mat'],'file') && erasePreviousA==0
                    load([directName,mark,temp,'-A.mat'],'StimInPorts','TpsStart','TpsStop');
                    if exist('StimInPorts','var') && exist('TpsStart','var') && exist('TpsStop','var') 
                        disp('           -> AnalyseMNT already done')
                        Do_analysis=0;
                    end
                end
                
                if isempty(strfind(temp,'Session'))
                    MultipleRecInMCrack=1;   
                else
                    MultipleRecInMCrack=0; 
                    n_Session=str2double(temp(strfind(temp,'Session')+7));
                end
                
                
                %----------------------------------------------------------
                % perform analysis
                if Do_analysis
                    cd(directName)
                    eval('AnalyseMNT')
                    cd(MotherFolder)
                end
                
                %----------------------------------------------------------
                % TrueVisit
                % = port / delayWithLastPort / lasting 
                load([directName,mark,temp,'-A.mat'],'TrueVisit','TrueVisit_5sDelay','TimeRealStim');
                load([directName,mark,temp,'-A.mat'],'StimInPorts','TimeInPorts','RewardedPorts','TpsStop','TpsStart');

                if MultipleRecInMCrack
                    
                    load([directName,mark,temp,'-A.mat'],'PosMatALL','Ratio_IMAonREAL','RewardedTimeInPorts')


                    for ses=1:NbtrialPerSession
                        %--------------------------------------------------
                        % tracked position
                        if ses==1
                            tempPosMat=PosMatALL(PosMatALL(:,1)==ses,:);
                        else
                            tempPosMat=PosMatALL(PosMatALL(:,1)==ses,:);
                            tempPosMat(:,2)=tempPosMat(:,2)+max(PosMatALL(PosMatALL(:,1)==ses-1,2));
                        end
                      
                        tempSTIM=TimeRealStim(TimeRealStim(:,1)==ses,2);
                        NoStimPeriod=IntervalSet(tempPosMat(1,2),tempPosMat(end,2))-IntervalSet(tempSTIM,tempSTIM+5);% attention en s !!!  
%                         for tR=1:length(tempSTIM)
%                             indPos=find(tempPosMat(:,2)<=tempSTIM(tR) & tempPosMat(:,2)>tempSTIM(tR)-DelayPOS);
%                             PosMATTT=[PosMATTT;[A_Mice(mi)*ones(length(indPos)+1,1),A_Days(da)*ones(length(indPos)+1,1),ses*ones(length(indPos)+1,1),...
%                                 [tempPosMat(indPos,3);NaN],[tempPosMat(indPos,4);NaN]]]; 
%                         end

                        %--------------------------------------------------
                        % caculate speed and runned distance
                        indexPos=find(~isnan(tempPosMat(:,2)) & ~isnan(tempPosMat(:,3)) & ~isnan(tempPosMat(:,4)));
                        MATXi=tempPosMat(indexPos(2:end),3);
                        MATXe=tempPosMat(indexPos(1:end-1),3);
                        MATYi=tempPosMat(indexPos(2:end),4);
                        MATYe=tempPosMat(indexPos(1:end-1),4);
                        MATt=diff(tempPosMat(indexPos,2));
                        RunDist=sqrt((MATXi-MATXe).*(MATXi-MATXe)+(MATYi-MATYe).*(MATYi-MATYe))/Ratio_IMAonREAL;% distance (cm)
                        RunSpeed=RunDist./MATt;
                        for vv=1:length(RunSpeed)
                            if vv>1 && RunSpeed(vv)>speed_thresh
                                RunSpeed(vv)=RunSpeed(vv-1);
                                RunDist(vv)=RunDist(vv-1);
                            end
                        end
                        
                        %--------------------------------------------------
                        % fill tempMat
                        Rports=RewardedPorts(RewardedPorts(:,1)==ses,2);
                        NRports=find(~ismember([1:8],Rports));
                        tempMAT(1,1:3)=[A_Mice(mi) A_Days(da) ses];%'Mouse','Day','Session'
                        
                        tempMAT(1,4)=TpsStop(ses)-TpsStart(ses);% 'Length Session (s)'
                        tempMAT(1,5)=sum(RunDist)/100;%'runned distance(m)'
                        tempMAT(1,6)=mean(Data(Restrict(tsd(tempPosMat(indexPos(2:end),2),RunSpeed),NoStimPeriod)));%'Average Speed outside stim (cm/s)'
                        tempMAT(1,7)=mean(RunSpeed);%'Average speed (cm/s)'
                        tempMAT(1,8)=median(RunSpeed);%'Median speed (cm/s)'
                        tempMAT(1,9)=percentile(RunSpeed, 80);%'80th speed percentile (cm/s)'
                        tempMAT(1,10)=sum(RewardedTimeInPorts(ses,Rports));% 't in Stimulation (s)'
                        tempMAT(1,11)=100*tempMAT(1,10)/tempMAT(1,4);% '%Tsession in stim'
                        tempMAT(1,12)=100*tempMAT(1,10)/sum(TimeInPorts(ses,:));% '%Tvisit in stim'

                        tempMAT(1,13)=sum(ismember(TrueVisit_5sDelay(TrueVisit_5sDelay(:,1)==ses,2),Rports));% 'Entry in Rewarded ports'
                        tempMAT(1,14)=sum(TimeInPorts(ses,Rports));% 't in R (s)'
                        tempMAT(1,15)=100*tempMAT(1,14)/tempMAT(1,4);% '%Tsession in R'
                        tempMAT(1,16)=100*tempMAT(1,14)/sum(TimeInPorts(ses,:));% '%Tvisit in R'
                        tempMAT(1,17)=sum(ismember(TrueVisit_5sDelay(TrueVisit_5sDelay(:,1)==ses,2),NRports));% 'Entry in UNrewarded port
                        tempMAT(1,18)=sum(TimeInPorts(ses,NRports));% 't in NR (s)
                        tempMAT(1,19)=100*tempMAT(1,18)/tempMAT(1,4);% '%Tsession in NR'
                        tempMAT(1,20)=100*tempMAT(1,18)/sum(TimeInPorts(ses,:));% '%Tvisit in NR'
                        tempMAT(1,21)=100*tempMAT(1,13)/(tempMAT(1,13)+tempMAT(1,17));% '%Visit in R (REF Perf)'
                        tempMAT(1,22)=100*tempMAT(1,17)/(tempMAT(1,13)+tempMAT(1,17));% '%Visit in NR (REF ERROR)'
                        tempMAT(1,23)=sum(StimInPorts(ses,:));%Nb Stim
                        
                        tempMAT(1,24)=tempMAT(1,13)-sum(StimInPorts(ses,:));% 'nb REentry in R'
                        tempMAT(1,25)=100*tempMAT(1,24)/(tempMAT(1,13)+tempMAT(1,17)); % '%Visit REentry in R (WORKING M)'
                        tempMAT(1,26)=100*(tempMAT(1,14)-tempMAT(1,10))/sum(TimeInPorts(ses,:));% '%Tvisit REentry in R'
                        tempMAT(1,27)=100*(tempMAT(1,14)-tempMAT(1,10))/tempMAT(1,4);% '%Tsession REentry in R'
                        NRentries=TrueVisit_5sDelay(ismember(TrueVisit_5sDelay(TrueVisit_5sDelay(:,1)==ses,2),NRports),2);
                        tempMAT(1,28)=length(NRentries)-length(unique(NRentries));% 'nb REentry in NR'
                        tempMAT(1,29)=100*tempMAT(1,28)/(tempMAT(1,13)+tempMAT(1,17)); % '%Visit REentry in NR (WORKING M)'
                        tempMAT(1,30)=100*sum(TrueVisit_5sDelay(ismember(TrueVisit_5sDelay(TrueVisit_5sDelay(:,1)==ses,2),NRports),4))/sum(TimeInPorts(ses,:));% '%Tvisit REentry in NR'
                        tempMAT(1,31)=100*sum(TrueVisit_5sDelay(ismember(TrueVisit_5sDelay(TrueVisit_5sDelay(:,1)==ses,2),NRports),4))/tempMAT(1,4);% '%Tsession REentry in NR'
                        MATTT=[MATTT;tempMAT];
                        
                    end
                    
                    
                else
                    NRports=find(~ismember([1:8],RewardedPorts));
                    tempMAT(1,1:3)=[A_Mice(mi) A_Days(da) n_Session];%'Mouse','Day','Session'
                    
                    tempMAT(1,5)=sum(RunDist)/100;%'runned distance(m)'
                    tempMAT(1,6)=NaN;%'Average Speed outside stim (cm/s)'
                    tempMAT(1,7)=NaN;%'Average speed (cm/s)'
                    tempMAT(1,8)=NaN;%'Median speed (cm/s)'
                    tempMAT(1,9)=NaN;%'80th speed percentile (cm/s)'
                    tempMAT(1,10)=sum(TimeInPorts(2,RewardedPorts));%'t in Stimulation (s)'
                    tempMAT(1,11)=100*sum(TimeInPorts(2,RewardedPorts))/tempMAT(1,4);% '%Tsession in stim'
                    tempMAT(1,12)=100*sum(TimeInPorts(2,RewardedPorts))/sum(TimeInPorts(1,:));% '%Tvisit in stim'
                    
                    tempMAT(1,13)=sum(ismember(TrueVisit_5sDelay(:,1),RewardedPorts));% 'Entry in Rewarded ports (R)'
                    tempMAT(1,14)=sum(TimeInPorts(1,RewardedPorts));% 't in R (s)'
                    tempMAT(1,15)=100*tempMAT(1,14)/tempMAT(1,4);% '%Tsession in R'
                    tempMAT(1,16)=100*tempMAT(1,14)/sum(TimeInPorts(1,:));% '%Tvisit in R'
                    tempMAT(1,17)=sum(ismember(TrueVisit_5sDelay(:,1),NRports));% 'Entry in NONrewarded ports (NR)'
                    tempMAT(1,18)=sum(TimeInPorts(1,NRports));% 't in NR (s)'
                    tempMAT(1,19)=100*tempMAT(1,18)/tempMAT(1,4);% '%Tsession in NR'
                    tempMAT(1,20)=100*tempMAT(1,18)/sum(TimeInPorts(1,:));% '%Tvisit in NR'
                    tempMAT(1,21)=100*tempMAT(1,13)/(tempMAT(1,13)+tempMAT(1,17)); % '%Visit in R'
                    tempMAT(1,22)=100*tempMAT(1,17)/(tempMAT(1,13)+tempMAT(1,17));% '%Visit in NR (REF ERROR)'
                    tempMAT(1,23)=sum(StimInPorts);% 'Nb Stim'
                    
                    tempMAT(1,24)=tempMAT(1,13)-sum(StimInPorts);% 'nb REentry in R'
                    tempMAT(1,25)=100*tempMAT(1,24)/(tempMAT(1,13)+tempMAT(1,17));% '%Visit REentry in R (WORKING MEM ERR)'
                    tempMAT(1,26)=100*(tempMAT(1,14)-tempMAT(1,10))/sum(TimeInPorts(1,:));% '%Tvisit REentry in R'
                    tempMAT(1,27)=100*(tempMAT(1,14)-tempMAT(1,10))/tempMAT(1,4);% '%Tsession REentry in R'
                    NRentries=TrueVisit_5sDelay(ismember(TrueVisit_5sDelay(:,1),NRports),1);
                    tempMAT(1,28)=length(NRentries)-length(unique(NRentries));% 'nb REentry in NR'
                    tempMAT(1,29)=100*tempMAT(1,28)/(tempMAT(1,13)+tempMAT(1,17)); % '%Visit REentry in NR (WORKING MEM)'
                    tempMAT(1,30)=100*sum(TrueVisit_5sDelay(ismember(TrueVisit_5sDelay(:,1),NRports),3))/sum(TimeInPorts(1,:));% '%Tvisit REentry in NR'
                    tempMAT(1,31)=100*sum(TrueVisit_5sDelay(ismember(TrueVisit_5sDelay(:,1),NRports),3))/tempMAT(1,4);% '%Tsession REentry in NR'
                    
                    try MATTT=[MATTT;tempMAT];catch keyboard; end
                end
            
            end
        end
    end
end

U_Mice=unique(MATTT(:,1));
U_Days=unique(MATTT(:,2));
U_Sessions=unique(MATTT(:,3));
nf=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT ALL PARAMETERS PER SESSION
for np=1:length(nbGroupParams)-1
    figure ('Color',[1 1 1]),numF(nf)=gcf; nameF{nf}=[nameManipe,'_Indiv_Sessions_',NameGroupParams{np}]; nf=nf+1;
    tempParams=nbGroupParams(np):nbGroupParams(np+1)-1;
    for p=1:length(tempParams)
        for mi=1:length(U_Mice)
            indexMice=find(MATTT(:,1)==U_Mice(mi));
            subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),p), hold on,
            ylabel(MATTnames{tempParams(p)}), xlabel('Sessions')
            plot(MATTT(indexMice,3)+max(U_Sessions)*(MATTT(indexMice,2)-1),MATTT(indexMice,tempParams(p)),'.-','Color',coloriMouse{mi})
        end
    end
    legend(num2str(U_Mice),'Location','Best');
    subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),2),
    title(['Experiment ',nameManipe,'  (n=',num2str(length(U_Mice)),', Mice ',num2str(U_Mice'),')'],'fontsize',12,'fontweight','b')
    
    % drow line to separate days
    for p=1:length(tempParams)
        subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),p), hold on,
        for da=1:length(U_Days)
            yl=ylim;
            hold on, line([4*(da-1)+0.5 4*(da-1)+0.5],yl,'Color',[0.5 0.5 0.5])
            xlim([0 length(U_Sessions)*length(U_Days)])
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT ALL PARAMETERS PER SESSION POOLED PER GROUPS

for mi=1:length(U_Mice)
    for gg=1:length(Groups)
        if ismember(U_Mice(mi),Groups{gg})
            GroupMi(mi)=gg;
        end
    end
end
Nsessions=length(U_Days)*NbtrialPerSession;
for np=1:length(nbGroupParams)-1
    figure ('Color',[1 1 1]),numF(nf)=gcf; nameF{nf}=[nameManipe,'_Groups_Days_',NameGroupParams{np}]; nf=nf+1;
    tempParams=nbGroupParams(np):nbGroupParams(np+1)-1;
    for p=1:length(tempParams)
        for mi=1:length(U_Mice)
            for da=1:length(U_Days)
                Av_mice(mi,(da-1)*NbtrialPerSession+[1:NbtrialPerSession])=MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),tempParams(p))';
            end
        end
        
        subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),p), hold on,
        for gg=1:length(Groups)
            plot([1:Nsessions],mean(Av_mice(GroupMi==gg,:),1),['.-',colori{gg}],'Linewidth',2)
            errorbar([1:Nsessions],mean(Av_mice(GroupMi==gg,:),1),stdError(Av_mice(GroupMi==gg,:)),'Color',colori{gg})
            for u=1:Nsessions,
                pval=ranksum(Av_mice(GroupMi==gg,1),Av_mice(GroupMi==gg,u));
                if pval<0.05, text(u,(0.7+0.1*gg)*max(ylim),'*','Color',colori{gg});
                end
            end
        end
        for u=1:Nsessions,
            pval=ranksum(Av_mice(GroupMi==1,u),Av_mice(GroupMi==2,u));
            if pval<0.05, text(u,max(ylim),'*','Color','g'); end
        end
        
        ylabel(MATTnames{tempParams(p)});xlabel('Trial');
        xlim([0.5 Nsessions+0.5])
        if ~isempty(strfind(MATTnames{tempParams(p)},'%Visit in R')) 
            line([0.5 Nsessions+0.5],[0 0]+100*2/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
            text(Nsessions/2,100*2/8,'Chance Level','Color',[0.5 0.5 0.5])
        elseif ~isempty(strfind(MATTnames{tempParams(p)},'%Visit in NR')) 
            line([0.5 Nsessions+0.5],[0 0]+100*6/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
            text(Nsessions/2,100*6/8,'Chance Level','Color',[0.5 0.5 0.5])
        end
        % drow line to separate days
        for da=1:length(U_Days)
            yl=ylim;
            hold on, line([ length(U_Sessions)*(da-1)+0.5 length(U_Sessions)*(da-1)+0.5],yl,'Color',[0.5 0.5 0.5])
            xlim([0 length(U_Sessions)*length(U_Days)])
        end
    end
    leg=[]; for gg=1:length(Groups),leg=[leg,GroupsName(gg),num2str(Groups{gg})];end
    legend(leg);
    subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),2),
    title(['Experiment ',nameManipe,'  (n=',num2str(length(U_Mice)),', Mice ',num2str(U_Mice'),')'],'fontsize',10,'fontweight','b'),
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT ALL PARAMETERS PER DAY POOLED PER GROUPS

for np=1:length(nbGroupParams)-1
    figure ('Color',[1 1 1]),numF(nf)=gcf; nameF{nf}=[nameManipe,'_Groups_Days_',NameGroupParams{np}]; nf=nf+1;
    tempParams=nbGroupParams(np):nbGroupParams(np+1)-1;
    for p=1:length(tempParams)
        for mi=1:length(U_Mice)
            for da=1:length(U_Days)
                Av_mice(mi,da)=nanmean(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),tempParams(p)),1);
            end
        end
        
        subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),p), hold on,
        for gg=1:length(Groups)
            plot([1:length(U_Days)],mean(Av_mice(GroupMi==gg,:),1),['.-',colori{gg}],'Linewidth',2)
            errorbar([1:length(U_Days)],mean(Av_mice(GroupMi==gg,:),1),stdError(Av_mice(GroupMi==gg,:)),'Color',colori{gg})
            for u=1:length(U_Days),
                pval=ranksum(Av_mice(GroupMi==gg,1),Av_mice(GroupMi==gg,u));
                if pval<0.05, text(u,(0.7+0.1*gg)*max(ylim)+1,'*','Color',colori{gg});
                end
            end
        end
        for u=1:length(U_Days),
            pval=ranksum(Av_mice(GroupMi==1,u),Av_mice(GroupMi==2,u));
            if pval<0.05, text(u,max(ylim)+1,'*','Color','g'); end
        end
        
        ylabel(MATTnames{tempParams(p)});xlabel('days');
        xlim([0.5 length(U_Days)+0.5])
        if ~isempty(strfind(MATTnames{tempParams(p)},'%Visit in R')) 
            line([0.5 length(U_Days)+0.5],[0 0]+100*2/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
            text(length(U_Days)/2,100*2/8,'Chance Level','Color',[0.5 0.5 0.5])
        elseif ~isempty(strfind(MATTnames{tempParams(p)},'%Visit in NR')) 
            line([0.5 length(U_Days)+0.5],[0 0]+100*6/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
            text(length(U_Days)/2,100*6/8,'Chance Level','Color',[0.5 0.5 0.5])
        end
    end
    leg=[]; for gg=1:length(Groups),leg=[leg,GroupsName(gg),num2str(Groups{gg})];end
    legend(leg);
    subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),2),
    title(['Experiment ',nameManipe,'  (n=',num2str(length(U_Mice)),', Mice ',num2str(U_Mice'),')'],'fontsize',10,'fontweight','b'),
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% POOL GROUPS FOR ALL PARAMETERS 

for np=1:length(nbGroupParams)-1
    figure ('Color',[1 1 1]),numF(nf)=gcf; nameF{nf}=[nameManipe,'_Groups_Days_',NameGroupParams{np}]; nf=nf+1;
    tempParams=nbGroupParams(np):nbGroupParams(np+1)-1;
    for p=1:length(tempParams)
        Av_Mice=[];
        for mi=1:length(U_Mice)
            for da=1:length(U_Days)
                Av_mice(mi,da)=mean(MATTT(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da),tempParams(p)));
            end
        end
        
        subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),p), hold on,
        for gg=1:length(Groups)
            plot([1:length(U_Days)],mean(Av_mice(GroupMi==gg,:),1),['.-',colori{gg}],'Linewidth',2)
            errorbar([1:length(U_Days)],mean(Av_mice(GroupMi==gg,:),1),stdError(Av_mice(GroupMi==gg,:)),'Color',colori{gg})
            for u=1:length(U_Days),
                pval=ranksum(Av_mice(GroupMi==gg,1),Av_mice(GroupMi==gg,u));
                if pval<0.05, text(u,(0.7+0.1*gg)*max(ylim)+1,'*','Color',colori{gg});
                end
            end
        end
        for u=1:length(U_Days),
            pval=ranksum(Av_mice(GroupMi==1,u),Av_mice(GroupMi==2,u));
            if pval<0.05, text(u,max(ylim)+1,'*','Color','g'); end
        end
        
        ylabel(MATTnames{tempParams(p)});xlabel('days');
        xlim([0.5 length(U_Days)+0.5])
        if ~isempty(strfind(MATTnames{tempParams(p)},'%Visit in R')) 
            line([0.5 length(U_Days)+0.5],[0 0]+100*2/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
            text(length(U_Days)/2,100*2/8,'Chance Level','Color',[0.5 0.5 0.5])
        elseif ~isempty(strfind(MATTnames{tempParams(p)},'%Visit in NR')) 
            line([0.5 length(U_Days)+0.5],[0 0]+100*6/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
            text(length(U_Days)/2,100*6/8,'Chance Level','Color',[0.5 0.5 0.5])
        end
    end
    leg=[]; for gg=1:length(Groups),leg=[leg,GroupsName(gg),num2str(Groups{gg})];end
    legend(leg);
    subplot(round(sqrt(length(tempParams))),ceil(sqrt(length(tempParams))),2),
    title(['Experiment ',nameManipe,'  (n=',num2str(length(U_Mice)),', Mice ',num2str(U_Mice'),')'],'fontsize',10,'fontweight','b'),
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% COMPARE FIRST SESSIONS WITH LAST SESSIONS
PercChngeInter=zeros(length(U_Mice),length(U_Days)-1);
nsub=ceil(sqrt((length(MATTnames)-3)/2));
for p=1:length(MATTnames)-3
    if p==1 || p==nsub*nsub-1, figure ('Color',[1 1 1]);numF(nf)=gcf; nf=nf+1;asub=1;end
    
    Av_MiceI=[];Av_MiceE=[];
    for mi=1:length(U_Mice)
        for da=1:length(U_Days)
            indMat=find(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da) & ismember(MATTT(:,3),[1 2]));
            Av_miceI(mi,da)=mean(MATTT(indMat,p+3));
            indMat=find(MATTT(:,1)==U_Mice(mi) & MATTT(:,2)==U_Days(da) & ismember(MATTT(:,3),[3 4]));
            Av_miceE(mi,da)=mean(MATTT(indMat,p+3));
            try PercChngeInter(mi,da-1)=100*(Av_miceI(mi,da)-Av_miceE(mi,da-1))./Av_miceE(mi,da-1);end
        end
    end
    
    subplot(nsub,2*nsub,asub);asub=asub+1; hold on,
    for gg=1:length(Groups)
        plot([1:length(U_Days)],mean(Av_miceI(GroupMi==gg,:),1),['.-',colori{gg}],'Linewidth',2)
        errorbar([1:length(U_Days)],mean(Av_miceI(GroupMi==gg,:),1),stdError(Av_miceI(GroupMi==gg,:)),'Color',colori{gg})
        plot([1:length(U_Days)],mean(Av_miceE(GroupMi==gg,:),1),['.-',colori{gg}])
        errorbar([1:length(U_Days)],mean(Av_miceE(GroupMi==gg,:),1),stdError(Av_miceE(GroupMi==gg,:)),'Color',colori{gg})
    end
    for u=1:length(U_Days),
        pval=ranksum(Av_miceI(GroupMi==1,u),Av_miceI(GroupMi==2,u));
        if pval<0.05, text(u,max(ylim)+1,'*','Color','r'); end
        pval=ranksum(Av_miceE(GroupMi==1,u),Av_miceE(GroupMi==2,u));
        if pval<0.05, text(u,max(ylim)+1,'  *','Color','m'); end
    end
    ylabel(MATTnames{p+3});xlabel('days');
    xlim([0.5 length(U_Days)+0.5])
    
    subplot(nsub,2*nsub,asub);asub=asub+1; hold on,
    PercChngeIntra=100*(Av_miceE-Av_miceI)./Av_miceI;
    for gg=1:length(Groups)
        plot([1:length(U_Days)],mean(PercChngeIntra(GroupMi==gg,:),1),['.-',colori{gg}],'Linewidth',2)
        errorbar([1:length(U_Days)],mean(PercChngeIntra(GroupMi==gg,:),1),stdError(PercChngeIntra(GroupMi==gg,:)),'Color',colori{gg})
        plot([2:length(U_Days)],mean(PercChngeInter(GroupMi==gg,:),1),['.-',colori{gg}])
        errorbar([2:length(U_Days)],mean(PercChngeInter(GroupMi==gg,:),1),stdError(PercChngeInter(GroupMi==gg,:)),'Color',colori{gg})
        line([0.5 length(U_Days)+0.5],[0 0],'Color',[0.5 0.5 0.5])
    end  
    xlim([0.5 length(U_Days)+0.5])
    ylabel('% change')    
    
    if p==nsub-1 || p==length(MATTnames)-3
        leg=[]; for gg=1:length(Groups),leg=[leg,'IntraDay',GroupsName(gg),'InterDay',' ','zero'];end; legend(leg)
        leg=[]; for gg=1:length(Groups),leg=[leg,'First sessions',GroupsName(gg),'Last Sessions',' '];end;subplot(nsub,2*nsub,1),legend(leg)
        subplot(nsub,2*nsub,2),
        title(['Experiment ',nameManipe,'  (n=',num2str(length(U_Mice)),', Mice ',num2str(U_Mice'),')'],'fontsize',10,'fontweight','b'),
    end
    if ~isempty(strfind(MATTnames{p},'%Visit in R'))
        line([0.5 length(U_Days)+0.5],[0 0]+100*2/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
        text(length(U_Days)/2,100*2/8,'Chance Level','Color',[0.5 0.5 0.5])
    elseif ~isempty(strfind(MATTnames{p},'%Visit in NR'))
        line([0.5 length(U_Days)+0.5],[0 0]+100*6/8,'Color',[0.5 0.5 0.5],'LineStyle','--')
        text(length(U_Days)/2,100*6/8,'Chance Level','Color',[0.5 0.5 0.5])
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SAVE FIGURES
if 1
    disp('Keyboard to change figures before saving'); keyboard;
    FolderSave=uigetdir('Where to save Figures?',pwd);
    if FolderSave~=0
        disp(['Saving figures in ',FolderSave])
        for nf=1:length(numF)
            saveFigure(numF(nf),nameF{nf},FolderSave)
        end
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PLOT TRAJECTORIES
if 0
figure ('Color',[1 1 1]),
for mi=1:length(U_Mice)
    for da=1:length(U_Days)
        subplot(ceil(sqrt(length(U_Mice))),ceil(length(U_Mice)/ceil(sqrt(length(U_Mice)))),mi), hold on,
        ind=find(PosMATTT(:,1)==U_Mice(mi) & PosMATTT(:,2)==U_Days(da));
        plot(PosMATTT(ind,4),PosMATTT(ind,5),'Color',colori{da});
    end
    title(['Mouse ',num2str(U_Mice(mi))])
    ylim([0 300]); xlim([0 300])
end

end
