%FigBILANObsFreezManipBulbectomie

% 23.12.2014 aims at giving an overview of the behavioral results of Fear Conditionning(oct-nov2014)
% produce a large matrix (color coded) of PSTH (averaged CS-, first CS+, last CS+)

clear 
close all


lim=100; % nb bins
bi=1000; % bin size
smo=1;

cd C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie
list=dir; %list of mouse folders

% Matrix of data; mice in lines
C=[]; % COND
C1=[];% COND  4 first CS+
C2=[]; % COND  remaining CS+
P=[]; % PLETH
P1=[];
P2=[];
E=[]; % ENV B
E1=[];
E2=[];
a=1; %counter for MouseList COND

for i=1:length(list)
    % cd C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION 
    cd C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie
    if list(i).isdir==1&list(i).name(1)~='.'&list(i).name(1)=='M' % if the folder is indeed a mouse name folder
        
        eval(['cd(list(',num2str(i),').name)'])
        
        % store the names of the mice for Y tick labeling
        Mousename=list(i).name;
        %MouseListC{a}=['M' Mousename(6:end)];
        MouseListC{a}=Mousename;
        a=a+1;
        hFigIndiv=figure('Color',[1 1 1]);
        
        listdir=dir;
        % go the the COND folder
        cond_ind=[];
        for j=1:size(listdir,1)
            if ~isempty(strfind(listdir(j).name, 'COND'))
                cond_ind=[cond_ind j];
            end
        end
        
        eval(['cd(listdir(' num2str(cond_ind) ').name)'])
        
        load Behavior.mat
        csp=StimInfo(StimInfo(:,2)==7,1); % times of CS+
        csm=StimInfo(StimInfo(:,2)==5,1); % times of CS-
        
        % compute PSTH
        [m,s,t]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim); 
        [m1,s1,t1]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
        [m2,s2,t2]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim);

        C=[C,m];
        C1=[C1,m1];
        C2=[C2,m2];
        
        subplot(3,1,1);
        PlotPSTH(lim, bi, smo, m,s,t,m1,s1,t1,m2,s2,t2,cd,1)
        ylim([0 40])
        
        cd .. % go backward
        
        % go the the EXTpleth folder
        try
        pleth_ind=[];
        for j=1:size(listdir,1)
            if ~isempty(strfind(listdir(j).name, 'EXTpleth'))
                pleth_ind=[pleth_ind j];
            end
        end

        pleth_ind
        eval(['cd(listdir(' num2str(pleth_ind) ').name)'])
        
        if ((exist('Behavior.mat'))~=0)
            load Behavior.mat
            csp=StimInfo(StimInfo(:,2)==7,1);
            csm=StimInfo(StimInfo(:,2)==5,1);

            [m,s,t]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
            [m1,s1,t1]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
            [m2,s2,t2]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
        else
            m=NaN*ones(size((P),1),1);
            m1=NaN*ones(size((P),1),1);
            m2=NaN*ones(size((P),1),1);
        end
        
        P=[P,m];
        P1=[P1,m1];
        P2=[P2,m2];
        
        subplot(3,1,2);
        PlotPSTH(lim, bi, smo, m,s,t,m1,s1,t1,m2,s2,t2,cd,2)
        ylim([0 10])
        
        end % try pleth
        
        cd ..

          
        % go the the EXTenvB folder
        try
        envB_ind=[];
        for j=1:size(listdir,1)
            if ~isempty(strfind(listdir(j).name, 'EXTenvB')) & isempty(strfind(listdir(j).name, 'EXTenvB2'))
                envB_ind=[envB_ind j];
            end
        end
        
        eval(['cd(listdir(' num2str(envB_ind) ').name)'])
        clear m
        clear m1
        clear m2
        
        load Behavior.mat
        csp=StimInfo(StimInfo(:,2)==7,1);
        csm=StimInfo(StimInfo(:,2)==5,1);

        [m,s,t]=mETAverage(csp(1:4)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
        [m1,s1,t1]=mETAverage(csp(5:end)*1E4,Range(Movtsd),Data(Movtsd),bi,lim);
        [m2,s2,t2]=mETAverage(csm*1E4,Range(Movtsd),Data(Movtsd),bi,lim);

        E=[E,m];
        E1=[E1,m1];
        E2=[E2,m2];
        
        subplot(3,1,3);
        PlotPSTH(lim, bi, smo, m,s,t,m1,s1,t1,m2,s2,t2,cd, 3)
        ylim([0 20])
        
        end % try pleth
        
        cd ..
        set(hFigIndiv,'Position', [1000 80 560 900])
        saveas(hFigIndiv, 'PSTH.fig')
        set(hFigIndiv,'PaperPosition',[0 0 12 20])
        saveas(hFigIndiv, 'PSTH.png')
        end
       
end
% 
% % Sort matrices to correspond to BULBECTOMY (1:7) and SHAM (7:14)
 MouseListC=MouseListC(:,[[1:4] [8:10] [11:14] [5:7]]);
C=C(:,[[1:4] [8:10] [11:14] [5:7]]);
E=E(:,[[1:4] [8:10] [11:14] [5:7]]);
P=P(:,[[1:4] [8:10] [11:14] [5:7]]);

C1=C1(:,[[1:4] [8:10] [11:14] [5:7]]);
E1=E1(:,[[1:4] [8:10] [11:14] [5:7]]);
P1=P1(:,[[1:4] [8:10] [11:14] [5:7]]);

C2=C2(:,[[1:4] [8:10] [11:14] [5:7]]);
E2=E2(:,[[1:4] [8:10] [11:14] [5:7]]);
P2=P2(:,[[1:4] [8:10] [11:14] [5:7]]);



% Figure BILAN
cd ('C:\Users\Clémence\Desktop\chgtordinateur\Fear\DATA-ACQUISITION\ManipBulbectomie\BilanFreezing')
save BulbectomiePSTHdata.mat C E P C1 E1 P1 C2 E2 P2

figure('color',[1 1 1]),
set(gcf, 'Position',[ 8  91  1819 887]);
subplot(3,3,1),imagesc(t/1E3,[1:size(C,2)],C'),ylabel('cs+ (1-4)'),title('Cond'), hold on, line([0 0],[0.5 size(C,2)+0.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
text(-80, -2,'PSTH', 'FontSize', 20)
subplot(3,3,2),imagesc(t/1E3,[1:size(P,2)],P'),title('Plet'), hold on, line([0 0],[0.5 size(P,2)+0.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 size(P,2)+0.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,3),imagesc(t/1E3,[1:size(E,2)],E'),title('EnvB'), hold on, line([0 0],[0.5 size(E,2)+0.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 size(E,2)+0.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)

subplot(3,3,4),imagesc(t1/1E3,[1:size(C,2)],C1'),ylabel('cs+ (end)'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,5),imagesc(t1/1E3,[1:size(C,2)],P1'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,6),imagesc(t1/1E3,[1:size(C,2)],E1'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)

subplot(3,3,7),imagesc(t2/1E3,[1:size(C,2)],C2'),ylabel('cs-'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,8),imagesc(t2/1E3,[1:size(C,2)],P2'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,9),imagesc(t2/1E3,[1:size(C,2)],E2'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
saveas(gcf,'FigBilanMAPFreezing_PSTH.fig')
set(gcf,'PaperPosition',[ 0  0 27 18])
saveas(gcf,'FigBilanMAPFreezing_PSTH.png')

% same figure with zscores
figure('color',[1 1 1]),
set(gcf, 'Position',[ 8  91  1819 887]);
subplot(3,3,1),imagesc(t/1E3,[1:15],zscore(C)'),ylabel('cs+ (1-4)'),title('Cond'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
%set(get(gca,'YLabel'), 'Fontsize',12)
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
text(-80, -2,'PSTH zscores', 'FontSize', 20)
subplot(3,3,2),imagesc(t/1E3,[1:size(C,2)],zscore(P)'),title('Plet'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,3),imagesc(t/1E3,[1:size(C,2)],zscore(E)'),title('EnvB'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)

subplot(3,3,4),imagesc(t1/1E3,[1:size(C,2)],zscore(C1)'),ylabel('cs+ (end)'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,5),imagesc(t1/1E3,[1:size(C,2)],zscore(P1)'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,6),imagesc(t1/1E3,[1:size(C,2)],zscore(E1)'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)

subplot(3,3,7),imagesc(t2/1E3,[1:size(C,2)],zscore(C2)'),ylabel('cs-'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,8),imagesc(t2/1E3,[1:size(C,2)],zscore(P2)'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
subplot(3,3,9),imagesc(t2/1E3,[1:size(C,2)],zscore(E2)'), hold on, line([0 0],[0.5 15.5],'color',[0.7 0.7 0.7]),line([30 30],[0.5 15.5],'color',[0.7 0.7 0.7])
set(gca, 'YTick',[1:length(MouseListC)],'YTickLabel', MouseListC)
saveas(gcf,'FigBilanMAPFreezing_PSTH_zcores.fig')
set(gcf,'PaperPosition',[ 0  0 27 18])
saveas(gcf,'FigBilanMAPFreezing_PSTH_zscores.png')




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Averaging data Pre sound /post sound

Ez=zscore(E);
E1z=zscore(E1);
E2z=zscore(E2);

Ez=(E);
E1z=(E1);
E2z=(E2);
Pz=(P);
P1z=(P1);
P2z=(P2);
Cz=(C);
C1z=(C1);
C2z=(C2);

ColorPSTH={ 'k','r',[1 0.5 0]}; 

post=55:80;
pre=15:40;
%%%%%%%%%%%% CONDITIONING %%%%%%%%%%%%%%
% BULBECTOMIE (1:7)
id=1:5;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t/1E3,nanmean(Cz(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('COND Bulb')
subplot(3,2,3), plot(t/1E3,nanmean(C1z(:,id)'),'linewidth',2,'Color', ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t/1E3,nanmean(C2z(:,id)'),'linewidth',2,'Color', ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(Cz(pre,id))',nanmean(Cz(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(C1z(pre,id))',nanmean(C1z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(C2z(pre,id))',nanmean(C2z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [20 40 300 900]) 
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_COND_Bulb.fig')
saveas(gcf, 'PrePost_COND_Bulb.png')
% SHAM (7:14)
id=6:10;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t/1E3,nanmean(Cz(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('COND Sham')
subplot(3,2,3), plot(t/1E3,nanmean(C1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t/1E3,nanmean(C2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(Cz(pre,id))',nanmean(Cz(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(C1z(pre,id))',nanmean(C1z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(C2z(pre,id))',nanmean(C2z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [320 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_COND_Sham.fig')
saveas(gcf, 'PrePost_COND_Sham.png')

%%%%%%% EXT plethysmo %%%%%%%%%%%%%
% BULBECTOMIE (1:7)
id=1:7;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t/1E3,nanmean(Pz(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('EXT Pleth Bulb')
subplot(3,2,3), plot(t/1E3,nanmean(P1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t/1E3,nanmean(P2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(Pz(pre,id))',nanmean(Pz(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(P1z(pre,id))',nanmean(P1z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(P2z(pre,id))',nanmean(P2z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [620 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTpleth_Bulb.fig')
saveas(gcf, 'PrePost_EXTpleth_Bulb.png')

% SHAM (7:14)
id=7:14;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t/1E3,nanmean(Pz(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'), title('EXT Pleth Sham')
subplot(3,2,3), plot(t/1E3,nanmean(P1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t/1E3,nanmean(P2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(Pz(pre,id))',nanmean(Pz(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(P1z(pre,id))',nanmean(P1z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(P2z(pre,id))',nanmean(P2z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [920 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTpleth_Sham.fig')
saveas(gcf, 'PrePost_EXTpleth_Sham.png')


%%%%%%% EXT environment B %%%%%%%%%%%%%
% BULBECTOMIE (1:7)
id=1:5;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t/1E3,nanmean(Ez(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('EXT envB Bulb')
subplot(3,2,3), plot(t/1E3,nanmean(E1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t/1E3,nanmean(E2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(Ez(pre,id))',nanmean(Ez(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(E1z(pre,id))',nanmean(E1z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(E2z(pre,id))',nanmean(E2z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [1220 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTenvB_Bulb.fig')
saveas(gcf, 'PrePost_EXTenvB_Bulb.png')

% SHAM (7:14)
id=6:10;
figure('color',[1 1 1]), 
subplot(3,2,1), plot(t/1E3,nanmean(Ez(:,id)'),'linewidth',2, 'Color',ColorPSTH{2}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k'),title('EXT envB Sham')
subplot(3,2,3), plot(t/1E3,nanmean(E1z(:,id)'),'linewidth',2, 'Color',ColorPSTH{3}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,5), plot(t/1E3,nanmean(E2z(:,id)'),'linewidth',2, 'Color',ColorPSTH{1}), yl=ylim; hold on, line([0 0],yl,'color','r'), line([30 30],yl,'color','k')
subplot(3,2,2),PlotErrorBar2(nanmean(Ez(pre,id))',nanmean(Ez(post,id))',0);title('cs+ 1-4')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,4),PlotErrorBar2(nanmean(E1z(pre,id))',nanmean(E1z(post,id))',0);title('cs+ 5-end')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
subplot(3,2,6),PlotErrorBar2(nanmean(E2z(pre,id))',nanmean(E2z(post,id))',0);title('cs-')
set(gca,'xtick',[1:2])
set(gca,'xticklabel',{'pre','post'})
ylim([0 10])
set(gcf, 'Position', [1520 40 300 900])
set(gcf,'PaperPosition', [10 10 8 18]);
saveas(gcf, 'PrePost_EXTenvB_Sham.fig')
saveas(gcf, 'PrePost_EXTenvB_Sham.png')

