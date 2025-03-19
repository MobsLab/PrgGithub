
clear all

GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

thr=1; % threshold for noise
Freq_Limit=3.66;
load('/media/nas4/ProjetEmbReact/Mouse739/29052018/ProjectEmbReact_M739_29052018_TestPost_PostDrug/TestPost2/B_Low_Spectrum.mat')

Session_type={'Cond'};
Mouse=Drugs_Groups_UMaze_BM(22);

% Calculating data for each mouse
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Sessions_List_ForLoop_BM
        
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
        
        Ripples.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'ripples');
        
        
        RipplesFreezing.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Ripples.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
        RespiFreezing.(Session_type{sess}).(Mouse_names{mouse}) = Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
        
        %         [All_Freq.(Session_type{sess}).(Mouse_names{mouse}) , EpLength.(Mouse_names{mouse}) , EpProp_2_4.(Mouse_names{mouse}) , TimeProp_thr_2_4.(Mouse_names{mouse}) , TimeProp_abs_2_4.(Mouse_names{mouse})] = FreezingSpectrumEpisodesAnalysis_BM(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , Respi.(Session_type{sess}).(Mouse_names{mouse}) , Freq_Limit);
        
    end
    disp(Mouse_names{mouse})
end

BinSize =   2 ;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        if length( Ripples.(Session_type{sess}).(Mouse_names{mouse}))>2
            RippleByBin.(Session_type{sess}){mouse} = [];
            BreathByBin.(Session_type{sess}){mouse} = [];
            
            for ff = 1:length(Start(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) ))
                LitEp = subset(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}),ff);
                if (Stop(LitEp,'s') - Start(LitEp,'s'))>BinSize
                    NumEp = floor((Stop(LitEp,'s') - Start(LitEp,'s'))/BinSize);
                    
                    for nn = 1:NumEp
                        LitLitEp = intervalSet(Start(LitEp),Start(LitEp)+(nn-1)*BinSize*1E4);
                        RippleByBin.(Session_type{sess}){mouse} = [ RippleByBin.(Session_type{sess}){mouse},length(Data(Restrict( Ripples.(Session_type{sess}).(Mouse_names{mouse}),LitLitEp)))];
                        BreathByBin.(Session_type{sess}){mouse} = [BreathByBin.(Session_type{sess}){mouse},nanmean(Data(Restrict( Respi.(Session_type{sess}).(Mouse_names{mouse}),LitLitEp)))];
                    end
                end
            end
        end
    end
end

AllResp = [];
AllRip = [];
Session_type={'Cond'};

for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        if length(Ripples.(Session_type{sess}).(Mouse_names{mouse}))>50
         AllResp = [AllResp,[BreathByBin.(Session_type{sess}){mouse} 1 1 7 7]];
         AllRip = [AllRip,[RippleByBin.(Session_type{sess}){mouse} -1 6 -1 6]];
        end
    end
end


% dividing it by freezing episode
for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        try
            Start_FzEpoch = Start(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));
            Stop_FzEpoch = Stop(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}));                                                                                                                                                                                                                 
            
            for i=1:length(Start_FzEpoch)
                if (Stop_FzEpoch(i)-Start_FzEpoch(i))>3e4
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
                    Ripples_numb_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = sum(Start_FzEpoch(i) < Range(RipplesFreezing.(Session_type{sess}).(Mouse_names{mouse})) & Range(RipplesFreezing.(Session_type{sess}).(Mouse_names{mouse})) < Stop_FzEpoch(i));
                    Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = (Ripples_numb_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) / sum(Stop_FzEpoch(i)-Start_FzEpoch(i)))*1e4;
                    Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = nanmean(Data(Restrict(Respi.(Session_type{sess}).(Mouse_names{mouse}) , subset(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , i))));
                else
                    Ripples_numb_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = NaN;
                    Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = NaN;
                    Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})(i) = NaN;
                end
            end
            
            %         [R_ind.(Mouse_names{mouse}),P_ind.(Mouse_names{mouse})]=corrcoef_BM(nanmean(All_Freq.(Session_type{sess}).(Mouse_names{mouse})') , Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}));
            FzEp_Mean_Length.(Session_type{sess}).(Mouse_names{mouse}) = Stop_FzEpoch-Start_FzEpoch;
            if sum(Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})==0)==length(Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}))
                Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})=NaN(1,length(Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})));
            end
        end
    end;
    disp(Mouse_names{mouse})
end

% Session_type={'sleep_pre'};
% [OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples_density');

Session_type={'Cond'};
clear MAP MAP_norm MAP2 MAP2_norm


%% SB try
AllResp = [];
AllRip = [];
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        if length(Ripples.(Session_type{sess}).(Mouse_names{mouse}))>50
         AllResp = [AllResp,[Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})]];
         AllRip = [AllRip,[Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse})]];
        end
    end
end
clf
BadGuys = AllResp ==1 | AllResp ==7 ;
AllResp(BadGuys)=[]
AllRip(BadGuys)=[]
BadGuys = isnan(AllResp) | isnan(AllRip);
AllResp(BadGuys)=[]
AllRip(BadGuys)=[]

plot(AllResp',AllRip','k.','MarkerSize',10)
hold on
RespiBin = [1.25:0.5:7];
clear MnVal StdVal
for bb = 1:length(RespiBin)-1
    MnVal(bb) = nanmedian(AllRip(AllResp>RespiBin(bb) & AllResp<RespiBin(bb+1)));
    StdVal(1,bb) = prctile(AllRip(AllResp>RespiBin(bb) & AllResp<RespiBin(bb+1)),75) - nanmedian(AllRip(AllResp>RespiBin(bb) & AllResp<RespiBin(bb+1)));
    StdVal(2,bb) = -prctile(AllRip(AllResp>RespiBin(bb) & AllResp<RespiBin(bb+1)),25) + nanmedian(AllRip(AllResp>RespiBin(bb) & AllResp<RespiBin(bb+1)));

    Hist_bin(bb) = sum(AllResp>RespiBin(bb) & AllResp<RespiBin(bb+1));
end
 

BadGuys =  AllRip ==0;
BadGuys = isnan(AllRip);
AllResp(BadGuys)=[];
AllRip(BadGuys)=[];

figure
subplot(3,1,1:2)
dscatter(AllResp',AllRip','BINS',[20 20]*3)
hold on
errorbar(RespiBin(1:end-1)+0.25,MnVal,StdVal(2,:),StdVal(1,:),'k', 'linewidth',3)
xlim([1 7]), ylim([-0.2 3]), caxis([-0.3 0.8])
xlabel('Breathing (Hz)'), ylabel('SWR occurence (#/s)')
set(gca,'YTick',[0:3],'XTick',[2:2:6])
makepretty_BM2
colormap viridis, %axis square

subplot(313)
b=bar(RespiBin(1:end-1)+0.25 , Hist_bin./sum(Hist_bin)); b.FaceColor=[.3 .3 .3]; b.FaceAlpha=.3;
set(gca,'XTick',[2:2:6]), xlim([1 7]), ylim([0 .15]), xlabel('Breathing (Hz)'), ylabel('proportion')
makepretty








