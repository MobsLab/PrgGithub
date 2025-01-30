%AnalyseNREMsubstages_RipplesPFCneuron_check

% see AnalyseNREMsubstages_RipplesPFCneuron.m


FolderToSave='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyseNREMsubstages_RipplesPFCneuron';
colori=[0.5 0.5 0.5;0 0 0; 0.7 0.2 0.8 ; 1 0.2 0.8 ;1 0 0;0.5 0.5 0.8];
res='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
nameAnaly='AnalyNREM_RipplesPFCneuron8NewCheck';
%nameAnaly='AnalyNREM_RipplesPFCneuron8NewCheck2';
savFig=0;

% fac1=5;fac2=400; % crosscor
fac1=10;fac2=200;% crosscor
windRipDel=400;%ms
smo=3;
Stages={'WAKE','REM','N1','N2','N3','NREM'};

% directories
Dir=PathForExperimentsMLnew('Spikes');


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if exist([res,'/',nameAnaly,'.mat'],'file')
    load([res,'/',nameAnaly,'.mat']);
    TCspkRip;
    disp([nameAnaly,' has been loaded.'])
else
    Nametps={'Ripples','RipInSpin','RipOutSpin', ...
        'Delta','RipPreDelt','RipPostDelt','RipOutDelt'...
        'SpindSupH','SpindSupL','SpindDepH','SpindDepL',};
    
    for n=1:length(Stages)
        for k=1:length(Nametps)
            TCspkRip{n,k}=[];TCspkRipNorm{n,k}=[];
        end
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
            
            % get ripples peak
            dHPCrip=GetRipplesML;
            rip=ts(dHPCrip(:,2)*1E4);
            TotalRipEpoch=intervalSet(dHPCrip(1,1)*1E4,dHPCrip(end,3)*1E4);
            
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
            tps{8}=ts([]); tps{9}=ts([]); tps{10}=ts([]); tps{11}=ts([]);
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_sup');
            if ~isempty(SpiHigh), Spi1=intervalSet(SpiHigh(:,1)*1E4,SpiHigh(:,3)*1E4); tps{8}=ts(SpiHigh(:,2)*1E4); end
            if ~isempty(SpiLow), Spi2=intervalSet(SpiLow(:,1)*1E4,SpiLow(:,3)*1E4); tps{9}=ts(SpiLow(:,2)*1E4);  end
            
            [SpiTot,SpiHigh,SpiLow,SpiULow]=GetSpindlesML('PFCx_deep');
            if ~isempty(SpiHigh),Spi3=intervalSet(SpiHigh(:,1)*1E4,SpiHigh(:,3)*1E4); tps{10}=ts(SpiHigh(:,2)*1E4); end
            if ~isempty(SpiLow),Spi4=intervalSet(SpiLow(:,1)*1E4,SpiLow(:,3)*1E4); tps{11}=ts(SpiLow(:,2)*1E4); end
            
            SpiEpoch=or(or(Spi1,Spi2),or(Spi3,Spi4));
            stSp=Start(SpiEpoch);enSp=End(SpiEpoch);
            %SpfcT=ts(SpfcT(:,2)*1E4);
            
            % separate ripples inside spindles or not
            SpiEpoch=intervalSet(stSp-0.5*1E4,enSp+0.5*1E4);
            SpiEpoch=mergeCloseIntervals(SpiEpoch,1);% if delta closer than windRipDel
            SpiEpoch=CleanUpEpoch(SpiEpoch);
            ripSpi=Restrict(rip,SpiEpoch);
            ripNoSpi=Restrict(rip,TotalRipEpoch-SpiEpoch);
            
         %    Nametps={'Ripples','RipInSpin','RipOutSpin', ...
        %'Delta','RipPreDelt','RipPostDelt','RipOutDelt'...
        %'SpindSupH','SpindSupL','SpindDepH','SpindDepL',};
            tps{1}=rip;
            tps{2}=ripSpi;
            tps{3}=ripNoSpi;
            tps{4}=dpfc;
            tps{5}=RipPeD;
            tps{6}=RipPoD;
            tps{7}=RipOuD;
            
         
            % get spikes
            load SpikeData S
            numNeurons=GetSpikesFromStructure('PFCx','res',pwd,'remove_MUA',1);
            
            
            % jiter ripples time for normalization %removed in AnalyNREM_RipplesPFCneuron8NewCheck2
%             jitrg={};
%             for k=1:3
%                 rk=Range(tps{k});
%                 for a=1:500, jitrg{k,a}=sort(rk+rand(length(rk),1)*4000-2000);end % +/- 200 ms autour de la ripples  
%             end
            % cross corr neurons and rythms
            for n=1:length(Stages)
                eval(['epoch=',Stages{n},';']);
                disp(Stages{n})
                for k=1:3
                    disp(['    -',Nametps{k}]);
                    temp=TCspkRip{n,k};
                    tempN=TCspkRipNorm{n,k};
                    for ss=1:length(numNeurons)
                        rg=Range(Restrict(tps{k},epoch));
                        [tempp,B]= CrossCorrKB(rg, Range(S{ss}), fac1, fac2);
                        temp=[temp;tempp'];
                        temppNorm=[];
                        % jitter
                        for a=1:500
                            %rk=Range(Restrict(ts(jitrg{k,a}),epoch));
                            rk=rg+rand(length(rg),1)*4000-2000;
                            temppN= CrossCorrKB(rk, Range(S{ss}), fac1, fac2);
                            temppNorm=[temppNorm,temppN];
                        end
                        tempN=[tempN;mean(temppNorm,2)'];
                    end
                    TCspkRip{n,k}=temp;
                    TCspkRipNorm{n,k}=tempN;
                end
            end
            %  check with figure
            if 1
                colo={'k','g','r','m','b'};
                numF=figure('Color',[1 1 1]);
                for k=1:3
                    for n=1:3
                        temp=TCspkRip{n,k};tempN= TCspkRipNorm{n,k};
                        subplot(3,3,k), hold on, plot(B/1E3,nanmean(temp),'Color',colo{n})
                        subplot(3,3,3+k), hold on, plot(B/1E3,nanmean(tempN),'Color',colo{n})
                        subplot(3,3,6+k), hold on, plot(B/1E3,nanmean(temp./tempN),'Color',colo{n})
                    end
                    title(Nametps{k}); legend(Stages(3:5))
                end
                try close(NumF.Number-1);end
            end
        catch
            disp('Problem.... skip')
        end
        % save every session
        save([res,'/',nameAnaly],'Dir','TCspkRip','TCspkRipNorm','windRipDel','fac1','fac2','Stages','Nametps','B','man');
    end
end
    

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< Display <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% option for display
%Do=1; %crosscorr./jitter_crosscorr;
%Do=2; % zscore(crosscorr)
Do=3; % zscore(jitter_crosscorr)

smo2=1;
xl2=[-1 1];

%% spikes at Ripples, NREM - in/out spindles
ca=[-4 4];
limsort=[80 120];
colo={'b','k','r'};
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.5 0.6]), numF=gcf;
n=6;
if Do==1, yl=[0.75 1.5];
else yl=[-0.5 2];end
%yl=[0.14 0.21];
for k=1:3
    if Do==1, temp=TCspkRip{n,k}./TCspkRipNorm{n,k};
    elseif Do==2, temp=zscore(TCspkRip{n,k}')';
    elseif Do==3, temp=zscore(TCspkRipNorm{n,k}')';end
    [BE,id]=sort(nanmean(temp(:,limsort(1):limsort(2)),2));
    subplot(2,4,k), imagesc(B/1E3,1:length(id),temp(id,:)), title([Nametps{k},' ',Stages{n}])
    caxis(ca); xlim([xl2]);
    subplot(2,4,4+k),hold on,
    plot(B/1E3,SmoothDec(nanmean(temp),smo2),'Color',colo{k},'Linewidth',2),
    title(Nametps{k});
    xlim([xl2]); ylim(yl)
    subplot(2,4,4),hold on,
    plot(B/1E3,SmoothDec(nanmean(temp),smo2),'Color',colo{k},'Linewidth',2),
    xlim([xl2]); ylim(yl)
end
xlabel('Time (s)')
subplot(2,4,4), 
title(Stages(n)); legend(Nametps)
%colormap('gray')
%if savFig, saveFigure(numF.Number,'PFCNeuron_ResponseToRipples_InAndOutSpindles',FolderToSave);end

%% spikes at Ripples, N1-N2-N3
xl2=[-1 1];
ca=[-4 4];
limsort=[90 110];
nk=[6,10,11];
colo={'b','k','r'};
figure('color',[1 1 1],'Unit','Normalized','Position',[0.2 0.2 0.5 0.6]), numF=gcf; 
for n=3:5
    for k=1:3
        try
        if Do==1, temp=TCspkRip{n,k}./TCspkRipNorm{n,k};
    elseif Do==2, temp=zscore(TCspkRip{n,k}')';
    elseif Do==3, temp=zscore(TCspkRipNorm{n,k}')';end
        [BE,id]=sort(nanmean(temp(:,limsort(1):limsort(2)),2));
        subplot(4,4,(k-1)*4+n-2), imagesc(B/1E3,1:length(id),temp(id,:)), title([Nametps{k},' ',Stages{n}])
        caxis(ca); ylim([0.5 502.5]);
        subplot(4,4,4*k),hold on,
        plot(B/1E3,SmoothDec(nanmean(temp),smo2),'Color',colori(n,:),'Linewidth',2), 
        if n==3, title(Nametps{k});end
        xlim([xl2])
        end
    end
    xlabel('Time (s)')
end
legend(Stages(3:5)); 
%%
for n=3:5
    subplot(4,4,10+n), hold on
    if Do==1, temp1=TCspkRip{n,2}./TCspkRipNorm{n,2}; temp2=TCspkRip{n,3}./TCspkRipNorm{n,3};
    elseif Do==2, temp1=zscore(TCspkRip{n,2}')'; temp2=zscore(TCspkRip{n,3}')';
    elseif Do==3, temp1=zscore(TCspkRipNorm{n,2}')'; temp2=zscore(TCspkRipNorm{n,3}')';end
    
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
if Do==1, ylb=[0 2]; else, ylb=[0 1]; end
figure('color',[1 1 1],'Unit','Normalized','Position',[0.1 0.1 0.5 0.6]), numF=gcf;
for k=1:3
    MatBar=[];
    for n=3:6
        if Do==1, temp=TCspkRip{n,k}./TCspkRipNorm{n,k};
    elseif Do==2, temp=zscore(TCspkRip{n,k}')';
    elseif Do==3, temp=zscore(TCspkRipNorm{n,k}')';end
    
        M=mean(temp(:,li1:li2),2);
        MatBar(1:length(M),n-2)=M;
    end
    subplot(2,7,k), PlotErrorBar3(MatBar(:,1),MatBar(:,2),MatBar(:,3),0,0);
    set(gca,'xtick',[1:3]); set(gca,'xticklabel',Stages(3:5))
    title(Nametps{k}); ylim(ylb)
end
for n=3:6
    MatBar=[];
    for k=1:3
        if Do==1, temp=TCspkRip{n,k}./TCspkRipNorm{n,k};
    elseif Do==2, temp=zscore(TCspkRip{n,k}')';
    elseif Do==3, temp=zscore(TCspkRipNorm{n,k}')';end
    
        M=mean(temp(:,li1:li2),2);
        MatBar(1:length(M),k)=M;
    end
    subplot(2,7,n+5), PlotErrorBar3(MatBar(:,1),MatBar(:,2),MatBar(:,3),0,0);
    set(gca,'xtick',[1:3]); set(gca,'xticklabel',{'all','in','out'})
    title(Stages(n));ylim(ylb)
end

Mbar=[];Sbar=[];Pbar=[];
xl=ones(3,1)*[1:3]+[-0.23 0 0.23]'*ones(1,3);
xl2=ones(4,1)*[1:3]+[-0.28 -0.09 0.09 0.28]'*ones(1,3);
xl3=ones(3,1)*[1:4]+[-0.23 0 0.23]'*ones(1,4);

for k=1:3
    pval=nan(200,3);
    for n=3:6
        if Do==1, temp=TCspkRip{n,k}./TCspkRipNorm{n,k};
    elseif Do==2, temp=zscore(TCspkRip{n,k}')';
    elseif Do==3, temp=zscore(TCspkRipNorm{n,k}')';end
    
        M=mean(temp(:,li1:li2),2);
        Mbar(k,n-2)=nanmean(M);
        Sbar(k,n-2)=stdError(M);
        pval(1:length(M),n-2)=M;
        for n2=3:n-1
            [~,Pbar(k,n+n2-6)]=ttest2(pval(:,n-2),pval(:,n2-2));
        end
    end
end

subplot(2,7,4:7), bar(Mbar); colormap('gray')
hold on, errorbar(xl2',Mbar,Sbar,'+k')
ylim(ylb)
set(gca,'xtick',[1:3]); set(gca,'xticklabel',Nametps(1:3))
for k=1:3
    for n=3:6
        for n2=3:n-1
            m=(0.9+0.1*(n+n2-6))*max(max(Mbar));
            hold on, line(k-0.46+0.23*[n-2,n2-2],[m m],'linewidth',2,'Color','k')
            if Pbar(k,n+n2-6)<0.05
                text(k+0.23*(n-5),m*1.05,sprintf('p=%1.3f',Pbar(k,n+n2-6)),'color','r')
            else
                text(k+0.23*(n-5),m*1.05,sprintf('p=%1.3f',Pbar(k,n+n2-6)),'color','k')
            end
        end
    end
end
legend(Stages(3:6));

subplot(2,7,12:14), bar(Mbar'); colormap('gray')
hold on, errorbar(xl3',Mbar',Sbar','+k')
set(gca,'xtick',[1:4]); set(gca,'xticklabel',Stages(3:6))
Pbar=[];
for n=3:6
    pval=nan(200,3);
    for k=1:3
        if Do==1, temp=TCspkRip{n,k}./TCspkRipNorm{n,k};
    elseif Do==2, temp=zscore(TCspkRip{n,k}')';
    elseif Do==3, temp=zscore(TCspkRipNorm{n,k}')';end
    
        pval(1:length(mean(temp(:,li1:li2),2)),k)=mean(temp(:,li1:li2),2);
        for i2=1:k-1
            [~,Pbar(n,k+i2-2)]=ttest2(pval(:,k),pval(:,i2));
        end
    end
end
for n=3:6
    for k=1:3
        for i2=1:k-1
            m=(0.9+0.1*(k+i2-2))*max(max(Mbar));
            hold on, line(n-2.46+0.23*[k,i2],[m m],'linewidth',2,'Color','k')
            if Pbar(n,k+i2-2)<0.05
                text(n-2+0.23*(k-3),m*1.05,sprintf('p=%1.3f',Pbar(n,k+i2-2)),'color','r')
            else
                text(n-2+0.23*(k-3),m*1.05,sprintf('p=%1.3f',Pbar(n,k+i2-2)),'color','k')
            end
        end
    end
end
legend(Nametps(1:3));ylim(ylb)
if savFig, saveFigure(numF.Number,'PFCNeuron_ResponseToRipples_InAndOutSpindlesBAR',FolderToSave);end
