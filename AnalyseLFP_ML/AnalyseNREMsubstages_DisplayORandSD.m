% AnalyseNREMsubstages_DisplayORandSD.m
%
% list of related scripts in NREMstages_scripts.m



% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< MANUAL INPUTS <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%doExp=1; % SD24h
doExp=2; % SD6h
%doExp=3; % OR

t_step=120*60;
%t_step=60*60; % in second (default 1h)
%t_step=30*60; % in second

savFigure=0;
donoise=1; % to include noise within WAKE periods

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<< INITIATE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

analyFolder='/media/DataMOBsRAIDN/ProjetNREM/AnalysisNREM';
if doExp==1
    analyname='AnalyNREMsubstagesSD24h';
    saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/SleepDeprivation';
elseif doExp==2
    analyname='AnalyNREMsubstagesSD6h';
    saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/SleepDeprivation';
elseif doExp==3
    analyname='AnalyNREMsubstagesOR';
    saveFolder='/media/DataMOBsRAIDN/ProjetNREM/Figures/ObjectRecognition';
end
FigName= analyname(19:end);

% name of expe to load    
nam={'',''};
if floor(t_step/3600)~=0, nam{1}=sprintf('%dh',floor(t_step/3600));else,nam{2}='min';end 
if rem(t_step,3600)~=0,nam{2}=[sprintf('%d',floor(rem(t_step,3600)/60)),nam{2}];end
analyname=[analyname,'_',nam{1},nam{2},'Step'];
FigName=[FigName,'_',nam{1},nam{2}];

if donoise, analyname=[analyname,'_Wnz'];FigName=[FigName,'W'];end
saveFolder=[saveFolder,'/',analyname];

if ~exist(saveFolder,'dir'), mkdir(saveFolder);end
if savFigure, disp(['saving figures in ',saveFolder]);end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<< LOAD DATA IF EXIST <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

try
    clear durEp Epochs
    load([analyFolder,'/',analyname,'.mat']);
    Epochs;
    disp([analyname,'.mat already exists... loaded.'])
catch
    error([analyname,'.mat does not exist. Run first'])
end


% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< DISPLAY ZT RESULTS INDIV <<<<<<<<<<<<<<<<<<<<<<<<<<<
colori=[0.5 0.2 0.1;0 0.6 0 ;0.6 0.2 0.9 ;1 0.7 1 ; 0.8 0.2 0.8; 0 0 0.5; 0 0 0.5; 0 0 1];

NameSess={'BSL','PostSD','+24h'};
Nmice=2:8;
L=3; % 3 to include expe at +24h
Rainbo=[0 0 0;1 0 0; 1 0.5 0; 0.9 0.9 0; 0 0.5 0; 0 1 1; 0 0 1; 0.5 0 0.5];
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
% plot indiv data
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.85 0.85]), numF1=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.85 0.85]), numF2=gcf;
durEp=durEp(ismember(durEp(:,1),Nmice),:);
for n=1:6
    Mt=[]; Ms=[];
    for i=1:L
        ind1=find(durEp(:,2)==i & durEp(:,3)==n);
        ind2=find(durEp(:,2)==i & durEp(:,3)==7);%total time
        ind3=find(durEp(:,2)==i & durEp(:,3)==8);%SLEEP
        Mt=[Mt,100*durEp(ind1,4:end)./durEp(ind2,4:end)];
        if n==1, Ms=[Ms,100*durEp(ind3,4:end)./durEp(ind2,4:end)];
        else, Ms=[Ms,100*durEp(ind1,4:end)./durEp(ind3,4:end)]; end
    end
    figure(numF1),subplot(6,1,n),PP=plot([1:size(Mt,2)]*t_step/3600,Mt','.-','Linewidth',1.2);
    for pp=1:size(Mt,1), PP(pp).Color=Rainbo(pp,:);end
    ylabel({Stages{n},'(%rec)'},'Color',colori(n,:))
    hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
    line([24.5,24.5],ylim,'Color','k','Linewidth',1.5);
    if doExp==2, line([24.5+6,24.5+6],ylim,'Color','k','Linewidth',1.5);end
    legend(nameMouse(Nmice),'Location','BestOutside');
    
    figure(numF2),subplot(6,1,n),PP=plot([1:size(Ms,2)]*t_step/3600,Ms','.-','Linewidth',1.2);
    for pp=1:size(Ms,1), PP(pp).Color=Rainbo(pp,:);end
    ylabel({Stages{n},'(%sleep)'},'Color',colori(n,:))
    if n==1, ylabel({'SLEEP','(%sleep)'},'Color','b');end
    hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
    line([24.5,24.5],ylim,'Color','k','Linewidth',1.5);
    if doExp==2, line([24.5+6,24.5+6],ylim,'Color','k','Linewidth',1.5);end
    legend(nameMouse(Nmice),'Location','BestOutside');
end
figure(numF1),xlabel('ZT Time (h)');subplot(6,1,1),
text(24,1.2*max(ylim),FigName(1:5)); if doExp==1,text(24,1.1*max(ylim),'V'); end
text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})
if savFigure, saveFigure(numF1.Number,[FigName,'-IndivEvol-DurationTotal'],saveFolder);end

figure(numF2),xlabel('ZT Time (h)');subplot(6,1,1),
text(24,1.2*max(ylim),FigName(1:5)); if doExp==1,text(24,1.1*max(ylim),'V'); end
text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})
if savFigure, saveFigure(numF2.Number,[FigName,'-IndivEvol-DurationSleep'],saveFolder);end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<< DISPLAY ZT RESULTS POOLED <<<<<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.7 0.7]), numF1=gcf;
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.7 0.7]), numF2=gcf;
clear MAtMt
for n=1:6
    clear Mt1 Mt2 Mt3 Ms1 Ms2 Ms3 
    for i=1:L
        ind1=find(durEp(:,2)==i & durEp(:,3)==n);
        ind2=find(durEp(:,2)==i & durEp(:,3)==7);%total time
        ind3=find(durEp(:,2)==i & durEp(:,3)==8);%SLEEP
        Mt=100*durEp(ind1,4:end)./durEp(ind2,4:end);
        Ms=100*durEp(ind1,4:end)./durEp(ind3,4:end);
        if n==1, Ms=100*durEp(ind3,4:end)./durEp(ind2,4:end);end
        
        if i==1, colo=[0 0 0]; elseif i==2, colo=colori(n,:);  else, colo=[0.5 0.5 0.5]; end
        
        figure(numF1),subplot(2,3,n), hold on,
        errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(Mt,1),stdError(Mt),'Linewidth',2,'Color',colo);
        
        figure(numF2),subplot(2,3,n), hold on,
        if i==2 && n==1, colo=[0 0 1];end  
        if i==2 && doExp==2, Ms(:,1:6/(t_step/3600))=nan;end
        eval(sprintf('Mt%d=Mt; Ms%d=Ms;',i,i));
        errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(Ms,1),stdError(Ms),'Linewidth',2,'Color',colo);
        if n==1, plot([1:24/(t_step/3600)]*t_step/3600,sum(~isnan(Ms),1),'.-','Color',colo);end% n across ZT
        
        MAtMt{n,i}=Mt;
    end
    ylim([0 100]); if ismember(n,[2,3,5]), ylim([0 40]); elseif n==4, ylim([40 80]);elseif n==6, ylim([60 100]);end
    %stats
    pvalt1=nan(1,24/(t_step/3600)); pvalt2=pvalt1; pvalt3=pvalt1;
    pvals1=nan(1,24/(t_step/3600)); pvals2=pvals1; pvals3=pvals1;
    for k=1:24/(t_step/3600)
        if 1
            namtest='signrank BSL-SD';
            try pt1=signrank(Mt1(:,k),Mt2(:,k));end; try ps1=signrank(Ms1(:,k),Ms2(:,k));end
            try pt2=signrank(Mt1(:,k),Mt3(:,k));end; try ps2=signrank(Ms1(:,k),Ms3(:,k));end
            try pt3=signrank(Mt2(:,k),Mt3(:,k));end; try ps2=signrank(Ms2(:,k),Ms3(:,k));end
        else
            namtest='ttest BSL-SD';
            try [h,pt1]=ttest2(Mt1(:,k),Mt2(:,k));end; try [h,ps1]=ttest2(Ms1(:,k),Ms2(:,k));end
            try [h,pt2]=ttest2(Mt1(:,k),Mt3(:,k));end; try [h,ps2]=ttest2(Ms1(:,k),Ms3(:,k));end
            try [h,pt3]=ttest2(Mt2(:,k),Mt3(:,k));end; try [h,ps3]=ttest2(Ms2(:,k),Ms3(:,k));end
        end
        try if pt1<0.05, pvalt1(k)=max(ylim);end; end
        try if ps1<0.05, pvals1(k)=max(ylim);end; end
        try if pt2<0.05, pvalt2(k)=0.95*max(ylim);end; end
        try if ps2<0.05, pvals2(k)=0.93*max(ylim);end;end
        try if pt3<0.05, pvalt3(k)=0.90*max(ylim);end; end
        try if ps3<0.05, pvals3(k)=0.86*max(ylim);end; end
    end
    
    figure(numF1),xlim([0 25]); xlabel('ZT Time (h)'); ylabel('% total rec');
    title(sprintf([Stages{n},' (n=%d)'],length(~isnan(nanmean(Mt,2)))),'Color',colori(n,:))
    plot([1:24/(t_step/3600)]*t_step/3600,pvalt1,'*r')
    try plot([1:24/(t_step/3600)]*t_step/3600,pvalt2,'*m'); end
    try plot([1:24/(t_step/3600)]*t_step/3600,pvalt3,'*','Color',[1 0.7 0]);end
    line([12.5 12.5],ylim,'Color',[0.5 0.5 0.5])
    
    figure(numF2),xlim([0 25]); xlabel('ZT Time (h)'); ylabel('% sleep');
    title(sprintf([Stages{n},' (n=%d)'],length(~isnan(nanmean(Ms,2)))),'Color',colori(n,:))
    if n==1, title(sprintf(['SLEEP (n=%d)'],length(~isnan(nanmean(Ms,2)))),'Color','b'); ylabel('% total rec');end
    plot([1:24/(t_step/3600)]*t_step/3600,pvals1,'*r')
    try plot([1:24/(t_step/3600)]*t_step/3600,pvals2,'*m'); end
    try plot([1:24/(t_step/3600)]*t_step/3600,pvals3,'*','Color',[1 0.7 0]);end
    line([12.5 12.5],ylim,'Color',[0.5 0.5 0.5])
    
end
legend([NameSess(1:L),namtest,'BSL-24h','SD-24h'],'Location','Best')
figure(numF1),legend([NameSess(1:L),namtest,'BSL-24h','SD-24h'],'Location','Best')
% save Figure
if savFigure, saveFigure(numF1.Number,[FigName,'-BilanEvol-DurationTotal'],saveFolder);end
if savFigure, saveFigure(numF2.Number,[FigName,'-BilanEvol-DurationSleep'],saveFolder);end

%% <<<<<<<<<<<<<<<<<<<<< DISPLAY LOG RATIO <<<<<<<<<<<<<<<<<<<<<<<
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.7 0.7]), numIndiv=gcf; colormap gray
figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.7 0.7]), numBilan=gcf; colormap gray
for n=1:6
    M=MAtMt{n,2}./MAtMt{n,1};
    figure(numIndiv), subplot(2,3,n), bar(log(M)');
    title(Stages{n},'Color',colori(n,:))
    figure(numBilan), subplot(2,3,n), bar(nanmean(log(M),1));
    hold on, errorbar(1:size(MAtMt{n,1},2),nanmean(log(M),1),stdError(log(M)),'+k')
    title(Stages{n},'Color',colori(n,:))
    set(gca,'Xtick',1:size(MAtMt{n,1},2)), set(gca,'XtickLabel',[1:24/(t_step/3600)]*t_step/3600)
    xlim([0 size(MAtMt{n,1},2)+1]); xlabel('ZT (h)')
end

% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<< DISPLAY INDIV RESULTS SWA <<<<<<<<<<<<<<<<<<<<<<<<<<
L=3;
SW=SW(ismember(SW(:,1),Nmice),:);
for stru=1:length(nameStru)
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.1 0.2 0.55 0.85]), numF=gcf;
    for n=1:6
        M=[];
        for i=1:L
            M=[M,SW(find(SW(:,2)==i & SW(:,3)==n & SW(:,4)==stru),7:end)];
        end
        %hold off;
        subplot(6,1,n), 
        PP=plot([1:size(M,2)]*t_step/3600,M','.-','Linewidth',1.2);ylabel({Stages{n},nameStru{stru}},'Color',colori(n,:))
        for pp=1:size(M,1), PP(pp).Color=Rainbo(pp,:);end
        hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
        line([24.5,24.5],ylim,'Color','k','Linewidth',1.5);
        if doExp==2,line([24.5+6,24.5+6],ylim,'Color','k','Linewidth',1.5);end
        legend(nameMouse(Nmice),'Location','BestOutside')
    end
    xlabel('ZT Time (h)');subplot(6,1,1),
    text(24,1.2*max(ylim),FigName(1:5)); if doExp==1,text(24,1.1*max(ylim),'V'); end
    text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})
    if savFigure, saveFigure(numF.Number,[FigName,'-IndivEvol-',nameStru{stru}],saveFolder);end
    
%     close 
%     figure('Color',[1 1 1]);
%     PP=plot([1:size(M,2)]*t_step/3600,M','.-','Linewidth',1.2);ylabel({Stages{n},nameStru{stru}},'Color',colori(n,:))
%     for pp=1:size(M,1), PP(pp).Color=Rainbo(pp,:);end
%     hold on, line(0.5+12*[1:5;1:5],ylim'*ones(1,5),'Color',[0.5 0.5 0.5]); xlim([0.5 72.5])
%     line([24.5,24.5],ylim,'Color','k','Linewidth',1.5); xlabel('ZT Time (h)');
%     legend(nameMouse);text(22,1.2*max(ylim),'24hSD');text(24,1.1*max(ylim),'V');
%     text(5+12*[0:5],1.1*max(ylim)*ones(1,6),{'day','night','day','night','day','night'})
end
% <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<< DISPLAY POOLED RESULTS SWA <<<<<<<<<<<<<<<<<<<<<<<
for stru=[1,5:7]
    figure('Color',[1 1 1],'Unit','Normalized','Position',[0.05 0.1 0.7 0.7]); numF2(stru)=gcf; a=0;
    for n=[2:6,8]
        a=a+1;
        clear M1 M2 M3
        for i=1:L
            M=SW(find(SW(:,2)==i & SW(:,3)==n & SW(:,4)==stru),7:end);
            if i==1, colo=[0 0 0]; elseif i==2, colo=colori(n,:);  else, colo=[0.5 0.5 0.5]; end
            if doExp==2 && i==2, M(:,1:6/(t_step/3600))=nan;end
            eval(sprintf('M%d=M; ',i));
            subplot(2,3,a), hold on,
            errorbar([1:24/(t_step/3600)]*t_step/3600,nanmean(M,1),stdError(M),'Linewidth',2,'Color',colo);
            if stru==1; ylim([0 2]);end; if stru>4; ylim([-2 3]);end
        end
        
        %stats
        pvalt1=nan(1,24/(t_step/3600)); pvalt2=pvalt1; pvalt3=pvalt1;
        for k=1:24/(t_step/3600)
            if 0
                namtest='signrank';
                try pt1=signrank(M1(:,k),M2(:,k));end; 
                try pt2=signrank(M1(:,k),M3(:,k));end; 
                try pt3=signrank(M2(:,k),M3(:,k));end; 
            else
                namtest='ttest';
                try [h,pt1]=ttest2(M1(:,k),M2(:,k));end;
                try [h,pt2]=ttest2(M1(:,k),M3(:,k));end; 
                try [h,pt3]=ttest2(M2(:,k),M3(:,k));end; 
            end
            if pt1<0.05, pvalt1(k)=max(ylim);end; 
            if pt2<0.05, pvalt2(k)=0.93*max(ylim);end; 
            if pt3<0.05, pvalt3(k)=0.86*max(ylim);end; 
        end
        
        xlim([0 25]); xlabel('ZT Time (h)'); ylabel(nameStru{stru});
        title(sprintf([Stages{n},' (n=%d)'],length(~isnan(nanmean(M,2)))),'Color',colori(n,:))
        plot([1:24/(t_step/3600)]*t_step/3600,pvalt1,'*r')
        plot([1:24/(t_step/3600)]*t_step/3600,pvalt2,'*','Color',[1 0.2 0.8])
        plot([1:24/(t_step/3600)]*t_step/3600,pvalt3,'*r','Color',[1 0.5 0.2])
        line([12.5 12.5],ylim,'Color',[0.5 0.5 0.5])
    end
    legend([NameSess(1:L),{[namtest,' B/P']},'B/+24h','P/+24h'],'Location','Best')
    % save Figure
    if savFigure, saveFigure(numF2(stru).Number,[FigName,'-BilanEvol-',nameStru{stru}],saveFolder);end
end




