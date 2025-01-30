% Analyse data plethysmo ManipDec15BulbectomiePlethysmo (respi + freezing)
clear all
shammice=[280:290];
bulbmice=[269:279];
expgroup={shammice,bulbmice};
groupname={'sham','bulb'};

fig1=figure;
fig2=figure;
for g=1:2
    group=expgroup{g};
    for mousenb=1:length(group)
        m=group(mousenb)
        try
            PathPlethysmo=['G:\Plethysmo\Data respi/ext_downsampled/M' num2str(m) '/M' num2str(m) '-TestPlethy-171215/']; %path pour windows
            %PathPlethysmo=['/media/DataMobs31/Plethysmo/Data respi/ext_downsampled/M' num2str(m) '/M' num2str(m) '-TestPlethy-171215/'];
            cd(PathPlethysmo)
        catch
            PathPlethysmo=['G:\Plethysmo\Data respi\ext_downsampled/M' num2str(m) '/M' num2str(m) '-TestPlethy-231215/'];
            %PathPlethysmo=['/media/DataMobs31/Plethysmo/Data respi/ext_downsampled/M' num2str(m) '/M' num2str(m) '-TestPlethy-231215/'];
            cd(PathPlethysmo)
        end
    
        % debut data sur TTL Start
        load('LFPData/LFP0.mat')
        Temp=thresholdIntervals(LFP,1.5*1e4,'Direction','Above');
        debut=-Start(Temp)/1e4;
        load('Respi_Low_Spectrum.mat')
        load('Behavior.mat')
        % Bip
        load('LFPData/LFP1.mat')
        if ismember(m,[270:274, 280:284]) %CSplu=Bip
            CSplu=tsd(Range(LFP)+debut*1e4,Data(LFP));
        elseif ismember(m,[275:279,285:289,290,269]) %CSplu=WN
            CSmin=tsd(Range(LFP)+debut*1e4,Data(LFP));
        end
        % White Noise
        load('LFPData/LFP2.mat')
        if ismember(m,[270:274, 280:284])
            CSmin=tsd(Range(LFP)+debut*1e4,Data(LFP));
        elseif ismember(m,[275:279,285:289,290,269])
            CSplu=tsd(Range(LFP)+debut*1e4,Data(LFP));
        end
        
        load('LFPData/LFP3.mat')
        Respi=tsd(Range(LFP)+debut*1e4,Data(LFP));
        Sptsd=tsd(Spectro{2}*1e4+debut*1e4,Spectro{1});
%                 figure
%                 imagesc(Range(Sptsd,'s'),Spectro{3},log(Data(Sptsd)'));
%                 axis xy
%                 keyboard

        %
        try load('BehavAnalysis.mat')
            FreezeEpoch;
        catch
            a=Data(Movtsd);
            a(a<0.01)=NaN;
            Movtsd=tsd(Range(Movtsd),a);
            
            figure
            plot(Range(Movtsd,'s'),Data(Movtsd))
            [x,mov_thresh]=ginput(1);
            FreezeEpoch=thresholdIntervals(Movtsd,mov_thresh,'Direction','Below');
            FreezeEpoch=dropShortIntervals(FreezeEpoch,2*1e4);
        end
        
        
        %         figure
        %         plot(Range(Movtsd,'s'),Data(Movtsd))
        %         hold on
        %         plot(Range(Restrict(Movtsd,FreezeEpoch),'s'),Data(Restrict(Movtsd,FreezeEpoch)),'g')
        
        
        NoFreezeEpoch=intervalSet(0,1200*1e4)-FreezeEpoch;
        Freezing{m-268,1}=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        Freezing{m-268,2}=mean(Data(Restrict(Sptsd,NoFreezeEpoch)));
        
        if sum(Stop(FreezeEpoch)-Start(FreezeEpoch))>100*1E4
            SpFr=Restrict(Sptsd,FreezeEpoch);
            datafr=Data(SpFr);
            rangefr=Range(SpFr);
            temp=round(length(datafr)/5);
            allData{1}=nanmean(datafr(1:temp,:));
            allData{2}=nanmean(datafr(temp:2*temp,:));
            allData{3}=nanmean(datafr(2*temp:3*temp,:));
            allData{4}=nanmean(datafr(3*temp:4*temp,:));
            allData{5}=nanmean(datafr(4*temp:end,:));
            allRange{1}=rangefr(1:temp);
            allRange{2}=rangefr(temp:2*temp);
            allRange{3}=rangefr(2*temp:3*temp);
            allRange{4}=rangefr(3*temp:4*temp);
            allRange{5}=rangefr(4*temp:end);
%             
%             firstSeconds{1}=nanmean(datafr(1:firstDur,:));
%             firstSeconds{2}=nanmean(datafr(temp:temp+firstDur,:));
%             firstSeconds{3}=nanmean(datafr(2*temp:2*temp+firstDur,:));
%             firstSeconds{4}=nanmean(datafr(3*temp:3*temp+firstDur,:));
%             firstSeconds{5}=nanmean(datafr(4*temp:4*temp+firstDur,:));
%             
%            
            figure(fig2)
            subplot(2,11,mousenb+(g-1)*11)
            colors=jet(5);
            for j=1:length(allData)
                plot(Spectro{3},allData{j},'color',colors(j,:))
                hold on
                [amplMax,index]=max(allData{j});
                freqMax=Spectro{3}(index);
                RespiFr{m-268,j}=[amplMax,freqMax,sum(Stop(FreezeEpoch)-Start(FreezeEpoch))];
                AllSpec{m-268,j}=allData{j};
            end
            title(num2str(sum(Stop(FreezeEpoch)-Start(FreezeEpoch))))
        else
                        for j=1:5
                RespiFr{m-268,j}=[NaN,NaN,NaN];
                        end
        end
        
        
        %         figure
        %         plot(Spectro{3},mean((Data(Restrict(Sptsd,NoFreezeEpoch)))),'r')
        %         hold on
        %         plot(Spectro{3},mean((Data(Restrict(Sptsd,FreezeEpoch)))),'b')
        %
        
        %Freezing pendant les CS+
        CSpluEpochs=thresholdIntervals(CSplu,0.5*1e4,'Direction','Above');
        CSpluEpochs=mergeCloseIntervals(CSpluEpochs,10*1e4);
        CSpluEpochs2=intervalSet(Start(CSpluEpochs),Start(CSpluEpochs)+50*1e4);
        %CSpluEpochsBeg=intervalSet(Start(CSpluEpochs),Start(CSpluEpochs)+5*1e4);
        
        CSminEpochs=thresholdIntervals(CSmin,0.5*1e4,'Direction','Above');
        CSminEpochs=mergeCloseIntervals(CSminEpochs,10*1e4);
        CSminEpochs2=intervalSet(Start(CSminEpochs),Start(CSminEpochs)+50*1e4);
        
        FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
        FreezeEpoch=mergeCloseIntervals(FreezeEpoch,10*1e4);
        FirstSec{m-268,1}=[];
        LastSec{m-268,1}=[];
        for ii=1:length(Start(FreezeEpoch))
            Ep=subset(FreezeEpoch,ii);
            EpBeg=intervalSet(Start(Ep)-5*1E4,Start(Ep)+5*1E4);
            EpLast=intervalSet(Stop(Ep)-5*1E4,Stop(Ep)+5*1E4);
            SpfirstSec=Restrict(Sptsd,EpBeg);
            SplastSec=Restrict(Sptsd,EpLast);
            FirstSec{m-268,ii}=Data(SpfirstSec);
            LastSec{m-268,ii}=Data(SplastSec);
        end
       
        figure(fig1)
        subplot(2,11,mousenb+(g-1)*11)
        colors=jet(length(Start(CSpluEpochs2)));
        for i=1:length(Start(CSpluEpochs2))
            Ep=and(FreezeEpoch,subset(CSpluEpochs2,i));
            plot(Spectro{3},mean((Data(Restrict(Sptsd,Ep)))),'color',colors(i,:))
            hold on
            [amplMax,index]=max(mean((Data(Restrict(Sptsd,Ep)))));
            freqMax=Spectro{3}(index);
            RespiFrCSplu{m-268,i}=[amplMax,freqMax,sum(Stop(Ep,'s')-Start(Ep,'s'))];
            AllSpec2{m-268,i}=mean((Data(Restrict(Sptsd,Ep))));
            if isempty(AllSpec2{m-268,i})
                AllSpec2{m-268,i}=nan(1,263);
            end
        end
        
        AllSpec2{m-268,13}=nan(1,263);

        
        %          figure
        %         colors=jet(length(Start(CSpluEpochs2)));
        %         for i=1:length(Start(CSpluEpochs2))
        %             Ep=subset(CSpluEpochs2,i);
        %             plot(Spectro{3},mean((Data(Restrict(Sptsd,Ep)))),'color',colors(i,:))
        %             hold on
        %             [amplMax,index]=max(mean((Data(Restrict(Sptsd,Ep)))));
        %             freqMax=Spectro{3}(index);
        %             RespiFrCSplu2{m-268,i}=[amplMax,freqMax,sum(Stop(Ep,'s')-Start(Ep,'s'))];
        %         end
        
        % 5 periodes : basal, CS-, CS+,CS+,CS+
        CSminstart=Start(CSminEpochs2);
        CSminstop=Stop(CSminEpochs2);
        CSplustart=Start(CSpluEpochs2);
        CSplustop=Stop(CSpluEpochs2);
        basalEp=intervalSet(0,CSminstart(1));
        CSminEp=intervalSet(CSminstart(1),CSminstop(4)+30*1e4);
        CSpluEp1=intervalSet(CSplustart(1),CSplustop(4)+30*1e4);
        CSpluEp2=intervalSet(CSplustart(5),CSplustop(8)+30*1e4);
        CSpluEp3=intervalSet(CSplustart(9),CSplustop(12)+30*1e4);
        
        Frbasal=sum(Stop(and(FreezeEpoch,basalEp))-Start(and(FreezeEpoch,basalEp)))/(Stop(basalEp)-Start(basalEp));
        FrCSmin=sum(Stop(and(FreezeEpoch,CSminEp))-Start(and(FreezeEpoch,CSminEp)))/(Stop(CSminEp)-Start(CSminEp));
        FrCSplu1=sum(Stop(and(FreezeEpoch,CSpluEp1))-Start(and(FreezeEpoch,CSpluEp1)))/(Stop(CSpluEp1)-Start(CSpluEp1));
        FrCSplu2=sum(Stop(and(FreezeEpoch,CSpluEp2))-Start(and(FreezeEpoch,CSpluEp2)))/(Stop(CSpluEp2)-Start(CSpluEp2));
        FrCSplu3=sum(Stop(and(FreezeEpoch,CSpluEp3))-Start(and(FreezeEpoch,CSpluEp3)))/(Stop(CSpluEp3)-Start(CSpluEp3));
        TableFr{g}(mousenb,1)=Frbasal;
        TableFr{g}(mousenb,2)=FrCSmin;
        TableFr{g}(mousenb,3)=FrCSplu1;
        TableFr{g}(mousenb,4)=FrCSplu2;
        TableFr{g}(mousenb,5)=FrCSplu3;
        
        
        save('BehavAnalysis.mat','mov_thresh','FreezeEpoch')
        
        clear FreezeEpoch CSpluEpochs CSpluEpochs2 Sptsd CSplu CSmin mov_thresh
    end
end
% saveas(fig1,'AllMiceSpectra.fig')
% saveas(fig1,'AllMiceSpectra.png')


figure
colors=jet(22);
Tot1=[];Tot2=[];
for m=1:22
    a=reshape([RespiFr{m,1:5}],3,5)';
    subplot(1,2,1)
    plot([1:5],(a(:,1)),'color',colors(m,:)) %ampl
    hold on
    xlabel('Proportion of time in freezing')
    set(gca,'XTick',[1:5],'XTickLabel',{'1/5','2/5','3/5','4/5','5/5'})
 ylabel('Power')
    subplot(1,2,2)
    plot([1:5],(a(:,2)),'color',colors(m,:)) %freq
    hold on
    xlabel('Proportion of time in freezing')
    ylabel('Max Freq')
     set(gca,'XTick',[1:5],'XTickLabel',{'1/5','2/5','3/5','4/5','5/5'})
        Tot1=[Tot1,a(:,1)];
    Tot2=[Tot2,a(:,2)];

end


colors=jet(22);
Tot11=[];Tot21=[];
for m=1:22
    a=reshape([RespiFrCSplu{m,1:12}],3,12)';
    Tot11=[Tot11,a(:,1)];
    Tot21=[Tot21,a(:,2)];

end


subplot(1,2,1)
plot(nanmean(Tot1'),'k','linewidth',2)
errorbar([1:5],nanmean(Tot1'),stdError(Tot1'),'k','linewidth',2)
subplot(1,2,2)
plot(nanmean(Tot2'),'k','linewidth',2)
errorbar([1:5],nanmean(Tot2'),stdError(Tot2'),'k','linewidth',2)


figure
colors=jet(22);
fr=[]; nofr=[];
for m=1:22
    plot(Spectro{3},(Freezing{m,1}),'color','k'), hold on
    fr=[fr;(Freezing{m,1})];
    plot(Spectro{3},(Freezing{m,2}),'color', 'g'), hold on
    nofr=[nofr;(Freezing{m,2})];
end
xlabel('frequency')
ylabel('power')
box off

figure
shadedErrorBar(Spectro{3},nanmean(fr),[stdError(fr);stdError(fr)])
hold on
g=shadedErrorBar(Spectro{3},nanmean(nofr),[stdError(nofr);stdError(nofr)]);
set(g.patch,'FaceColor',[0.4 1 0.6])
xlabel('frequency')
ylabel('power')
box off

figure
errorbar(Spectro{3}(1:8:end),nanmean(fr(1:11,1:8:end)),stdError(fr(1:11,1:8:end)),'k','linewidth',2)
hold on
errorbar(Spectro{3}(1:8:end),nanmean(fr(12:22,1:8:end)),stdError(fr(12:22,1:8:end)),'color',[ 0.5 0.5 0.5],'linewidth',2)
errorbar(Spectro{3}(1:8:end),nanmean(nofr(1:11,1:8:end)),stdError(nofr(1:11,1:8:end)),'color',[ 0 0.5 0],'linewidth',2)
hold on
errorbar(Spectro{3}(1:8:end),nanmean(nofr(12:22,1:8:end)),stdError(nofr(12:22,1:8:end)),'color',[ 0 0.8 0],'linewidth',2)
legend({'Sham Fz','OBX Fz','Sham NoFz','OBX NoFz'})

xlabel('frequency')
ylabel('power')
box off

figure
subplot(121)
a=reshape([AllSpec{1,:}],263,5);
for k=2:22
    try
        temp=reshape([AllSpec{k,:}],263,5);
        a=a+temp;
    end
end
imagesc([1:5],Spectro{3},zscore(a)), axis xy
xlabel('Proportion of time in freezing')
set(gca,'XTick',[1:5],'XTickLabel',{'1/5','2/5','3/5','4/5','5/5'})
ylabel('Frequency')
colormap(jet)
subplot(122)
plot(nanmean(Tot1'),'k','linewidth',2)
errorbar([1:5],nanmean(Tot1'),stdError(Tot1'),'k','linewidth',2)
xlabel('Proportion of time in freezing')
ylabel('Power')
set(gca,'XTick',[1:5],'XTickLabel',{'1/5','2/5','3/5','4/5','5/5'})


figure
subplot(121)
a=reshape([AllSpec2{1,:}],263,13);
for k=2:22
try
  temp=reshape([AllSpec2{k,:}],263,13);
      

  for x=1:263
      for y=1:13
  a(x,y)=nansum([a(x,y),temp(x,y)]);
      end
  end
end 
end
 imagesc([1:13],Spectro{3},zscore(a)), axis xy
 colormap(jet)
 xlim([0.5 12.5])
 xlabel('CS num')
ylabel('Frequency')
colormap(jet)
subplot(122)
plot(nanmean(Tot11'),'k','linewidth',2),hold on
errorbar([1:12],nanmean(Tot11'),stdError(Tot11'),'k','linewidth',2)
 xlabel('CS num')
ylabel('Power')



% figure
% subplot(121)
% FirstSec=FirstSec(:,[1:12]);
clear TableBeg TableLast
taille=size(FirstSec{1,1});
TableBeg=zeros(taille(1),263);
TableLast=zeros(taille(1),263);
for k=1:22
    for l=1:size(FirstSec,2)
        if not(isempty(FirstSec{k,l})) %not((isempty(FirstSec{k,l})) | (k==17 & l==1))
        if isnan(FirstSec{k,l})
        else
            temp=FirstSec{k,l};
            TableBeg=TableBeg+temp;
        end
        end
    end
    for j=1:size(LastSec,2)
        if not(isempty(LastSec{k,j}))
            if isnan(LastSec{k,j})
            else
                temp2=LastSec{k,j};
                TableLast=TableLast+temp2;
            end
        end
    end
end
figure
subplot(2,1,1)
imagesc([-taille(1)/2:taille(1)/2],Spectro{3},TableBeg'),axis xy
subplot(2,1,2)
imagesc([-taille(1)/2:taille(1)/2],Spectro{3},TableLast'),axis xy
colormap(jet)
