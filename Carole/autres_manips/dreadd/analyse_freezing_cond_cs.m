Mice=[873 874 891];
Mat=zeros(length(Mice),3);

for i=1:length(Mice)
    mouse_num=Mice(i);
    path=strcat('/media/mobschapeau/09E7077B1FE07CCB/DREADD/', num2str(mouse_num), '/cond/day1_hab_cond/cond');
    cd(path)
    load('ExpeInfo.mat');
    load(strcat('behavResources-',num2str(mouse_num),'.mat'));
    load('Epoch.mat');
    
    % percentage of freezing during first 4 cs-

    Ep = and(Epoch.CSMoins1,Epoch.All_Freeze);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSMoins1)-Start(Epoch.CSMoins1)));
    Mat(i,1)=percent;
   
    % percentage of freezing during last 4 cs-

    Ep = and(Epoch.CSMoins2,Epoch.All_Freeze);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSMoins2)-Start(Epoch.CSMoins2)));
    Mat(i,2)=percent;
    
    % percentage of freezing during first 4 cs+
    Ep = and(Epoch.CSPlus1,Epoch.All_Freeze);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus1)-Start(Epoch.CSPlus1)));
    Mat(i,3)=percent;
    
    % percentage of freezing during last 4 cs+
    Ep = and(Epoch.CSPlus2,Epoch.All_Freeze);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus2)-Start(Epoch.CSPlus2)));
    Mat(i,4)=percent;
end


PlotErrorBar_dreadd_CS(Mat, 'newfig', 1);
set(gca,'xticklabel',{'','CS- 1','CS- 2','CS+ 1','CS+ 2',''});

title('% of freezing during cond');
hold on
text(4,1,'black=ctrl');

% % 
% plot(Range(NewMovAcctsd,'s')-TTLInfo.ExtTTL,Data(NewMovAcctsd))
% hold on
% vline(TTLInfo.ExtTTL, 'r', 'ext');
% vline(TTLInfo.PostExtTTL, 'r', 'fin ext');


% plot(Range(NewMovAcctsd,'s')-TTLInfo.ExtTTL,Data(NewMovAcctsd))
% hold on
% vline(TTLInfo.ExtTTL, 'r', 'ext');
% vline(TTLInfo.PostExtTTL, 'r', 'fin ext');
% hold on
% plot(Range(Restrict(NewMovAcctsd,FreezeAccEpoch),'s')-TTLInfo.ExtTTL,Data(Restrict(NewMovAcctsd,FreezeAccEpoch)))
% plot(Range(Restrict(NewMovAcctsd,Extinction_FreezeAccEpoch),'s')-TTLInfo.ExtTTL,Data(Restrict(NewMovAcctsd,Extinction_FreezeAccEpoch)))
% ExtinctionEpoch=intervalSet(TTLInfo.ExtTTL*1e4, TTLInfo.PostExtTTL*1e4);
% Extinction_FreezeAccEpoch=and(ExtinctionEpoch, FreezeAccEpoch);
% plot(Range(Restrict(NewMovAcctsd,Extinction_FreezeAccEpoch),'s')-TTLInfo.ExtTTL,Data(Restrict(NewMovAcctsd,Extinction_FreezeAccEpoch)))
% 

