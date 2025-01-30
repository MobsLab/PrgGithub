clear AllDat
SessionType={'SoundHab','SoundCond','SoundTest'};
for sess=1:3
    Dir=PathForExperimentsEmbReact(SessionType{sess});
    mouse=0;
    for mm=1:length(Dir.path)
        cd(Dir.path{mm}{1})
        
        if exist('HeartBeatInfo.mat')
            load('behavResources_SB.mat')
            Epoch{1}=intervalSet(TTLInfo.CSPlusTimes-30*1e4,TTLInfo.CSPlusTimes+30*1e4);
            Epoch{2}=intervalSet(TTLInfo.CSMoinsTimes-30*1e4,TTLInfo.CSMoinsTimes+30*1e4);
            
            load('HeartBeatInfo.mat')
            mouse=mouse+1;
            for ep=1:2
                for s=1:length(Start(Epoch{ep}))
                    Dat=Data(Restrict(EKG.HBRate,subset(Epoch{ep},s)));
                    tps=Range(Restrict(EKG.HBRate,subset(Epoch{ep},s)),'s')-Start(subset(Epoch{ep},s),'s')-30;
                    AllDat.Heart.(SessionType{sess}){ep}(s,mouse,:)=interp1(tps,Dat,[-29:0.3:29]);
                    Dat=Data(Restrict(Behav.Imdifftsd,subset(Epoch{ep},s)));
                    tps=Range(Restrict(Behav.Imdifftsd,subset(Epoch{ep},s)),'s')-Start(subset(Epoch{ep},s),'s')-30;
                    AllDat.Speed.(SessionType{sess}){ep}(s,mouse,:)=interp1(tps,Dat,[-29:0.3:29]);
                end
            end
            
            
            load('InstFreqAndPhase_B.mat')
            for ep=1:2
                for s=1:length(Start(Epoch{ep}))
                    Dat=Data(Restrict(LocalFreq.WV,subset(Epoch{ep},s)));
                    tps=Range(Restrict(LocalFreq.WV,subset(Epoch{ep},s)),'s')-Start(subset(Epoch{ep},s),'s')-30;
                    AllDat.Respi.(SessionType{sess}){ep}(s,mouse,:)=interp1(tps,Dat,[-29:0.3:29]);
                end
            end
        end
        
    end
end


close all
figure(1)
figure(2)
figure(3)
for sess=1:3
    for ep=1:2
        figure(1)
        subplot(3,2,(sess-1)*2+ep)
        Dat=reshape(AllDat.Heart.(SessionType{sess}){ep},size(AllDat.Heart.(SessionType{sess}){ep},1)*6,194);
        dat=mean(Dat(:,1:50)')';
        Dat=sortrows([dat,Dat]);
        if sess==2 & ep==1
            Dat(:,140:153)=NaN;
        end
        Dat(:,1)=[];
        imagesc([-29:0.3:29],1:size(Dat,2),Dat), clim([6 14.5]);
        figure(2)
        subplot(3,2,(sess-1)*2+ep)
        Dat2=reshape(AllDat.Speed.(SessionType{sess}){ep},size(AllDat.Speed.(SessionType{sess}){ep},1)*6,194);
        Dat2=sortrows([dat,Dat2]);
        if sess==2 & ep==1
            Dat2(:,140:153)=NaN;
        end
        Dat2(:,1)=[];
        imagesc([-29:0.3:29],1:size(Dat,2),nanzscore(Dat2')'),clim([-3 3])
        figure(3)
        subplot(3,2,(sess-1)*2+ep)
        Dat2=reshape(AllDat.Respi.(SessionType{sess}){ep},size(AllDat.Respi.(SessionType{sess}){ep},1)*6,194);
        Dat2=sortrows([dat,Dat2]);
        if sess==2 & ep==1
            Dat2(:,140:153)=NaN;
        end
        Dat2(:,1)=[];
        imagesc([-29:0.3:29],1:size(Dat,2),Dat2),clim([1 12])
    end
end

for sess=1:3
figure
subplot(311)
g=shadedErrorBar([-29:0.3:29],(squeeze(mean(mean(AllDat.Heart.(SessionType{sess}){2})))),(stdError(squeeze((mean(AllDat.Heart.(SessionType{sess}){2}))))),'b')
hold on
g=shadedErrorBar([-29:0.3:29],(squeeze(mean(mean(AllDat.Heart.(SessionType{sess}){1})))),(stdError(squeeze((mean(AllDat.Heart.(SessionType{sess}){1}))))),'r')
title('Heart Rate')
subplot(312)
g=shadedErrorBar([-29:0.3:29],(squeeze(mean(mean(AllDat.Speed.(SessionType{sess}){2})))),(stdError(squeeze((mean(AllDat.Speed.(SessionType{sess}){2}))))),'b')
hold on
g=shadedErrorBar([-29:0.3:29],(squeeze(mean(mean(AllDat.Speed.(SessionType{sess}){1})))),(stdError(squeeze((mean(AllDat.Speed.(SessionType{sess}){1}))))),'r')
title('Speed')
subplot(313)
g=shadedErrorBar([-29:0.3:29],runmean(squeeze(mean(mean(AllDat.Respi.(SessionType{sess}){2}))),2),runmean(stdError(squeeze((mean(AllDat.Respi.(SessionType{sess}){2})))),2),'b')
hold on
g=shadedErrorBar([-29:0.3:29],runmean(squeeze(mean(mean(AllDat.Respi.(SessionType{sess}){1}))),2),runmean(stdError(squeeze((mean(AllDat.Respi.(SessionType{sess}){1})))),2),'r')
title('Resp')
end

