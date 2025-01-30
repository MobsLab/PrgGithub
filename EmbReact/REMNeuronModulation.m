clear all
Dir=PathForExperimentsDeltaSleep2016('Basal');
keepGoodLow=3;
keepNoLow=1;
SaveFigFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Figures/Nov2016/REMNeurons/';

for mm=1:length(Dir.path)
    mm
    try
        cd(Dir.path{mm})
        clear ph OB HPC Kappa mu pval freq Channel Sptsd REMEpoch
        
        disp('loading data')
        load('StateEpochSB.mat','REMEpoch')
        
        
        try
            load('ChannelsToAnalyse/dHPC_deep.mat')
            Channel.HPC=channel;
        catch
            
            load('ChannelsToAnalyse/dHPC_rip.mat')
            Channel.HPC=channel;
        end
        
        load('ChannelsToAnalyse/Bulb_deep.mat')
        Channel.OB=channel;
        
        load('ChannelsToAnalyse/PFCx_deep.mat')
        Channel.PFCx=channel;
        
        try, load(['SpectrumDataL/Spectrum',num2str(Channel.OB),'.mat'])
            Sptsd.OB=tsd(t*1e4,Sp);
            freq.OB=f;
        catch
            try
                load('B_Low_Spectrum.mat')
            catch
                disp('calculating OB spectrum')
                LowSpectrumSB([cd,filesep],Channel.OB,'B',0)
                load('B_Low_Spectrum.mat')
            end
            Sptsd.OB=tsd(Spectro{2}*1e4,Spectro{1});
            freq.OB=Spectro{3};
        end
        
        try,
            load(['SpectrumDataL/Spectrum',num2str(Channel.HPC),'.mat'])
            Sptsd.HPC=tsd(t*1e4,Sp);
            freq.HPC=f;
            
        catch
            try
                load('H_Low_Spectrum.mat')
            catch
                disp('calculating HPC spectrum')
                LowSpectrumSB([cd,filesep],Channel.HPC,'H',0)
                load('H_Low_Spectrum.mat')
            end
            Sptsd.HPC=tsd(Spectro{2}*1e4,Spectro{1});
            freq.HPC=Spectro{3};
        end
        
           try,
            load(['SpectrumDataL/Spectrum',num2str(Channel.PFCx),'.mat'])
            Sptsd.PFCx=tsd(t*1e4,Sp);
            freq.PFCx=f;
        catch
            try
                load('PFCx_Low_Spectrum.mat')
            catch
                disp('calculating PFCx spectrum')
                LowSpectrumSB([cd,filesep],Channel.PFCx,'PFCx',0)
                load('.mat')
            end
            Sptsd.PFCx=tsd(Spectro{2}*1e4,Spectro{1});
            freq.PFCx=Spectro{3};
         end
        
        
        [Epoch,val,val2]=FindSlowOscBulb(Data(Sptsd.OB),t,freq.OB,REMEpoch,1,[5 8]);
        
        load('SpikeData.mat')
        
        %% get the n° of the neurons of PFCx
        numtt=[]; % nb tetrodes ou montrodes du PFCx
        load LFPData/InfoLFP.mat
        chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
        
        for cc=1:length(chans)
            for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
                if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                    numtt=[numtt,tt];
                end
            end
        end
        
        numNeurons=[]; % neurones du PFCx
        for i=1:length(S);
            if ismember(TT{i}(1),numtt)
                numNeurons=[numNeurons,i];
            end
        end
        
        numMUA=[];
        for k=1:length(numNeurons)
            j=numNeurons(k);
            if TT{j}(2)==1
                numMUA=[numMUA, k];
            end
        end
        numNeurons(numMUA)=[];
        
        disp('phase coupling HPC')
        clear LFP
        load(['LFPData/LFP',num2str(Channel.HPC),'.mat'])
        FilLFP=FilterLFP(Restrict(LFP,REMEpoch),[6 9],1024);
        for i=1:length(numNeurons)
            [ph{i,1},mu{i,1}, Kappa{i,1}, pval{i,1},~,~]=ModulationTheta(S{numNeurons(i)},FilLFP,Epoch{keepGoodLow},30,0);
            [ph{i,2},mu{i,2}, Kappa{i,2}, pval{i,2},~,~]=ModulationTheta(S{numNeurons(i)},FilLFP,REMEpoch-Epoch{keepNoLow},30,0);
        end
        
        disp('phase coupling OB')
        clear LFP
        load(['LFPData/LFP',num2str(Channel.OB),'.mat'])
        FilLFP=FilterLFP(Restrict(LFP,REMEpoch),[2 4],1024);
        for i=1:length(numNeurons)
            [ph{i,3},mu{i,3}, Kappa{i,3}, pval{i,3},~,~]=ModulationTheta(S{numNeurons(i)},FilLFP,Epoch{keepGoodLow},30,0);
            [ph{i,4},mu{i,4}, Kappa{i,4}, pval{i,4},~,~]=ModulationTheta(S{numNeurons(i)},FilLFP,REMEpoch-Epoch{keepNoLow},30,0);
        end
        
        HPC.Low.Kappa=[Kappa{:,1}];
        HPC.NoLow.Kappa=[Kappa{:,2}];
        HPC.Low.pval=[pval{:,1}];
        HPC.NoLow.pval=[pval{:,2}];
        HPC.Low.phase=[mu{:,1}];
        HPC.NoLow.phase=[mu{:,2}];
        
        OB.Low.Kappa=[Kappa{:,3}];
        OB.NoLow.Kappa=[Kappa{:,4}];
        OB.Low.pval=[pval{:,3}];
        OB.NoLow.pval=[pval{:,4}];
        OB.Low.phase=[mu{:,3}];
        OB.NoLow.phase=[mu{:,4}];
        
        for i=1:length(numNeurons)
            Fr(i,1)=length(Data(Restrict(S{numNeurons(i)},Epoch{keepGoodLow})))./length(Range(Restrict(Sptsd.OB,Epoch{keepGoodLow})));
            Fr(i,2)=length(Data(Restrict(S{numNeurons(i)},REMEpoch-Epoch{keepNoLow})))./length(Range(Restrict(Sptsd.OB,REMEpoch-Epoch{keepNoLow})));
        end
        SpecMoy{1,1}=mean(Data(Restrict(Sptsd.OB,Epoch{keepGoodLow})));
        SpecMoy{2,1}=mean(Data(Restrict(Sptsd.OB,REMEpoch-Epoch{keepNoLow})));
        SpecMoy{1,2}=mean(Data(Restrict(Sptsd.HPC,Epoch{keepGoodLow})));
        SpecMoy{2,2}=mean(Data(Restrict(Sptsd.HPC,REMEpoch-Epoch{keepNoLow})));
        SpecMoy{1,3}=mean(Data(Restrict(Sptsd.PFCx,Epoch{keepGoodLow})));
        SpecMoy{2,3}=mean(Data(Restrict(Sptsd.PFCx,REMEpoch-Epoch{keepNoLow})));

        close all
        disp('making figure')
        fig=figure;
        subplot(3,3,1)
        plot(freq.OB,mean(Data(Restrict(Sptsd.OB,Epoch{keepGoodLow}))),'r')
        hold on
        plot(freq.OB,mean(Data(Restrict(Sptsd.OB,REMEpoch-Epoch{keepNoLow}))),'b')
        perc=round(100*sum(or(OB.Low.pval<0.05,OB.NoLow.pval<0.05))./length(numNeurons));
        title(['OB ',num2str(perc),'% mod'])
        
        subplot(3,3,2)
        plot(freq.HPC,mean(Data(Restrict(Sptsd.HPC,Epoch{keepGoodLow}))),'r')
        hold on
        plot(freq.HPC,mean(Data(Restrict(Sptsd.HPC,REMEpoch-Epoch{keepNoLow}))),'b')
        perc=round(100*sum(or(HPC.Low.pval<0.05,HPC.NoLow.pval<0.05))./length(numNeurons));
        title(['HPC ',num2str(perc),'% mod'])
        
        subplot(3,3,3)
        plot(freq.PFCx,mean(Data(Restrict(Sptsd.PFCx,Epoch{keepGoodLow}))),'r')
        hold on
        plot(freq.PFCx,mean(Data(Restrict(Sptsd.PFCx,REMEpoch-Epoch{keepNoLow}))),'b')
        title('PFCx')
        
        subplot(3,3,4)
        hold on
        plot(OB.Low.Kappa(OB.Low.pval<0.05),OB.NoLow.Kappa(OB.Low.pval<0.05),'*r')
        plot(OB.Low.Kappa(OB.NoLow.pval<0.05),OB.NoLow.Kappa(OB.NoLow.pval<0.05),'*b')
        plot(OB.Low.Kappa(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),OB.NoLow.Kappa(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),'*k')
        xlim([0 0.4]),ylim([0 0.4])
        line(xlim,ylim)
        xlabel('Low'), ylabel('NoLow'), title('OB kappa')
        
        subplot(3,3,7)
        hold on
        plot(OB.Low.phase(OB.Low.pval<0.05),OB.NoLow.phase(OB.Low.pval<0.05),'*r')
        plot(OB.Low.phase(OB.NoLow.pval<0.05),OB.NoLow.phase(OB.NoLow.pval<0.05),'*b')
        plot(OB.Low.phase(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),OB.NoLow.phase(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),'*k')
        xlabel('Low'), ylabel('NoLow'), title('OB phase')
        plot([0 7],[0 7]), xlim([0 7]), ylim([0 7])
        
        subplot(3,3,5)
        hold on
        plot(HPC.Low.Kappa(HPC.Low.pval<0.05),HPC.NoLow.Kappa(HPC.Low.pval<0.05),'*r')
        plot(HPC.Low.Kappa(HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(HPC.NoLow.pval<0.05),'*b')
        plot(HPC.Low.Kappa(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),'*k')
        xlim([0 0.4]),ylim([0 0.4])
        line(xlim,ylim)
        xlabel('Low'), ylabel('NoLow'),title('HPC kappa')
        
        subplot(3,3,8)
        hold on
        plot(HPC.Low.phase(HPC.Low.pval<0.05),HPC.NoLow.phase(HPC.Low.pval<0.05),'*r')
        plot(HPC.Low.phase(HPC.NoLow.pval<0.05),HPC.NoLow.phase(HPC.NoLow.pval<0.05),'*b')
        plot(HPC.Low.phase(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),HPC.NoLow.phase(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),'*k')
        plot([0 7],[0 7]), xlim([0 7]), ylim([0 7])
        xlabel('Low'), ylabel('NoLow'),title('HPC phase')
        
        subplot(3,3,9)
        hold on
        plot(OB.NoLow.Kappa(OB.NoLow.pval<0.05),HPC.NoLow.Kappa(OB.NoLow.pval<0.05),'*r')
        plot(OB.NoLow.Kappa(HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(HPC.NoLow.pval<0.05),'*b')
        plot(OB.NoLow.Kappa(OB.NoLow.pval<0.05 & HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(OB.NoLow.pval<0.05 & HPC.NoLow.pval<0.05),'*k')
        xlim([0 0.4]),ylim([0 0.4])
        line(xlim,ylim)
        xlabel('OB'), ylabel('HPC'), title('NoLow')
        
        subplot(3,3,6)
        hold on
        plot(OB.Low.Kappa(OB.Low.pval<0.05),HPC.Low.Kappa(OB.Low.pval<0.05),'*r')
        plot(OB.Low.Kappa(HPC.Low.pval<0.05),HPC.Low.Kappa(HPC.Low.pval<0.05),'*b')
        plot(OB.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05),HPC.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05),'*k')
        line(xlim,ylim)
        xlabel('OB'), ylabel('HPC'), title('NoLow')
        disp('saving figure')
        saveas(fig,[SaveFigFolder,'REMmodulationBis',num2str(mm),'.png'])
        saveas(fig,[SaveFigFolder,'REMmodulationBis',num2str(mm),'.fig'])
        close all
        disp('saving data')
        save('NeuronModulationREM.mat','ph','HPC','OB','Fr','SpecMoy')
        
        clear ph mu Kappa Fr SpecMoy
    catch
        disp([num2str(mm),'failed'])
    end
end

%% Look at results
clear all
Dir=PathForExperimentsDeltaSleep2016('Basal');
BadMice={'Mouse244','Mouse294'};
keepGoodLow=3;
keepNoLow=1;
SaveFigFolder='/media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/REMNeurons/';
for i=1:5
    ModIndex{i}=[];
    AllNeurMod{i}=[];
end
AllPhaseH=[];AllPhaseB=[];
AllOBInfoL=[]; AllHPCInfoL=[];
AllNeurInfo=[];
AllOBInfoNL=[]; AllHPCInfoNL=[];
for t=1:3
    for tt=1:2
        Sp{tt,t}=[];
        Sp{tt,t}=[];
    end
end
fig3=figure;
fig1=figure;
keeptrack=1;
for mm=1:length(Dir.path)
    
    cd(Dir.path{mm})
    if not(strcmp(Dir.name{mm},BadMice{1}) | strcmp(Dir.name{mm},BadMice{2}))
        clear Fr HPC OB
        if exist('NeuronModulationREM.mat')>0
            mm
            load('NeuronModulationREM.mat')
            AllOBInfoL=[AllOBInfoL,[OB.Low.Kappa;OB.Low.pval;OB.Low.phase]];
            AllHPCInfoL=[AllHPCInfoL,[HPC.Low.Kappa;HPC.Low.pval;HPC.Low.phase]];
            AllOBInfoNL=[AllOBInfoNL,[OB.NoLow.Kappa;OB.NoLow.pval;OB.NoLow.phase]];
            AllHPCInfoNL=[AllHPCInfoNL,[HPC.NoLow.Kappa;HPC.NoLow.pval;HPC.NoLow.phase]];
            AllNeurInfo=[AllNeurInfo;Fr];
            
            for t=1:3
                for tt=1:2
                    Sp{tt,t}=[Sp{tt,t};SpecMoy{tt,t}(1:261)];
                    Sp{tt,t}=[Sp{tt,t};SpecMoy{tt,t}(1:261)];
                end
            end
            
            for k=1:size(ph,1)
                for g=1:4
                    [Y,X]=hist(Data(ph{k,g}{1}),60);
                    AllNeurMod{g}=[AllNeurMod{g};runmean([Y,Y],4)];
                end
            end
    figure(fig1)
    %                 subplot(3,3,1)
    %                 hold on
    %
    %                 plot(Spikenum(1,:),Spikenum(2,:),'*')
    %                 xlabel('Low'), ylabel('NoLow'),title('Number of spikes')
    %                 ModIndex{1}=[ ModIndex{1},(Spikenum(1,:)-Spikenum(2,:))./(Spikenum(1,:)+Spikenum(2,:))];
    %                 clear Spikenum
    
    
    
    subplot(3,3,4)
    hold on
    plot(OB.Low.Kappa(OB.Low.pval<0.05),OB.NoLow.Kappa(OB.Low.pval<0.05),'*r')
    plot(OB.Low.Kappa(OB.NoLow.pval<0.05),OB.NoLow.Kappa(OB.NoLow.pval<0.05),'*b')
    plot(OB.Low.Kappa(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),OB.NoLow.Kappa(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),'*k')
    xlim([0 0.4]),ylim([0 0.4])
    line(xlim,ylim)
    xlabel('Low'), ylabel('NoLow'), title('OB kappa')
    a=OB.Low.Kappa(OB.Low.pval<0.05 | OB.NoLow.pval<0.05);
    b=OB.NoLow.Kappa(OB.Low.pval<0.05 | OB.NoLow.pval<0.05);
    ModIndex{2}=[ ModIndex{2},(a-b)./(a+b)];
    
    subplot(3,3,5)
    hold on
    plot(HPC.Low.Kappa(HPC.Low.pval<0.05),HPC.NoLow.Kappa(HPC.Low.pval<0.05),'*r')
    plot(HPC.Low.Kappa(HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(HPC.NoLow.pval<0.05),'*b')
    plot(HPC.Low.Kappa(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),'*k')
    xlim([0 0.4]),ylim([0 0.4])
    line(xlim,ylim)
    xlabel('Low'), ylabel('NoLow'),title('HPC kappa')
    a=HPC.Low.Kappa(HPC.Low.pval<0.05 | HPC.NoLow.pval<0.05);
    b=HPC.NoLow.Kappa(HPC.Low.pval<0.05 | HPC.NoLow.pval<0.05);
    ModIndex{3}=[ ModIndex{3},(a-b)./(a+b)];
    
    subplot(3,3,6)
    hold on
    plot(OB.Low.Kappa(OB.Low.pval<0.05),HPC.Low.Kappa(OB.Low.pval<0.05),'*r')
    plot(OB.Low.Kappa(HPC.Low.pval<0.05),HPC.Low.Kappa(HPC.Low.pval<0.05),'*b')
    plot(OB.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05),HPC.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05),'*k')
    xlim([0 0.4]),ylim([0 0.4])
    line(xlim,ylim)
    xlabel('OB'), ylabel('HPC'), title('Low Kappa')
    a=OB.Low.Kappa(OB.Low.pval<0.05 | HPC.Low.pval<0.05);
    b=HPC.Low.Kappa(OB.Low.pval<0.05 | HPC.Low.pval<0.05);
    ModIndex{4}=[ ModIndex{4},(a-b)./(a+b)];
    
    subplot(3,3,7)
    hold on
    plot(OB.Low.phase(OB.Low.pval<0.05),OB.NoLow.phase(OB.Low.pval<0.05),'*r')
    plot(OB.Low.phase(OB.NoLow.pval<0.05),OB.NoLow.phase(OB.NoLow.pval<0.05),'*b')
    plot(OB.Low.phase(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),OB.NoLow.phase(OB.Low.pval<0.05 & OB.NoLow.pval<0.05),'*k')
    xlabel('Low'), ylabel('NoLow'), title('OB phase')
    plot([0 7],[0 7]), xlim([0 7]), ylim([0 7])
    a=OB.Low.phase(OB.Low.pval<0.05 | OB.NoLow.pval<0.05);
    b=OB.NoLow.phase(OB.Low.pval<0.05 | OB.NoLow.pval<0.05);
    %         ModIndex{5}=[ ModIndex{5},(a-b)./(a+b)];
    AllPhaseB=[AllPhaseB,a];
    
    subplot(3,3,8)
    hold on
    plot(HPC.Low.phase(HPC.Low.pval<0.05),HPC.NoLow.phase(HPC.Low.pval<0.05),'*r')
    plot(HPC.Low.phase(HPC.NoLow.pval<0.05),HPC.NoLow.phase(HPC.NoLow.pval<0.05),'*b')
    plot(HPC.Low.phase(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),HPC.NoLow.phase(HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),'*k')
    plot([0 7],[0 7]), xlim([0 7]), ylim([0 7])
    xlabel('Low'), ylabel('NoLow'),title('HPC phase')
    a=HPC.Low.phase(HPC.Low.pval<0.05 | HPC.NoLow.pval<0.05);
    b=HPC.NoLow.phase(HPC.Low.pval<0.05 | HPC.NoLow.pval<0.05);
    AllPhaseH=[AllPhaseH,a];
    
    subplot(3,3,9)
    hold on
    plot(OB.NoLow.Kappa(OB.NoLow.pval<0.05),HPC.NoLow.Kappa(OB.NoLow.pval<0.05),'*r')
    plot(OB.NoLow.Kappa(HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(HPC.NoLow.pval<0.05),'*b')
    plot(OB.NoLow.Kappa(OB.NoLow.pval<0.05 & HPC.NoLow.pval<0.05),HPC.NoLow.Kappa(OB.NoLow.pval<0.05 & HPC.NoLow.pval<0.05),'*k')
    xlim([0 0.4]),ylim([0 0.4])
    line(xlim,ylim)
    xlabel('OB'), ylabel('HPC'), title('NoLow Kappa')
    a=OB.NoLow.Kappa(OB.NoLow.pval<0.05 | HPC.NoLow.pval<0.05);
    b=HPC.NoLow.Kappa(OB.NoLow.pval<0.05 | HPC.NoLow.pval<0.05);
    ModIndex{5}=[ ModIndex{5},(a-b)./(a+b)];
    
    figure(fig3)
    subplot(131)
    line([OB.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05);OB.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05)],...
        [HPC.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05);HPC.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05)],'color','k')
    hold on,
    plot(OB.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05),...
        HPC.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05),'b*')
    plot(OB.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05 & OB.NoLow.pval<0.05),...
        HPC.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval>0.05 & OB.NoLow.pval<0.05),'r*')
    title('Only OB low sig')
    xlabel('OB kappa'), ylabel('HPC kappa')
    
    subplot(132)
    line([OB.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05);OB.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05)],...
        [HPC.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05);HPC.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05)],'color','k')
    hold on,
    plot(OB.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05),...
        HPC.Low.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05),'b*')
    plot(OB.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),...
        HPC.NoLow.Kappa(OB.Low.pval<0.05 & HPC.Low.pval<0.05 & HPC.NoLow.pval<0.05),'r*')
    title('Both low sig')
    xlabel('OB kappa'), ylabel('HPC kappa')
    
    subplot(133)
    line([OB.Low.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05);OB.NoLow.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05)],...
        [HPC.Low.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05);HPC.NoLow.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05)],'color','k')
    hold on,
    plot(OB.Low.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05),...
        HPC.Low.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05),'b*')
    plot(OB.NoLow.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05),...
        HPC.NoLow.Kappa(OB.Low.pval>0.05 & HPC.Low.pval<0.05),'r*')
    
    
    
    xlabel('OB kappa'), ylabel('HPC kappa')
    title('Only HPC low sig')
        end
    end
end

        
        subplot(3,3,2)
        [Y,X]=hist(AllPhaseB,30);
        Y=runmean(Y/sum(Y),4);
        stairs([X,X+2*pi],[Y,Y])
        title('Distrib OB phase')
        xlim([0.1 4*pi])
        subplot(3,3,3)
        [Y,X]=hist(AllPhaseH,30);
        Y=runmean(Y/sum(Y),4);
        stairs([X,X+2*pi],[Y,Y])
        title('Distrib HPC phase')
        xlim([0.1 4*pi])
end
% figure
% plotSpread(ModIndex,'showMM',5,'xNames',{'SpikeNum','OBKappa L/NL','HPCKappa L/NL','Low OB/HPC','NLow OB/HPC'},'distributionColors','k')
% hold on
% line(xlim,[0 0])
% for k=1:5
%     [h(k),p(k)]=ttest(ModIndex{k})
%     sigstar([k-0.1,k+0.1],p(k))
% end
% 

figure
clear a
a{1}=AllOBInfoL(1,(AllOBInfoL(2,:)<0.05 ));
a{2}=AllOBInfoNL(1,(AllOBInfoNL(2,:)<0.05));
a{3}=AllHPCInfoL(1,(AllHPCInfoL(2,:)<0.05));
a{4}=AllHPCInfoNL(1,(AllHPCInfoNL(2,:)<0.05));
plotSpread(a,'showMM',5,'xNames',{'OBLow','OBNoLow','HPCLow','HPCNoLow'})
[h,p]=ttest2(a{1},a{2}); sigstar({[1,2]},p)
[h,p]=ttest2(a{3},a{4}); sigstar({[3,4]},p)




figure
clear a
a(1)=sum(AllOBInfoL(2,:)<0.05 )/length(AllOBInfoNL);
a(2)=sum(AllOBInfoNL(2,:)<0.05)/length(AllOBInfoNL);
a(3)=sum(AllHPCInfoL(2,:)<0.05)/length(AllOBInfoNL);
a(4)=sum(AllHPCInfoNL(2,:)<0.05)/length(AllOBInfoNL);
bar(a)
set(gca,'XTickLabel',{'OBLow','OBNoLow','HPCLow','HPCNoLow'})

% How do the OB changelings change their HPC sensitivity
NeurOfInt=(AllOBInfoL(2,:)<0.05 & AllOBInfoNL(2,:)>0.05);
figure('name','OB sig that loose OB sig')
subplot(231)
b{1}=(AllHPCInfoL(1,NeurOfInt));
b{2}=(AllHPCInfoNL(1,NeurOfInt));
plotSpread(b,'showMM',5,'xNames',{'KappaH-Low','KappaH-NoLow'})
[h,p]=ttest(b{1},b{2});
hold on
 sigstar({[1,2]},p)
 subplot(232)
nhist(b,'binfactor',4,'legend',{'KappaH-Low','KappaH-NoLow'})
 subplot(233)
plot(b{1},b{2},'*'), hold on
plot(b{1},b{1},'k'), xlim([0 0.4]), ylim([0 0.4])
Denom=sum(NeurOfInt);
LowHPCSig=sum(NeurOfInt & AllHPCInfoL(2,:)<0.05)/Denom;
NoLowHPCSig=sum(NeurOfInt & AllHPCInfoNL(2,:)<0.05)/Denom;
title(['Prop HPC Low Sig',num2str(LowHPCSig),' Prop HPC No Low Sig',num2str(NoLowHPCSig)])
xlabel('KappaH-Low'),ylabel('KappaH-NoLow')
NeurOfInt=find(NeurOfInt);
subplot(245)
[val,ind]=sort(AllHPCInfoL(3,(NeurOfInt)));
imagesc(zscore(AllNeurMod{1}(NeurOfInt(ind),:)')'), clim([-3 3])
title('low HPC mod')
subplot(246)
[val,ind]=sort(AllHPCInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{2}(NeurOfInt(ind),:)')'), clim([-3 3])
title('nolow HPC mod')
subplot(247)
[val,ind]=sort(AllOBInfoL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{3}(NeurOfInt(ind),:)')'), clim([-3 3])
title('low OB mod')
subplot(248)
[val,ind]=sort(AllOBInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{4}(NeurOfInt(ind),:)')'), clim([-3 3])
title('nolow OB mod')



figure('name','OB and HPC sig that loose OB sig')
NeurOfInt=AllOBInfoL(2,:)<0.05 & AllOBInfoNL(2,:)>0.05 & AllHPCInfoL(2,:)<0.05;
subplot(231)
b{1}=(AllHPCInfoL(1,NeurOfInt));
b{2}=(AllHPCInfoNL(1,NeurOfInt));
plotSpread(b,'showMM',5,'xNames',{'KappaH-Low','KappaH-NoLow'})
[h,p]=ttest(b{1},b{2});
hold on
 sigstar({[1,2]},p)
 subplot(232)
nhist(b,'binfactor',4,'legend',{'KappaH-Low','KappaH-NoLow'})
 subplot(233)
plot(b{1},b{2},'*'), hold on
plot(b{1},b{1},'k'), xlim([0 0.4]), ylim([0 0.4])
Denom=sum(NeurOfInt);
LowHPCSig=sum(NeurOfInt & AllHPCInfoL(2,:)<0.05)/Denom;
NoLowHPCSig=sum(NeurOfInt & AllHPCInfoNL(2,:)<0.05)/Denom;
title(['Prop HPC Low Sig',num2str(LowHPCSig),' Prop HPC No Low Sig',num2str(NoLowHPCSig)])
xlabel('KappaH-Low'),ylabel('KappaH-NoLow')
NeurOfInt=find(NeurOfInt);
subplot(245)
[val,ind]=sort(AllHPCInfoL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{1}(NeurOfInt(ind),:)')'), clim([-3 3])
title('low HPC mod')
subplot(246)
[val,ind]=sort(AllHPCInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{2}(NeurOfInt(ind),:)')'), clim([-3 3])
title('nolow HPC mod')
subplot(247)
[val,ind]=sort(AllOBInfoL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{3}(NeurOfInt(ind),:)')'), clim([-3 3])
title('low OB mod')
subplot(248)
[val,ind]=sort(AllOBInfoNL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{4}(NeurOfInt(ind),:)')',[1,2])), clim([-3 3])
title('nolow OB mod')




figure('name','OB but not HPC sig that loose OB sig')
NeurOfInt=(AllOBInfoL(2,:)<0.05 & AllOBInfoNL(2,:)>0.05 & AllHPCInfoL(2,:)>0.05);
subplot(231)
b{1}=(AllHPCInfoL(1,NeurOfInt));
b{2}=(AllHPCInfoNL(1,NeurOfInt));
plotSpread(b,'showMM',5,'xNames',{'KappaH-Low','KappaH-NoLow'})
[h,p]=ttest(b{1},b{2});
hold on
 sigstar({[1,2]},p)
 subplot(232)
nhist(b,'binfactor',4,'legend',{'KappaH-Low','KappaH-NoLow'})
 subplot(233)
plot(b{1},b{2},'*'), hold on
plot(b{1},b{1},'k'), xlim([0 0.4]), ylim([0 0.4])
Denom=sum(NeurOfInt);
LowHPCSig=sum(NeurOfInt & AllHPCInfoL(2,:)<0.05)/Denom;
NoLowHPCSig=sum(NeurOfInt & AllHPCInfoNL(2,:)<0.05)/Denom;
title(['Prop HPC Low Sig',num2str(LowHPCSig),' Prop HPC No Low Sig',num2str(NoLowHPCSig)])
xlabel('KappaH-Low'),ylabel('KappaH-NoLow')
NeurOfInt=find(NeurOfInt);
subplot(245)
[val,ind]=sort(AllHPCInfoL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{1}(NeurOfInt(ind),:)')'), clim([-3 3])
title('low HPC mod')
subplot(246)
[val,ind]=sort(AllHPCInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{2}(NeurOfInt(ind),:)')'), clim([-3 3])
title('nolow HPC mod')
subplot(247)
[val,ind]=sort(AllOBInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{3}(NeurOfInt(ind),:)')'), clim([-3 3])
title('low OB mod')
subplot(248)
[val,ind]=sort(AllOBInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{4}(NeurOfInt(ind),:)')'), clim([-3 3])
title('nolow OB mod')

figure



figure
subplot(121)
plotSpread({log(AllNeurInfo(:,1)),log(AllNeurInfo(:,2))},'showMM',5,'xNames',{'Low','NoLow'})
subplot(122)
plot(log(AllNeurInfo(:,1)),log(AllNeurInfo(:,2)),'*'), hold on
plot(log(AllNeurInfo(:,1)),log(AllNeurInfo(:,1)),'k')
NeurOfInt=(AllOBInfoL(2,:)<0.05 & AllOBInfoNL(2,:)>0.05);
plot(log(AllNeurInfo(NeurOfInt,1)),log(AllNeurInfo(NeurOfInt,2)),'*'), hold on


figure
Struc={'OB','HPC','PFCx'};
suborder=[1,3,2];
for t=1:3
    subplot(3,1,suborder(t))
    g=shadedErrorBar(Spectro{3}(2:end-1),nanmean(Sp{1,t}),[stdError(Sp{1,t});stdError(Sp{1,t})],'r')
    hold on
    g=shadedErrorBar(Spectro{3}(2:end-1),nanmean(Sp{2,t}),[stdError(Sp{2,t});stdError(Sp{2,t})],'b')
    xlim([1 20])
    box off
    title(Struc{t})
end



figure
a{1}=AllHPCInfoL(1,AllHPCInfoL(2,:)>0.05 &AllOBInfoL(2,:)<0.05);
a{2}=AllHPCInfoNL(1,AllHPCInfoL(2,:)>0.05 &AllOBInfoL(2,:)<0.05);
subplot(121)
plotSpread(a,'showMM',5,'xNames',{'KappaH-Low','KappaH-NoLow'})
[h,p]=ttest(a{1},a{2});
sigstar({[1,2]},p)
title('Low OB specific neurons')
a{1}=AllHPCInfoL(1,AllHPCInfoL(2,:)<0.05 &AllOBInfoL(2,:)>0.05);
a{2}=AllHPCInfoNL(1,AllHPCInfoL(2,:)<0.05 &AllOBInfoL(2,:)>0.05);
subplot(122)
plotSpread(a,'showMM',5,'xNames',{'KappaH-Low','KappaH-NoLow'})
[h,p]=ttest(a{1},a{2});
sigstar({[1,2]},p)
title('Low HPC specific neurons')


figure
subplot(221)
NeurOfInt=find(AllHPCInfoL(2,:)>0.05 &AllOBInfoL(2,:)<0.05);
[val,ind]=sort(AllHPCInfoL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{1}(NeurOfInt(ind),:)')'), clim([-3 3])
title('Low OB specific neurons ')
subplot(223)
[val,ind]=sort(AllHPCInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{2}(NeurOfInt(ind),:)')'), clim([-3 3])
title('Low OB specific neurons ')
subplot(222)
NeurOfInt=find(AllHPCInfoL(2,:)<0.05 &AllOBInfoL(2,:)>0.05);
[val,ind]=sort(AllHPCInfoL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{1}(NeurOfInt(ind),:)')'), clim([-3 3])
title('Low HPC specific neurons ')
subplot(224)
[val,ind]=sort(AllHPCInfoNL(3,NeurOfInt));
imagesc(zscore(AllNeurMod{2}(NeurOfInt(ind),:)')'), clim([-3 3])
title('Low HPC specific neurons ')

figure
subplot(221)
NeurOfInt=find(AllHPCInfoL(2,:)>0.05 &AllOBInfoL(2,:)<0.05);
[val,ind]=sort(AllHPCInfoNL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{1}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low OB specific neurons ')
subplot(223)
[val,ind]=sort(AllHPCInfoNL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{2}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low OB specific neurons ')
subplot(222)
NeurOfInt=find(AllHPCInfoL(2,:)<0.05 &AllOBInfoL(2,:)>0.05);
[val,ind]=sort(AllHPCInfoL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{1}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low HPC specific neurons ')
subplot(224)
[val,ind]=sort(AllHPCInfoL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{2}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low HPC specific neurons ')

figure
subplot(221)
NeurOfInt=find(AllHPCInfoL(2,:)>0.05 &AllOBInfoL(2,:)<0.05);
[val,ind]=sort(AllOBInfoL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{3}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low OB specific neurons ')
subplot(223)
[val,ind]=sort(AllOBInfoL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{4}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low OB specific neurons ')
subplot(222)
NeurOfInt=find(AllHPCInfoL(2,:)<0.05 &AllOBInfoL(2,:)>0.05);
[val,ind]=sort(AllOBInfoL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{3}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low HPC specific neurons ')
subplot(224)
[val,ind]=sort(AllOBInfoNL(3,NeurOfInt));
imagesc(zscore(SmoothDec(AllNeurMod{4}(NeurOfInt(ind),:),[0.5,0.1])')')
title('Low HPC specific neurons ')

