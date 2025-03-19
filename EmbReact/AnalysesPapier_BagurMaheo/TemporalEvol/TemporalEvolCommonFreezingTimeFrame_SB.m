
clear all

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
Session_type={'Cond'};
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power'};
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllMiceTempEvol';
for param=1:8
    for mouse = 1:length(Mouse)
        try
            clear D, D = Data(OutPutData.Cond.(Params{param}).tsd{mouse,5});
            DATA_shock.(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
        try
            clear D, D = Data(OutPutData.Cond.(Params{param}).tsd{mouse,6});
            DATA_safe.(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
    end
    DATA_shock.(Params{param})(DATA_shock.(Params{param})==0) = NaN;
    DATA_safe.(Params{param})(DATA_safe.(Params{param})==0) = NaN;
end

clf
for mousenum = 1:51
for param=1:6
    subplot(2,6,param)
    plot(DATA_shock.(Params{param})(mousenum,:) , 'Color' , [1 .5 .5])
    hold on
    plot(DATA_safe.(Params{param})(mousenum,:) , 'Color' , [.5 .5 1])
    xlabel('time (a.u)')
    makepretty
end

% SVM
clear Sk Sf Sk_Vect Sf_Vect
for param = 1:5
    Mn = (nanmean((DATA_shock.(Params{param})(mousenum,:))) + nanmean((DATA_safe.(Params{param})(mousenum,:))))/2;
    Std = (nanstd((DATA_shock.(Params{param})(mousenum,:))) + nanstd((DATA_safe.(Params{param})(mousenum,:))))/2;
    
    SkData = (DATA_shock.(Params{param})(mousenum,:) - Mn)/Std;
    SfData = (DATA_safe.(Params{param})(mousenum,:) - Mn)/Std;
    
    Sk(param) = nanmean(SkData);
    Sf(param) = nanmean(SfData);
    Sk_Vect(param,:) = SkData;
    Sf_Vect(param,:) = SfData;
end

Proj_Sk = nanmean((Sk_Vect'.*(Sk-Sf))');
Proj_Sf = nanmean((Sf_Vect'.*(Sk-Sf))');

subplot(2,1,2)
plot(Proj_Sk,'r')
hold on
plot(Proj_Sf,'b')
yyaxis right
plot(diff(cumsum(DATA_safe.(Params{6})(mousenum,:),"omitnan") + cumsum(DATA_shock.(Params{6})(mousenum,:),"omitnan")),'g')

Proj_Sk_all(mousenum,:) = Proj_Sk;
Proj_Sf_all(mousenum,:) = Proj_Sf;
Rip_all(mousenum,:) = (diff(cumsum(DATA_safe.(Params{6})(mousenum,:),"omitnan") + cumsum(DATA_shock.(Params{6})(mousenum,:),"omitnan")));
saveas(3,[SaveFolder filesep 'Mouse' num2str(mousenum) '_Fz01.png'])
clf
end
    
    
 %%%% Now realign the times
 
clear all
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllMiceTempEvol';

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat')
Session_type={'Cond'};
Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power'};
Epo = 1 % TotalEpoch
EpoSkFz = 5;
EpoSfFz = 6;
for param=1:8
    for mouse = 1:length(Mouse)
        try
            clear D, D = Data(OutPutData.Cond.(Params{param}).tsd{mouse,Epo});
            DATA_all.(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,1000));
            
            tps =  Range(OutPutData.Cond.(Params{param}).tsd{mouse,Epo});
            tps_Sk =  Range(OutPutData.Cond.(Params{param}).tsd{mouse,EpoSkFz});
            tps_Sk_aligned = interp1(linspace(0,1,length(D)) , double(~ismember(tps,tps_Sk)) , linspace(0,1,1000));
            DATA_shock.(Params{param})(mouse,:) =  DATA_all.(Params{param})(mouse,:);
            DATA_shock.(Params{param})(mouse,tps_Sk_aligned>0)= NaN;
            
            tps =  Range(OutPutData.Cond.(Params{param}).tsd{mouse,Epo});
            tps_Sf =  Range(OutPutData.Cond.(Params{param}).tsd{mouse,EpoSfFz});
            tps_Sf_aligned = interp1(linspace(0,1,length(D)) , double(~ismember(tps,tps_Sf)) , linspace(0,1,1000));
            DATA_safe.(Params{param})(mouse,:) =  DATA_all.(Params{param})(mouse,:);
            DATA_safe.(Params{param})(mouse,tps_Sf_aligned>0)= NaN;
            
            DATA_all.(Params{param})(mouse,tps_Sf_aligned>0 & tps_Sk_aligned>0)= NaN;
        end
        
        
    end
end 
    
    
% Get SVM proj from all mice
clf
    clear Sk Sf Sk_Vect Sf_Vect

for mousenum = 1:51
   
    
    % SVM
    for param = 1:5
        Mn = (nanmean((DATA_shock.(Params{param})(mousenum,:))) + nanmean((DATA_safe.(Params{param})(mousenum,:))))/2;
        Std = (nanstd((DATA_shock.(Params{param})(mousenum,:))) + nanstd((DATA_safe.(Params{param})(mousenum,:))))/2;
        
        SkData = (DATA_shock.(Params{param})(mousenum,Fzbin) - Mn)/Std;
        SfData = (DATA_safe.(Params{param})(mousenum,Fzbin) - Mn)/Std;
        
        Sk(mousenum,param) = nanmean(SkData);
        Sf(mousenum,param) = nanmean(SfData);
    end
end

ProjVect = nanmean(Sk) - nanmean(Sf);

clf
for mousenum = 1:51
    Fzbin = find(not(isnan(DATA_all.(Params{param})(mousenum,:))));
    for param=1:6
        subplot(2,6,param)
        plot(DATA_shock.(Params{param})(mousenum,Fzbin) , 'Color' , [1 .5 .5])
        hold on
        plot(DATA_safe.(Params{param})(mousenum,Fzbin) , 'Color' , [.5 .5 1])
        xlabel('time (a.u)')
        makepretty
    end
    
    % SVM
    clear Sk Sf Sk_Vect Sf_Vect
    for param = 1:5
        Mn = (nanmean((DATA_shock.(Params{param})(mousenum,:))) + nanmean((DATA_safe.(Params{param})(mousenum,:))))/2;
        Std = (nanstd((DATA_shock.(Params{param})(mousenum,:))) + nanstd((DATA_safe.(Params{param})(mousenum,:))))/2;
        
        SkData = (DATA_shock.(Params{param})(mousenum,Fzbin) - Mn)/Std;
        SfData = (DATA_safe.(Params{param})(mousenum,Fzbin) - Mn)/Std;
        
        Sk(param) = nanmean(SkData);
        Sf(param) = nanmean(SfData);
        Sk_Vect(param,:) = SkData;
        Sf_Vect(param,:) = SfData;
    end
    
    Proj_Sk = nanmean((Sk_Vect'.*ProjVect)');
    Proj_Sf = nanmean((Sf_Vect'.*ProjVect)');
    
    
    subplot(2,1,2)
    plot(Proj_Sk,'r')
    hold on
    plot(Proj_Sf,'b')
    yyaxis right
    plot(DATA_all.(Params{6})(mousenum,Fzbin),'g')
    
    TotBin = length(Fzbin);
    Rip_JustFz = DATA_all.(Params{6})(mousenum,Fzbin);
      Rip_Sk = DATA_shock.(Params{6})(mousenum,Fzbin);
    Rip_Sf = DATA_safe.(Params{6})(mousenum,Fzbin);

    BinNum = 20;
    for ii=1:BinNum
        Prop_Sf_all(mousenum,ii) = nanmean(isnan(Proj_Sf(floor((ii-1)*TotBin/BinNum)+1:floor((ii)*TotBin/BinNum))));
        Proj_Sk_all(mousenum,ii) = nanmean(Proj_Sk(floor((ii-1)*TotBin/BinNum)+1:floor((ii)*TotBin/BinNum)));
        Proj_Sf_all(mousenum,ii) = nanmean(Proj_Sf(floor((ii-1)*TotBin/BinNum)+1:floor((ii)*TotBin/BinNum)));
        
        Rip_Sk_all(mousenum,ii) = nanmean(Rip_Sk(floor((ii-1)*TotBin/BinNum)+1:floor((ii)*TotBin/BinNum)));
        Rip_Sf_all(mousenum,ii) = nanmean(Rip_Sf(floor((ii-1)*TotBin/BinNum)+1:floor((ii)*TotBin/BinNum)));
        Rip_all(mousenum,ii) = nanmean(Rip_JustFz(floor((ii-1)*TotBin/BinNum)+1:floor((ii)*TotBin/BinNum)));
    end
    % Proj_Sf_all(mousenum,:) = Proj_Sf;
    % Rip_all(mousenum,:) = DATA_all.(Params{6})(mousenum,Fzbin);
    saveas(3,[SaveFolder filesep 'Mouse' num2str(mousenum) '_Fz01SameTime.png'])
    
    clf
end



figure
subplot(311)
errorbar(nanmean(Proj_Sf_all),stdError(Proj_Sf_all),'b')
hold on
errorbar(nanmean(Proj_Sk_all),stdError(Proj_Sk_all),'r')
legend('sf','sk')
ylabel('SVM score')
ylim([-.8 .8])
line(xlim,[0 0])
makepretty
legend('sf','sk')

subplot(312)
errorbar(nanmean(Prop_Sf_all),stdError(Prop_Sf_all),'k')
ylim([0 1])
makepretty
ylabel('Prop Fz on shock side')
subplot(313)
errorbar(nanmean(Rip_all),stdError(Rip_all),'k')
hold on
errorbar(nanmean(Rip_Sf_all),stdError(Rip_Sf_all),'b')
errorbar(nanmean(Rip_Sk_all),stdError(Rip_Sk_all),'r')
makepretty
ylabel('Rip density')
legend('all','sf','sk')


figure
errorbar(nanmean(Rip_Sf_all),stdError(Rip_Sf_all),'k')
makepretty
ylabel('Dens ripples safe fz')
yyaxis right
errorbar(-nanmean(Proj_Sf_all),stdError(Proj_Sf_all),'b')
ylabel('SVM safe fz')
makepretty