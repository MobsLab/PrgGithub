clear all
LocalOb = 1;

SessNames={'SleepPreUMaze','SleepPostUMaze','SleepPreSound','SleepPostSound'};

MiceNumber=[490,507,508,509,510,512,514];
MiceNumber = 508;
for ss=1:length(SessNames)ed
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            
            for ddd=1:length(Dir.path{dd})
                
                cd(Dir.path{dd}{ddd})
                disp(Dir.path{dd}{ddd})
                if LocalOb
                    try
                        Mod.N1{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N1_LocalBulb_left_ActivitySpike.mat'],'ModInfo');
                        Mod.N2{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N2_LocalBulb_left_ActivitySpike.mat'],'ModInfo');
                        Mod.N3{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N3_LocalBulb_left_ActivitySpike.mat'],'ModInfo');
                        Mod.REM{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_REM_LocalBulb_left_ActivitySpike.mat'],'ModInfo');
                    catch
                        try
                            Mod.N1{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N1_LocalBulb_right_ActivitySpike.mat'],'ModInfo');
                            Mod.N2{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N2_LocalBulb_right_ActivitySpike.mat'],'ModInfo');
                            Mod.N3{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N3_LocalBulb_right_ActivitySpike.mat'],'ModInfo');
                            Mod.REM{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_REM_LocalBulb_right_ActivitySpike.mat'],'ModInfo');
                        
                    catch
                        disp('nope')
                    end
                    end
                    
                else
                    load('ChannelsToAnalyse/Bulb_deep.mat')
                    try
                        Mod.N1{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N1_LFP',num2str(channel),'Spike.mat'],'ModInfo');
                        Mod.N2{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N2_LFP',num2str(channel),'Spike.mat'],'ModInfo');
                        Mod.N3{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_N3_LFP',num2str(channel),'Spike.mat'],'ModInfo');
                        Mod.REM{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_REM_LFP',num2str(channel),'Spike.mat'],'ModInfo');
                    catch
                        disp('nope')
                    end
                end
                
            end
        end
    end
end

SessNames={'UMazeCond'};

%MiceNumber=[490,507,508,509,510,512,514];

for ss=1:length(SessNames)
    Dir = PathForExperimentsEmbReact(SessNames{ss});
    
    for dd=1:length(Dir.path)
        if ismember(Dir.ExpeInfo{dd}{1}.nmouse,MiceNumber)
            
            ddd=1;
            
            cd(Dir.path{dd}{ddd})
            load('ChannelsToAnalyse/Bulb_deep.mat')
            
            cd ..
            if LocalOb
                try
                    Mod.Fz{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnlyLocalBulb_left_ActivitySpike.mat'],'ModInfo');
                catch
                    try
                    Mod.Fz{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnlyLocalBulb_right_ActivitySpike.mat'],'ModInfo');
                    end
                end
                
            else
                try
                    Mod.Fz{ss}(find(MiceNumber==Dir.ExpeInfo{dd}{1}.nmouse)) = load(['RayleighFreqAnalysis/Rayleigh_BandWidth_FreezingOnlyLFP',num2str(channel),'Spike.mat'],'ModInfo');
                end
            end
        end
    end
end


%%
EpochTypes = {'N3','N2','N1','REM','Fz'};
for ep = 1:length(EpochTypes)
    Allpval.(EpochTypes{ep}) = [];
    Allmu.(EpochTypes{ep}) = [];
    AllKappa.(EpochTypes{ep}) = [];
end

for mm = 1:length(MiceNumber)
    for ep = 1:length(EpochTypes)
        
        Allpval.(EpochTypes{ep}) = [Allpval.(EpochTypes{ep}),Mod.(EpochTypes{ep}){1}(mm).ModInfo.pval.Transf];
        Allmu.(EpochTypes{ep}) = [Allmu.(EpochTypes{ep}),Mod.(EpochTypes{ep}){1}(mm).ModInfo.mu.Transf];
        AllKappa.(EpochTypes{ep}) = [AllKappa.(EpochTypes{ep}),Mod.(EpochTypes{ep}){1}(mm).ModInfo.Kappa.Transf];
    end
end

col = lines(5);
figure
for ep = 1:length(EpochTypes)
plot(nanmean(FilterBands),nanmean(Allpval.(EpochTypes{ep})'<0.05),'color',col(ep,:),'linewidth',2)
hold on
end
legend(EpochTypes)
xlabel('Freq of filterng')
ylabel('Sig mod neurons')

figure
for filt = 1:6
subplot(6,1,filt)
    for ep = 1:length(EpochTypes)
        dat_temp = Allmu.(EpochTypes{ep})(filt,:);
        dat_temp_p = Allpval.(EpochTypes{ep})(filt,:);
        dat_temp(dat_temp_p>0.05) = [];
        [Y,X] = hist(dat_temp,20);
        stairs([X,X+2*pi],[Y,Y],'color',col(ep,:),'linewidth',2)
        hold on
    end
end


figure
for filt = 1:6
    subplot(3,2,filt)
    for ep = 1:length(EpochTypes)
        dat_temp = Allmu.(EpochTypes{1})(filt,:);
        dat_temp_p = Allpval.(EpochTypes{1})(filt,:)<0.05;
        
        dat_temp2 = Allmu.(EpochTypes{5})(filt,:);
        dat_temp2_p = Allpval.(EpochTypes{5})(filt,:)<0.05;
        
        plot(dat_temp(dat_temp_p),dat_temp2(dat_temp_p),'b*')
        hold on
        plot(dat_temp(dat_temp2_p),dat_temp2(dat_temp2_p),'k*')
        plot(dat_temp(dat_temp_p&dat_temp2_p),dat_temp2(dat_temp_p&dat_temp2_p),'r*')
        xlabel('phase in N3')
        ylabel('phase in Fz')
        
        title(['Freq ', num2str(FilterBands(1,filt)),'Hz'])
    end
end

figure
for filt = 1:6
    subplot(3,2,filt)
    for ep = 1:length(EpochTypes)
        dat_temp = Allmu.(EpochTypes{1})(filt,:);
        dat_temp_p = Allpval.(EpochTypes{1})(filt,:)<0.05;
        
        dat_temp2 = Allmu.(EpochTypes{2})(filt,:);
        dat_temp2_p = Allpval.(EpochTypes{2})(filt,:)<0.05;
        
        plot(dat_temp(dat_temp_p),dat_temp2(dat_temp_p),'b*')
        hold on
        plot(dat_temp(dat_temp2_p),dat_temp2(dat_temp2_p),'k*')
        plot(dat_temp(dat_temp_p&dat_temp2_p),dat_temp2(dat_temp_p&dat_temp2_p),'r*')
        xlabel('phase in N3')
        ylabel('phase in N2')
        
        title(['Freq ', num2str(FilterBands(1,filt)),'Hz'])
    end
end

figure
for filt = 1:6
    subplot(3,2,filt)
    for ep = 1:length(EpochTypes)
        dat_temp = Allmu.(EpochTypes{3})(filt,:);
        dat_temp_p = Allpval.(EpochTypes{3})(filt,:)<0.05;
        
        dat_temp2 = Allmu.(EpochTypes{5})(filt,:);
        dat_temp2_p = Allpval.(EpochTypes{5})(filt,:)<0.05;
        
        plot(dat_temp(dat_temp_p),dat_temp2(dat_temp_p),'b*')
        hold on
        plot(dat_temp(dat_temp2_p),dat_temp2(dat_temp2_p),'k*')
        plot(dat_temp(dat_temp_p&dat_temp2_p),dat_temp2(dat_temp_p&dat_temp2_p),'r*')
        xlabel('phase in N1')
        ylabel('phase in Fz')
        
        title(['Freq ', num2str(FilterBands(1,filt)),'Hz'])
    end
end


figure
for filt = 1:6
subplot(6,1,filt)
    for ep = [1,5]
        dat_temp = Allmu.(EpochTypes{ep})(filt,:);
        dat_temp_p = Allpval.(EpochTypes{ep})(filt,:);
        dat_temp(dat_temp_p>0.05) = [];
        [Y,X] = hist(dat_temp,15);
        stairs([X,X+2*pi],[Y,Y],'color',col(ep,:),'linewidth',2)
        hold on
    end
end
