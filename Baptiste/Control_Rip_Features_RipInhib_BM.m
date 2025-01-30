
load('/media/nas7/ProjetEmbReact/DataEmbReact/Control_Rip_Features.mat')


[p,h] = ranksum(VHC_Stim_FreezingDensity_Shock{1} , VHC_Stim_FreezingDensity_Shock{2})
[p,h] = ranksum(VHC_Stim_FreezingDensity_Safe{1} , VHC_Stim_FreezingDensity_Safe{2})
[p,h] = ranksum(VHC_Stim_Numb_All{1} , VHC_Stim_Numb_All{2})

%% box plots stims
figure
MakeSpreadAndBoxPlot3_SB(VHC_Stim_Numb_All ,Cols,X,Legends , 'showpoints',1,'paired',0);
ylabel('VHC stimulations (#)')
makepretty_BM2


%% enveloppe 
figure
subplot(131)
Data_to_use = BandPassed_Envelope_LFP_rip_all{1}(:,1:349);
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-300,0,349) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.65, .75, 0]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
xlim([-250 0]),  ylim([100 600])
line([-200 -200],[100 490],'LineStyle','--','Color','k'), text(-230,500,'ripple detection','FontSize',10);
line([0 0],[100 490],'LineStyle','--','Color','k'), text(-50,500,'VHC stimulation','FontSize',10);
ylabel('120-250Hz enveloppe amplitude (a.u.)'), xlabel('time (ms)')

subplot(132)
Data_to_use = BandPassed_Envelope_LFP_rip_all{2}(:,1:349);
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-300,0,349) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.63, .08, .18]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
xlim([-250 0]), ylim([100 350])
xlabel('time (ms)')
line([0 0],[100 490],'LineStyle','--','Color','k'), text(-50,560,'ripples detection'), text(-25,530,'and','FontSize',10);
text(-50,500,'VHC stimulation','FontSize',10);

subplot(133)
Data_to_use = BandPassed_Envelope_AroundRip_all{1};
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-200,200,498) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
cols=[.3, .745, .93]; h.mainLine.Color=cols; h.patch.FaceColor=cols; h.edge(1).Color=cols; h.edge(2).Color=cols;
xlim([-125 125])
xlabel('time (ms)')
f=get(gca,'Children'); l=legend([f(9),f(5),f(1)],'Rip control triggered on ','Ripples inhib'); 
line([0 0],[100 550],'LineStyle','--','Color','k'), text(-30,580,'ripples detection')



%% specificity sensitivity




%% evoked potential
FolderList{1} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_0,99V_1ms/';
FolderList{2} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_0,999V_1ms/';
FolderList{3} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_1,99V_1ms/';
FolderList{4} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_2,99V_1ms/';
FolderList{5} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_3,99V_1ms/';
FolderList{6} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_4,99V_1ms/';
FolderList{7} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_5,99V_1ms/';
FolderList{8} = '/media/nas7/ProjetEmbReact/Mouse1500/20231010/ProjectEmbReact_M1500_20231010_CalibrationVHC_6,99V_1ms/';

EvokedPotential_VHC_Stim_PerMouse_BM(FolderList)







