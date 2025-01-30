

%% Movement quantity after VHC stim
clear all
GetEmbReactMiceFolderList_BM

n=1;
for group=7:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        Eyelid_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
        Around_Eyelid_Epoch_Noise.(Mouse_names{mouse}) = intervalSet(Start(Eyelid_Epoch.(Mouse_names{mouse}))-.05e4 , Start(Eyelid_Epoch.(Mouse_names{mouse}))+.3e4);
        VHC_Stim_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','vhc_stim');
        VHC_Stim_Epoch.(Mouse_names{mouse}) = VHC_Stim_Epoch.(Mouse_names{mouse}) - Around_Eyelid_Epoch_Noise.(Mouse_names{mouse});
        Accelero.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
        
        Freeze_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        Freeze_Epoch_Extended.(Mouse_names{mouse}) = or(Freeze_Epoch.(Mouse_names{mouse}) , Around_Eyelid_Epoch_Noise.(Mouse_names{mouse}));
        Eyelid_Freezing_Epoch.(Mouse_names{mouse}) = and(Eyelid_Epoch.(Mouse_names{mouse}) , Freeze_Epoch_Extended.(Mouse_names{mouse}));
        VHC_Stim_Freezing_Epoch.(Mouse_names{mouse}) = and(VHC_Stim_Epoch.(Mouse_names{mouse}) , Freeze_Epoch.(Mouse_names{mouse}));
        
        Start_Eyelid.(Mouse_names{mouse}) = Start(Eyelid_Epoch.(Mouse_names{mouse}));
        Start_VHC_Stim.(Mouse_names{mouse}) = Start(VHC_Stim_Epoch.(Mouse_names{mouse}));
        Start_Eyelid_Fz.(Mouse_names{mouse}) = Start(Eyelid_Freezing_Epoch.(Mouse_names{mouse}));
        Start_VHC_Stim_Fz.(Mouse_names{mouse}) = Start(VHC_Stim_Freezing_Epoch.(Mouse_names{mouse}));
        
        for stim = 1:length(Start_Eyelid.(Mouse_names{mouse}))
            Around_Eyelid_Epoch = intervalSet(Start_Eyelid.(Mouse_names{mouse})(stim)-1e4 , Start_Eyelid.(Mouse_names{mouse})(stim)+1e4);
            Accelero_Around_Eyelid.(Mouse_names{mouse})(stim,:) = Data(Restrict(Accelero.(Mouse_names{mouse}) , Around_Eyelid_Epoch));
        end
        for stim = 1:length(Start_VHC_Stim.(Mouse_names{mouse}))
            Around_VHC_Epoch = intervalSet(Start_VHC_Stim.(Mouse_names{mouse})(stim)-1e4 , Start_VHC_Stim.(Mouse_names{mouse})(stim)+1e4);
            Accelero_Around_VHC.(Mouse_names{mouse})(stim,1:length(Data(Restrict(Accelero.(Mouse_names{mouse}) , Around_VHC_Epoch)))) = Data(Restrict(Accelero.(Mouse_names{mouse}) , Around_VHC_Epoch));
        end
        
        for stim = 1:length(Start_VHC_Stim_Fz.(Mouse_names{mouse}))
            try
                Around_VHC_Epoch = intervalSet(Start_VHC_Stim_Fz.(Mouse_names{mouse})(stim)-1e4 , Start_VHC_Stim_Fz.(Mouse_names{mouse})(stim)+1e4);
                Accelero_Around_VHC_Fz.(Mouse_names{mouse})(stim,1:length(Data(Restrict(Accelero.(Mouse_names{mouse}) , Around_VHC_Epoch)))) = Data(Restrict(Accelero.(Mouse_names{mouse}) , Around_VHC_Epoch));
            end
        end
        
        Accelero_Around_Eyelid_All{n}(mouse,1:length(nanmean(Accelero_Around_Eyelid.(Mouse_names{mouse})))) = nanmean(Accelero_Around_Eyelid.(Mouse_names{mouse}));
        Accelero_Around_VHC_All{n}(mouse,1:length(nanmean(Accelero_Around_VHC.(Mouse_names{mouse})))) = nanmean(Accelero_Around_VHC.(Mouse_names{mouse}));
        try; Accelero_Around_Eyelid_Fz_All{n}(mouse,1:length(nanmean(Accelero_Around_Eyelid.(Mouse_names{mouse})))) = nanmean(Accelero_Around_Eyelid_Fz); end
        try; Accelero_Around_VHC_Fz_All{n}(mouse,1:length(nanmean(Accelero_Around_VHC.(Mouse_names{mouse})))) = nanmean(Accelero_Around_VHC_Fz.(Mouse_names{mouse})); end
        
        clear Accelero_Around_Eyelid Accelero_Around_VHC Accelero_Around_VHC_Fz Accelero_Around_Eyelid_Fz
        disp(Mouse_names{mouse})
    end
    Accelero_Around_VHC_Fz_All{n}(Accelero_Around_VHC_Fz_All{n}==0)=NaN;
    n=n+1;
end


%% figures
figure
subplot(121)
Conf_Inter=nanstd(Accelero_Around_Eyelid_All{1})/sqrt(size(Accelero_Around_Eyelid_All{1},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_Eyelid_All{1});
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(Accelero_Around_VHC_All{1})/sqrt(size(Accelero_Around_VHC_All{1},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_VHC_All{1});
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(Accelero_Around_VHC_Fz_All{1})/sqrt(size(Accelero_Around_VHC_Fz_All{1},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_VHC_Fz_All{1});
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'Eyelid','VHC stim','VHC stim during freezing');
u=text(0,8e6,'-----------------------------------'), set(u,'Rotation',90,'Color','r','FontSize',30);
set(gca , 'Yscale','log'), ylim([8e6 1e9]), ylabel('Movement quantity (log sclae)'), xlabel('time (s)');
makepretty, , title('Rip Inhib')

subplot(122)
Conf_Inter=nanstd(Accelero_Around_Eyelid_All{2})/sqrt(size(Accelero_Around_Eyelid_All{2},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_Eyelid_All{2});
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Conf_Inter=nanstd(Accelero_Around_VHC_All{2})/sqrt(size(Accelero_Around_VHC_All{2},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_VHC_All{2});
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(Accelero_Around_VHC_Fz_All{2})/sqrt(size(Accelero_Around_VHC_Fz_All{2},1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Accelero_Around_VHC_Fz_All{2});
shadedErrorBar(linspace(-1,1,100) , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'Eyelid','VHC stim','VHC stim during freezing');
u=text(0,8e6,'-----------------------------------'), set(u,'Rotation',90,'Color','r','FontSize',30);
set(gca , 'Yscale','log'), ylim([8e6 1e9]), xlabel('time (s)');
makepretty, title('Rip Inhib')

a=suptitle('Movement around stims'); a.FontSize=20;






