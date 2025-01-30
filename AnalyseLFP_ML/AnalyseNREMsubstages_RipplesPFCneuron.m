%AnalyseNREMsubstages_RipplesPFCneuron
%
% list of related scripts in NREMstages_scripts.m 

% based on KB codes
if 0
    edit FigureRipplesPFcN1N2N3Marie.m
    edit SpindlesRipplesN1N2N3.m
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyseNREMsubstages_RipplesPFCneuron';
colori=[0.5 0.5 0.5;0 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0;0.5 0.5 0.8];
savFig=0;
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
nameAnaly='AnalyNREM_RipplesPFCneuron';
doNew=1;
if doNew, nameAnaly=[nameAnaly,'New'];end

% fac1=5;fac2=400; % crosscor
fac1=10;fac2=200;% crosscor
windRipDel=400;%ms
smo=3;
Stages={'WAKE','REM','N1','N2','N3','NREM'};

% directories
if doNew
    Dir=PathForExperimentsMLnew('Spikes');
else
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if exist([res,'/',nameAnaly,'.mat'],'file')
    load([res,'/',nameAnaly,'.mat']);
    MatNb;
    disp([nameAnaly,' has been loaded.'])
else
    Nametps={'Delta','SpindSupH','SpindSupL','SpindDepH','SpindDepL',...
        'Ripples','RipPreDelt','RipPostDelt','RipOutDelt','RipInSpin','RipOutSpin'};
    MatNb=nan(length(Dir.path),5,11);
    
    for n=1:length(Stages)
        for c=1:11, 
            Cspk{n,c}=nan(length(Dir.path),201); TCspk{n,c}=[]; TCspkET{n,c}=[];TCspkRip{n,c}=[];TCspkETz{n,c}=[];
        end
        for c=1:26, MatCros{n,c}=nan(length(Dir.path),201); end
    end
    
    for man=1:length(Dir.path)
        disp(' '); disp(Dir.path{man})
        cd(Dir.path{man})
        clear WAKE REM N1 N2 N3 tps
        try
            % get substages
            [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise]=RunSubstages;close
            NREM=or(N1,or(N2,N3));
            totalEpoch=or(or(WAKE,REM),NREM)-noise;
            %eval(['Epoch=',SleepPeriod,';'])
            
            % get delta
            tDelta=GetDeltaML;
            tDelta(tDelta<windRipDel*10)=[];
            dpfc=ts(tDelta);
            
            % get ripples
            dHPCrip=GetRipplesML;
            rip=ts(dHPCrip(:,2)*1E4);
            TotalRipEpoch=intervalSet(dHPCrip(1,2)*1E4,dHPCrip(end,2)*1E4);
            
            % separate ripples followed by delta or not
            clear PreDelt PostDel OutDelt RipPeD RipPoD RipOuD
            PreDelt=intervalSet(tDelta-windRipDel*10,tDelta-0.1*1E4);
            PreDelt=mergeCloseIntervals(PreDelt,1);% if delta closer than windRipDel
            PostDelt=intervalSet(tDelta+0.1*1E4,tDelta+windRipDel*10);
            PostDelt=mergeCloseIntervals(PostDelt,1);% if delta closer than windRipDel
            
            OutDelt=TotalRipEpoch-intervalSet(tDelta-windRipDel*10,tDelta+windRipDel*10);
            OutDelt=mergeCloseIntervals(OutDelt,1);
            
            RipPeD=Restrict(rip,PreDelt);% ripples before delta
            RipPoD=Restrict(rip,PostDelt);% ripples after delta
            RipOuD=Restrict(rip,OutDelt);% ripples without delta
            
            % get spindles
            Spi1=intervalSet([],[]); Spi2=Spi1; Spi3=Spi1; Spi4=Spi1;
            tps{2}=ts([]); tps{3}=ts([]); tps{4}=ts([]); tps{5}=ts([]);
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup');
            if ~isempty(SpiHigh), Spi1=intervalSet(SpiHigh(:,1)*1E4,SpiHigh(:,3)*1E4); tps{2}=ts(SpiHigh(:,2)*1E4); end
            if ~isempty(SpiLow), Spi2=intervalSet(SpiLow(:,1)*1E4,SpiLow(:,3)*1E4); tps{3}=ts(SpiLow(:,2)*1E4);  end
            
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep');
            if ~isempty(SpiHigh),Spi3=intervalSet(SpiHigh(:,1)*1E4,SpiHigh(:,3)*1E4); tps{4}=ts(SpiHigh(:,2)*1E4); end
            if ~isempty(SpiLow),Spi4=intervalSet(SpiLow(:,1)*1E4,SpiLow(:,3)*1E4); tps{5}=ts(SpiLow(:,2)*1E4); end
            
            SpiEpoch=or(or(Spi1,Spi2),or(Spi3,Spi4));
            stSp=Start(SpiEpoch);enSp=End(SpiEpoch);
            %SpfcT=ts(SpfcT(:,2)*1E4);
            
            % separate ripples inside spindles or not
            SpiEpoch=intervalSet(stSp-0.5*1E4,enSp+0.5*1E4);
            SpiEpoch=mergeCloseIntervals(SpiEpoch,1);% if delta closer than windRipDel
            ripSpi=Restrict(rip,SpiEpoch);
            ripNoSpi=Restrict(rip,TotalRipEpoch-SpiEpoch);
            
            %Nametps={'Delta','SpindSupH','SpindSupL','SpindDepH','SpindDepL','Ripples','RipPreDelt','RipPostDelt','RipOutDelt','RipInSpin','RipOutSpin'};
            tps{1}=dpfc;
            tps{6}=rip;
            tps{7}=RipPeD;
            tps{8}=RipPoD;
            tps{9}=RipOuD;
            tps{10}=ripSpi;
            tps{11}=ripNoSpi;
            
            % Count and cross corr for each rythm
            indCros=[[ones(1,10);2:11]';[mod(0:15,4)+2';reshape(ones(4,1)*[6:9],1,16)]'];
            for n=1:length(Stages)
                eval(['epoch=',Stages{n},';']);
                for ind=1:length(tps)
                    MatNb(man,n,ind)=length(Range(Restrict(tps{ind},epoch)));
                end
                
                for d=1:length(indCros)
                    tpsA=Restrict(tps{indCros(d,1)},epoch);tpsB=Restrict(tps{indCros(d,2)},epoch);
                    try 
                        [tempCros,B]=CrossCorrKB(Range(tpsA),Range(tpsB),fac1,fac2); 
                        temp=MatCros{n,d}; temp(man,:)=tempCros'; MatCros{n,d}=temp;
                    end
                end
            end
            
            % get spikes
            load SpikeData S
            [S,numNeurons]=GetSpikesFromStructure('PFCx',S,pwd,1);
            Q=MakeQfromS(S,400);
            QS=full(Data(Q));
            
            % cross corr neurons and rythms
            t_step=0:0.05:max(Range(SleepStages,'s'));
            for n=1:length(Stages)
                eval(['epoch=',Stages{n},';']);
                
                % ripples, on each epoch get the same number of ripples
                nk=[6,10,11];
                for k=1:3, ne(k)=length(Range(Restrict(tps{nk(k)},epoch)));end
                for k=1:3
                    temp=TCspkRip{n,nk(k)};
                    for ss=1:length(numNeurons)
                        rg=Range(Restrict(tps{nk(k)},epoch));
                        rand_ind=ceil(rand(min(ne),1)*length(rg));
                        [tempp,B]=CrossCorrKB(rg(rand_ind),Range(Restrict(S{numNeurons(ss)},epoch)),fac1,fac2);
                        temp=[temp;tempp'];
                    end
                    TCspkRip{n,nk(k)}=temp;
                end
                
                for ind=1:length(tps)
                    %fprintf(['\n',Stages{n},'-',Nametps{ind},': neuron '])
                    temp=TCspk{n,ind};
                    %temp2=TCspkET{n,ind};
                    for ss=1:length(numNeurons)
                        try, [tempp,B]=CrossCorrKB(Range(Restrict(tps{ind},epoch)),Range(Restrict(S{numNeurons(ss)},epoch)),fac1,fac2);
                            temp=[temp;tempp'];end %fprintf('#%d',ss);
                        %tsdtps=hist(Range(S{numNeurons(ss)},'s'),t_step);
                        %tempp2=mETAverage(Range(Restrict(tps{ind},epoch)),t_step*1E4,zscore(tsdtps),fac1,fac2);
                        %temp2=[temp2;tempp2'];
                    end
                    try
                        [CS,bS,B2]=mETAverage(Range(Restrict(tps{ind},epoch)),Range(Q),mean(QS(:,numNeurons),2),10,500);
                        TCspkET{n,ind}=CS;
                    end
                    
                    TCspk{n,ind}=temp;
                    %TCspkET{n,ind}=temp2;
                    
                    %MUA
                    try 
                        [C,B]=CrossCorrKB(Range(Restrict(tps{ind},epoch)),Range(Restrict(PoolNeurons(S,numNeurons),epoch)),fac1,fac2);
                        temp=Cspk{n,ind}; temp(man,:)=C; Cspk{n,ind}=temp;
                    end
                end
            end
            %  check
            if 0
                ind=11; colo={'r','k','b'};
                figure('Color',[1 1 1])
                for n=3:5
                    temp=TCspk{n,ind}; 
                    temp2=TCspkET{n,ind};
                    subplot(1,2,1), hold on, plot(B/1E3,nanmean(temp),'linewidth',2,'Color',colo{n-2})
                    subplot(1,2,2), hold on, plot(B/1E3,nanmean(temp2),'linewidth',2,'Color',colo{n-2})
                end
            end
        catch
            disp('Problem.... skip')
        end
    end
    % save
    save([res,'/',nameAnaly],'Dir','MatNb','MatCros','TCspkRip','TCspk','TCspkET','TCspkETz','Cspk','windRipDel','fac1','fac2','Stages','Nametps','indCros','B');
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< DISPLAY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% to get order of analysis in MatCros
for d=1:length(indCros), NameAnaly{d}=[Nametps{indCros(d,2)},' by ',Nametps{indCros(d,1)}];end
for d=1:length(indCros), disp(sprintf(['%d- ',Nametps{indCros(d,2)},' by ',Nametps{indCros(d,1)}],d));end 

%% Ripples types by spindles types
xl=[-0.4 0.4];
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.1 0.8 0.7]), numF=gcf;
for n=3:5    
    for ind=11:26
        subplot(3,4,4*(n-3)+indCros(ind,1)-1), hold on
        plot(B/1E3,smooth(nanmean(MatCros{n,ind}),smo),'linewidth',2)
        title(['... by ',Nametps{indCros(ind,1)},' - ',Stages{n}]);
    end
    xlim(xl)
    if n==3, legend(Nametps(indCros([11 15 19 23],2)));end
end
if savFig, saveFigure(numF.Number,'RipplesBySpindlesTypes',FolderToSave);end
 
%% all Ripples by spindles low deep
xl=[-0.4 0.4];
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.1 0.6 0.4]), numF=gcf;
ind=14;
for n=3:5
    subplot(1,3,n-2), hold on
    plot(B/1E3,smooth(nanmean(MatCros{n,ind}),smo),'linewidth',2)
    title({[NameAnaly{ind},' - ',Stages{n}],sprintf('(n=%d)',sum(~isnan(nanmean(MatCros{n,ind},2))))});
    
    xlim(xl)
end
if savFig, saveFigure(numF.Number,'RipplesBySpindlesLD',FolderToSave);end
    


%% Ripples by Delta, pre or post delta period

figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.1 0.6 0.7]), numF=gcf;
for n=3:5
    fil1=tsd((B-B(1))/1E3*1E4,nanmean(MatCros{n,6})'-nanmean(nanmean(MatCros{n,6}))); % RipPreDelt by Delta
    Fil1=FilterLFP(fil1,[10 15],256);
    fil2=tsd((B-B(1))/1E3*1E4,nanmean(MatCros{n,7})'-nanmean(nanmean(MatCros{n,7}))); %RipPostDelt by Delta
    Fil2=FilterLFP(fil2,[10 15],256);
    
    subplot(3,4,4*(n-3)+1), hold on
    plot(B/1E3,smooth(nanmean(MatCros{n,6}),smo),'k','linewidth',1)
    plot(B/1E3,smooth(nanmean(MatCros{n,7}),smo),'r','linewidth',1)
    line([0 0],ylim,'color',[0.8 0.8 0.8]); ylim([-0.1 0.5])
    title(['CrossCorr ',Stages{n}])
    
    subplot(3,4,4*(n-3)+2), hold on
    plot(B/1E3,smooth(nanmean(MatCros{n,6}),smo),'k','linewidth',1)
    plot(B/1E3,Data(Fil1),'k','linewidth',2)
    line([0 0],ylim,'color',[0.8 0.8 0.8]); ylim([-0.1 0.5])
    
    subplot(3,4,4*(n-3)+3), hold on
    plot(B/1E3,smooth(nanmean(MatCros{n,7}),smo),'r','linewidth',1)
    plot(B/1E3,Data(Fil2),'r','linewidth',2)
    line([0 0],ylim,'color',[0.8 0.8 0.8]); ylim([-0.1 0.5])
    
    subplot(3,4,4*(n-3)+4), hold on
    plot(B/1E3,Data(Fil2),'r','linewidth',1)
    plot(B/1E3,Data(Fil1),'k','linewidth',1)
    line([0 0],ylim,'color',[0.8 0.8 0.8])
end
legend(NameAnaly(6:7)); xlabel('Time (s)')
if savFig, saveFigure(numF.Number,'RipplesByDelta-PreAndPostDelta',FolderToSave);end

%% Ripples by spindles types

figure('color',[1 1 1]),numF=gcf;
for n=3:5
    subplot(3,2,2*(n-3)+1), hold on
    plot(B/1E3,smooth(nanmean(MatCros{n,11}),smo),'k')
    plot(B/1E3,smooth(nanmean(MatCros{n,12}),smo),'r')
    title(sprintf(['CrossCorr ',Stages{n},', n=%d'],sum(~isnan(nanmean(MatCros{n,11},2)))))
    if n==3, legend(NameAnaly(11:12));end
    
    subplot(3,2,2*(n-3)+2), hold on
    plot(B/1E3,smooth(nanmean(MatCros{n,13}),smo),'b')
    plot(B/1E3,smooth(nanmean(MatCros{n,14}),smo),'m')
    title(sprintf(['CrossCorr ',Stages{n},', n=%d'],sum(~isnan(nanmean(MatCros{n,13},2)))))
    if n==3, legend(NameAnaly(13:14));end
end
if savFig, saveFigure(numF.Number,'RipplesBySpindles-SupAndDeep',FolderToSave);end


%% Rippes and Spindles by delta
colo={'r','r','b','b','k'};
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.5 0.5 0.3]), numF=gcf;
for n=3:5
    subplot(1,3,n-2),hold on
    for i=1:5
        plot(B/1E3,smooth(nanmean(MatCros{n,i}),smo),'Linewidth',mod(i,2)+1,'Color',colo{i})
    end
    ylim([0 0.25]);
    line([0 0],[0 0.25],'color',[0.7 0.7 0.7])
    title(['cross corr ',Stages{n}]); xlabel('Delta')
end
legend(Nametps{indCros(1:5,2)});
if savFig, saveFigure(numF.Number,'CrossCorrRipAndSpinByDelta',FolderToSave);end

%% spikes at rythms indiv
le=size(TCspkET{3,5},1);
for n=3:5;
    figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.5 0.6]), numF(n)=gcf;
    for i=1:11
        try
            subplot(3,4,i), imagesc(B/1E3,1:length(TCspkET{n,i}),TCspkET{n,i}),
            title([Nametps{i},' ',Stages{n}])
        end
        if i==1, ylabel('#neuron');end
    end
    % average
    figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.6]), numG(n)=gcf;
    for i=1:11
        try
            subplot(3,4,i), plot(B/1E3,nanmean(TCspkET{n,i}),'k'),
            title([Nametps{i},' ',Stages{n}])
            line([0 0],ylim,'color',[0.8 0.8 0.8]);
            xlabel({sprintf(['n=%1.0f ',Nametps{i}(1:3)],nanmean(squeeze(MatNb(:,n,i)))),' '})
        end
        if i==1, ylabel('#neuron');end
    end
    
    if savFig,
        saveFigure(numF(n).Number,['PFCNeuron_PETHResponseToAllRythm',Stages{n}],FolderToSave);
        saveFigure(numG(n).Number,['PFCNeuron_AverageResponseToAllRythm',Stages{n}],FolderToSave);
    end
end
%% Spikes at Rythm indiv
for n=3:6
    figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.5 0.6]), numF(n)=gcf; 
    for i=1:11
        if 0%ismember(i,[6,10,11])
            testi=TCspkRip{n,i};%TCspkET{n,i}(1:le,:);
            testO=nanzscore(TCspkRip{n,i}')';
        else
            try
            testi=TCspkET{n,i};%TCspkET{n,i}(1:le,:);
            testO=zscore(TCspkET{n,i}')';%nanzscore(TCspkET{n,i}(1:le,:)')';
%             catch
%             testi=TCspk{n,i};%TCspkET{n,i}(1:le,:);
%             testO=zscore(TCspk{n,i}')';%nanzscore(TCspkET{n,i}(1:le,:)')';
            end
        end
        if ismember(i,[2:5])
            val=testO(:,100)-testO(:,105);
            r=corrcoef(nanmean(testO),nanmean((sign(val)*ones(1,size(testO,2))).*testO));
            if r(2,1)<0
                testf=-(sign(val)*ones(1,size(testO,2))).*testO;
                testfi=-(sign(val)*ones(1,size(testi,2))).*testi;
            else
                testf=(sign(val)*ones(1,size(testO,2))).*testO;
                testfi=(sign(val)*ones(1,size(testi,2))).*testi;
            end
        else
            %         testf=zscore(CspkT{i}(1:le,:)')';
            testf=testO;
            testfi=testi;
        end
        CspkTc{n,i}=testf;
        CspkTcb{n,i}=testfi;
        
        subplot(3,4,i), hold on,
        plot(B/1E3,nanmean(testf),'k'),
        plot(B/1E3,nanmean(testfi),'r'), title([Nametps{i},' ',Stages{n}])
        line([0 0],ylim,'color',[0.8 0.8 0.8])
        if i==1, ylabel('Total Spikes');end
    end
    legend({'Zscore','raw'})
        if savFig, saveFigure(numF(n).Number,['PFCNeuron_ZscoreAverageResponseToAllRythm',Stages{n}],FolderToSave);end
end
%% spikes at Ripples, NREM - in/out spindles
xl2=[-1 1];
smo2=2;
ca=[-4 4];
limsort=[80 120];
nk=[6,10,11];
colo={'b','k','r'};
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.5 0.6]), numF=gcf;
n=6;
yl=[-0.5 1];
%yl=[0.14 0.21];
for i=1:length(nk)
    %temp=CspkTcb{n,nk(i)};
    %temp=zscore(CspkTcb{n,nk(i)}')';
    temp=zscore(CspkTc{n,nk(i)}')';
    [BE,id]=sort(nanmean(temp(:,limsort(1):limsort(2)),2));
    subplot(2,4,i), imagesc(B/1E3,1:length(id),temp(id,:)), title([Nametps{nk(i)},' ',Stages{n}])
    caxis(ca); xlim([xl2]);
    subplot(2,4,4+i),hold on,
    plot(B/1E3,SmoothDec(nanmean(temp),smo2),'Color',colo{i},'Linewidth',2),
    title(Nametps{nk(i)});
    xlim([xl2]); ylim(yl)
    subplot(2,4,4),hold on,
    plot(B/1E3,SmoothDec(nanmean(temp),smo2),'Color',colo{i},'Linewidth',2),
    xlim([xl2]); ylim(yl)
end
xlabel('Time (s)')
subplot(2,4,4), 
title(Stages(n)); legend(Nametps(nk))
%colormap('gray')
%if savFig, saveFigure(numF.Number,'PFCNeuron_ResponseToRipples_InAndOutSpindles',FolderToSave);end

%% spikes at Ripples, N1-N2-N3
xl2=[-1 1];
smo2=3;
ca=[-4 4];
limsort=[90 110];
nk=[6,10,11];
colo={'b','k','r'};
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.5 0.6]), numF=gcf; 
for n=3:5
    for i=1:length(nk)
        try
        %temp=CspkTc{n,nk(i)};
        temp=zscore(CspkTc{n,nk(i)}')';
        [BE,id]=sort(nanmean(temp(:,limsort(1):limsort(2)),2));
        subplot(4,4,(i-1)*4+n-2), imagesc(B/1E3,1:length(id),temp(id,:)), title([Nametps{nk(i)},' ',Stages{n}])
        caxis(ca); ylim([0.5 502.5]);
        subplot(4,4,4*i),hold on,
        plot(B/1E3,SmoothDec(nanmean(temp),smo2),'Color',colori(n,:),'Linewidth',2), 
        if n==3, title(Nametps{nk(i)});end
        xlim([xl2])
        end
    end
    xlabel('Time (s)')
end
legend(Stages(3:5)); 
%%
for n=3:5
    subplot(4,4,10+n), hold on
    temp1=zscore(CspkTc{n,10}')';
    temp2=zscore(CspkTc{n,11}')';
    plot(B/1E3,SmoothDec(nanmean(temp1),smo2),'Color',colori(n,:),'linestyle',':','Linewidth',2)
    plot(B/1E3,SmoothDec(nanmean(temp2),smo2),'Color',colori(n,:),'Linewidth',2)
    xlim([xl2]); ylim([-0.5 1])
    title(Stages(n)); legend(Nametps(10:11))
end
colormap('gray')
if savFig, saveFigure(numF.Number,'PFCNeuron_ResponseToRipples_InAndOutSpindles',FolderToSave);end

%% quantif zscore Spks during Ripples, in and out of spindles
%li1=95;li2=110;
%li1=80;li2=90;
li1=85;li2=105;
nk=[6,11,10];
figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.6]), numF=gcf;
for i=1:length(nk)
    MatBar=[];
    for n=3:6
        temp=zscore(CspkTc{n,nk(i)}')';
        M=mean(temp(:,li1:li2),2);
        MatBar(1:length(M),n-2)=M;
    end
    subplot(2,7,i), PlotErrorBar3(MatBar(:,1),MatBar(:,2),MatBar(:,3),0,0);
    set(gca,'xtick',[1:3]); set(gca,'xticklabel',Stages(3:5))
    title(Nametps{nk(i)}); ylim([0 0.9])
end
for n=3:6
    MatBar=[];
    for i=1:length(nk)
        temp=zscore(CspkTc{n,nk(i)}')';
        M=mean(temp(:,li1:li2),2);
        MatBar(1:length(M),i)=M;
    end
    subplot(2,7,n+5), PlotErrorBar3(MatBar(:,1),MatBar(:,2),MatBar(:,3),0,0);
    set(gca,'xtick',[1:3]); set(gca,'xticklabel',{'all','in','out'})
    title(Stages(n));ylim([0 0.9])
end

Mbar=[];Sbar=[];Pbar=[];
xl=ones(3,1)*[1:3]+[-0.23 0 0.23]'*ones(1,3);
xl2=ones(4,1)*[1:3]+[-0.28 -0.09 0.09 0.28]'*ones(1,3);
xl3=ones(3,1)*[1:4]+[-0.23 0 0.23]'*ones(1,4);

for i=1:length(nk)
    pval=nan(200,3);
    for n=3:6
        temp=zscore(CspkTc{n,nk(i)}')';
        M=mean(temp(:,li1:li2),2);
        Mbar(i,n-2)=nanmean(M);
        Sbar(i,n-2)=stdError(M);
        pval(1:length(M),n-2)=M;
        for n2=3:n-1
            [~,Pbar(i,n+n2-6)]=ttest2(pval(:,n-2),pval(:,n2-2));
        end
    end
end

subplot(2,7,4:7), bar(Mbar); colormap('gray')
hold on, errorbar(xl2',Mbar,Sbar,'+k')
legend(Stages(3:6));ylim([0 0.9])
set(gca,'xtick',[1:3]); set(gca,'xticklabel',Nametps(nk))
for i=1:length(nk)
    for n=3:6
        for n2=3:n-1
            m=(0.9+0.1*(n+n2-6))*max(max(Mbar));
            hold on, line(i-0.46+0.23*[n-2,n2-2],[m m],'linewidth',2,'Color','k')
            if Pbar(i,n+n2-6)<0.05
                text(i+0.23*(n-5),m*1.05,sprintf('p=%1.3f',Pbar(i,n+n2-6)),'color','r')
            else
                text(i+0.23*(n-5),m*1.05,sprintf('p=%1.3f',Pbar(i,n+n2-6)),'color','k')
            end
        end
    end
end

subplot(2,7,12:14), bar(Mbar'); colormap('gray')
hold on, errorbar(xl3',Mbar',Sbar','+k')
legend(Nametps(nk));ylim([0 0.9])
set(gca,'xtick',[1:4]); set(gca,'xticklabel',Stages(3:6))
Pbar=[];
for n=3:6
    pval=nan(200,3);
    for i=1:length(nk)
        temp=zscore(CspkTc{n,nk(i)}')';
        pval(1:length(mean(temp(:,li1:li2),2)),i)=mean(temp(:,li1:li2),2);
        for i2=1:i-1
            [~,Pbar(n,i+i2-2)]=ttest2(pval(:,i),pval(:,i2));
        end
    end
end
for n=3:6
    for i=1:length(nk)
        for i2=1:i-1
            m=(0.9+0.1*(i+i2-2))*max(max(Mbar));
            hold on, line(n-2.46+0.23*[i,i2],[m m],'linewidth',2,'Color','k')
            if Pbar(n,i+i2-2)<0.05
                text(n-2+0.23*(i-3),m*1.05,sprintf('p=%1.3f',Pbar(n,i+i2-2)),'color','r')
            else
                text(n-2+0.23*(i-3),m*1.05,sprintf('p=%1.3f',Pbar(n,i+i2-2)),'color','k')
            end
        end
    end
end
if savFig, saveFigure(numF.Number,'PFCNeuron_ResponseToRipples_InAndOutSpindlesBAR',FolderToSave);end

%% plot Number of rythms for substages

figure('color',[1 1 1]),
for n=3:5
    subplot(3,1,n-2),PlotErrorBar(squeeze(MatNb(:,n,:)),0)
    set(gca,'xtick',[1:11]); set(gca,'xticklabel',Nametps)
    set(gca,'yscale','log'), ylim([1 1E4])
    title(Stages(n));
end
