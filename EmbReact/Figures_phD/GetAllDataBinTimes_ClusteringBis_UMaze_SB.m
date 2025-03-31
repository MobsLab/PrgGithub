clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MouseToAvoid=[117,431,795]; % mice with noisy data to exclude

% Everything Together
SessionType{1} =  GetRightSessionsUMaze_SB('AllProtocol_PAG');
Name{1} = 'AllCondSessions';

WndwSz = 3*1e4;

for SOI = 1:length(SessionType)
    
    clear MouseByMouse MouseNum
    for ss=1:length(SessionType{SOI})
        Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
        Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
        disp(SessionType{SOI}{ss})
        for d=1:length(Dir.path)
            MouseByMouse.IsSession{Dir.ExpeInfo{d}{1}.nmouse} = nan(length(SessionType{SOI}{ss}),length(Dir.path{d}));
            % initialize all the variables we are going to use
            MouseByMouse.LinPos{Dir.ExpeInfo{d}{1}.nmouse} = [];
            MouseByMouse.OBFreq{Dir.ExpeInfo{d}{1}.nmouse} = [];
            MouseByMouse.HPCPower{Dir.ExpeInfo{d}{1}.nmouse} = [];
            MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse} = [];
            MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse} = [];
            MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse} = [];
            MouseByMouse.ShockDur{Dir.ExpeInfo{d}{1}.nmouse}  = [];
            MouseByMouse.SafeDur{Dir.ExpeInfo{d}{1}.nmouse}= [];
            MouseByMouse.Stim{Dir.ExpeInfo{d}{1}.nmouse}  = [];
            MouseByMouse.Blocked{Dir.ExpeInfo{d}{1}.nmouse}= [];
            MouseByMouse.WhichZone{Dir.ExpeInfo{d}{1}.nmouse}= [];
            MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse}= [];

        end
    end
    
    
    for ss=1:length(SessionType{SOI})
        Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
        Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
        disp(SessionType{SOI}{ss})
        for d=1:length(Dir.path)
            
            for dd=1:length(Dir.path{d})
                go=0;
                if isfield(Dir.ExpeInfo{d}{dd},'DrugInjected')
                    if strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'SAL')
                        go=1;
                    end
                else
                    go=1;
                end
                
                if go ==1
                    cd(Dir.path{d}{dd})
                    disp(Dir.path{d}{dd})
                    clear TTLInfo Behav SleepyEpoch TotalNoiseEpoch
                    load('ExpeInfo.mat')
                    MouseNum(ss,d,dd) = ExpeInfo.nmouse;
                    
                    % Get epochs
                    load('StateEpochSB.mat','TotalNoiseEpoch')
                    try
                    TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+2.5*1e4);
                    catch
                        TTLInfo.StimEpoch = intervalSet(0,0.1);
                    end
                    load('LFPData/InfoLFP.mat')

                    load(['LFPData/LFP',num2str(InfoLFP.channel(1)),'.mat'])

                    RemovEpoch=(or(TTLInfo.StimEpoch,TotalNoiseEpoch));
                    TotalEpoch = intervalSet(0,max(Range(LFP)));
                    CleanFreezeEpoch  = TotalEpoch-RemovEpoch;
                    
                    % Get all the data types
                    % OB frequency
                    clear LocalFreq
                    load('InstFreqAndPhase_B.mat','LocalFreq')
                    % smooth the estimates
                    WVBinsize = 7;
                    LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
                    LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
                    
                    % Ripple density
                    clear RipplesEpochR RipPower
                    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                        load('Ripples.mat')
                        load('H_VHigh_Spectrum.mat')
                        RipPower = nanmean(Spectro{1}(:,find(Spectro{3}>150,1,'first'):find(Spectro{3}>220,1,'first'))')./nanmean(Spectro{1}(:,find(Spectro{3}>0,1,'first'):find(Spectro{3}>150,1,'first'))');
                        RipPower=tsd(Spectro{2}*1e4,RipPower');
                        
                    else
                        RipplesEpochR = [];
                    end
                    
                    % Heart rate and heart rate variability in and out of freezing
                    clear EKG HRVar
                    if exist('HeartBeatInfo.mat')>0
                        load('HeartBeatInfo.mat')
                        HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                    end
                    
                    % HPC spec
                    clear Sp
                    if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
                        [Sp,t,f]=LoadSpectrumML('dHPC_deep');
                    elseif exist('ChannelsToAnalyse/dHPC_sup.mat')>0
                        [Sp,t,f]=LoadSpectrumML('dHPC_sup');
                    elseif  exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                        [Sp,t,f]=LoadSpectrumML('dHPC_rip');
                    end
                    Sptsd=tsd(t*1e4,Sp);
                    PowerThetaTemp = nanmean(Sp(:,find(f<5.5,1,'last'):find(f<7.5,1,'last'))')';
                    PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(LFP));
                    ThetaPowerSlow = PowerThetaTemp;
                    
                    PowerThetaTemp = nanmean(Sp(:,find(f<10,1,'last'):find(f<15,1,'last'))')';
                    PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(LFP));
                    ThetaPowerFast = PowerThetaTemp;
                    
                    PowerThetaSlow = tsd(Range(LFP),ThetaPowerSlow./ThetaPowerFast);

                    
                    
                    % Get periods one by one
                    if not(isempty(Start(CleanFreezeEpoch)))
                        if sum(Stop(CleanFreezeEpoch)-Start(CleanFreezeEpoch))>WndwSz
                            
                            for s=1:length(Start(CleanFreezeEpoch))
                                dur=(Stop(subset(CleanFreezeEpoch,s))-Start(subset(CleanFreezeEpoch,s)));
                                Str=Start(subset(CleanFreezeEpoch,s));
                                
                                if  dur<(WndwSz*2-0.5*1e4) & dur>(WndwSz-0.5*1e4)
                                    
                                    MouseByMouse.OBFreq{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.OBFreq{Dir.ExpeInfo{d}{1}.nmouse},(nanmedian(Data(Restrict(LocalFreq.WV,CleanFreezeEpoch)))+nanmedian(Data(Restrict(LocalFreq.PT,CleanFreezeEpoch))))/2];
                                    MouseByMouse.HPCPower{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HPCPower{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(PowerThetaSlow,CleanFreezeEpoch)))];
                                    if not(isempty(RipplesEpochR)),
                                        MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse},length(Start(and(RipplesEpochR,CleanFreezeEpoch)))./sum(Stop(CleanFreezeEpoch,'s')-Start(CleanFreezeEpoch,'s'))];
                                        MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(RipPower,CleanFreezeEpoch)))];
                                        
                                    else
                                        MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse},NaN];
                                        MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse},NaN];

                                    end
                                    
                                    if exist('HeartBeatInfo.mat')>0
                                        
                                        MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(EKG.HBRate,CleanFreezeEpoch)))];
                                        MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(HRVar,CleanFreezeEpoch)))];
                                    else
                                        MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse},NaN];
                                        MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse},NaN];
                                    end
                                    
                                    
                                    
                                else
                                    numbins=round(dur/WndwSz);
                                    epdur=dur/numbins;
                                    for nn=1:numbins
                                        LitEpoch = intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                                        
                                        MouseByMouse.OBFreq{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.OBFreq{Dir.ExpeInfo{d}{1}.nmouse},(nanmedian(Data(Restrict(LocalFreq.WV,LitEpoch)))+nanmedian(Data(Restrict(LocalFreq.PT,LitEpoch))))/2];
                                        MouseByMouse.HPCPower{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HPCPower{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(PowerThetaSlow,LitEpoch)))];
                                        if not(isempty(RipplesEpochR)),
                                            MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse},length(Start(and(RipplesEpochR,LitEpoch)))./sum(Stop(LitEpoch,'s')-Start(LitEpoch,'s'))];
                                            MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(RipPower,LitEpoch)))];

                                        else
                                            MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RippleDensity{Dir.ExpeInfo{d}{1}.nmouse},NaN];
                                            MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.RipplePower{Dir.ExpeInfo{d}{1}.nmouse},NaN];
                                                                                    
                                        end
                                        
                                        if exist('HeartBeatInfo.mat')>0
                                            
                                            MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(EKG.HBRate,LitEpoch)))];
                                            MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse},nanmean(Data(Restrict(HRVar,LitEpoch)))];
                                        else
                                            MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HR{Dir.ExpeInfo{d}{1}.nmouse},NaN];
                                            MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse} = [MouseByMouse.HRVar{Dir.ExpeInfo{d}{1}.nmouse},NaN];
                                            
                                        end
                                        
                                        
                                    end
                                    
                                end
                            end
                        end
                    end
                    
                end
            end
        end
    end
end


figure
clf
AllMice= unique(MouseNum);
AllMice(1)=[];
colormap(fliplr(redblue(100)')')
DataPCA = [];
LinPos = [];
EarlyLateSk = [];
EarlyLateSf = [];
ZoneFz = [];
IsBlocked = [];
StimType = [];
MouseID = [];
for m= 1:length(AllMice)
%     scatter(MouseByMouse.OBFreq{AllMice(m)},(MouseByMouse.HPCPower{AllMice(m)}),20,MouseByMouse.LinPos{AllMice(m)},'filled')
%     clim([0 1])
%     xlim([0 6])
%     AllMice(m)
%                                  sum(MouseByMouse.ShockDur{AllMice(m)})
%                                                                   sum(MouseByMouse.SafeDur{AllMice(m)})
%     ylim([-2 2])
%     colorbar
%     hold on
%         pause


DataPCA = [DataPCA;[MouseByMouse.OBFreq{AllMice(m)}',log(MouseByMouse.HPCPower{AllMice(m)})',MouseByMouse.HR{AllMice(m)}',...
    MouseByMouse.HRVar{AllMice(m)}',MouseByMouse.RipplePower{AllMice(m)}']];
MouseID = [MouseID,ones(1,length(MouseByMouse.OBFreq{AllMice(m)}))*AllMice(m)];
    
end

MouseID(DataPCA(:,1)>7) = [];
DataPCA(DataPCA(:,1)>7,:) = [];


figure
SelData = StimType==2;
%  SelData = StimType==1 & (MouseID<446|MouseID>486);

dat = nanzscore(DataPCA);
[coeff,score,latent] = pca(nanzscore(DataPCA(SelData,:)));
SelData = StimType==1 & (MouseID<446|MouseID>486);
clf

VarExp = (100*(latent)/sum(latent));

for c = 1:3
    subplot(3,3,1+(c-1)*3)
scatter(coeff(:,c)'*dat(SelData,:)',coeff(:,max([mod(c+1,4),1]))'*dat(SelData,:)',15,LinPos(SelData),'filled')
xlabel(['Comp' num2str(c)])
ylabel(['Comp' num2str(max([mod(c+1,4),1]))])
title(['VarExp: ' num2str(VarExp(c))])
clim([0 1])
xlim([-5 5])
ylim([-5 5])
zlim([-5 5])
    set(gca,'LineWidth',2,'FontSize',15), box off

subplot(3,3,2+(c-1)*3)
bar(coeff(:,c))
set(gca,'XTick',1:5,'XTickLabel',{'OBFreq','HPCThetPow','HR','HRVar','RipPow'})
xtickangle(45)
ylabel(['Coeff PCA' num2str(c)])
set(gca,'LineWidth',2,'FontSize',15), box off

subplot(3,3,3+(c-1)*3)
plot(LinPos(SelData),coeff(:,c)'*dat(SelData,:)','*')
a = LinPos(SelData);b = coeff(:,c)'*dat(SelData,:)';
nanind = find(isnan(a) | isnan(b));
a(nanind) = []; b(nanind) = []; 
[R,P] = corrcoef(a,b);
xlabel('Linear position')
ylabel(['Coeff PCA' num2str(c)])
title(['R=' num2str(R(1,2)) ' p=' num2str(P(1,2))])
set(gca,'LineWidth',2,'FontSize',15), box off
end
colormap(fliplr(redblue(100)')')


figure
subplot(131)
scatter(DataPCA(:,1),DataPCA(:,2),15,LinPos(:),'filled')
xlabel('OB Freq (Hz)')
ylabel('HPC Slow theta power')
title('All mice ')
set(gca,'LineWidth',2,'FontSize',15)
subplot(132)
SelData = StimType==2;
scatter(DataPCA(SelData,1),DataPCA(SelData,2),15,LinPos(SelData),'filled')
xlabel('OB Freq (Hz)')
ylabel('HPC Slow theta power')
title('Eyeshock only')
set(gca,'LineWidth',2,'FontSize',15)
subplot(133)
SelData = StimType==1 & (MouseID<446|MouseID>486);
scatter(DataPCA(SelData,1),DataPCA(SelData,2),15,LinPos(SelData),'filled')
colormap(fliplr(redblue(100)')')
xlabel('OB Freq (Hz)')
ylabel('HPC Slow theta power')
title('PAG only')
set(gca,'LineWidth',2,'FontSize',15)
