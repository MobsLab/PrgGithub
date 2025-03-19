% AnalyseNREMsubstages_N1evalEMGonlyML.m

% list of related scripts in NREMstages_scripts.m 
% CodePourMarieCrossCorrDeltaSpindlesRipples.m

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/N1mouvement';
res='/media/DataMOBsRAIDN/ProjetNREM/AnalyseNREMsubstagesNew';
analyname='AnalySubstagesN1notWake_EMGonly';
if 1
    Dir1=PathForExperimentsMLnew('BASALlongSleep');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
else
    analyname=[analyname,'_old'];
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
end
colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% check that N1 is not only movement

DoEp={'WAKE','N1','N2','N3','REM'};
wind=10E4;% in 1/1E4 second
%VarName={'mov','tsdEMG'}; analyname='AnalySubstagesN1notWake_EMGonly';
VarName={'mov','tsdEMG','tsdGhi'}; analyname='AnalySubstagesN1notWake_EMGandOB';


try
    clear MAT; load([res,'/',analyname]);
    if exist('MAT','var'), disp([analyname,' already exists: loaded !']),else, error;end
    
catch
    for n=1:length(DoEp),for v=1:length(VarName), MAT{n,v}=[];MATind{n,v}=[];end;end
    
    % figure these Marie, aller dans: 
    % /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse083/20130730/BULB-Mouse-83-30072013%
    % test=colormap('gray');colormap(test(end:-1:1,:));
    % pour movment non-zscore: caxis([0.5 6])
    % pour gamma OB: caxis([31 43]);
    
    for man=1:length(Dir.path)
        disp(Dir.path{man})
        cd(Dir.path{man})
        try
            % -----------------------
            % load movements
            disp('loading movements...')
            mov=tsd([],[]);
            clear Mmov
            try load('StateEpoch.mat','Mmov');end
            if exist('Mmov','var')
                rg=Range(Mmov,'s'); Dt=Data(Mmov);
                dt=SmoothDec(interp1(rg,Dt,rg(1):0.05:rg(end)),10);
                mov=tsd(1E4*(rg(1):0.05:rg(end)),zscore(dt)); %sample at 20Hz
                %mov=tsd(1E4*(rg(1):0.05:rg(end)),dt); %sample at 20Hz
            end
            
            % -----------------------
            % laod EMG if exists
            clear InfoLFP emg tsdEMG LFP
            load('LFPData/InfoLFP.mat');
            emg=InfoLFP.channel(min([find(strcmp(InfoLFP.structure,'EMG')),find(strcmp(InfoLFP.structure,'emg'))]));
            if ~isempty(emg)
                disp('Loading and filtering EMG channel... WAIT...')
                load(['LFPData/LFP',num2str(emg),'.mat'],'LFP');
                tsdEMG=FilterLFP(LFP,[50 300], 1024);
                Dt=abs(Data(tsdEMG));rg=Range(tsdEMG,'s');
                dt=SmoothDec(interp1(rg,Dt,rg(1):0.05:rg(end)),10);
                tsdEMG=tsd(1E4*(rg(1):0.05:rg(end))',zscore(dt)); %sample at 25Hz
            else
                disp('no EMG...')
                tsdEMG=tsd([],[]);
                if length(VarName)>2, disp('abort day'); error;end
            end
            % -----------------------
            % load substages
            clear WAKE REM N1 N2 N3 SleepStages
            disp('Loading Substages...')
            [WAKE,REM,N1,N2,N3,NamesStages]=RunSubstages;close;
            SleepStages=[];
            disp('Calculating SleepStages...')
            for n=1:length(NamesStages)
                eval(['epoch=',NamesStages{n},';'])
                SleepStages=[SleepStages; [ Start(epoch,'s'),Stop(epoch,'s'),n*ones(length(Start(epoch)),1)]];
            end
            SleepStages=sortrows(SleepStages,1);
            SavSleepSt{man}=SleepStages;
            
            
            
            % -----------------------
            % load gamma OB
            if length(VarName)>2
                disp('loading spectrum from OB...')
                tsdGhi=tsd([],[]);
                clear Spectro
                try
                    load('B_High_Spectrum.mat');
                    tsdGhi=tsd(Spectro{2}*1E4,mean(10*log10(Spectro{1}(:,Spectro{3}>50 & Spectro{3}<70)),2));
                    newTsd=Restrict(tsdGhi,ts(min(Range(tsdGhi)):1E4/49:max(Range(tsdGhi))));
                    rg=Range(newTsd);Dt=Data(newTsd);Dt(Dt==Inf | Dt==-Inf)=NaN;
                    tsdGhi=tsd(rg,nanzscore(SmoothDec(Dt,100)));
                end
            else
                disp('skip loading spectrum from OB...')
                tsdGhi=tsd([],[]);Sptsd=tsd([],[]);fL=1;t=1;
            end
            
            % -----------------------
            % trig variables on epoch start
            figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.5 0.8]),numF=gcf;
            Cl=nan(length(VarName),2*length(DoEp));
            for n=1:length(DoEp)
                disp(DoEp{n})
                eval(['epoch=',DoEp{n},';']);
                
                st=Start(epoch);sto=Stop(epoch);
                durEp=Stop(epoch,'s')-Start(epoch,'s');
                m1=max([Range(mov);Range(tsdEMG);Range(tsdGhi)]);
                m2=min([Range(mov);Range(tsdEMG);Range(tsdGhi)]);
                st=st(st < m1-wind & st > m2+wind);
                sto=sto(st < m1-wind & st > m2+wind);
                durEp=durEp(st < m1-wind & st > m2+wind);
                % previous stage
                NatR=6+zeros(length(st),1);DurR=nan(length(st),1);
                for i=1:length(st)
                    try
                        idNat=find(abs(st(i)-SleepStages(:,2)*1E4)<5);
                        NatR(i)=SleepStages(idNat,3);
                        DurR(i)=SleepStages(idNat,2)-SleepStages(idNat,1);
                    end
                end
                % remove noise episods
                if 1
                    st(NatR==6)=[]; sto(NatR==6)=[]; durEp(NatR==6)=[]; DurR(NatR==6,:)=[]; NatR(NatR==6,:)=[];
                end
                
                for v=1:length(VarName)
                    eval(['vr=',VarName{v},';']);
                    if ~isempty(Data(vr))
                        % imagePETH
                        tps=[-10:1/50:10];
                        dt=nan(length(st),length(tps));
                        for tt=1:length(st)
                            I=ts(st(tt)+tps*1E4);
                            dt(tt,:)=Data(Restrict(vr,I))';
                        end
                        % ------------ period from 0 to 3s after N1 onset --------------
                        [temp,ind]=sortrows(-mean(dt(:,find(tps<3 & tps>0)),2),1);
                        % ------------ order by episod length --------------
                        [~,ind]=sort(durEp);
                        % ------------ order by nature of previous episod --------------
                        [~,ind2]=sort(NatR);
                        
                        figure(numF),
                        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v-1),
                        imagesc(tps,1:size(dt,1),dt(ind,:));
                        hold on, plot(durEp(ind),1:size(dt,1),'.k')
                        line([0,0],[0,size(dt,1)],'Color','k')
                        %
                        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v),
                        imagesc(tps,1:size(dt,1),dt(ind2,:));
                        idLine=find(diff(NatR(ind2))~=0);
                        for i=1:length(idLine),line(xlim,idLine(i)+[0 0],'Color','k');end
                        xlabel(NamesStages(unique(NatR(NatR<6))))
                        line([0,0],[0,size(dt,1)],'Color','k')
                        
                        % for save
                        temp=MAT{n,v};
                        MAT{n,v}=[temp;dt];
                        temp=MATind{n,v};
                        MATind{n,v}=[temp;[durEp,NatR,man*ones(length(st),1),DurR]];
                        
                        disp(['      - ',VarName{v},' done !'])
                    else
                        disp(['      - skip',VarName{v}])
                    end
                    figure(numF),subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v-1),
                    ylabel(VarName{v});  caxis([0.5 6])
                    xlabel({['Time before ',DoEp{n},' start (s)'],'Ordered by epoch duration'})
                    Cl(v,2*n-1:2*n)=caxis;
                    
                    if v==2 && n==1, title(Dir.path{man});end
                end
            end
            test=colormap('gray');colormap(test(end:-1:1,:));
            saveFigure(numF.Number,sprintf(['AnalyseNREM-N1noWake%dzc-',Dir.name{man}],man),FolderToSave);
        catch
            disp('Problem...')
            if length(VarName)<3 && exist('Mmov','var'), keyboard ; end
        end
    end
    disp(['saving in ',analyname,'...'])
    save([res,'/',analyname],'Dir','SavSleepSt','MAT','MATind','DoEp','wind','VarName','tps','NamesStages');
    
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< Display ALL concatenates <<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


figure('Color',[1 1 1],'Unit','normalized','Position',[0.05 0.1 0.5 0.85]),numF=gcf;
Cl=nan(length(VarName),2*length(DoEp));
for n=1:length(DoEp)
    for v=1:length(VarName)
        dt=MAT{n,v};
        if ~isempty(dt)
        % ------------ order by episod length --------------
        durEp=MATind{n,v}(:,1);
        [~,ind]=sort(durEp);
        % ------------ order by nature of previous episod --------------
        NatR=MATind{n,v}(:,2);
        [~,ind2]=sort(NatR);
        
        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v-1),
        imagesc(tps,1:size(dt,1),dt(ind,:));
        hold on, plot(durEp(ind),1:size(dt,1),'.k')
        line([0,0],[0,size(dt,1)],'Color','k'); ylabel(VarName{v})
        xlabel({['Time before ',DoEp{n},' start (s)'],'Ordered by epoch duration'})
        caxis([1 2]);%Cl(v,2*n-1:2*n)=caxis;
        %
        subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*(n-1)+2*v),
        imagesc(tps,1:size(dt,1),dt(ind2,:));caxis([0.5 3]);
        idLine=find(diff(NatR(ind2))~=0);line([0,0],[0,size(dt,1)],'Color','k');
        for i=1:length(idLine),line(xlim,idLine(i)+[0 0],'Color','w','Linewidth',2);end
        xlabel(NamesStages(unique(NatR(NatR<6))))
        end
    end
    test=colormap('gray');colormap(test(end:-1:1,:));
    try
    % mtspectrum
    subplot(length(DoEp),2*length(VarName)+1,(2*length(VarName)+1)*n),
    imagesc(t/1E3,fL,MATsp{n}), axis xy
    line([0,0],[min(fL),max(fL)],'Color','k','Linewidth',2)
    ylabel('Spectrum PFCx')
    xlabel(['Time around ',DoEp{n},' start (s)'])
    end
end

%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<other<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< Display mean for ALL <<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
iW=find(strcmp(NamesStages,'WAKE'));
iR=find(strcmp(NamesStages,'REM'));

%v1=find(strcmp(VarName,'tsdEMG')); % EMG;
v1=find(strcmp(VarName,'tsdGhi')); % gamma;
figure('Color',[1 1 1]), numF=gcf;
iv=[v1,1:length(VarName)];
for v=1:length(iv)
    subplot(2,length(iv),v),hold on,
    
    dt=MAT{strcmp(DoEp,'N1'),iv(v)};% N1
    info=MATind{strcmp(DoEp,'N1'),iv(v)};
    dt2=MAT{strcmp(DoEp,'WAKE'),iv(v)};% Wake
    info2=MATind{strcmp(DoEp,'WAKE'),iv(v)};
    dt3=MAT{strcmp(DoEp,'REM'),iv(v)};% REM
    info3=MATind{strcmp(DoEp,'REM'),iv(v)};
    
    clear matbar matbar1 matbar2 matbar3
    for man=1:length(Dir.path)
        % minimum duration = 5s
        matbar(man,1:size(dt,2))=nanmean(dt(find(info(:,4)>5 & info(:,1)>5 & info(:,3)==man & info(:,2)==iW),:),1); % N1 after wake
        matbar1(man,1:size(dt,2))=nanmean(dt(find(info(:,4)>5 & info(:,1)>5 & info(:,3)==man & info(:,2)~=iW & info(:,2)<6),:),1); % N1 after other
        matbar2(man,1:size(dt2,2))=nanmean(dt2(find(info2(:,4)>5 & info2(:,1)>5 & info2(:,3)==man & info2(:,2)<6),:),1); % WAKE after other
        matbar3(man,1:size(dt3,2))=nanmean(dt3(find(info3(:,4)>5 & info3(:,1)>5 & info3(:,3)==man & info3(:,2)~=iW & info3(:,2)<6),:),1); % REM after other
if man==56 || man==32, matbar(man,1:size(dt,2))=nan;end
    if 0
        plot(tps,matbar(man,1:size(dt,2)),'Color','k')
    plot(tps,matbar1(man,1:size(dt,2)),'Color','b')
    plot(tps,matbar2(man,1:size(dt2,2)),'Color','r')
    plot(tps,matbar3(man,1:size(dt3,2)),'Color','g')
    end
        % no minimum duration
%         matbar(man,1:size(dt,2))=nanmean(dt(find(info(:,3)==man & info(:,2)==iW),:),1); % N1 after wake
%         matbar1(man,1:size(dt,2))=nanmean(dt(find(info(:,3)==man & info(:,2)~=iW & info(:,2)<6),:),1); % N1 after other
%         matbar2(man,1:size(dt2,2))=nanmean(dt2(find(info2(:,3)==man & info2(:,2)<6),:),1); % WAKE after other
%         matbar3(man,1:size(dt3,2))=nanmean(dt3(find(info3(:,3)==man & info3(:,2)~=iW & info3(:,2)<6),:),1); % REM after other
     end
    
    if 1 % select only EMG mice
        if v==1
            emgI=find(isnan(nanmean(matbar,2))==0);
            emgI1=find(isnan(nanmean(matbar1,2))==0);
            emgI2=find(isnan(nanmean(matbar2,2))==0);
            emgI3=find(isnan(nanmean(matbar3,2))==0);
        end
        emgI(emgI==56)=[];
        matbar=matbar(emgI,:);
        matbar1=matbar1(emgI1,:);
        matbar2=matbar2(emgI2,:);
        matbar3=matbar3(emgI3,:);
    end
        
    subplot(2,length(iv),length(iv)+v),hold on,
    Nind=find(isnan(nanmean(matbar,2))==0);
    plot(tps,nanmean(matbar),'Linewidth',2,'Color','k')
    plot(tps,nanmean(matbar1),'Linewidth',2,'Color','b')
    plot(tps,nanmean(matbar2),'Linewidth',2,'Color','r')
    plot(tps,nanmean(matbar3),'Linewidth',2,'Color','g')
    
    plot(tps,nanmean(matbar)+stdError(matbar),'Color','k');
    plot(tps,nanmean(matbar)-stdError(matbar),'Color','k');
    plot(tps,nanmean(matbar1)+stdError(matbar1),'Color','b');
    plot(tps,nanmean(matbar1)-stdError(matbar1),'Color','b');
    plot(tps,nanmean(matbar2)+stdError(matbar2),'Color','r');
    plot(tps,nanmean(matbar2)-stdError(matbar2),'Color','r');
    plot(tps,nanmean(matbar3)+stdError(matbar3),'Color','g');
    plot(tps,nanmean(matbar3)-stdError(matbar3),'Color','g');
    
    ylabel([VarName{iv(v)},' zscore']); xlabel('Time (s)'); %xlim([-7 7])
    title(sprintf('n=%d expe, N=%d mice',length(Nind),length(unique(Dir.name(Nind)))))
    line([0 0],ylim,'Color',[0.5 0.5 0.5])
end
    legend('WAKE -> N1','other -> N1','other -> WAKE','other -> REM')

%saveFigure(numF.Number,'NREMStages_N1eval_EMGonly',FolderToSave)    

%% averaged EMG / mov per stage
figure('Color',[1 1 1]), numF=gcf;
iv=[v1,1:length(VarName)];
for v=1:length(iv)
    clear matbar
    for n=1:length(DoEp)
        dt=MAT{n,iv(v)};% N1
        info=MATind{n,iv(v)};
        for man=1:length(Dir.path)
            matbar(man,n)=nanmean(nanmean(dt(find(info(:,3)==man),:))); % N1 after wake
        end
    end
    if v==1
        emgI=find(isnan(nanmean(matbar,2))==0);
    end
    matbar=matbar(emgI,:);
    
    subplot(1,length(iv),v),hold on,
    Nind=find(isnan(nanmean(matbar,2))==0);
    PlotErrorBarN_KJ(matbar,'newfig',0);
    set(gca,'Xtick',1:length(DoEp)); set(gca,'XtickLabel',DoEp); 
    ylabel([VarName{iv(v)},' zscore']); 
    title(sprintf('n=%d expe, N=%d mice',length(Nind),length(unique(Dir.name(Nind)))))
end