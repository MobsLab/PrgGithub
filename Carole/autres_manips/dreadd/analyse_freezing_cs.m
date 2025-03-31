Mice=[873 874 891];
Mat=zeros(length(Mice),4);

for i=1:length(Mice)
    mouse_num=Mice(i);
    path=strcat('/media/mobschapeau/09E7077B1FE07CCB/DREADD/', num2str(mouse_num), '/cond/day2_sleep_ext_sleep');
    cd(path)
    load('ExpeInfo.mat');
    load('behavResources.mat');
    load('Epoch.mat');
    
    % percentage of freezing during cs-

    Ep = and(Epoch.CSMoins,Epoch.FreezeAcc_Ext);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSMoins)-Start(Epoch.CSMoins)));
    Mat(i,1)=percent;
    
    % percentage of freezing during first cs+
    Ep = and(Epoch.CSPlus_1,Epoch.FreezeAcc_Ext);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_1)-Start(Epoch.CSPlus_1)));
    Mat(i,2)=percent;
    
    % percentage of freezing during 2nd cs+
    Ep = and(Epoch.CSPlus_2,Epoch.FreezeAcc_Ext);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_2)-Start(Epoch.CSPlus_2)));
    Mat(i,3)=percent;
    
    % percentage of freezing during 3rd cs+
    Ep = and(Epoch.CSPlus_3,Epoch.FreezeAcc_Ext);
    percent=(sum(Stop(Ep)-Start(Ep)))/(sum(Stop(Epoch.CSPlus_3)-Start(Epoch.CSPlus_3)));
    Mat(i,4)=percent;
end


PlotErrorBar_dreadd_CS(Mat, 'newfig', 1);
set(gca,'xticklabel',{'','CS-','CS+ 1','CS+ 2','CS+ 3',''});

title('% of freezing during ext');
text(4,1,'black=ctrl')
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

