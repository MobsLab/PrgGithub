clear all, close all
uiopen('/media/DataMOBsRAID/ProjetAversion/ManipNov15Bulbectomie/Hyperactivity/Hyperactivity_5_for_paper.fig',1)
h=gcf;axesObjs = get(h, 'Children');dataObjs = get(axesObjs, 'Children');

%% Make bokplot versions
figure
CTRLEarly = dataObjs{1}(8).YData/100;
CTRLLate = dataObjs{1}(6).YData/100;
OBXEarly = dataObjs{1}(7).YData/100;
OBXLate = dataObjs{1}(5).YData/100;

Vals = {CTRLEarly'; OBXEarly'; CTRLLate'; OBXLate'};
XPos = [1.1,1.9,3.5,4.4];

Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.8 0.8],[1 0.4 0.4]};

A = Vals;
Legends = {'Sham','OBX','Sham','OBX'};
X = [1 2 4 5];
figure
MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends,1,0)
ylabel('Travelled distance(m)')

box off

%% figure for correlation hyperactivity

figure,plot(dataObjs{2}.XData,dataObjs{2}.YData*100,'.','color','k','MarkerSize',30)
hold on
plot(dataObjs{2}.XData,dataObjs{2}.YData*100,'.','color',[0.6,0.6,0.6]*ColFact(1),'MarkerSize',20)
box off
set(gca,'FontSize',18,'linewidth',1.5)
ylabel('% time freezing')
xlabel('Travelled distance in open field')
xlim([0 4500])
ylim([-10 80])



figure,plot(dataObjs{3}.XData,dataObjs{3}.YData*100,'.','color','k','MarkerSize',30)
hold on
plot(dataObjs{3}.XData,dataObjs{3}.YData*100,'.','color',[0.6,0.6,0.6]*ColFact(2),'MarkerSize',20)
box off
set(gca,'FontSize',18,'linewidth',1.5)
ylabel('% time freezing')
xlabel('Travelled distance in open field')
xlim([0 4500])
ylim([-10 80])
