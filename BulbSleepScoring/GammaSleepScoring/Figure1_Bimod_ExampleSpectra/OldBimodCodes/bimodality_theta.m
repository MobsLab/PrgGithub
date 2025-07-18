%% Evaluate bimodality of distribution
struc={'B','H','Pi','PF','Pa','PFSup','PaSup','Amyg'};
clear todo chan dataexis
m=1;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[1,10,NaN,4,13,6,2,NaN];

m=2;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[2,9,NaN,10,7,8,3,NaN];

m=3;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[6,10,NaN,5,13,1,7,NaN];

m=4;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,1,1,1];
chan(m,:)=[15,6,0,4,9,12,NaN,3];

m=5;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,0,0,1];
chan(m,:)=[11,2,12,8,4,15,NaN,15];
rgstd=[0.5,0.75,1,1.25,1.5,1.75,2,2.25,2.5,2.75,3,3.25,3.5,3.75,4,4.25,4.5,4.75,5];

for file=1:5
    file
    cd(filename2{file})
    load(strcat('LFPData/LFP',num2str(chan(file,2)),'.mat'));
    load('StateEpochSB.mat');
    rg=Range(LFP);
    TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
    try
        load('behavResources.mat','PreEpoch');
        TotalEpoch=And(TotalEpoch,PreEpoch);
    end
    
    FilTheta=FilterLFP(LFP,[5 10],1024);
    FilDelta=FilterLFP(LFP,[3 6],1024);
    FilTheta=Restrict(FilTheta,TotalEpoch);
    FilDelta=Restrict(FilDelta,TotalEpoch);
    HilTheta=hilbert(Data(FilTheta));
    HilDelta=hilbert(Data(FilDelta));
    H=abs(HilDelta);
    H(H<100)=100;
    ThetaRatio=abs(HilTheta)./H;
    rgThetaRatio=Range(FilTheta,'s');
    ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
    smrange=[0.5,1,2,4,6,8,10,12,15,17,20,22,24,26,30];
    smfact=floor(smrange/median(diff(Range(ThetaRatioTSD,'s'))));
    cc=jet(length(smfact));
    clear smooth_theta_hil
    clear FilTheta FilDelta HilTheta HilDelta ThetaRatio
    
    %         for i=1:length(smfact)
    %             i
    %             smooth_theta_hil{i}=tsd(Range(ThetaRatioTSD),smooth(Data(ThetaRatioTSD),smfact(i)));
    %         end
    %         save('bimoddiffmethodstheta.mat','smooth_theta_hil','-v7.3')
    
    
    figure(1),figure(2), figure(3), figure(4),figure(5),figure(6)
    
    for i=1:length(smfact)
        i
        clear smooth_theta_hil
        smooth_theta_hil{i}=tsd(Range(ThetaRatioTSD),smooth(Data(ThetaRatioTSD),smfact(i)));
        mn=mean(Data(smooth_theta_hil{i}));
        st=std(Data(smooth_theta_hil{i}));
        
        for k=1:length(rgstd)
            Ep=thresholdIntervals(smooth_theta_hil{i},mn+st*rgstd(k));
            Ep=mergeCloseIntervals(Ep,0.2*1e4);
            disttime{file,k,i}=Stop(Ep)-Start(Ep);
        end
        
        [Y,X]=hist(log(Data(smooth_theta_hil{i})),700);
        figure(1)
        plot(X,Y/sum(Y),'color',cc(i,:))
        hold on
        [cf2,goodness2]=createFit2gauss(X,Y/sum(Y));
        [cf1,goodness1]=createFit1gauss(X,Y/sum(Y));
        % goodness of fits
        rms{file,1}(i,1)=goodness1.sse;
        rms{file,1}(i,2)=goodness2.sse;
        rms{file,1}(i,3)=goodness1.rsquare;
        rms{file,1}(i,4)=goodness2.rsquare;
        rms{file,1}(i,5)=goodness1.adjrsquare;
        rms{file,1}(i,6)=goodness2.adjrsquare;
        rms{file,1}(i,7)=goodness1.rmse;
        rms{file,1}(i,8)=goodness2.rmse;
        
        % distance between peaks
        a= coeffvalues(cf2);
        dist{file,1}(i,1)=abs(a(2)-a(5));
        b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
        dist{file,1}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
        
        % overlap
        d=([min(X):max(X)/1000:max(X)]);
        Y1=normpdf(d,a(2),a(3));
        Y2=normpdf(d,a(5),a(6));
        dist{file,1}(i,3)=sum(min(Y1,Y2)/sum(Y2));
        dist{file,1}(i,4)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
        coeff{file,1}(i,1:6)=a;
        coeff{file,1}(i,7:8)=intersect_gaussians(a(2), a(5), a(3), a(6));
%         figure(2)
%         subplot(3,4,i)
%         plot(X,Y/sum(Y))
%         hold on
%         h_ = plot(cf2,'fit',0.95);
%         set(h_(1),'Color',[1 0 0],...
%             'LineStyle','-', 'LineWidth',2,...
%             'Marker','none', 'MarkerSize',6);
%         h_ = plot(cf1,'fit',0.95);
%         set(h_(1),'Color',[0 1 0],...
%             'LineStyle','-', 'LineWidth',2,...
%             'Marker','none', 'MarkerSize',6);
%         h=legend({})
%         delete(h)
%         title(num2str(smrange(i)))
%         
        %Just sleep
        [Y,X]=hist(log(Data(Restrict(smooth_theta_hil{i},And(TotalEpoch,sleepper)))),700);
        figure(3)
        plot(X,Y/sum(Y),'color',cc(i,:))
        hold on
        [cf2,goodness2]=createFit2gauss(X,Y/sum(Y));
        [cf1,goodness1]=createFit1gauss(X,Y/sum(Y));
        % goodness of fits
        rms{file,2}(i,1)=goodness1.sse;
        rms{file,2}(i,2)=goodness2.sse;
        rms{file,2}(i,3)=goodness1.rsquare;
        rms{file,2}(i,4)=goodness2.rsquare;
        rms{file,2}(i,5)=goodness1.adjrsquare;
        rms{file,2}(i,6)=goodness2.adjrsquare;
        rms{file,2}(i,7)=goodness1.rmse;
        rms{file,2}(i,8)=goodness2.rmse;
        
        % distance between peaks
        a= coeffvalues(cf2);
        dist{file,2}(i,1)=abs(a(2)-a(5));
        b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
        dist{file,2}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
        
        % overlap
        d=([min(X):max(X)/1000:max(X)]);
        Y1=normpdf(d,a(2),a(3));
        Y2=normpdf(d,a(5),a(6));
        dist{file,2}(i,3)=sum(min(Y1,Y2)/sum(Y2));
        dist{file,2}(i,4)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
        coeff{file,2}(i,1:6)=a;
        coeff{file,2}(i,7:8)=intersect_gaussians(a(2), a(5), a(3), a(6));
%         figure(4)
%         subplot(3,4,i)
%         plot(X,Y/sum(Y))
%         hold on
%         h_ = plot(cf2,'fit',0.95);
%         set(h_(1),'Color',[1 0 0],...
%             'LineStyle','-', 'LineWidth',2,...
%             'Marker','none', 'MarkerSize',6);
%         h_ = plot(cf1,'fit',0.95);
%         set(h_(1),'Color',[0 1 0],...
%             'LineStyle','-', 'LineWidth',2,...
%             'Marker','none', 'MarkerSize',6);
%         h=legend({})
%         delete(h)
%         title(num2str(smrange(i)))
        
        %Just wak
        [Y,X]=hist(log(Data(Restrict(smooth_theta_hil{i},And(TotalEpoch,wakeper)))),700);
        figure(5)
        plot(X,Y/sum(Y),'color',cc(i,:))
        hold on
        [cf2,goodness2]=createFit2gauss(X,Y/sum(Y));
        [cf1,goodness1]=createFit1gauss(X,Y/sum(Y));
        % goodness of fits
        rms{file,3}(i,1)=goodness1.sse;
        rms{file,3}(i,2)=goodness2.sse;
        rms{file,3}(i,3)=goodness1.rsquare;
        rms{file,3}(i,4)=goodness2.rsquare;
        rms{file,3}(i,5)=goodness1.adjrsquare;
        rms{file,3}(i,6)=goodness2.adjrsquare;
        rms{file,3}(i,7)=goodness1.rmse;
        rms{file,3}(i,8)=goodness2.rmse;
        
        % distance between peaks
        a= coeffvalues(cf2);
        dist{file,3}(i,1)=abs(a(2)-a(5));
        b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
        dist{file,3}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
        
        % overlap
        d=([min(X):max(X)/1000:max(X)]);
        Y1=normpdf(d,a(2),a(3));
        Y2=normpdf(d,a(5),a(6));
        dist{file,3}(i,3)=sum(min(Y1,Y2)/sum(Y2));
        dist{file,3}(i,4)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
        coeff{file,3}(i,1:6)=a;
        coeff{file,3}(i,7:8)=intersect_gaussians(a(2), a(5), a(3), a(6));
%         figure(6)
%         subplot(3,4,i)
%         plot(X,Y/sum(Y))
%         hold on
%         h_ = plot(cf2,'fit',0.95);
%         set(h_(1),'Color',[1 0 0],...
%             'LineStyle','-', 'LineWidth',2,...
%             'Marker','none', 'MarkerSize',6);
%         h_ = plot(cf1,'fit',0.95);
%         set(h_(1),'Color',[0 1 0],...
%             'LineStyle','-', 'LineWidth',2,...
%             'Marker','none', 'MarkerSize',6);
%         h=legend({})
%         delete(h)
%         title(num2str(smrange(i)))
        
    end
    saveas(1,'DistribsSuperposedTheta.png')
    saveas(1,'DistribsSuperposedTheta.fig')
%     saveas(2,'DistribsFitTheta.png')
%     saveas(2,'DistribsFitTheta.fig')
    saveas(3,'DistribsSuperposedThetaS.png')
    saveas(3,'DistribsSuperposedThetaS.fig')
%     saveas(4,'DistribsFitThetaS.png')
%     saveas(4,'DistribsFitThetaS.fig')
    saveas(5,'DistribsSuperposedThetaW.png')
    saveas(5,'DistribsSuperposedThetaW.fig')
%     saveas(6,'DistribsFitThetaW.png')
%     saveas(6,'DistribsFitThetaW.fig')
    
    
    close(1), close(2), close(3), close(4),close(5), close(6)
end
cd /home/mobs/Documents/
save('bimodHPC.mat','rms','dist','coeff','disttime')

%%%%%
figure
x=smrange;                 %#initialize x array

subplot(321)
clear a
for g=1:5
    a(g,:)=rms{g,3}(:,3);
end
y1=mean(a(2:end,:))-std(mean(a(2:end,:))/sqrt(5))                   %#create first curve
y2=mean(a(2:end,:))+std(mean(a(2:end,:))/sqrt(5))                   %#create second curve
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(x,mean(a(2:end,:)),'r','linewidth',3)
box off
title('R² Single gaussian fit')
ylim([0.75 1.1])

% for i=1:length(smrange)
%     p(i)=ranksum(a(2:end,i),a(2:end,end));
% end
% mn=mean(a(2:end,:));
% plot(smrange(find(p>0.05,1,'first')),mn(find(p>0.05,1,'first'))*1,'k*')
%
subplot(322)
clear a
for g=1:5
    a(g,:)=rms{g,3}(:,4);
end
y1=mean(a(2:end,:))-std(mean(a(2:end,:))/sqrt(5))                   %#create first curve
y2=mean(a(2:end,:))+std(mean(a(2:end,:))/sqrt(5))                   %#create second curve
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(x,mean(a(2:end,:)),'r','linewidth',3)
box off
title('R² Double gaussian fit')
ylim([0.75 1.1])
% for i=1:length(smrange)
%     p(i)=ranksum(a(2:end,i),a(2:end,end));
% end
% mn=mean(a(2:end,:));
% plot(smrange(find(p>0.05,1,'first')),mn(find(p>0.05,1,'first'))*1,'k*')

subplot(323)
clear a
for g=1:5
    a(g,:)=dist{g,3}(:,3);
end
y1=mean(a(2:end,:))-std(mean(a(2:end,:))/sqrt(5))                   %#create first curve
y2=mean(a(2:end,:))+std(mean(a(2:end,:))/sqrt(5))                   %#create second curve
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(x,mean(a(2:end,:)),'r','linewidth',3)
box off
title('Overlap of distributions')
% for i=1:length(smrange)
%     p(i)=ranksum(a(2:end,i),a(2:end,end));
% end
% mn=mean(a(2:end,:));
% plot(smrange(find(p>0.05,1,'first')),mn(find(p>0.05,1,'first'))*1,'k*')


subplot(324)
clear a
d=[3:0.0075:10];
for g=1:5
    minvals=(coeff{g,3}(:,7:8)');
    cotokeep(1,:)=minvals(1,:)>coeff{g,3}(:,2)';
    cotokeep(2,:)=minvals(2,:)>coeff{g,3}(:,2)';
    tokeep=find(cotokeep==1);
    minvals=minvals(tokeep);
    for i=1:length(smrange)
        Y1=normpdf(d,coeff{g,3}(i,2),coeff{g,3}(i,3));
        Y1=Y1/sum(Y1);
        Y2=normpdf(d,coeff{g,3}(1,5),coeff{g,3}(1,6));
        Y2=Y2/sum(Y2);
        alt=Y1(find(d>minvals(i),1,'first'));
        a(g,i)=(abs(max(Y2)-alt)+abs(max(Y1)-alt));
    end
end
y1=mean(a(2:end,:))-std(mean(a(2:end,:))/sqrt(5))                   %#create first curve
y2=mean(a(2:end,:))+std(mean(a(2:end,:))/sqrt(5))                   %#create second curve
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(x,mean(a(2:end,:)),'r','linewidth',3)
box off
title('Peak to valley')
% for i=1:length(smrange)
%     p(i)=ranksum(a(2:end,i),a(2:end,end));
% end
% mn=mean(a(2:end,:));
% plot(smrange(find(p>0.05,1,'first')),mn(find(p>0.05,1,'first'))*1,'k*')


subplot(325)
clear a
for g=1:5
    a(g,:)=dist{g,3}(:,4);
end
y1=mean(a(2:end,:))-std(mean(a(2:end,:))/sqrt(5))                   %#create first curve
y2=mean(a(2:end,:))+std(mean(a(2:end,:))/sqrt(5))                   %#create second curve
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(x,mean(a(2:end,:)),'r','linewidth',3)
box off
title('Ashman''s D')
% for i=1:length(smrange)
%     p(i)=ranksum(a(2:end,i),a(2:end,end));
% end
% mn=mean(a(2:end,:));
% plot(smrange(find(p>0.05,1,'first')),mn(find(p>0.05,1,'first'))*1,'k*')

subplot(326)
clear a
for g=1:5
    a(g,:)=dist{g,3}(:,1);
end
y1=mean(a(2:end,:))-std(mean(a(2:end,:))/sqrt(5))                   %#create first curve
y2=mean(a(2:end,:))+std(mean(a(2:end,:))/sqrt(5))                   %#create second curve
X=[x,fliplr(x)];                %#create continuous x value array for plotting
Y=[y1,fliplr(y2)];              %#create y values for out and then back
f=fill(X,Y,'b');
set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
hold on
plot(x,mean(a(2:end,:)),'r','linewidth',3)
box off
title('Distance between peaks')
% for i=1:length(smrange)
%     p(i)=ranksum(a(2:end,i),a(2:end,end));
% end
% mn=mean(a(2:end,:));
% plot(smrange(find(p>0.05,1,'first')),mn(find(p>0.05,1,'first'))*1,'k*')
%


%
%
%
%     dist{file}(i,1)=abs(a(2)-a(5));
%     b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
%     dist{file}(i,2)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
%
%     % overlap
%     d=([min(X):max(X)/1000:max(X)]);
%     Y1=normpdf(d,a(2),a(3));
%     Y2=normpdf(d,a(5),a(6));
%     dist{file}(i,3)=sum(min(Y1,Y2)/sum(Y2));
%     dist{file}(i,4)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
%     coeff{file}(i,1:6)=a;


%% file - rgstd - smoo
figure
smoo=2;
file=1;
Ytot=[];residtot=[];
for smoo=1:5
    for k=1:8
        good=0;
        for file=1:5
            [Y,X]=hist(disttime{file,k,smoo}/1e4,[0:0.1:5]);
            subplot(5,8,k+(smoo-1)*8)
            plot(X,Y/sum(Y),'color',[0.4 0.4 0.9])
            [cf_,goodness,x_,resid]=ExpFIt(X,Y/sum(Y));
            hold on
            h=plot(cf_);
            set(h,'color','k')
            plot(x_,resid,'color',[0.8 0.6 0.8])
            residtot(:,file)=resid;
good=good+goodness.rsquare;
h=legend({});
            delete(h)
            xlim([0 5])
            Ytot=[Ytot;Y/sum(Y)];
        end
        subplot(5,8,k+(smoo-1)*8)
        
        y1=nanmean(residtot')-(nanstd(residtot'))/sqrt(5);
        y2=nanmean(residtot')+(nanstd(residtot'))/sqrt(5);
        X=[x_',fliplr(x_')];                %#create continuous x value array for plotting
        Y=[y1,fliplr(y2)];              %#create y values for out and then back
        f=fill(X,Y,'b');
        set(f,'FaceColor',[0.8 0.8 0.8],'EdgeColor',[0.8 0.8 0.8])
        hold on
        plot(x_,nanmean(residtot'),'color',[1 0.5 0.2],'linewidth',3)
        box off
        ylim([-0.1 0.3])   
        title(num2str(good/5))
    end
end
