clear all, close all
%% Average spectra for all three states + levels of anesthesia

ExperimentNames{1} = 'BaselineSleep';
ExperimentNames{2} = 'Isoflurane_08';
ExperimentNames{3} = 'Isoflurane_10';
ExperimentNames{4} = 'Isoflurane_12';
ExperimentNames{5} = 'Isoflurane_15';
ExperimentNames{6} = 'Isoflurane_18';
ExperimentNames{7} = 'Ketamine';

Structures = {'B','P','H'};

FreqBand = {'High','Low'};

for exp = 7:length(ExperimentNames)
    Dir = PathForExperimentsAnesthesia(ExperimentNames{exp});
    
    for k = 1 : length(Dir.path)
        
        cd(Dir.path{k}{1})
        
        % load all the spectra
        load('B_High_Spectrum.mat')
        Sptsd.B.High=tsd(Spectro{2}*1e4,Spectro{1});
%         load('H_High_Spectrum.mat')
%         Sptsd.H.High=tsd(Spectro{2}*1e4,Spectro{1});
%         load('PFCx_High_Spectrum.mat')
%         Sptsd.P.High=tsd(Spectro{2}*1e4,Spectro{1});
        FHigh = Spectro{3};

        load('B_Low_Spectrum.mat')
        Sptsd.B.Low=tsd(Spectro{2}*1e4,Spectro{1});
%         load('H_Low_Spectrum.mat')
%         Sptsd.H.Low=tsd(Spectro{2}*1e4,Spectro{1});
%         load('PFCx_Low_Spectrum.mat')
%         Sptsd.P.Low=tsd(Spectro{2}*1e4,Spectro{1});
        FLow = Spectro{3};

        clear Epoch
        load('StateEpochSB.mat','Epoch');
        
        if exp ==1
            
            % For sleep session, separate sleep and wake
            load('StateEpochSB.mat','Sleep','Wake');
            for st = 1%length(Structures)
                for f = 1:length(FreqBand)
                    Spectr.(Structures{st}).(FreqBand{f}){exp}{1}(k,:) = nanmean(Data(Restrict(Sptsd.(Structures{st}).(FreqBand{f}),and(Sleep,Epoch))));
                    if f==2
                        LowPow = Data(Sptsd.(Structures{st}).Low);
                        Lim = prctile(nanmean(LowPow(:,1:10)'),95);
                        LowPow = tsd(Range(Sptsd.(Structures{st}).Low), nanmean(LowPow(:,1:10)')');
                        LimEpoch = thresholdIntervals(LowPow,Lim,'Direction','Below');
                        Spectr.(Structures{st}).(FreqBand{f}){exp}{2}(k,:) = nanmean(Data(Restrict(Sptsd.(Structures{st}).(FreqBand{f}),and(Wake,and(LimEpoch,Epoch)))));
                    else
                        Spectr.(Structures{st}).(FreqBand{f}){exp}{2}(k,:) = nanmean(Data(Restrict(Sptsd.(Structures{st}).(FreqBand{f}),and(Wake,(Epoch)))));
                        
                    end
                end
            end
            
        elseif exp == 7
            
            % For ketamine experiment, take only the part when mouse is
            % properly anesthesized
             KetEp = intervalSet(60*60*1e4,60*120*1e4);
             for st = 1%:length(Structures)
                for f = 1:length(FreqBand)
                    Spectr.(Structures{st}).(FreqBand{f}){exp}{1}(k,:) = nanmean(Data(Restrict(Sptsd.(Structures{st}).(FreqBand{f}),and(Epoch,KetEp))));
                end
            end
            
            
        else
            
            for st = 1%:length(Structures)
                for f = 1:length(FreqBand)
                    Spectr.(Structures{st}).(FreqBand{f}){exp}{1}(k,:) = nanmean(Data(Restrict(Sptsd.(Structures{st}).(FreqBand{f}),and(Epoch,intervalSet(0,580*1e4)))));
                end
            end
            
        end
        
    end
end


clf
% 
% 
% for k = 1:4
%     figure
% cols = jet(5);
% for st = 1:length(Structures)
%     for exp = 2:6
%         subplot(2,3,st)
%         plot(FHigh,Spectr.(Structures{st}).(FreqBand{1}){exp}{1}(k,:),'linewidth',2,'color',cols(exp-1,:)), hold on
%         title(Structures{st})
%         subplot(2,3,st+3)
%         plot(FLow,Spectr.(Structures{st}).(FreqBand{2}){exp}{1}(k,:),'linewidth',2,'color',cols(exp-1,:)), hold on
%     end
% end
% legend({'08','10','12','15','18'})
% end
% 



% log
figure
cols = jet(5);
smo=8;
clf
for st = 1:length(Structures)
    
    subplot(3,2,(st-1)*2+1), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
        plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])

    subplot(3,2,(st-1)*2+2), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
        plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])

    for exp = 2:6
        subplot(3,2,(st-1)*2+1), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        subplot(3,2,(st-1)*2+2), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        
    end
end


for st = 1:length(Structures)
    
    for exp = 1
        subplot(3,2,(st-1)*2+2), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{2})),smo),runmean(stdError(log((Spectr.(Structures{st}).(FreqBand{1}){exp}{2}))),smo));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(log((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=[0.6 0.6 0.6];
        
        subplot(3,2,(st-1)*2+1), hold on
        g=shadedErrorBar(FLow,nanmean(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{2})),stdError(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{2})));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FLow,nanmean(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=[0.6 0.6 0.6];
        title(Structures{st})
        
    end
    
    
    
    
end


for st = 1:length(Structures)
  
    for exp = 2:6
        subplot(3,2,(st-1)*2+2), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(log((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=cols(exp-1,:);
        subplot(3,2,(st-1)*2+1), hold on
        g=shadedErrorBar(FLow,nanmean(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=cols(exp-1,:);
        title(Structures{st})

    end
        subplot(3,2,(st-1)*2+2), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([20 100])
        subplot(3,2,(st-1)*2+1), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([0 20])
    legend({'Wk','Sl','08','10','12','15','18'})    
end



% no log
figure
cols = jet(5);
smo=1;
clf
for st = 1:length(Structures)
    
    subplot(3,2,(st-1)*2+1), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
        plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])

    subplot(3,2,(st-1)*2+2), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
        plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])

    for exp = 2:6
        subplot(3,2,(st-1)*2+1), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        subplot(3,2,(st-1)*2+2), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        
    end
end

for st = 1:length(Structures)
    
    for exp = 1
        subplot(3,2,(st-1)*2+2), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{2})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{2}))),smo));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=[0.6 0.6 0.6];
        
        subplot(3,2,(st-1)*2+1), hold on
        g=shadedErrorBar(FLow,nanmean((Spectr.(Structures{st}).(FreqBand{2}){exp}{2})),stdError((Spectr.(Structures{st}).(FreqBand{2}){exp}{2})));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FLow,nanmean((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=[0.6 0.6 0.6];
        title(Structures{st})
        
    end
    
    
    
    
end


for st = 1:length(Structures)
  
    for exp = 2:6
        subplot(3,2,(st-1)*2+2), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=cols(exp-1,:);
        subplot(3,2,(st-1)*2+1), hold on
        g=shadedErrorBar(FLow,nanmean((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=cols(exp-1,:);
        title(Structures{st})

    end
        subplot(3,2,(st-1)*2+2), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([20 100])
        subplot(3,2,(st-1)*2+1), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([0 20])
    legend({'Wk','Sl','08','10','12','15','18'})

    
end




% Just OB
for st=1 :3
    figure
    cols = jet(5);
    smo=4;
    clf
    
    subplot(121), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])
    
    subplot(122), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])
    
    for exp = 2:6
        subplot(121), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        subplot(122), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        
    end
    
    
    
    for exp = 1
        
        subplot(121), hold on
        g=shadedErrorBar(FLow,nanmean((Spectr.(Structures{st}).(FreqBand{2}){exp}{2})),stdError((Spectr.(Structures{st}).(FreqBand{2}){exp}{2})));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FLow,nanmean((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=[0.6 0.6 0.6];
        title(Structures{st})
        
        
        subplot(122), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{2})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{2}))),smo));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=[0.6 0.6 0.6];
        
        
        
        
    end
    
    for exp = 2:6
        subplot(121), hold on
        g=shadedErrorBar(FLow,nanmean((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError((Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=cols(exp-1,:);
        subplot(122), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=cols(exp-1,:);
        
    end
    subplot(121), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([0 20])
    legend({'Wk','Sl','08','10','12','15','18'})
    subplot(122), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([20 100])
    
    
    
end

figure
st=1;
plot(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){1}{2})),smo),'color',[0.8 0.8 0.8],'linewidth',3);
hold on
plot(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){1}{1})),smo),'color',[0.6 0.6 0.6],'linewidth',3);
for exp = 2:6
    plot(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),'color',cols(exp-1,:),'linewidth',3);
end
plot(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){7}{1})),smo),'color','r','linewidth',3);

figure
st=1;
plot(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){1}{2})),smo),'color',[0.8 0.8 0.8],'linewidth',5);
hold on
plot(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){1}{1})),smo),'color',[0.6 0.6 0.6],'linewidth',5);
for exp = 2:6
    plot(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),'color',cols(exp-1,:),'linewidth',5);
end
plot(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){7}{1})),smo),'--','color','r','linewidth',5);


% Structures one by one = log
for st=1 :3
    figure
    cols = jet(5);
    smo=4;
    clf
    
    subplot(121), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])
    
    subplot(122), hold on
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
    plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])
    
    for exp = 2:6
        subplot(121), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        subplot(122), hold on
        plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:))
        
    end
    
    
    
    for exp = 1
        
        subplot(121), hold on
        g=shadedErrorBar(FLow,nanmean(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{2})),stdError(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{2})));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FLow,nanmean(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=[0.6 0.6 0.6];
        title(Structures{st})
        
        
        subplot(122), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{2})),smo),runmean(stdError(log((Spectr.(Structures{st}).(FreqBand{1}){exp}{2}))),smo));
        g.patch.FaceColor=[0.8 0.8 0.8];
        g=shadedErrorBar(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(log((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=[0.6 0.6 0.6];
        
        
        
        
    end
    
    for exp = 2:6
        subplot(121), hold on
        g=shadedErrorBar(FLow,nanmean(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})),stdError(log(Spectr.(Structures{st}).(FreqBand{2}){exp}{1})));
        g.patch.FaceColor=cols(exp-1,:);
        subplot(122), hold on
        g=shadedErrorBar(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(log((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
        g.patch.FaceColor=cols(exp-1,:);
        
    end
    subplot(121), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([0 20])
    legend({'Wk','Sl','08','10','12','15','18'})
    subplot(122), hold on
    box off
    set(gca,'linewidth',2,'FontSize',12)
    ylabel('Power'), xlabel('Frequency (Hz)')
    xlim([20 100])
    
    
    
end

%% figure for paper

for k= 1 :4
    meanval(k) = nanmean(runmean((Spectr.(Structures{1}).(FreqBand{1}){1}{1}(k,:)),smo));
    
end

figure
st=1;
plot(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){1}{2})),smo),'color',[0.8 0.8 0.8],'linewidth',5);
hold on
plot(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){1}{1})),smo),'color',[0.6 0.6 0.6],'linewidth',5);
for exp = 2:6
    plot(FHigh,runmean(nanmean(log(Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),'color',cols(exp-1,:),'linewidth',5);
end
plot(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){7}{1})),smo),':','color','r','linewidth',5);

figure
cols = jet(5);
smo=4;
clf
hold on
% for the legend
plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.6 0.6 0.6])
plot([-5:-1],[-5:-1],'linewidth',2,'color',[0.8 0.8 0.8])

for exp = 2:6
    plot([-5:-1],[-5:-1],'linewidth',2,'color',cols(exp-1,:)) 
end
plot(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){7}{1})),smo),':','color','r','linewidth',5);

exp = 1;
for k = 1:4,SpecTesmp(k,:) = (Spectr.(Structures{st}).(FreqBand{1}){exp}{2}(k,:));end
g=shadedErrorBar(FHigh,runmean(nanmean(SpecTesmp),smo),runmean(stdError(SpecTesmp),smo));
g.patch.FaceColor=[0.8 0.8 0.8];
g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
g.patch.FaceColor=[0.6 0.6 0.6];


for exp = 2:6
    
    g=shadedErrorBar(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){exp}{1})),smo),runmean(stdError(((Spectr.(Structures{st}).(FreqBand{1}){exp}{1}))),smo));
    g.patch.FaceColor=cols(exp-1,:);
    
end
plot(FHigh,runmean(nanmean((Spectr.(Structures{st}).(FreqBand{1}){7}{1})),smo),':','color','r','linewidth',5);

box off
set(gca,'linewidth',2,'FontSize',12)
ylabel('Power'), xlabel('Frequency (Hz)')
xlim([20 100])
    legend({'Wake','Sleep','Iso-0.8%','Iso-1%','Iso-1.2%','Iso-1.5%','Iso-1.8%','Ketamine'})
