

clear all
GetEmbReactMiceFolderList_BM
GetAllSalineSessions_BM

% also OB_Spectrogram_AroundRipples_BM

% Mouse=[688 777 849 1189 1391];
Mouse=Drugs_Groups_UMaze_BM(11);

Side={'All','Shock','Safe'};

load('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2/H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2/B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2/B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2/H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};

window_time = 3;

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    try
%                 Ripples_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'around_ripples_epoch','window_time',window_time);
        Ripples.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'ripples');
        Fz_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','freezeepoch');
        Zone_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','zoneepoch');
        Shock_Epoch.(Mouse_names{mouse}) = Zone_Epoch.(Mouse_names{mouse}){1};
        Safe_Epoch.(Mouse_names{mouse}) = or(Zone_Epoch.(Mouse_names{mouse}){2} , Zone_Epoch.(Mouse_names{mouse}){5});
        
        Fz.All.(Mouse_names{mouse}) = Fz_Epoch.(Mouse_names{mouse});
        Fz.Shock.(Mouse_names{mouse}) = and(Shock_Epoch.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        Fz.Safe.(Mouse_names{mouse}) = and(Safe_Epoch.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        
        %     OB_High_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','B_High');
        OB_Low_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
        %     HPC_VHigh_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','H_Vhigh');
        %     HPC_Low_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
        try
            PFC_Low_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','PFCx_Low');
        catch
            PFC_Low_Spec.(Mouse_names{mouse})=tsd([],[]);
        end
        %
        %     HeartRate.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'heartrate');
        Respi.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'respi_freq_bm');
        %
        %     HPC_VHigh_Spec_Fz.(Mouse_names{mouse}) = Restrict(HPC_VHigh_Spec.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        %     HPC_Low_Spec_Fz.(Mouse_names{mouse}) = Restrict(HPC_Low_Spec.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        OB_Low_Spec_Fz.(Mouse_names{mouse}) = Restrict(OB_Low_Spec.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        %     OB_High_Spec_Fz.(Mouse_names{mouse}) = Restrict(OB_High_Spec.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        PFC_Low_Spec_Fz.(Mouse_names{mouse}) = Restrict(PFC_Low_Spec.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        %     HeartRate_Fz.(Mouse_names{mouse}) = Restrict(HeartRate.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
        %
        
        %         RipplesDensity_Shock.(Mouse_names{mouse}) = length(Restrict(Ripples.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse}))))./(sum(DurationEpoch(and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse}))))/1e4);
        %         RipplesDensity_Safe.(Mouse_names{mouse}) = length(Restrict(Ripples.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse}))))./(sum(DurationEpoch(and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse}))))/1e4);
        %         Fz_Duration_Shock.(Mouse_names{mouse}) = sum(DurationEpoch(and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse}))))/1e4;
        %         Fz_Duration_Safe.(Mouse_names{mouse}) = sum(DurationEpoch(and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse}))))/1e4;
        %         Respi_Shock.(Mouse_names{mouse}) = nanmean(Data(Restrict(Respi.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse})))));
        %         Respi_Safe.(Mouse_names{mouse}) = nanmean(Data(Restrict(Respi.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse})))));
        
        for side=1:3
            OB_Low_Data_Fz.(Side{side}){mouse} = Data(Restrict(OB_Low_Spec.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})));
            Fz_Ripples.(Side{side}).(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse}));
            try
                Ra = Range(Restrict(OB_Low_Spec.(Mouse_names{mouse}) , Fz.(Side{side}).(Mouse_names{mouse})));
                rand_times.(Side{side}).(Mouse_names{mouse}) = Ra(round(rand(1,length(Fz_Ripples.(Side{side}).(Mouse_names{mouse})))*length(Ra)));
            end
        end
        disp(Mouse_names{mouse})
    end
end



Struct_name={'HPC_VHigh','HPC_Low','OB_Low','OB_High','PFC_Low','Heart_rate'};
for Struct=[3 5]%1:length(Struct_name)
    clear Data_Norm2_rip Data_Norm2_rand Data_Norm_Mean_Per_Mouse Data_Norm_Mice_Mean  %Data_Norm_Mean_All
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            if Struct==1
                Data_to_use = HPC_VHigh_Spec.(Mouse_names{mouse});    Range_to_use = RangeVHigh; ind1=41; ind2=94;
            elseif Struct==2
                Data_to_use = HPC_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow; ind1=52; ind2=157;
            elseif Struct==3
                Data_to_use = OB_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow; ind1=13; ind2=100;
            elseif Struct==4
                Data_to_use = OB_High_Spec.(Mouse_names{mouse});    Range_to_use = RangeHigh; ind1=9; ind2=25;
            elseif Struct==5
                Data_to_use = PFC_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow; ind1=52; ind2=157;
            elseif Struct==6
                Data_to_use = HeartRate.(Mouse_names{mouse});    Range_to_use = 1;
            end
            
            for side=1:3
                clear R; R=Range(Fz_Ripples.(Side{side}).(Mouse_names{mouse}));
                if isfield(Fz_Ripples.(Side{side}) , Mouse_names{mouse})
                    for rip=1:size(R,1)
                        SmallEp = intervalSet(R(rip)-window_time*1e4 , R(rip)+window_time*1e4);
                        if (sum(DurationEpoch(and(SmallEp , Fz_Epoch.(Mouse_names{mouse}))))/1e4)==2*window_time
                            clear Data_temp Data_temp_Norm, Data_temp = Data(Restrict(Data_to_use , SmallEp));
                            if and(~isempty(Data_temp) , length(Data_temp)>1)
                                if size(Data_temp , 2)>1           % spectrogram
                                    for line=1:length(Range_to_use)
                                        Data_temp_Norm(:,line) = interp1(linspace(0,1,size(Data_temp , 1)) ,  Data_temp(:,line)' , linspace(0,1,50));
                                    end
                                    Data_Norm2_rip.(Side{side}).(Mouse_names{mouse})(rip,:,:) = Data_temp_Norm;
                                else                               % no spectrogram
                                    Data_Norm2_rip.(Side{side}).(Mouse_names{mouse})(rip,:) = interp1(linspace(0,1,size(Data_temp , 1)) ,  Data_temp' , linspace(0,1,50));
                                end
                            end
                            
                            SmallEp_rand = intervalSet(rand_times.(Side{side}).(Mouse_names{mouse})(rip)-window_time*1e4 , rand_times.(Side{side}).(Mouse_names{mouse})(rip)+window_time*1e4);
                            if (sum(DurationEpoch(and(SmallEp_rand , Fz_Epoch.(Mouse_names{mouse}))))/1e4)==2*window_time
                                clear Data_temp Data_temp_Norm, Data_temp = Data(Restrict(Data_to_use , SmallEp_rand));
                                if and(~isempty(Data(Restrict(Data_to_use , SmallEp_rand))) , length(Data(Restrict(Data_to_use , SmallEp_rand)))>1)
                                    if size(Data_temp , 2)>1           % spectrogram
                                        for line=1:length(Range_to_use)
                                            Data_temp_Norm(:,line) = interp1(linspace(0,1,size(Data_temp , 1)) ,  Data_temp(:,line)' , linspace(0,1,50));
                                        end
                                        Data_Norm2_rand.(Side{side}).(Mouse_names{mouse})(rip,:,:) = Data_temp_Norm;
                                    else                               % no spectrogram
                                        Data_Norm2_rand.(Side{side}).(Mouse_names{mouse})(rip,:) = interp1(linspace(0,1,size(Data_temp , 1)) ,  Data_temp' , linspace(0,1,50));
                                    end
                                end
                            end
                        end
                    end
                end
                
            end
            disp(Mouse_names{mouse})
        end
    end
    
    % average along episodes for each mouse, then average for mice
    for mouse=1:length(Mouse)
        for side=1:3
            if isfield(Data_Norm2_rip.(Side{side}),Mouse_names{mouse})
                Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse}) = squeeze(nanmean(Data_Norm2_rip.(Side{side}).(Mouse_names{mouse})))';
                if Struct~=6
                    if size(Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse}),1)>1
                        Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})(mouse,:,:) = Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})./max(max(Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})(ind1:ind2,:)));
                        Data_Norm_Mean_All_SB.(Struct_name{Struct}).(Side{side})(mouse,:,:) = Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})./nanmean(OB_Low_Data_Fz.(Side{side}){mouse})';
                        clear P, P = Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})./nanmean(OB_Low_Data_Fz.(Side{side}){mouse})';
                        Power_Evol.(Struct_name{Struct}).(Side{side})(mouse,:) = nanmean(P(ind1:ind2,:));
                    end
                else
                    Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})(mouse,:) = Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})./max(Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse}));
                end
            end
            if isfield(Data_Norm2_rand.(Side{side}),Mouse_names{mouse})
                Data_Norm_Mean_Per_Mouse_rand.(Side{side}).(Mouse_names{mouse}) = squeeze(nanmean(Data_Norm2_rand.(Side{side}).(Mouse_names{mouse})))';
                if Struct~=6
                    if size(Data_Norm_Mean_Per_Mouse_rand.(Side{side}).(Mouse_names{mouse}),1)>1
                        Data_Norm_Mean_All_rand.(Struct_name{Struct}).(Side{side})(mouse,:,:) = Data_Norm_Mean_Per_Mouse_rand.(Side{side}).(Mouse_names{mouse})./max(max(Data_Norm_Mean_Per_Mouse_rand.(Side{side}).(Mouse_names{mouse})(ind1:ind2,:)));
                        Data_Norm_Mean_All_SB_rand.(Struct_name{Struct}).(Side{side})(mouse,:,:) = Data_Norm_Mean_Per_Mouse_rand.(Side{side}).(Mouse_names{mouse})./nanmean(OB_Low_Data_Fz.(Side{side}){mouse})';
                        clear P, P = Data_Norm_Mean_Per_Mouse_rand.(Side{side}).(Mouse_names{mouse})./nanmean(OB_Low_Data_Fz.(Side{side}){mouse})';
                        Power_Evol_rand.(Struct_name{Struct}).(Side{side})(mouse,:) = nanmean(P(ind1:ind2,:));
                    end
                else
                    Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})(mouse,:) = Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})./max(Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse}));
                end
            end
        end
    end
    Power_Evol.(Struct_name{Struct}).(Side{side})(Power_Evol.(Struct_name{Struct}).(Side{side})==0)=NaN;
    Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})(Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})==0)=NaN;
    Data_Norm_Mean_All_SB.(Struct_name{Struct}).(Side{side})(Data_Norm_Mean_All_SB.(Struct_name{Struct}).(Side{side})==0)=NaN;
    Power_Evol_rand.(Struct_name{Struct}).(Side{side})(Power_Evol_rand.(Struct_name{Struct}).(Side{side})==0)=NaN;
    Data_Norm_Mean_All_rand.(Struct_name{Struct}).(Side{side})(Data_Norm_Mean_All_rand.(Struct_name{Struct}).(Side{side})==0)=NaN;
    Data_Norm_Mean_All_SB_rand.(Struct_name{Struct}).(Side{side})(Data_Norm_Mean_All_SB_rand.(Struct_name{Struct}).(Side{side})==0)=NaN;
    
    for side=1:3
        Data_Norm_Mice_Mean.(Side{side}) = squeeze(nanmean(Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})));
        Data_Norm_Mice_MeanSB.(Side{side}) = squeeze(nanmean(Data_Norm_Mean_All_SB.(Struct_name{Struct}).(Side{side})));
        
        Data_Norm_Mice_Mean_rand.(Side{side}) = squeeze(nanmean(Data_Norm_Mean_All_rand.(Struct_name{Struct}).(Side{side})));
        Data_Norm_Mice_MeanSB_rand.(Side{side}) = squeeze(nanmean(Data_Norm_Mean_All_SB_rand.(Struct_name{Struct}).(Side{side})));
    end
    
    %     % figures
    %     figure
    %     for side=1:3
    %         subplot(1,3,side)
    %         if Struct~=6
    %             imagesc([1:50] , Range_to_use , Data_Norm_Mice_Mean.(Side{side})); axis xy
    %             caxis([0 1]);
    %             if Struct==3; ylim([0 10]); end
    %             ylabel('Frequency (Hz)')
    %
    %         else
    %             Data_To_Use = Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side}); %if size(Data_To_Use,1)==1; Data_To_Use=[Data_To_Use;Data_To_Use]; end
    %             Conf_Inter=nanstd(Data_To_Use)/sqrt(size(Data_To_Use,1));
    %             clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_To_Use);
    %             shadedErrorBar([1:50],Mean_All_Sp,Conf_Inter,'-k',1); hold on;
    %             makepretty
    %             ylabel('Frequency (Hz)')
    %         end
    %
    %         title(Side{side})
    %         h=vline(25,'--r'); set(h,'LineWidth',2)
    %         xticks([1 25 50]); xticklabels({['-' num2str(window_time*1e3) 'ms'],'0',['+' num2str(window_time*1e3) 'ms']});
    %
    %         colormap jet
    %     end
    %     suptitle(['Mean spectrum around ripples, ' Struct_name{Struct} ' spectrum'])
end



for mouse=1:length(Mouse)
    
    %mouse=mouse+1;
    figure('color',[1 1 1])
    subplot(331),
    bar([Fz_Duration_Shock.(Mouse_names{mouse}) Fz_Duration_Safe.(Mouse_names{mouse})])
    ylabel('fz duration'), xticklabels({'Shock','Safe'})
    title(['Mouse: ',num2str(mouse)])
    
    subplot(334)
    bar([Respi_Shock.(Mouse_names{mouse}) Respi_Safe.(Mouse_names{mouse})])
    ylabel('fz respi'), xticklabels({'Shock','Safe'})
    
    subplot(337)
    bar([RipplesDensity_Shock.(Mouse_names{mouse}) RipplesDensity_Safe.(Mouse_names{mouse})])
    ylabel('ripples occurency'), xticklabels({'Shock','Safe'})
    
    subplot(132)
    imagesc([1:50] , RangeLow , SmoothDec(squeeze(Data_Norm_Mean_All.OB_Low.Shock(mouse,:,:)),.7)), axis xy
    u=vline(25,'--r'); u.LineWidth=5;
    ylim([0 10])
    caxis([0 1.2])
    xticks([1 25 50]); xticklabels({'-3s','0','+3s'});
    title('Fz shock')
    
    subplot(133)
    imagesc([1:50] , RangeLow , SmoothDec(squeeze(Data_Norm_Mean_All.OB_Low.Safe(mouse,:,:)),.7)), axis xy
    u=vline(25,'--r'); u.LineWidth=5;
    ylim([0 10])
    caxis([0 1.2])
    xticks([1 25 50]); xticklabels({'-3s','0','+3s'});
    title('Fz safe')
    
    colormap jet
end


%% other method
clear all
GetEmbReactMiceFolderList_BM
Struct_name={'HPC_VHigh','HPC_Low','OB_Low','OB_High','PFC_Low','Heart_rate'};

Mouse=[688,739,777,849,1170,1189,1251,1253,1254];
Side={'All','Shock','Safe'};

cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
window_time = 3;
Side={'All','Shock','Safe'};

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    Ripples_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'ripples');
    Fz_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','freezeepoch');
    Zone_Epoch.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}) ,'epoch','epochname','zoneepoch');
    Shock_Epoch.(Mouse_names{mouse}) = Zone_Epoch.(Mouse_names{mouse}){1};
    Safe_Epoch.(Mouse_names{mouse}) = or(Zone_Epoch.(Mouse_names{mouse}){2} , Zone_Epoch.(Mouse_names{mouse}){5});
    
    Fz_Ripples_Epoch.All.(Mouse_names{mouse}) = Restrict(Ripples_Epoch.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
    Fz_Ripples_Epoch.Shock.(Mouse_names{mouse}) = Restrict(Ripples_Epoch.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse})));
    Fz_Ripples_Epoch.Safe.(Mouse_names{mouse}) = Restrict(Ripples_Epoch.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse})));
    
    OB_High_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','B_High');
    OB_Low_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','B_Low');
    HPC_VHigh_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','H_Vhigh');
    HPC_Low_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','H_Low');
    try
        PFC_Low_Spec.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'spectrum','prefix','PFCx_Low');
    catch
        PFC_Low_Spec.(Mouse_names{mouse})=tsd([],[]);
    end
    
    HeartRate.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'heartrate');
end




for Struct=1:length(Struct_name)
    clear Data_Norm2 Data_Norm_Mean_Per_Mouse Data_Norm_Mice_Mean  %Data_Norm_Mean_All
    for mouse =1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        if Struct==1
            Data_to_use = HPC_VHigh_Spec.(Mouse_names{mouse});    Range_to_use = RangeVHigh; ind1=41; ind2=94;
        elseif Struct==2
            Data_to_use = HPC_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow; ind1=52; ind2=157;
        elseif Struct==3
            Data_to_use = OB_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow; ind1=13; ind2=100;
        elseif Struct==4
            Data_to_use = OB_High_Spec.(Mouse_names{mouse});    Range_to_use = RangeHigh; ind1=9; ind2=29;
        elseif Struct==5
            Data_to_use = PFC_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow; ind1=52; ind2=157;
        elseif Struct==6
            Data_to_use = HeartRate.(Mouse_names{mouse});    Range_to_use = 1;
        end
        
        for side=1:3
            FreezingEp.(Side{side})(mouse) = length(Range(Fz_Ripples_Epoch.(Side{side}).(Mouse_names{mouse})));
            clear Rg
            Rg = Range(Fz_Ripples_Epoch.(Side{side}).(Mouse_names{mouse}));
            for ep=1:length(Range(Fz_Ripples_Epoch.(Side{side}).(Mouse_names{mouse})))
                
                clear Rg Data_temp Data_temp_Norm
                Rg = Range(Fz_Ripples_Epoch.(Side{side}).(Mouse_names{mouse}));
                %                 Epoch_to_use = intervalSet(Rg(ep)-window_time*1e4 , Rg(ep)+window_time*1e4);
                Epoch_to_use = and(intervalSet(Rg(ep)-window_time*1e4 , Rg(ep)+window_time*1e4) , Fz_Epoch.(Mouse_names{mouse})); % consider only freezing epochs
                if Stop(Epoch_to_use)-Start(Epoch_to_use)~=window_time*2e4
                    Epoch_to_use=intervalSet(0,0);
                    FreezingEp.(Side{side})(mouse) = FreezingEp.(Side{side})(mouse) -1;
                end
                Data_temp = Data(Restrict(Data_to_use , Epoch_to_use));
                
                if isempty(Data_temp) % no data
                    if Struct==6
                        Data_temp = NaN(50,1);
                    else
                        Data_temp = NaN(50,length(Range_to_use));
                    end
                end
                if size(Data_temp , 1)<3 % too short episodes
                    if Struct==6
                        Data_temp = NaN(50,1);
                    else
                        Data_temp = NaN(50,length(Range_to_use));
                    end
                end
                if size(Data_temp , 2)>1 % spectrogram
                    for line=1:length(Range_to_use)
                        Data_temp_Norm(:,line) = interp1(linspace(0,1,size(Data_temp , 1)) ,  Data_temp(:,line)' , linspace(0,1,50));
                    end
                    Data_Norm2.(Side{side}).(Mouse_names{mouse})(ep,:,:) = Data_temp_Norm;
                else % no spectrogram
                    Data_Norm2.(Side{side}).(Mouse_names{mouse})(ep,:) = interp1(linspace(0,1,size(Data_temp , 1)) ,  Data_temp' , linspace(0,1,50));
                end
            end
            FreezingEpProp.(Side{side})(mouse) = FreezingEp.(Side{side})(mouse)/length(Rg);
        end
        disp(Mouse_names{mouse})
    end
    
    for mouse=1:length(Mouse)
        for side=1:3
            if size(Data_Norm2.(Side{side}).(Mouse_names{mouse}),1)==1
                Data_Norm2.(Side{side}).(Mouse_names{mouse})=[Data_Norm2.(Side{side}).(Mouse_names{mouse}) ; Data_Norm2.(Side{side}).(Mouse_names{mouse})];
            end
        end
    end
    
    % average along episodes for each mouse, then average for mice
    for mouse=1:length(Mouse)
        for side=1:3
            
            Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse}) = squeeze(nanmean(Data_Norm2.(Side{side}).(Mouse_names{mouse})))';
            
            if Struct~=6
                Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})(mouse,:,:) = Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})./max(max(Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})(ind1:ind2,:)));
            else
                Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})(mouse,:) = Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})./Data_Norm_Mean_Per_Mouse.(Side{side}).(Mouse_names{mouse})(1);
            end
        end
    end
    for side=1:3
        Data_Norm_Mice_Mean.(Side{side}) = squeeze(nanmean(Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side})));
        FreezingEp_All(:,side) = FreezingEp.(Side{side});
        FreezingEpProp_All(:,side) = FreezingEpProp.(Side{side});
    end
    % figures
    figure
    for side=1:3
        subplot(1,3,side)
        if Struct~=6
            imagesc([1:50] , Range_to_use , Data_Norm_Mice_Mean.(Side{side})); axis xy
            caxis([0 1]);
            if Struct==3; ylim([0 10]); end
            if mouse==1; title(Side{side}); end
            
        else
            Data_To_Use = Data_Norm_Mean_All.(Struct_name{Struct}).(Side{side}); %if size(Data_To_Use,1)==1; Data_To_Use=[Data_To_Use;Data_To_Use]; end
            Conf_Inter=nanstd(Data_To_Use)/sqrt(size(Data_To_Use,1));
            clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_To_Use);
            shadedErrorBar([1:50],Mean_All_Sp,Conf_Inter,'-k',1); hold on;
            makepretty
        end
        
        if side==1, ylabel('Frequency (Hz)'); end
        h=vline(25,'--r'); set(h,'LineWidth',2)
        xticks([1 25 50]); xticklabels({['-' num2str(window_time*1e3) 'ms'],'0',['+' num2str(window_time*1e3) 'ms']});
        title([Side{side}])
        
        colormap jet
    end
    sgtitle(['Mean spectrum around ripples, ' Struct_name{Struct} ' spectrum'])
end


Cols = {[0.66 0.66 1],[0 0 1],[0 0 0.33]};
X = [1:3];
Legends ={'All Freezing' 'Shock Freezing' 'Safe Freezing'};
NoLegends ={'' '' ''};

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(FreezingEp_All,Cols,X,Legends,'showpoints',0);
ylabel('#')
title('ripples number')

subplot(122)
MakeSpreadAndBoxPlot2_SB(FreezingEpProp_All*100,Cols,X,Legends,'showpoints',0);
ylabel('proportion')
title('ripples proportion')

sgtitle('Selected data, ripples, window time = 3 s')



%%



for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    
    Ripples.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondPostSess.(Mouse_names{mouse}),'ripples');
    
    Fz_Ripples.All.(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
    Fz_Ripples.Shock.(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Shock_Epoch.(Mouse_names{mouse})));
    Fz_Ripples.Safe.(Mouse_names{mouse}) = Restrict(Ripples.(Mouse_names{mouse}) , and(Fz_Epoch.(Mouse_names{mouse}) , Safe_Epoch.(Mouse_names{mouse})));
    
end

Side={'All','Shock','Safe'};
Struct_name={'HPC_VHigh','HPC_Low','OB_Low','OB_High','PFC_Low','Heart_rate'};


for Struct=1:5%length(Struct_name)
    
    if Struct==1
        Data_to_use = HPC_VHigh_Spec.(Mouse_names{mouse});    Range_to_use = RangeVHigh;
    elseif Struct==2
        Data_to_use = HPC_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow;
    elseif Struct==3
        Data_to_use = OB_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow;
    elseif Struct==4
        Data_to_use = OB_High_Spec.(Mouse_names{mouse});    Range_to_use = RangeHigh;
    elseif Struct==5
        Data_to_use = PFC_Low_Spec.(Mouse_names{mouse});    Range_to_use = RangeLow;
    elseif Struct==6
        Data_to_use = HeartRate.(Mouse_names{mouse});    Range_to_use = 1;
    end
    
    for mouse=1:length(Mouse)
        [M.All.(Struct_name{Struct}).(Mouse_names{mouse}),S,t]=AverageSpectrogram(Data_to_use,Range_to_use,Fz_Ripples.All.(Mouse_names{mouse}),10,100,0,1);
        [M.Shock.(Struct_name{Struct}).(Mouse_names{mouse}),S,t]=AverageSpectrogram(Data_to_use,Range_to_use,Fz_Ripples.Shock.(Mouse_names{mouse}),10,100,0,1);
        [M.Safe.(Struct_name{Struct}).(Mouse_names{mouse}),S,t]=AverageSpectrogram(Data_to_use,Range_to_use,Fz_Ripples.Safe.(Mouse_names{mouse}),10,100,0,1);
        
        M_pre.All.(Struct_name{Struct})(mouse,:,:) = M.All.(Struct_name{Struct}).(Mouse_names{mouse});
        M_pre.Shock.(Struct_name{Struct})(mouse,:,:) = M.Shock.(Struct_name{Struct}).(Mouse_names{mouse});
        M_pre.Safe.(Struct_name{Struct})(mouse,:,:) = M.Safe.(Struct_name{Struct}).(Mouse_names{mouse});
    end
    M_all.All.(Struct_name{Struct}) = squeeze(nanmean(M_pre.All.(Struct_name{Struct})));
    M_all.Shock.(Struct_name{Struct}) = squeeze(nanmean(M_pre.Shock.(Struct_name{Struct})));
    M_all.Safe.(Struct_name{Struct}) = squeeze(nanmean(M_pre.Safe.(Struct_name{Struct})));
    
    figure
    for side=1:3
        subplot(1,3,side)
        imagesc(t/1E3,Range_to_use,M_all.(Side{side}).(Struct_name{Struct})), axis xy
        yl=ylim;
        line([0 0],yl,'color','w')
        ylabel('Frequency (Hz)')
        xlabel('Times (s)')
        xlim([t(2) t(end-1)]/1E3)
        ylim([Range_to_use(1) Range_to_use(end)])
    end
end




subplot(132)
imagesc(t/1E3,Range_to_use,M_all.Shock), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
xlabel('Times (s)')
xlim([t(2) t(end-1)]/1E3)
ylim([RangeLow(1) RangeLow(end)])

subplot(133)
imagesc(t/1E3,RangeLow,M_all.Safe), axis xy
yl=ylim;
line([0 0],yl,'color','w')
ylabel('Frequency (Hz)')
xlabel('Times (s)')
xlim([t(2) t(end-1)]/1E3)
ylim([RangeLow(1) RangeLow(end)])


figure
subplot(131)
[M,S,t]=AverageSpectrogram(OB_Low_Spec.(Mouse_names{mouse}),RangeLow,Fz_Ripples.All.(Mouse_names{mouse}),10,100,0,1);
subplot(132)
[M,S,t]=AverageSpectrogram(OB_Low_Spec.(Mouse_names{mouse}),RangeLow,Fz_Ripples.Shock.(Mouse_names{mouse}),10,100,0,1);
subplot(133)
[M,S,t]=AverageSpectrogram(OB_Low_Spec.(Mouse_names{mouse}),RangeLow,Fz_Ripples.Safe.(Mouse_names{mouse}),10,100,0,1);










