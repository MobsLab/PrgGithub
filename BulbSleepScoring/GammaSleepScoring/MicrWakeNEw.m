%% New code for microarousals
close all;clear all;
EMGmice;

%% OB microawakenings
% Look at EMG activity distribution
for mm=1:m
    mm
    cd (filename{mm,1})
    load('StateEpochEMGSB.mat','EMGData','EMG_thresh','SWSEpoch','REMEpoch')
    load('TransLimsEMG.mat')
    
    TotalEpoch=intervalSet(0,max(Range(EMGData)));
    Wake=thresholdIntervals(EMGData,EMG_thresh);
    Sleep=thresholdIntervals(EMGData,X1,'Direction','Below');
    Sleep=mergeCloseIntervals(Sleep,10*1e4);
    IsMA=[];
    for k=1:length(Start(Wake))
        BeforeEp=intervalSet(Start(subset(Wake,k))-15*1e4,Start(subset(Wake,k)));
        AfterEp=intervalSet(Stop(subset(Wake,k)),Stop(subset(Wake,k))+15*1e4);
        IsMA(k)=(length(Range(Restrict(EMGData,And(Sleep,subset(Wake,k)))))==length(Range(Restrict(EMGData,subset(Wake,k)))))...
            *(length(Range(Restrict(EMGData,And(Sleep,AfterEp))))==length(Range(Restrict(EMGData,AfterEp))))...
            *(length(Range(Restrict(EMGData,And(Sleep,BeforeEp))))==length(Range(Restrict(EMGData,And(Sleep,BeforeEp)))));
    end
    MicroWake=subset(Wake,find(IsMA));
    MicroWake=mergeCloseIntervals(MicroWake,5*1e4);
    
    
    load('StateEpochSB.mat','smooth_ghi','gamma_thresh')
    GammWake=thresholdIntervals(smooth_ghi,gamma_thresh);
    GammaAgree=[];
    for k=1:length(Start(MicroWake))
        GammaAgree(k)=length(Range(Restrict(EMGData,And(subset(MicroWake,k),GammWake))))*(mean(diff(Range(smooth_ghi))));
    end
    
    load('H_Low_Spectrum.mat')
    Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
    DelBand=[find(Spectro{3}>2,1,'first'):find(Spectro{3}>5,1,'first')];
    ThetBand=[find(Spectro{3}>6,1,'first'):find(Spectro{3}>8,1,'first')];
    rr=1;rrr=1;
    ss=1;sss=1;
    Type{1,mm}=[]; ValBA{1,mm}=[];
    for k=1:length(Start(MicroWake))
        tempEp=intervalSet(Start(subset(MicroWake,k))-5*1e4,Start(subset(MicroWake,k))+5*1e4);
        tempEpB=intervalSet(Start(subset(MicroWake,k))-5*1e4,Start(subset(MicroWake,k)));
        tempEpA=intervalSet(Start(subset(MicroWake,k)),Start(subset(MicroWake,k))+5*1e4);
        if sum(Stop(And(tempEp,REMEpoch))-Start(And(tempEp,REMEpoch)))>sum(Stop(And(tempEp,SWSEpoch))-Start(And(tempEp,SWSEpoch)))
            if GammaAgree(k)/1e4>3
                AllSpRA{ss}=Data(Restrict(Sptsd,tempEp));
                Type{1,mm}(k)=1;
                tempDat=Data(Restrict(Sptsd,tempEpB));
                ValBA{1,mm}(k,1)=mean(mean(tempDat(:,ThetBand)));
                tempDat=Data(Restrict(Sptsd,tempEpA));
                ValBA{1,mm}(k,2)=mean(mean(tempDat(:,ThetBand)));
                ss=ss+1;
            else
                AllSpRD{sss}=Data(Restrict(Sptsd,tempEp));
                Type{1,mm}(k)=2;
                tempDat=Data(Restrict(Sptsd,tempEpB));
                ValBA{1,mm}(k,1)=mean(mean(tempDat(:,ThetBand)));
                tempDat=Data(Restrict(Sptsd,tempEpA));
                ValBA{1,mm}(k,2)=mean(mean(tempDat(:,ThetBand)));
                sss=sss+1;
            end
        else
            if GammaAgree(k)/1e4>3
                AllSpSA{rr}=Data(Restrict(Sptsd,tempEp));
                Type{1,mm}(k)=3;
                tempDat=Data(Restrict(Sptsd,tempEpB));
                ValBA{1,mm}(k,1)=mean(mean(tempDat(:,DelBand)));
                tempDat=Data(Restrict(Sptsd,tempEpA));
                ValBA{1,mm}(k,2)=mean(mean(tempDat(:,DelBand)));
                rr=rr+1;
            else
                AllSpSD{rrr}=Data(Restrict(Sptsd,tempEp));
                Type{1,mm}(k)=4;
                tempDat=Data(Restrict(Sptsd,tempEpB));
                ValBA{1,mm}(k,1)=mean(mean(tempDat(:,DelBand)));
                tempDat=Data(Restrict(Sptsd,tempEpA));
                ValBA{1,mm}(k,2)=mean(mean(tempDat(:,DelBand)));
                rrr=rrr+1;
            end
        end
    end
    
    MeanAllSpRA{1,mm}=zeros(50,263);    MeanAllSpRD{1,mm}=zeros(50,263);
    MeanAllSpSA{1,mm}=zeros(50,263);    MeanAllSpSD{1,mm}=zeros(50,263);
    for i=1:ss-1,MeanAllSpRA{1,mm}=MeanAllSpRA{1,mm}+AllSpRA{i} ;end
    for i=1:sss-1,MeanAllSpRD{1,mm}=MeanAllSpRD{1,mm}+AllSpRD{i} ;end
    for i=1:rr-1,MeanAllSpSA{1,mm}=MeanAllSpSA{1,mm}+AllSpSA{i} ;end
    for i=1:rrr-1,MeanAllSpSD{1,mm}=MeanAllSpSD{1,mm}+AllSpSD{i} ;end
    dt=(mean(diff(Range(Sptsd,'s'))));
    figure
    for t=1:50
        MeanAllSpRA{1,mm}(t,:)= MeanAllSpRA{1,mm}(t,:).*Spectro{3};
        MeanAllSpRD{1,mm}(t,:)= MeanAllSpRD{1,mm}(t,:).*Spectro{3};
        MeanAllSpSA{1,mm}(t,:)= MeanAllSpSA{1,mm}(t,:).*Spectro{3};
        MeanAllSpSD{1,mm}(t,:)= MeanAllSpSD{1,mm}(t,:).*Spectro{3};
    end
    subplot(221)
    imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpRA{1,mm})'), axis xy
    c1=caxis;
    subplot(222)
    imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpRD{1,mm})'), axis xy
    c2=caxis;
    caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
    subplot(221)
    caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
    subplot(223)
    imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpSA{1,mm})'), axis xy
    c1=caxis;
    subplot(224)
    imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpSD{1,mm})'), axis xy
    c2=caxis
    caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
    subplot(223)
    caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
    
    if exist('PFC_Low_Spectrum.mat')>0
        load('PFC_Low_Spectrum.mat')
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        
        rr=1;rrr=1;
        ss=1;sss=1;
        Type{2,mm}=[]; ValBA{2,mm}=[];
        for k=1:length(Start(MicroWake))
            tempEp=intervalSet(Start(subset(MicroWake,k))-5*1e4,Start(subset(MicroWake,k))+5*1e4);
            tempEpB=intervalSet(Start(subset(MicroWake,k))-5*1e4,Start(subset(MicroWake,k)));
            tempEpA=intervalSet(Start(subset(MicroWake,k)),Start(subset(MicroWake,k))+5*1e4);
            if sum(Stop(And(tempEp,REMEpoch))-Start(And(tempEp,REMEpoch)))>sum(Stop(And(tempEp,SWSEpoch))-Start(And(tempEp,SWSEpoch)))
                if GammaAgree(k)/1e4>3
                    AllSpRA{ss}=Data(Restrict(Sptsd,tempEp));
                    Type{2,mm}(k)=1;
                    tempDat=Data(Restrict(Sptsd,tempEpB));
                    ValBA{2,mm}(k,1)=mean(mean(tempDat(:,ThetBand)));
                    tempDat=Data(Restrict(Sptsd,tempEpA));
                    ValBA{2,mm}(k,2)=mean(mean(tempDat(:,ThetBand)));
                    ss=ss+1;
                else
                    AllSpRD{sss}=Data(Restrict(Sptsd,tempEp));
                    Type{2,mm}(k)=2;
                    tempDat=Data(Restrict(Sptsd,tempEpB));
                    ValBA{2,mm}(k,1)=mean(mean(tempDat(:,ThetBand)));
                    tempDat=Data(Restrict(Sptsd,tempEpA));
                    ValBA{2,mm}(k,2)=mean(mean(tempDat(:,ThetBand)));
                    sss=sss+1;
                end
            else
                if GammaAgree(k)/1e4>3
                    AllSpSA{rr}=Data(Restrict(Sptsd,tempEp));
                    Type{2,mm}(k)=3;
                    rr=rr+1;
                    tempDat=Data(Restrict(Sptsd,tempEpB));
                    ValBA{2,mm}(k,1)=mean(mean(tempDat(:,DelBand)));
                    tempDat=Data(Restrict(Sptsd,tempEpA));
                    ValBA{2,mm}(k,2)=mean(mean(tempDat(:,DelBand)));
                else
                    AllSpSD{rrr}=Data(Restrict(Sptsd,tempEp));
                    Type{2,mm}(k)=4;
                    rrr=rrr+1;
                    tempDat=Data(Restrict(Sptsd,tempEpB));
                    ValBA{2,mm}(k,1)=mean(mean(tempDat(:,DelBand)));
                    tempDat=Data(Restrict(Sptsd,tempEpA));
                    ValBA{2,mm}(k,2)=mean(mean(tempDat(:,DelBand)));
                end
            end
        end
        
        MeanAllSpRA{2,mm}=zeros(50,263);    MeanAllSpRD{2,mm}=zeros(50,263);
        MeanAllSpSA{2,mm}=zeros(50,263);    MeanAllSpSD{2,mm}=zeros(50,263);
        for i=1:ss-1,MeanAllSpRA{2,mm}=MeanAllSpRA{2,mm}+AllSpRA{i} ;end
        for i=1:sss-1,MeanAllSpRD{2,mm}=MeanAllSpRD{2,mm}+AllSpRD{i} ;end
        for i=1:rr-1,MeanAllSpSA{2,mm}=MeanAllSpSA{2,mm}+AllSpSA{i} ;end
        for i=1:rrr-1,MeanAllSpSD{2,mm}=MeanAllSpSD{2,mm}+AllSpSD{i} ;end
        dt=(mean(diff(Range(Sptsd,'s'))));
        figure
        for t=1:50
            MeanAllSpRA{2,mm}(t,:)= MeanAllSpRA{2,mm}(t,:).*Spectro{3};
            MeanAllSpRD{2,mm}(t,:)= MeanAllSpRD{2,mm}(t,:).*Spectro{3};
            MeanAllSpSA{2,mm}(t,:)= MeanAllSpSA{2,mm}(t,:).*Spectro{3};
            MeanAllSpSD{2,mm}(t,:)= MeanAllSpSD{2,mm}(t,:).*Spectro{3};
        end
        subplot(221)
        imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpRA{2,mm})'), axis xy
        c1=caxis;
        subplot(222)
        imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpRD{2,mm})'), axis xy
        c2=caxis;
        caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
        subplot(221)
        caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
        subplot(223)
        imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpSA{2,mm})'), axis xy
        c1=caxis;
        subplot(224)
        imagesc([-5:dt:5-dt],Spectro{3},(MeanAllSpSD{2,mm})'), axis xy
        c2=caxis
        caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
        subplot(223)
        caxis([min([c1(1),c2(1)]) max(([c1(2),c2(2)]))])
    end
    
    figure
    subplot(131)
    hist((Stop(MicroWake,'s')-Start(MicroWake,'s')),50)
    hold on
    plot(mean((Stop(subset(MicroWake,find(Type{2,mm}==3 | Type{2,mm}==4)),'s')-Start(subset(MicroWake,find(Type{2,mm}==3 | Type{2,mm}==4)),'s'))),10,'b*')
    plot(mean((Stop(subset(MicroWake,find(Type{2,mm}==1 | Type{2,mm}==2)),'s')-Start(subset(MicroWake,find(Type{2,mm}==1 | Type{2,mm}==2)),'s'))),10,'r*')
    subplot(132)
    plot((Stop(subset(MicroWake,find(Type{2,mm}==3 | Type{2,mm}==4)),'s')-Start(subset(MicroWake,find(Type{2,mm}==3 | Type{2,mm}==4)),'s')),GammaAgree(find(Type{2,mm}==3| Type{2,mm}==4))/1e4,'k*'), hold on
    title([num2str(sum(Type{2,mm}==4)) 'vs' num2str(sum(Type{2,mm}==3))])
    subplot(133)
    plot((Stop(subset(MicroWake,find(Type{2,mm}==1 | Type{2,mm}==2)),'s')-Start(subset(MicroWake,find(Type{2,mm}==1 | Type{2,mm}==2)),'s')),GammaAgree(find(Type{2,mm}==1 | Type{2,mm}==2))/1e4,'r*')
    title([num2str(sum(Type{2,mm}==2)) 'vs' num2str(sum(Type{2,mm}==1))])
    
    
end

figure
for mm=1:m
    for k=1:4
        subplot(2,2,k)
        plot(ValBA{1,mm}(Type{1,mm}==k,:)'./mean(mean(ValBA{1,mm})),'k'), hold on
    end
end

for k=1:4,Dat{k}=[];end
for mm=1:m
    for k=1:4
        
        Dat{k}=[Dat{k};(ValBA{1,mm}(Type{1,mm}==k,2)-ValBA{1,mm}(Type{1,mm}==k,1))./(ValBA{1,mm}(Type{1,mm}==k,2)+ValBA{1,mm}(Type{1,mm}==k,1))];
        
    end
end

Titres={'Rem Agree','Rem Disagree','SWS Agree','SWS Disagree'};
Xlab={'MI Theta','MI Theta','MI Delta','MI Delta'}
figure
for k=1:4
    subplot(1,4,k)
    plotSpread(Dat{k})
    hold on
    line([-1 3],[0 0],'color','k')
    ylim([-1 1])
    title(Titres{k})
    ylabel(Xlab{k})
end
% 
% for k=1:16
%     
%     saveas(k,['fig' num2str(k) '.fig'])
% end



clear Temp
for k=1:4,Temp{k}=zeros(50,263);end
for mm=1:m
    Temp{1}=Temp{1}+reshape(zscore(MeanAllSpRA{1,mm}(:)),50,263);
    Temp{2}=Temp{2}+reshape(zscore(MeanAllSpRD{1,mm}(:)),50,263);
    Temp{3}=Temp{3}+reshape(zscore(MeanAllSpSA{1,mm}(:)),50,263);
    Temp{4}=Temp{4}+reshape(zscore(MeanAllSpSD{1,mm}(:)),50,263);
end
figure
for k=1:4
    subplot(2,2,k)
    imagesc([-5:dt:5-dt],Spectro{3},Temp{k}'), axis xy
end


clear Temp
for k=1:4,Temp{k}=zeros(50,263);end
for mm=1:4
    Temp{1}=Temp{1}+reshape(zscore(MeanAllSpRA{1,mm}(:)),50,263);
    Temp{2}=Temp{2}+reshape(zscore(MeanAllSpRD{1,mm}(:)),50,263);
    Temp{3}=Temp{3}+reshape(zscore(MeanAllSpSA{1,mm}(:)),50,263);
    Temp{4}=Temp{4}+reshape(zscore(MeanAllSpSD{1,mm}(:)),50,263);
end
figure
for k=1:4
    subplot(2,2,k)
    imagesc([-5:dt:5-dt],Spectro{3},Temp{k}'), axis xy
end

for k=1:20
    
    saveas(k,['fig' num2str(k) '.fig'])
end


