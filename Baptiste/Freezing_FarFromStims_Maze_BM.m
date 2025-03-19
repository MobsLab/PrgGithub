

GetAllSalineSessions_BM
Mouse=Drugs_Groups_UMaze_BM(22);
Session_type = {'Cond'};
load('B_Low_Spectrum.mat')

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
%         HR.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'heartrate');
%         chan_numb = Get_chan_numb_BM(FolderList.(Mouse_names{mouse}){1},'EKG');
%         LFP_EKG.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'lfp','channumber',chan_numb);
        Freeze.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        Zone.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
        ShockZone.(Session_type{sess}).(Mouse_names{mouse}) = Zone.(Session_type{sess}).(Mouse_names{mouse}){1};
        SafeZone.(Session_type{sess}).(Mouse_names{mouse}) = or(Zone.(Session_type{sess}).(Mouse_names{mouse}){2} , Zone.(Session_type{sess}).(Mouse_names{mouse}){5});
        BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
        UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0,max(Range(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}))))-BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse});
        
%         chan = Get_chan_numb_BM(CondSess.(Mouse_names{mouse}){1},'bulb_deep');
%         LFP_OB.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'lfp','channumber',chan);
%         InstFreq_OB.(Session_type{sess}){mouse} = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'InstFreq','suffix_instfreq','B');
        
%         try
%             Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'accelero');
%             Acc_Freeze.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Acc.(Session_type{sess}).(Mouse_names{mouse}),Freeze.(Session_type{sess}).(Mouse_names{mouse}));
%         end
        
        Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
        Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = and(Freeze.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
        
        Sto_Shock.(Session_type{sess}).(Mouse_names{mouse}) = Stop(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
        Sta_Safe.(Session_type{sess}).(Mouse_names{mouse}) = Start(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
        
        Sto_Safe.(Session_type{sess}).(Mouse_names{mouse}) = Stop(Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
        Sta_Shock.(Session_type{sess}).(Mouse_names{mouse}) = Start(Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}))/1e4;
        
        % Spectro
        try
            OB_Low_Spec_Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}));
            [OB_Spec_clean_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}),~,~]=CleanSpectro(OB_Low_Spec_Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}),Spectro{3},8);
            OB_MeanSpecFz_Shock.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Spec_clean_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse})));
            OB_MeanSpecFz_NoClean_Shock.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Low_Spec_Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse})));
            
            OB_Low_Spec_Freeze_Shock_Blocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Spec_clean_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            OB_Low_Spec_Freeze_Shock_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Spec_clean_Fz_Shock.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            OB_MeanSpecFz_Shock_Blocked.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Low_Spec_Freeze_Shock_Blocked.(Session_type{sess}).(Mouse_names{mouse})));
            OB_MeanSpecFz_Shock_Unblocked.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Low_Spec_Freeze_Shock_Unblocked.(Session_type{sess}).(Mouse_names{mouse})));
        end
        try
            OB_Low_Spec_Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}) , Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}));
            [OB_Spec_clean_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}),~,~]=CleanSpectro(OB_Low_Spec_Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}),Spectro{3},8);
            OB_MeanSpecFz_Safe.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Spec_clean_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse})));
            OB_MeanSpecFz_NoClean_Safe.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Low_Spec_Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse})));
            
            OB_Low_Spec_Freeze_Safe_Blocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Spec_clean_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}) , BlockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            OB_Low_Spec_Freeze_Safe_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(OB_Spec_clean_Fz_Safe.(Session_type{sess}).(Mouse_names{mouse}) , UnblockedEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            OB_MeanSpecFz_Safe_Blocked.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Low_Spec_Freeze_Safe_Blocked.(Session_type{sess}).(Mouse_names{mouse})));
            OB_MeanSpecFz_Safe_Unblocked.(Session_type{sess})(mouse,:) = nanmean(Data(OB_Low_Spec_Freeze_Safe_Unblocked.(Session_type{sess}).(Mouse_names{mouse})));
        end
        %LFP
        %             OB_LFP_Fz_Shock.(Session_type{sess}){mouse} = Restrict(LFP_OB.(Session_type{sess}){mouse} , Freeze_Shock.(Session_type{sess}).(Mouse_names{mouse}));
        %             OB_LFP_Fz_Safe.(Session_type{sess}){mouse} = Restrict(LFP_OB.(Session_type{sess}){mouse} , Freeze_Safe.(Session_type{sess}).(Mouse_names{mouse}));
        
        %         blocked or not
        
        
        
        %             for ep=1:length(Sta_Safe.(Session_type{sess}).(Mouse_names{mouse}))
        %                 for epi=1:length(Sto_Shock.(Session_type{sess}).(Mouse_names{mouse}))
        %                     if and(Sta_Safe.(Session_type{sess}).(Mouse_names{mouse})(ep)>Sto_Shock.(Session_type{sess}).(Mouse_names{mouse})(epi) , Sta_Safe.(Session_type{sess}).(Mouse_names{mouse})(ep)<(Sto_Shock.(Session_type{sess}).(Mouse_names{mouse})(epi)+15))
        %                         disp([mouse ep epi])
        %                     end
        %                     if and(Sta_Shock.(Session_type{sess}).(Mouse_names{mouse})(ep)>Sto_Safe.(Session_type{sess}).(Mouse_names{mouse})(epi) , Sta_Shock.(Session_type{sess}).(Mouse_names{mouse})(ep)<(Sto_Safe.(Session_type{sess}).(Mouse_names{mouse})(epi)+15))
        %                         disp([mouse ep epi])
        %                     end
        %                 end
        %             end
        disp(Mouse_names{mouse})
    end
    OB_MeanSpecFz_Shock.(Session_type{sess})(OB_MeanSpecFz_Shock.(Session_type{sess})==0)=NaN;
    OB_MeanSpecFz_Safe.(Session_type{sess})(OB_MeanSpecFz_Safe.(Session_type{sess})==0)=NaN;
    OB_MeanSpecFz_NoClean_Shock.(Session_type{sess})(OB_MeanSpecFz_NoClean_Shock.(Session_type{sess})==0)=NaN;
    OB_MeanSpecFz_NoClean_Safe.(Session_type{sess})(OB_MeanSpecFz_NoClean_Safe.(Session_type{sess})==0)=NaN;
    OB_MeanSpecFz_Shock_Blocked.(Session_type{sess})(OB_MeanSpecFz_Shock_Blocked.(Session_type{sess})==0)=NaN;
    OB_MeanSpecFz_Safe_Blocked.(Session_type{sess})(OB_MeanSpecFz_Safe_Blocked.(Session_type{sess})==0)=NaN;
    OB_MeanSpecFz_Shock_Unblocked.(Session_type{sess})(OB_MeanSpecFz_Shock_Unblocked.(Session_type{sess})==0)=NaN;
    OB_MeanSpecFz_Safe_Unblocked.(Session_type{sess})(OB_MeanSpecFz_Safe_Unblocked.(Session_type{sess})==0)=NaN;
end
OB_MeanSpecFz_Shock.Ext(7,:)=NaN;


load('B_Low_Spectrum.mat')


mouse=0; val=14.5;
figure,% mouse=mouse+1;
imagesc(Range(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}))/1e4 , Spectro{3} , runmean(runmean(log10(Spectro{3}'.*Data(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}))'),10)',10)'), axis xy
% imagesc(Range(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse}))/1e4 , Spectro{3} , log10(Data(OB_Low_Spec.(Session_type{sess}).(Mouse_names{mouse})))'), axis xy
line([Start(Freeze.(Session_type{sess}).(Mouse_names{mouse}))/1e4 Stop(Freeze.(Session_type{sess}).(Mouse_names{mouse}))/1e4],[12 12],'Color','k','Linewidth',10)
line([Start(ShockZone.(Session_type{sess}).(Mouse_names{mouse}))/1e4 Stop(ShockZone.(Session_type{sess}).(Mouse_names{mouse}))/1e4],[val val],'Color','r','Linewidth',10)
line([Start(SafeZone.(Session_type{sess}).(Mouse_names{mouse}))/1e4 Stop(SafeZone.(Session_type{sess}).(Mouse_names{mouse}))/1e4],[val val],'Color','b','Linewidth',10)
% xlim([Sta_Safe.(Session_type{sess}).(Mouse_names{mouse})(ep)-20 Sta_Safe.(Session_type{sess}).(Mouse_names{mouse})(ep)+10])
xlabel('time (s)'), ylabel('Frequency (Hz)')
ylim([.15 15])

mouse=10; ep=8;
mouse=10; ep=9;
mouse=12; ep=56;
mouse=15; ep=71;
mouse=15; ep=104;




%%
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure
[h , MaxPowerValues , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_Shock , 'color' , 'r');
[h , MaxPowerValues , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_Safe , 'color' , 'b');
xlim([0 10])
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)')
makepretty
f=get(gca,'Children'); l=legend([f(8),f(4)],'Shock','Safe');

Freq_Max1([7 14 15]) = [2.136 2.518 NaN];
Freq_Max2(3) = NaN;

figure
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)')



figure
plot(Spectro{3} , OB_Shock(7,:)), i=i+1;


figure
for sess=1:3
    [h , MaxPowerValues , Freq_Max1.(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(OB_Shock.(Session_type{sess}) , 'color' , 'r');
    [h , MaxPowerValues , Freq_Max2.(Session_type{sess})] = Plot_MeanSpectrumForMice_BM(OB_Safe.(Session_type{sess}) , 'color' , 'b');
    
    
    subplot(1,3,sess)
    MakeSpreadAndBoxPlot3_SB({Freq_Max1.(Session_type{sess}) Freq_Max2.(Session_type{sess})},Cols,X,Legends,'showpoints',0,'paired',1);
    ylabel('Frequency (Hz)')
end
