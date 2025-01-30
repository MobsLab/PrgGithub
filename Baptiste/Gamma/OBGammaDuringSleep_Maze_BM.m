

Mouse=[666,668,688,739,777,779,849,893];
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end


Session_type={'SleepPre','SleepPostPre','SleepPostPost'};
for mouse=1:length(Mouse)
    for sess=1:length(Session_type) % generate all data required for analyses
        try
            cd(UMazeSleepSess.(Mouse_names{mouse}){sess})
            load('B_Middle_Spectrum.mat')
            load('StateEpochSB.mat')
            load('SleepSubstages.mat')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            Sptsd_Wake.(Mouse_names{mouse}).(Session_type{sess})=nanmean(Data(Restrict(Sptsd,Wake)));
            Sptsd_NREM.(Mouse_names{mouse}).(Session_type{sess})=nanmean(Data(Restrict(Sptsd,SWSEpoch)));
            Sptsd_REM.(Mouse_names{mouse}).(Session_type{sess})=nanmean(Data(Restrict(Sptsd,REMEpoch)));
            Sptsd_N1.(Mouse_names{mouse}).(Session_type{sess})=nanmean(Data(Restrict(Sptsd,Epoch{1})));
            Sptsd_N2.(Mouse_names{mouse}).(Session_type{sess})=nanmean(Data(Restrict(Sptsd,Epoch{2})));
            Sptsd_N3.(Mouse_names{mouse}).(Session_type{sess})=nanmean(Data(Restrict(Sptsd,Epoch{3})));
        end
    end
end


figure
for mouse=1:length(Mouse)
    for sess=1:length(Session_type) % generate all data required for analyses
        try
            subplot(3,8,(sess-1)*8+mouse)
            plot(Spectro{3} , Sptsd_Wake.(Mouse_names{mouse}).(Session_type{sess}),'b')
            hold on
            plot(Spectro{3} , Sptsd_NREM.(Mouse_names{mouse}).(Session_type{sess}),'r')
            plot(Spectro{3} , Sptsd_REM.(Mouse_names{mouse}).(Session_type{sess}),'g')
            set(gca, 'YScale', 'log'); 
            if and(sess==1,mouse==1); legend('Wake','NREM','REM'); end
            if sess==1; title(Mouse_names{mouse}); end
            if sess==3; xlabel('Frequency (Hz)'); end
            if mouse==1; ylabel('Power (a.u.)'); end
            makepretty
        end
    end
end




