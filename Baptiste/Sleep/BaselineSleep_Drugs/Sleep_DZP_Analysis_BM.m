
clear all

SleepInfo = GetSleepSessions_Drugs_BM;

% take 2 hours of sleep before injection and 1 hour after
Drug_Group= {'Saline','DZP','BUS'};
sal_n = 9;
dzp_n = 12;
bus_n = 9;

cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};

Cols = {[0.3 0.3 0.3],[0.5 0.5 0.5],[0.7 0.7 0.7],[0 0 1],[0.4 0.4 1],[0.7 0.7 1],[1 0 0],[1 0.4 0.4],[1 0.7 0.7]};
X = [1:3 5:7 9:11];
Legends = {'Pre','+1h','Post','Pre','+1h','Post','Pre','+1h','Post'};
NoLegends = {'','','','','','','','',''};


for drug = 1:2%length(Drug_Group)
    clear Mouse_names
    for mouse = 1:length(SleepInfo.path{drug})
%         Mouse_names{mouse}=SleepInfo.MouseName{drug,mouse};
        
        cd(SleepInfo.path{drug}{mouse})
        clear SmoothTheta SmoothGamma tRipples EKG MovAcctsd Sleep Wake SWSEpoch REMEpoch Epoch RipplesEpochR
        load('SleepScoring_OBGamma.mat'); load('SleepSubstages.mat'); load('behavResources.mat', 'MovAcctsd');
        try; load('HeartBeatInfo.mat'); end
        load('SWR.mat'); load('DeltaWaves.mat')
        
        NREM_Epoch.(Drug_Group{drug}){mouse} = SWSEpoch; REM_Epoch.(Drug_Group{drug}){mouse} = REMEpoch;
        N1_Epoch.(Drug_Group{drug}){mouse} = Epoch{1}; N2_Epoch.(Drug_Group{drug}){mouse} = Epoch{2}; N3_Epoch.(Drug_Group{drug}){mouse} = Epoch{3};
        
        chan_numb = Get_chan_numb_BM(SleepInfo.path{drug}{mouse} , 'rip');
        LFP_rip.(Drug_Group{drug}){mouse} = ConcatenateDataFromFolders_BM({SleepInfo.path{drug}{mouse}},'lfp','channumber',chan_numb);
        Ripples_tsd.(Drug_Group{drug}){mouse} = ConcatenateDataFromFolders_SB({SleepInfo.path{drug}{mouse}},'ripples');
        
        load('H_VHigh_Spectrum.mat');
        H_VHigh_Sp_Pre = tsd(Spectro{2}*1e4,Spectro{1});
        load('H_Low_Spectrum.mat');
        H_Low_Sp_Pre = tsd(Spectro{2}*1e4,Spectro{1});
        load('B_Low_Spectrum.mat');
        OB_Low_Sp_Pre = tsd(Spectro{2}*1e4,Spectro{1});
        load('PFCx_Low_Spectrum.mat')
        PFCx_Low_Sp_Pre = tsd(Spectro{2}*1e4,Spectro{1});
        
        %
        time_max=max(Range(SmoothGamma));
        
        DZP_Epoch.(Drug_Group{drug}){mouse}{1} = intervalSet(0 , SleepInfo.Injection_time{drug,mouse}-80e4);
        DZP_Epoch.(Drug_Group{drug}){mouse}{2} = intervalSet(SleepInfo.Injection_time{drug,mouse} , SleepInfo.Injection_time{drug,mouse}+3600*1e4);
        if and(mouse==8 , drug==1)
            DZP_Epoch.(Drug_Group{drug}){mouse}{3} = intervalSet(SleepInfo.Injection_time{drug,mouse}+3600*1e4 , 3.3345e8);
        elseif and(mouse==6 , drug==3)
            DZP_Epoch.(Drug_Group{drug}){mouse}{3} = intervalSet(SleepInfo.Injection_time{drug,mouse}+3600*1e4 , 3.3345e8);
        else
            DZP_Epoch.(Drug_Group{drug}){mouse}{3} = intervalSet(SleepInfo.Injection_time{drug,mouse}+3600*1e4 , max(Range(MovAcctsd)));
        end
        
        try; HR.(Drug_Group{drug}){mouse} = EKG.HBRate;
        catch; HR.(Drug_Group{drug}){mouse} = NaN;
        end
        Accelero.(Drug_Group{drug}){mouse} = MovAcctsd;
        
        for sleep_part=1:3
            Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part} = and(Sleep , DZP_Epoch.(Drug_Group{drug}){mouse}{sleep_part});
            Wake_DZP.(Drug_Group{drug}){mouse}{sleep_part} = and(Wake , DZP_Epoch.(Drug_Group{drug}){mouse}{sleep_part});
        end
        
        SleepEp_PostInjection.(Drug_Group{drug}){mouse} = and(Sleep , or(DZP_Epoch.(Drug_Group{drug}){mouse}{2} , DZP_Epoch.(Drug_Group{drug}){mouse}{3}));
        LatencyToSleep_PostInjection.(Drug_Group{drug}){mouse} = Start(SleepEp_PostInjection.(Drug_Group{drug}){mouse});
        SleepEp_Duration.(Drug_Group{drug}){mouse} = (Stop(SleepEp_PostInjection.(Drug_Group{drug}){mouse})-Start(SleepEp_PostInjection.(Drug_Group{drug}){mouse}))/1e4;
        % will only consider episodes longer than 5s
        LatencyToSleep_PostInjection_Corrected.(Drug_Group{drug}){mouse} = (LatencyToSleep_PostInjection.(Drug_Group{drug}){mouse}(find(SleepEp_Duration.(Drug_Group{drug}){mouse}>5,1)) - SleepInfo.Injection_time{drug,mouse})/1e4;
        
        for sleep_part=1:3 % Sleep part : 1=before injection, 2=+1h after injection, 3=+1h until the end
            
            % Sleep features
            States = {'Wake','Sleep','NREM','REM','N1','N2','N3'};
            Subdivision = {'proportion','numb','mean_duration'};
            for state = 1:length(States)
                for sub = 1:length(Subdivision)
                    
                    if state==1
                        Epoch_to_use{1} = Wake_DZP.(Drug_Group{drug}){mouse}{1}; Epoch_to_use{2} = Wake_DZP.(Drug_Group{drug}){mouse}{2}; Epoch_to_use{3} = Wake_DZP.(Drug_Group{drug}){mouse}{3};
                    elseif state==2
                        Epoch_to_use{1} = Sleep_DZP.(Drug_Group{drug}){mouse}{1}; Epoch_to_use{2} = Sleep_DZP.(Drug_Group{drug}){mouse}{2}; Epoch_to_use{3} = Sleep_DZP.(Drug_Group{drug}){mouse}{3};
                    elseif state==3
                        Epoch_to_use{1} = and(NREM_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{1}); Epoch_to_use{2} = and(NREM_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{2}); Epoch_to_use{3} = and(NREM_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{3});
                    elseif state==4
                        Epoch_to_use{1} = and(REM_Epoch.(Drug_Group{drug}){mouse}   , Sleep_DZP.(Drug_Group{drug}){mouse}{1}); Epoch_to_use{2} = and(REM_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{2}); Epoch_to_use{3} = and(REM_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{3});
                    elseif state==5
                        Epoch_to_use{1} = and(N1_Epoch.(Drug_Group{drug}){mouse}   , Sleep_DZP.(Drug_Group{drug}){mouse}{1}); Epoch_to_use{2} = and(N1_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{2}); Epoch_to_use{3} = and(N1_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{3});
                    elseif state==6
                        Epoch_to_use{1} = and(N2_Epoch.(Drug_Group{drug}){mouse}   , Sleep_DZP.(Drug_Group{drug}){mouse}{1}); Epoch_to_use{2} = and(N2_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{2}); Epoch_to_use{3} = and(N2_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{3});
                    elseif state==7
                        Epoch_to_use{1} = and(N3_Epoch.(Drug_Group{drug}){mouse}   , Sleep_DZP.(Drug_Group{drug}){mouse}{1}); Epoch_to_use{2} = and(N3_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{2}); Epoch_to_use{3} = and(N3_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{3});
                    end
                    
                    if sub==1
                        if or(state==1,state==2)
                            Features.(Drug_Group{drug}).(States{state}).(Subdivision{sub})(mouse,sleep_part) = sum(Stop(Epoch_to_use{sleep_part})-Start(Epoch_to_use{sleep_part}))/sum(Stop(DZP_Epoch.(Drug_Group{drug}){mouse}{sleep_part})-Start(DZP_Epoch.(Drug_Group{drug}){mouse}{sleep_part}));
                        else
                            Features.(Drug_Group{drug}).(States{state}).(Subdivision{sub})(mouse,sleep_part) = sum(Stop(Epoch_to_use{sleep_part})-Start(Epoch_to_use{sleep_part}))/sum(Stop(Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part})-Start(Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part}));
                        end
                    elseif sub==2
                        if or(state==1,state==2)
                            Features.(Drug_Group{drug}).(States{state}).(Subdivision{sub})(mouse,sleep_part) = length(Start(Epoch_to_use{sleep_part}))/(sum(Stop(DZP_Epoch.(Drug_Group{drug}){mouse}{sleep_part})-Start(DZP_Epoch.(Drug_Group{drug}){mouse}{sleep_part}))/3.6e7);
                        else
                            Features.(Drug_Group{drug}).(States{state}).(Subdivision{sub})(mouse,sleep_part) = length(Start(Epoch_to_use{sleep_part}))/(sum(Stop(Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part})-Start(Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part}))/3.6e7);
                        end
                    else
                        Features.(Drug_Group{drug}).(States{state}).(Subdivision{sub})(mouse,sleep_part) = nanmean(Stop(Epoch_to_use{sleep_part})-Start(Epoch_to_use{sleep_part}))/1e4;
                    end
                end
                
                % HR features
                try
                    if state==1
                        HR.(Drug_Group{drug}).(States{state})(mouse,sleep_part) = nanmean(Data(Restrict(HR.(Drug_Group{drug}){mouse} , Epoch_to_use{sleep_part})));
                    else
                        HR.(Drug_Group{drug}).(States{state})(mouse,sleep_part) = nanmean(Data(Restrict(HR.(Drug_Group{drug}){mouse} , Epoch_to_use{sleep_part})));
                    end
                end
                Rip_Density.(States{state}).(Drug_Group{drug})(mouse,sleep_part) = length(Restrict(tRipples,Epoch_to_use{sleep_part}))/(sum(Stop(Epoch_to_use{sleep_part})-Start(Epoch_to_use{sleep_part}))/1e4);
                Rip_Density2.(States{state}).(Drug_Group{drug})(mouse,sleep_part) = length(Start(and(RipplesEpoch,Epoch_to_use{sleep_part})))/(sum(Stop(Epoch_to_use{sleep_part})-Start(Epoch_to_use{sleep_part}))/1e4);
                
                H_VHigh_Sp.(States{state}).(Drug_Group{drug})(mouse,sleep_part,:) = nanmean(Data(Restrict(H_VHigh_Sp_Pre , Epoch_to_use{sleep_part})));
                H_Low_Sp.(States{state}).(Drug_Group{drug})(mouse,sleep_part,:) = nanmean(Data(Restrict(H_Low_Sp_Pre , Epoch_to_use{sleep_part})));
                OB_Low_Sp.(States{state}).(Drug_Group{drug})(mouse,sleep_part,:) = nanmean(Data(Restrict(OB_Low_Sp_Pre , Epoch_to_use{sleep_part})));
                PFCx_Low_Sp.(States{state}).(Drug_Group{drug})(mouse,sleep_part,:) = nanmean(Data(Restrict(PFCx_Low_Sp_Pre , Epoch_to_use{sleep_part})));
                
                %                 [mean_curve.(States{state}).(Drug_Group{drug})(:,mouse,sleep_part) , delta_density.(States{state}).(Drug_Group{drug})(mouse,sleep_part) , mean_duration.(States{state}).(Drug_Group{drug})(mouse,sleep_part)] = Delta_Analysis_BM(Epoch_to_use{sleep_part});
                
                % Ripples mean waveform
                clear Ripples_times_OnEpoch ripples_time T_pre
                try
                    Ripples_times_OnEpoch = Restrict(Ripples_tsd.(Drug_Group{drug}){mouse} , Epoch_to_use{sleep_part});
                    ripples_time = Range(Ripples_times_OnEpoch,'s');
                    [M_pre] = PlotRipRaw(LFP_rip.(Drug_Group{drug}){mouse}, ripples_time, 400, 0, 0);
                    Mean_Ripples.(States{state}).(Drug_Group{drug})(mouse,sleep_part,:) = M_pre(:,2);
                end
            end
            
            % Theta features
            Theta_REM.(Drug_Group{drug})(mouse,sleep_part) = nanmean(Data(Restrict(SmoothTheta , and(REM_Epoch.(Drug_Group{drug}){mouse} , Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part}))));
            
            % Gamma features
            Gamma_Wake.(Drug_Group{drug})(mouse,sleep_part) = nanmean(Data(Restrict(SmoothGamma , Wake_DZP.(Drug_Group{drug}){mouse}{sleep_part})));
            
            % N1 description
            try; N1_HR.(Drug_Group{drug})(mouse,sleep_part) = nanmean(Data(Restrict(HR.(Drug_Group{drug}){mouse} , and(N1_Epoch.(Drug_Group{drug}){mouse},Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part})))); end
            N1_Gamma.(Drug_Group{drug})(mouse,sleep_part) = nanmean(Data(Restrict(SmoothGamma , and(N1_Epoch.(Drug_Group{drug}){mouse},Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part}))));
            N1_Acc.(Drug_Group{drug})(mouse,sleep_part) = nanmean(Data(Restrict(Accelero.(Drug_Group{drug}){mouse} , and(N1_Epoch.(Drug_Group{drug}){mouse},Sleep_DZP.(Drug_Group{drug}){mouse}{sleep_part}))));
            
        end
        disp(Mouse_names{mouse})
    end
end


%% Corrections
N1_HR.DZP(1,:)=NaN;

for drug=2
    for states=1:length(States)
        HR.(Drug_Group{drug}).(States{states})(1,:) = NaN(1,3);
    end
end


for state = 1:7
    Features.All.(States{state}).proportion(1:sal_n,1:3) = Features.Saline.(States{state}).proportion*100;
    Features.All.(States{state}).proportion(1:dzp_n,4:6) = Features.DZP.(States{state}).proportion*100;
    Features.All.(States{state}).proportion(1:bus_n,7:9) = Features.BUS.(States{state}).proportion*100;
    Features.All.(States{state}).proportion(Features.All.(States{state}).proportion==0)= NaN;
    
    Features.All.(States{state}).numb(1:sal_n,1:3) = Features.Saline.(States{state}).numb;
    Features.All.(States{state}).numb(1:dzp_n,4:6) = Features.DZP.(States{state}).numb;
    Features.All.(States{state}).numb(1:bus_n,7:9) = Features.BUS.(States{state}).numb;
    Features.All.(States{state}).numb(Features.All.(States{state}).numb==0)= NaN;
    
    Features.All.(States{state}).mean_duration(1:sal_n,1:3) = Features.Saline.(States{state}).mean_duration;
    Features.All.(States{state}).mean_duration(1:dzp_n,4:6) = Features.DZP.(States{state}).mean_duration;
    Features.All.(States{state}).mean_duration(1:bus_n,7:9) = Features.BUS.(States{state}).mean_duration;
    Features.All.(States{state}).mean_duration(Features.All.(States{state}).mean_duration==0)= NaN;
    
    Rip_Density.(States{state}).All(1:sal_n,1:3) = Rip_Density.(States{state}).Saline;
    Rip_Density.(States{state}).All(1:dzp_n,4:6) = Rip_Density.(States{state}).DZP;
    Rip_Density.(States{state}).All(1:bus_n,7:9) = Rip_Density.(States{state}).BUS;
    Rip_Density.(States{state}).All(Rip_Density.(States{state}).All==0)=NaN;
    Rip_Density2.(States{state}).All(1:sal_n,1:3) = Rip_Density2.(States{state}).Saline;
    Rip_Density2.(States{state}).All(1:dzp_n,4:6) = Rip_Density2.(States{state}).DZP;
    Rip_Density2.(States{state}).All(1:bus_n,7:9) = Rip_Density2.(States{state}).BUS;
    Rip_Density2.(States{state}).All(Rip_Density2.(States{state}).All==0)=NaN;
    Rip_Density.(States{state}).All(6,4:6)=NaN;
    Rip_Density2.(States{state}).All(6,4:6)=NaN;
    Rip_Density.(States{state}).All(3,1:3)=NaN;
    
    HR.All.(States{state})(1:sal_n,1:3) = HR.Saline.(States{state});
    HR.All.(States{state})(1:dzp_n,4:6) = HR.DZP.(States{state});
    HR.All.(States{state})(1:bus_n,7:9) = HR.BUS.(States{state});
    HR.All.(States{state})(HR.All.(States{state})==0)= NaN;
    
    
    %     for mouse=1:length(delta_density.(States{state}).Saline)
    %         for sleep_part=1:3
    %             delta_density.(States{state}).All(mouse,sleep_part) = delta_density.(States{state}).Saline(mouse,sleep_part);
    %             mean_duration.(States{state}).All.all(mouse,sleep_part) = mean_duration.(States{state}).Saline(mouse,sleep_part).all;
    %             mean_duration.(States{state}).All.short(mouse,sleep_part) = mean_duration.(States{state}).Saline(mouse,sleep_part).short;
    %             mean_duration.(States{state}).All.long(mouse,sleep_part) = mean_duration.(States{state}).Saline(mouse,sleep_part).long;
    %             try
    %                 mean_curve.(States{state}).All.all.sup(mouse,sleep_part,:) = mean_curve.(States{state}).Saline(1,mouse,sleep_part).all.sup(:,2);
    %                 mean_curve.(States{state}).All.all.deep(mouse,sleep_part,:) = mean_curve.(States{state}).Saline(1,mouse,sleep_part).all.deep(:,2);
    %             end
    %         end
    %     end
    %     for mouse=1:length(delta_density.(States{state}).DZP)
    %         for sleep_part=1:3
    %             delta_density.(States{state}).All(mouse,sleep_part+3) = delta_density.(States{state}).DZP(mouse,sleep_part);
    %             mean_duration.(States{state}).All.all(mouse,sleep_part+3) = mean_duration.(States{state}).DZP(mouse,sleep_part).all;
    %             mean_duration.(States{state}).All.short(mouse,sleep_part+3) = mean_duration.(States{state}).DZP(mouse,sleep_part).short;
    %             mean_duration.(States{state}).All.long(mouse,sleep_part+3) = mean_duration.(States{state}).DZP(mouse,sleep_part).long;
    %             try
    %                 mean_curve.(States{state}).All.all.sup(mouse,sleep_part+3,:) = mean_curve.(States{state}).DZP(1,mouse,sleep_part).all.sup(:,2);
    %                 mean_curve.(States{state}).All.all.deep(mouse,sleep_part+3,:) = mean_curve.(States{state}).DZP(1,mouse,sleep_part).all.deep(:,2);
    %             end
    %         end
    %     end
    %     for mouse=1:length(delta_density.(States{state}).BUS)
    %         for sleep_part=1:3
    %             delta_density.(States{state}).All(mouse,sleep_part+6) = delta_density.(States{state}).BUS(mouse,sleep_part);
    %             mean_duration.(States{state}).All.all(mouse,sleep_part+6) = mean_duration.(States{state}).BUS(mouse,sleep_part).all;
    %             mean_duration.(States{state}).All.short(mouse,sleep_part+6) = mean_duration.(States{state}).BUS(mouse,sleep_part).short;
    %             mean_duration.(States{state}).All.long(mouse,sleep_part+6) = mean_duration.(States{state}).BUS(mouse,sleep_part).long;
    %             try
    %                 mean_curve.(States{state}).All.all.sup(mouse,sleep_part+6,:) = mean_curve.(States{state}).BUS(1,mouse,sleep_part).all.sup(:,2);
    %                 mean_curve.(States{state}).All.all.deep(mouse,sleep_part+6,:) = mean_curve.(States{state}).BUS(1,mouse,sleep_part).all.deep(:,2);
    %             end
    %         end
    %     end
    %     delta_density.(States{state}).All(delta_density.(States{state}).All==0)=NaN;
    %     mean_duration.(States{state}).All.all(mean_duration.(States{state}).All.all==0)=NaN;
    %     mean_duration.(States{state}).All.short(mean_duration.(States{state}).All.short==0)=NaN;
    %     mean_duration.(States{state}).All.long(mean_duration.(States{state}).All.long==0)=NaN;
    %     try
    %         mean_curve.(States{state}).All.all.sup(mean_curve.(States{state}).All.all.sup==0)=NaN;
    %         mean_curve.(States{state}).All.all.deep(mean_curve.(States{state}).All.all.deep==0)=NaN;
    %     end
end
Gamma_Wake.All(1:sal_n,1:3) = Gamma_Wake.Saline;
Gamma_Wake.All(1:dzp_n,4:6) = Gamma_Wake.DZP;
Gamma_Wake.All(1:bus_n,7:9) = Gamma_Wake.BUS;
Gamma_Wake.All(Gamma_Wake.All==0)=NaN;

Theta_REM.All(1:sal_n,1:3) = Theta_REM.Saline;
Theta_REM.All(1:dzp_n,4:6) = Theta_REM.DZP;
Theta_REM.All(1:bus_n,7:9) = Theta_REM.BUS;
Theta_REM.All(Theta_REM.All==0)=NaN;

N1_Acc.All(1:sal_n,1:3) = N1_Acc.Saline;
N1_Acc.All(1:dzp_n,4:6) = N1_Acc.DZP;
N1_Acc.All(1:bus_n,7:9) = N1_Acc.BUS;
N1_Acc.All(N1_Acc.All==0)=NaN;

N1_HR.All(1:sal_n,1:3) = N1_HR.Saline;
N1_HR.All(1:dzp_n,4:6) = N1_HR.DZP;
N1_HR.All(1:bus_n,7:9) = N1_HR.BUS;
N1_HR.All(N1_HR.All==0)=NaN;

N1_Gamma.All(1:sal_n,1:3) = N1_Gamma.Saline;
N1_Gamma.All(1:dzp_n,4:6) = N1_Gamma.DZP;
N1_Gamma.All(1:bus_n,7:9) = N1_Gamma.BUS;
N1_Gamma.All(N1_Gamma.All==0)=NaN;

Gamma_Wake.All(6,4:6)=NaN;
N1_Gamma.All(6,4:6)=NaN;
N1_HR.All(N1_HR.All<6.3)=NaN;


for drug = 1:length(Drug_Group)
    clear Mouse_names
    for mouse = 1:length(SleepInfo.MouseName(drug,cellfun(@ischar,SleepInfo.MouseName(drug,:))))
        Mouse_names{mouse}=SleepInfo.MouseName{drug,mouse};
        try
            AllLatencyToSleep_PostInjection_Corrected.(Drug_Group{drug})(mouse) = LatencyToSleep_PostInjection_Corrected.(Drug_Group{drug}){mouse}/60;
        end
    end
    AllLatencyToSleep_PostInjection_Corrected.All(1:length(AllLatencyToSleep_PostInjection_Corrected.(Drug_Group{drug})),drug) = AllLatencyToSleep_PostInjection_Corrected.(Drug_Group{drug});
end
AllLatencyToSleep_PostInjection_Corrected.All(AllLatencyToSleep_PostInjection_Corrected.All==0)=NaN;

for sleep_part=1:3
    H_VHigh_Sp.(States{3}).(Drug_Group{2})(6,sleep_part,:)=NaN;
end
H_VHigh_Sp.(States{1}).(Drug_Group{3})(7,3,:)=NaN;

%% Figures
% Basic sleep features
figure;
for state = 2:4
    
    subplot(3,3,state-1)
    MakeSpreadAndBoxPlot2_SB(Features.All.(States{state}).proportion,Cols,X,NoLegends,'showpoints',1,'paired',0,'showsigstar','none');
    title(States{state})
    if state==2; ylabel('Proportion (%)'); f=get(gca,'Children'); legend([f(72),f(48),f(24)],'Saline','DZP','BUS'); end
    ylim([0 100])
    
    subplot(3,3,state+2)
    MakeSpreadAndBoxPlot2_SB(Features.All.(States{state}).numb ,Cols,X,NoLegends,'showpoints',1,'paired',0,'showsigstar','none');
    if state==2; ylabel('Ep numb (#/hour)'); end
    ylim([0 65])
    
    subplot(3,3,state+5)
    MakeSpreadAndBoxPlot2_SB(Features.All.(States{state}).mean_duration,Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    if state==2; ylabel('Mean duration (s)'); end
    ylim([0 170])
end
a=suptitle('Sleep architecture, drugs experiments, n=5'); a.FontSize=20;


figure
for state = 5:7
    
    subplot(3,3,state-4)
    MakeSpreadAndBoxPlot2_SB(Features.All.(States{state}).proportion,Cols,X,NoLegends,'showpoints',1,'paired',0,'showsigstar','none');
    title(States{state})
    if state==5; ylabel('Proportion (%)'); f=get(gca,'Children'); legend([f(72),f(48),f(24)],'Saline','DZP','BUS'); end
    ylim([0 80])
    
    subplot(3,3,state-1)
    MakeSpreadAndBoxPlot2_SB(Features.All.(States{state}).numb,Cols,X,NoLegends,'showpoints',1,'paired',0,'showsigstar','none');
    if state==5; ylabel('Ep numb (#/hour)'); end
    ylim([0 300])
    
    subplot(3,3,state+2)
    MakeSpreadAndBoxPlot2_SB(Features.All.(States{state}).mean_duration,Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
    if state==5; ylabel('Mean duration (s)'); end
    ylim([0 20])
end
a=suptitle('NREM architecture, drugs experiments, n=5'); a.FontSize=20;


% Brain rythms modifications
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB(Rip_Density.NREM.All,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('Ripples/s'); title('Ripples density'); axis square
f=get(gca,'Children'); legend([f(78),f(54),f(30)],'Saline','DZP','BUS');

subplot(132)
MakeSpreadAndBoxPlot2_SB(log10(Gamma_Wake.All) ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('Power (u.a.)'); title('Gamma Wake'); axis square

subplot(133)
MakeSpreadAndBoxPlot2_SB(Theta_REM.All ,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Power (u.a.)'); title('Theta REM'); axis square

a=suptitle('Oscillations features, drugs experiments, n=5'); a.FontSize=20;


% N1 features
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB(N1_Acc.All ,Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('Movement quantity'); title('Accelero'); axis square
f=get(gca,'Children'); legend([f(72),f(48),f(24)],'Saline','DZP','BUS');

subplot(132)
MakeSpreadAndBoxPlot2_SB(N1_HR.All ,Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('Frequency (Hz)'); title('HR'); axis square

subplot(133)
MakeSpreadAndBoxPlot2_SB(N1_Gamma.All ,Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('Power (a.u.)'); title('Gamma power'); axis square

a=suptitle('N1 features, drugs exeperiments, n=5'); a.FontSize=20;


% HR feature during sleep stages and substages
figure
for state = 1:length(States)
    
    subplot(2,4,state)
    if state==1 | state==2 | state==3 | state==4;   MakeSpreadAndBoxPlot2_SB(HR.All.(States{state}),Cols,X,NoLegends,'showpoints',1,'paired',0,'showsigstar','none');
    else    MakeSpreadAndBoxPlot2_SB(HR.All.(States{state}),Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none'); end
    title(States{state})
    if state==1; ylabel('Frequency (Hz)'); f=get(gca,'Children'); legend([f(72),f(48),f(24)],'Saline','DZP','BUS'); end
    ylim([5 12])
    
end
a=suptitle('Heart rate frequency, drugs experiments, n=5'); a.FontSize=20;


% Latency to sleep
figure
MakeSpreadAndBoxPlot2_SB(AllLatencyToSleep_PostInjection_Corrected.All,{[0 0 0],[0 0 1],[1 0 0]},[1:3],{'Saline' 'DZP' 'BUS'},'showpoints',1,'paired',0);
title('Time lantency to sleep after injection')
ylabel('time (min)'); 
axis square


%% Ripples density
figure
subplot(241)
MakeSpreadAndBoxPlot2_SB(Rip_Density.Wake.All,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('Ripples/s'); title('Wake'); ylim([-0.02 1.3]); axis square
f=get(gca,'Children'); legend([f(76),f(52),f(20)],'Saline','DZP','BUS');

subplot(242)
MakeSpreadAndBoxPlot2_SB(Rip_Density.Sleep.All,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('Ripples/s'); title('Sleep'); ylim([-0.02 1.3]); axis square

subplot(243)
MakeSpreadAndBoxPlot2_SB(Rip_Density.NREM.All ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('NREM'); axis square; ylim([-0.02 1.3]);

subplot(244)
MakeSpreadAndBoxPlot2_SB(Rip_Density.REM.All ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('REM'); axis square; ylim([-0.02 1.3]);

subplot(234)
MakeSpreadAndBoxPlot2_SB(Rip_Density.N1.All ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('Ripples/s'); title('N1'); ylim([-0.02 1.3]); axis square
f=get(gca,'Children'); legend([f(72),f(48),f(24)],'Saline','DZP','BUS');

subplot(235)
MakeSpreadAndBoxPlot2_SB(Rip_Density.N2.All ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('N2'); ylim([-0.02 1.3]); axis square

subplot(236)
MakeSpreadAndBoxPlot2_SB(Rip_Density.N3.All ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('N3'); ylim([-0.02 1.3]); axis square
Sp
a=suptitle('Ripples density, SWR.mat'); a.FontSize=20;


%% H_VHigh spectrum
figure; thr=42; state=3;
for drug = 1:length(Drug_Group)
    subplot(1,3,drug)
    clear a; [a(:),~] = max(RangeVHigh(thr:end)'.*squeeze(H_VHigh_Sp.(States{state}).(Drug_Group{drug})(:,1,thr:end))');
    for sleep_part=1:3
        plot(RangeVHigh , nanmean(RangeVHigh.*squeeze(H_VHigh_Sp.(States{state}).(Drug_Group{drug})(:,sleep_part,:)./a')))
        hold on
    end
    makepretty
    ylim([.2 1.3]); xlim([50 250])
    if drug==1; legend('Pre','+1h','Post'); ylabel('Power (a.u.)'); end
    xlabel('Frequency (Hz)') 
    title(Drug_Group{drug}) 
end
b=suptitle('HPC Very High spectrum, sleep'); b.FontSize=20;


%% Mean waveform
figure
subplot(231)
Conf_Inter=nanstd(squeeze(Mean_Ripples.NREM.DZP(:,1,:)))/sqrt(size(squeeze(Mean_Ripples.NREM.DZP(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(Mean_Ripples.NREM.DZP(:,1,:)));
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(Mean_Ripples.Wake.DZP([2 5 8],1,:)))/sqrt(size(squeeze(Mean_Ripples.Wake.DZP([2 5 8],1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(Mean_Ripples.Wake.DZP([2 5 8],1,:)));
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty; title('Before Diazepam'); xlim([450 550]); ylabel('amplitude (a.u.)'); xlabel('time (a.u.)')
f=get(gca,'Children'); legend([f(5),f(1)],'NREM before DZP','Wake before DZP');

subplot(232)
Conf_Inter=nanstd(squeeze(Mean_Ripples.NREM.DZP(:,1,:)))/sqrt(size(squeeze(Mean_Ripples.NREM.DZP(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(Mean_Ripples.NREM.DZP(:,1,:)));
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(Mean_Ripples.NREM.DZP(:,3,:)))/sqrt(size(squeeze(Mean_Ripples.NREM.DZP(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(Mean_Ripples.NREM.DZP(:,3,:)));
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-m',1); hold on;
makepretty; title('NREM'); xlim([450 550]); ylim([-2500 1500]); xlabel('time (a.u.)')
f=get(gca,'Children'); legend([f(5),f(1)],'NREM before DZP','NREM after DZP');

subplot(233)
Conf_Inter=nanstd(squeeze(Mean_Ripples.Wake.DZP([2 5 8],1,:)))/sqrt(size(squeeze(Mean_Ripples.Wake.DZP([2 5 8],1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(Mean_Ripples.Wake.DZP([2 5 8],1,:)));
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(Mean_Ripples.Wake.DZP([2 3 5 8 10 12],3,:)))/sqrt(size(squeeze(Mean_Ripples.Wake.DZP([2 3 5 8 10 12],3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(Mean_Ripples.Wake.DZP([2 3 5 8 10 12],3,:)));
shadedErrorBar([1:1001] , Mean_All_Sp , Conf_Inter,'-c',1); hold on;
makepretty; title('Wake'); xlim([450 550]); xlabel('time (a.u.)');
f=get(gca,'Children'); legend([f(5),f(1)],'Wake before DZP','Wake after DZP');


subplot(234)
Conf_Inter=nanstd(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,1,:)))/sqrt(size(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,1,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 5 8],1,:)))/sqrt(size(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 5 8],1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 5 8],1,:)));
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty; set(gca, 'YScale', 'log'); ylim([3e3 1.5e5])
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')

subplot(235)
Conf_Inter=nanstd(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,1,:)))/sqrt(size(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,1,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,3,:)))/sqrt(size(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Spectro{3}.*squeeze(H_VHigh_Sp.NREM.DZP(:,3,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-m',1); hold on;
makepretty; set(gca, 'YScale', 'log'); ylim([2e3 5e4])
xlabel('Frequency (Hz)'); 

subplot(236)
Conf_Inter=nanstd(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 5 8],1,:)))/sqrt(size(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 5 8],1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 5 8],1,:)));
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 3 5 8 10 12],3,:)))/sqrt(size(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 3 5 8 10 12],3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(RangeVHigh.*squeeze(H_VHigh_Sp.Wake.DZP([2 3 5 8 10 12],3,:)));
shadedErrorBar(RangeVHigh , Mean_All_Sp , Conf_Inter,'-c',1); hold on;
makepretty; set(gca, 'YScale', 'log'); ylim([4e3 1.5e5])
xlabel('Frequency (Hz)'); 



%% deltas
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB(delta_density.Wake.All*1e4,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('Deltas/s'); title('Wake'); ylim([0 2]); axis square

subplot(232)
MakeSpreadAndBoxPlot2_SB(delta_density.NREM.All*1e4 ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('NREM'); axis square; ylim([0 2]);

subplot(233)
MakeSpreadAndBoxPlot2_SB(delta_density.REM.All*1e4 ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('REM'); axis square; ylim([0 2]);

subplot(234)
MakeSpreadAndBoxPlot2_SB(delta_density.N1.All*1e4 ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('Deltas/s'); title('N1'); ylim([0 2]); axis square
f=get(gca,'Children'); legend([f(72),f(48),f(24)],'Saline','DZP','BUS');

subplot(235)
MakeSpreadAndBoxPlot2_SB(delta_density.N2.All*1e4 ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('N2'); ylim([0 2]); axis square

subplot(236)
MakeSpreadAndBoxPlot2_SB(delta_density.N3.All*1e4 ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('N3'); ylim([0 2]); axis square

a=suptitle('Deltas density'); a.FontSize=20;


figure
subplot(231)
MakeSpreadAndBoxPlot2_SB(mean_duration.Wake.All.all,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('time (s)'); title('Wake');  ylim([0.09 0.16]); axis square

subplot(232)
MakeSpreadAndBoxPlot2_SB(mean_duration.NREM.All.all ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('NREM'); axis square;  ylim([0.09 0.16]);

subplot(233)
MakeSpreadAndBoxPlot2_SB(mean_duration.REM.All.all ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('REM'); axis square;  ylim([0.09 0.16]);

subplot(234)
MakeSpreadAndBoxPlot2_SB(mean_duration.N1.All.all ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
ylabel('time (s)'); title('N1');  ylim([0.09 0.16]); axis square
f=get(gca,'Children'); legend([f(72),f(48),f(24)],'Saline','DZP','BUS');

subplot(235)
MakeSpreadAndBoxPlot2_SB(mean_duration.N2.All.all ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('N2');  ylim([0.09 0.16]); axis square

subplot(236)
MakeSpreadAndBoxPlot2_SB(mean_duration.N3.All.all ,Cols,X,Legends,'showpoints',1,'paired',0,'x_data',X);
title('N3'); ylim([0.09 0.16]); axis square

a=suptitle('Deltas mean duration'); a.FontSize=20;


%% Deltas mean waveform
% check basic stuff on Saline
figure
subplot(121)
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;

Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
xlabel('time (a.u.)'); ylabel('amplitude (a.u.)');
makepretty; title('Saline, evolution through session');
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'Pre','+1h','Post');

subplot(122)
Conf_Inter=nanstd(squeeze(mean_curve.N3.All.all.sup(:,1,:)))/sqrt(size(squeeze(mean_curve.N3.All.all.sup(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.N3.All.all.sup(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.N2.All.all.sup(:,2,:)))/sqrt(size(squeeze(mean_curve.N2.All.all.sup(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.N2.All.all.sup(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.N1.All.all.sup(:,3,:)))/sqrt(size(squeeze(mean_curve.N1.All.all.sup(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.N1.All.all.sup(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;

Conf_Inter=nanstd(squeeze(mean_curve.N3.All.all.deep(:,1,:)))/sqrt(size(squeeze(mean_curve.N3.All.all.deep(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.N3.All.all.deep(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.N2.All.all.deep(:,2,:)))/sqrt(size(squeeze(mean_curve.N2.All.all.deep(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.N2.All.all.deep(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.N1.All.all.deep(:,3,:)))/sqrt(size(squeeze(mean_curve.N1.All.all.deep(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.N1.All.all.deep(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-g',1); hold on;
xlabel('time (a.u.)'); makepretty; title('Saline, evolution through NREM substages');
f=get(gca,'Children'); legend([f(9),f(5),f(1)],'N3','N2','N1');

a=suptitle('Deltas mean waveform, basic features check'); a.FontSize=20;


% Compare drugs
figure
subplot(231)
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,4,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,4,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,4,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;

Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,4,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,4,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,4,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty; title('Pre');
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','DZP');

subplot(232)
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,5,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,5,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,5,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,5,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty; title('+1h');


subplot(233)
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,6,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,6,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,6,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,6,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty; title('Post');


subplot(234)
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,7,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,7,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,7,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;

Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,1,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,7,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,7,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,7,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty; 
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','BUS');

subplot(235)
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,8,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,8,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,8,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,2,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,8,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,8,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,8,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty;

subplot(236)
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.sup(:,9,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.sup(:,9,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.sup(:,9,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,3,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(mean_curve.Sleep.All.all.deep(:,9,:)))/sqrt(size(squeeze(mean_curve.Sleep.All.all.deep(:,9,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(mean_curve.Sleep.All.all.deep(:,9,:)));
shadedErrorBar([1:1251] , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
makepretty; 


%% Deeper analyses on mean spectrum
% H_Low
figure; thr=39; n=1;
for state = [1 3 4]
    for drug = 1:length(Drug_Group)
        subplot(3,3,drug+(n-1)*3)
        clear a; [a(:),~] = max(RangeLow(thr:end)'.*squeeze(H_Low_Sp.(States{state}).(Drug_Group{drug})(:,1,thr:end))');
        for sleep_part=1:3
            plot(RangeLow , RangeLow'.*squeeze(nanmean(H_Low_Sp.(States{state}).(Drug_Group{drug})(:,sleep_part,:)./a')))
            hold on
        end
        if state==1; vline(8.3,'--r'); elseif state==4;  vline(7.4,'--r'); end
        makepretty
        ylim([0 1.1]); xlim([0 15])
        if drug==1; ylabel(States{state}); end
        if and(drug==1,state==1); legend('Pre','+1h','Post'); end
        if state==4; xlabel('Frequency (Hz)'); end
        if state==1; title(Drug_Group{drug}); end
    end
    n=n+1;
end
a=suptitle('HPC Low spectrum, sleep'); a.FontSize=20;


% H_VHigh
figure; thr=5; n=1;
for state = [1 3 4]
    for drug = 1:length(Drug_Group)
        subplot(3,3,drug+(n-1)*3)
        clear a; [a(:),~] = max(RangeVHigh(thr:end)'.*squeeze(H_VHigh_Sp.(States{state}).(Drug_Group{drug})(:,1,thr:end))');
        for sleep_part=1:3
            plot(RangeVHigh , RangeVHigh'.*squeeze(nanmean(H_VHigh_Sp.(States{state}).(Drug_Group{drug})(:,sleep_part,:)./a')))
            hold on
        end
        if state==1; vline(8.3,'--r'); elseif state==4;  vline(7.4,'--r'); end
        makepretty
        ylim([0 1.3]); xlim([20 250])
        if drug==1; ylabel(States{state}); end
        if and(drug==1,state==1); legend('Pre','+1h','Post'); end
        if state==4; xlabel('Frequency (Hz)'); end
        if state==1; title(Drug_Group{drug}); end
    end
    n=n+1;
end
a=suptitle('HPC Very High spectrum, sleep'); a.FontSize=20;


% OB_Low
figure; thr=16; n=1;
for state = [1 3 4]
    for drug = 1:length(Drug_Group)
        subplot(3,3,drug+(n-1)*3)
        clear a; [a(:),~] = max(RangeLow(thr:end)'.*squeeze(OB_Low_Sp.(States{state}).(Drug_Group{drug})(:,1,thr:end))');
        for sleep_part=1:3
            plot(RangeLow , RangeLow'.*squeeze(nanmean(OB_Low_Sp.(States{state}).(Drug_Group{drug})(:,sleep_part,:)./a')))
            hold on
        end
        if or(state==3 , state==4); vline(3.357,'--r'); end
        makepretty
        ylim([0 1.65]); xlim([0 15]); 
        if drug==1; ylabel(States{state}); end
        if and(drug==1,state==1); legend('Pre','+1h','Post'); end
        if state==4; xlabel('Frequency (Hz)'); end
        if state==1; title(Drug_Group{drug}); end
    end
    n=n+1;
end
a=suptitle('OB Low spectrum, sleep'); a.FontSize=20;


% PFCx_Low
figure; thr=16; n=1;
for state = [1 3 4]
    for drug = 1:length(Drug_Group)
        subplot(3,3,drug+(n-1)*3)
        clear a; [a(:),~] = max(RangeLow(thr:end)'.*squeeze(PFCx_Low_Sp.(States{state}).(Drug_Group{drug})(:,1,thr:end))');
        for sleep_part=1:3
            plot(RangeLow , RangeLow'.*squeeze(nanmean(PFCx_Low_Sp.(States{state}).(Drug_Group{drug})(:,sleep_part,:)./a')))
            hold on
        end
        if state==1; vline(8.3,'--r'); elseif state==4;  vline(7.4,'--r'); end
        makepretty
        ylim([0 1.1]); xlim([0 15])
        if state==4; ylim([0 1.2]); end
        if drug==1; ylabel(States{state}); end
        if and(drug==1,state==1); legend('Pre','+1h','Post'); end
        if state==4; xlabel('Frequency (Hz)'); end
        if state==1; title(Drug_Group{drug}); end
    end
    n=n+1;
end
a=suptitle('PFCx Low spectrum, sleep'); a.FontSize=20;



