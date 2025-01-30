function QuandrantExplo


% Compute exploration in quadrant (8 zones of 3hours)
      

disp('pas fini')

Epoch1=subset(QuantifExploEpoch,N);
Epoch2=subset(QuantifExploEpoch,M);
X1=Restrict(X,Epoch1);
Y1=Restrict(Y,Epoch1);
Y2=Restrict(Y,Epoch2);
X2=Restrict(X,Epoch2);


ce=[round((max([Data(X1);Data(X2)])-min([Data(X1);Data(X2)]))/2),round((max([Data(Y1);Data(Y2)])-min([Data(Y1);Data(Y2)]))/2)];
% figure, plot([Data(X1);Data(X2)], [Data(Y1);Data(Y2)]);xlim([0,300]);ylim([0,300]);
% Nfig=gcf;
% [xq,yq]=ginput('limite basse du quadrant',1);
% hold on, plot([ce(1) xq],[ce(2) yq],'r-')
% ok=input('La limite basse du quadrant de stimulation est-elle ok? (o/n)','s');
% 
% while ok~='o'
%     figure(Nfig), plot([Data(X1);Data(X2)], [Data(Y1);Data(Y2)]);xlim([0,300]);ylim([0,300]);
%     [xq,yq]=ginput('limite basse du quadrant',1);
%     hold on, plot([ce(1) xq],[ce(2) yq],'r-')
%     ok=input('La limite basse du quadrant de stimulation est-elle ok? (o/n)','s');
% end  

