%CheckAnalyQuantifExplo



%% inputs/ initialization
saveFigures=1;
basename='wideband';
res=pwd;

N=input('give number of quantifExplo: ');

%% loading files and variables
load([res,'/behavResources.mat']);
% clear FinalEpoch
% load([res,'-',basename,'/FinalEpochQuantifExplo',nameQEx,'.mat']);
% disp(['  FinalEpochQuantifExplo',nameQEx,'.mat']);
% 
% 
lis=dir([res,'-',basename]);
for i=3:length(lis)
    filename=lis(i).name;
    if ~isempty(strfind(filename,'QuantifExplo')) && ~isempty(strfind(filename,'-wideband.mat')) && ~exist('ima','var')
        disp(filename)
        load([res,'-',basename,'/',filename],'ima')
    end
end


%% plot figures of QExplo

figure('Color',[1 1 1]), numF=gcf;
subplot(1,2,1), image(ima)
title('QExplo - All Trajectories ')
Y_lim=ylim; X_lim=xlim;

figure('Color',[1 1 1]),numFall=gcf;
for i=N
    
    figure(numF)
    subEpoch=subSet(QuantifExploEpoch,i);
    timeRg=(1:length(Range(Restrict(X,subEpoch))))./(Stop(subEpoch,'s')-Start(subEpoch,'s'));
    
    subplot(1,2,1),
    hold on, plot(Data(Restrict(X,subEpoch)),Data(Restrict(Y,subEpoch)),'k'); 
    
    subplot(1,2,2),
    hold off, scatter(Data(Restrict(X,subEpoch)),Data(Restrict(Y,subEpoch)),15,timeRg,'filled');
    xlim(X_lim);ylim(Y_lim); axis ij
    colorbar;
    
    figure(numFall),
    subplot(2,ceil(length(N)/2),find(N==i)),
    hold off, scatter(Data(Restrict(X,subEpoch)),Data(Restrict(Y,subEpoch)),15,timeRg,'filled');
    xlim(X_lim);ylim(Y_lim); axis ij
    title(['Essais ',num2str(i)]);
    
    ok=input('Press any key to continue','s');
    
    
end



% %% test
% load('/media/DataMOBsRAID5/DataD2/ICSS-Sleep/Mouse026/20120111/ICSS-Mouse-26-11012012-wideband/ICSS-Mouse-26-11012012-03-ICSSallRond-wideband.mat')
% 
% figure,
% subplot(1,2,1), image(ima),
% hold on, scatter(Pos(:,2),Pos(:,3),15,Pos(:,1),'filled')
% hold on, plot(Pos(:,2),Pos(:,3),'k')
% title('from Pos')
% 
% cd('/media/DataMOBsRAID5/DataD2/ICSS-Sleep/Mouse026/20120111/ICSS-Mouse-26-11012012')
% SetCurrentSession('same')
% evt=GetEvents('output','Descriptions');
% Beg_file=GetEvents(evt(strcmp(evt,'beginning of ICSS-Mouse-26-11012012-03-ICSSallRond-wideband')));
% End_file=GetEvents(evt(strcmp(evt,'end of ICSS-Mouse-26-11012012-03-ICSSallRond-wideband')));
% periodFile=intervalSet(Beg_file*1E4,End_file*1E4);
% 
% load('/media/DataMOBsRAID5/DataD2/ICSS-Sleep/Mouse026/20120111/ICSS-Mouse-26-11012012/behavResources.mat')
% 
% subplot(1,2,2), image(ima),
% hold on, scatter(Data(Restrict(X,periodFile)),Data(Restrict(Y,periodFile)),15,Range(Restrict(Y,periodFile),'s'),'filled')
% hold on, plot(Data(Restrict(X,periodFile)),Data(Restrict(Y,periodFile)),'k')
% title('from behavResources')





