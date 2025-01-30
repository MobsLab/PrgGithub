clear all
AllSlScoringMice_SleepScoringArticle_SB
mousenum=1;
for f = 1:length(filename2)
    cd(filename2{f})
    if     exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        load('ChannelsToAnalyse/dHPC_rip.mat')
        FileUsed{mousenum} = filename2{f};
        
        load('StateEpochSB.mat','SWSEpoch','Wake','REMEpoch','NoiseEpoch','GndNoiseEpoch')
        load('H_High_Spectrum.mat')
        f1 = Spectro{3};
        Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
        clear Spectro
        GetSpectraH{1}(mousenum,:)=(nanmean(Data(Restrict(Sptsd,SWSEpoch-NoiseEpoch-GndNoiseEpoch))));
        GetSpectraH{2}(mousenum,:)= (nanmean(Data(Restrict(Sptsd,Wake-NoiseEpoch-GndNoiseEpoch))));
        GetSpectraH{3}(mousenum,:)=(nanmean(Data(Restrict(Sptsd,REMEpoch-NoiseEpoch-GndNoiseEpoch))));
        
        load('HPC_rip_Gamma_Power.mat');
        GetGammDistH{1}{mousenum} = ((Data(Restrict(smooth_ghi,SWSEpoch-NoiseEpoch-GndNoiseEpoch))));
        GetGammDistH{2}{mousenum} =  ((Data(Restrict(smooth_ghi,Wake-NoiseEpoch-GndNoiseEpoch))));
        GetGammDistH{3}{mousenum} = ((Data(Restrict(smooth_ghi,REMEpoch-NoiseEpoch-GndNoiseEpoch))));
        
        load(['LFPData/LFP',num2str(channel),'.mat'])
        load('RipplesSB.mat')
        [M,T] = PlotRipRaw(LFP,Rip(:,2),50,0,0);
        SaveRip(mousenum,:) = M(:,2);
        mousenum=mousenum+1;
    end
end

figure
for mouse = 1:mousenum-1
nhist({GetGammDistH{1}{mouse},GetGammDistH{2}{mouse},GetGammDistH{3}{mouse}},100)
disp(FileUsed{mouse})
pause
end

for mouse = 1:mousenum-1
GetSpectraH{1}(mouse,:) = runmean(GetSpectraH{1}(mouse,:),5);
GetSpectraH{2}(mouse,:) = runmean(GetSpectraH{2}(mouse,:),5);
GetSpectraH{3}(mouse,:) = runmean(GetSpectraH{3}(mouse,:),5);
    
end

% Plot spectra
figure
temp=log(GetSpectraH{1}./(mean(GetSpectraH{1}')'*ones(1,32)));
g=shadedErrorBar(f1,nanmean(temp),[stdError(temp);stdError(temp)],'b');
hold on
temp=log(GetSpectraH{2}./(mean(GetSpectraH{2}')'*ones(1,32)));
g=shadedErrorBar(f1,nanmean(temp),[stdError(temp);stdError(temp)],'k');
temp=log(GetSpectraH{3}./(mean(GetSpectraH{3}')'*ones(1,32)));
g=shadedErrorBar(f1,nanmean(temp),[stdError(temp);stdError(temp)],'r');
box off
set(gca,'XTick',[20:20:100],'YTick',[-8:1:5])

figure


%% Get Gamma distributions

clear all
AllSlScoringMice_SleepScoringArticle_SB
mousenum=1;
for f = 1:length(filename2)
    cd(filename2{f})
    if     exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        load('ChannelsToAnalyse/dHPC_rip.mat')
        disp('calculating')
        %% Initiation
        %         % load HPC LCP
        %         load(strcat('LFPData/LFP',num2str(channel),'.mat'));
        %         % params
        %         smootime=3;
        %
        %         % get instantaneous gamma power
        %         FilGamma=FilterLFP(LFP,[50 70],1024);
        %         HilGamma=hilbert(Data(FilGamma));
        %         H=abs(HilGamma);
        %         tot_ghi=tsd(Range(LFP),H);
        %
        %         % smooth gamma power
        %         smooth_ghi = tsd(Range(tot_ghi),runmean(Data(tot_ghi),ceil(smootime/median(diff(Range(tot_ghi,'s'))))));
        %
        %         %
        %
        %         save('HPC_rip_Gamma_Power.mat','smooth_ghi','channel','-v7.3');
        
        load('StateEpochSB.mat','SWSEpoch','Wake','REMEpoch','NoiseEpoch','GndNoiseEpoch')
        InputInfo.Epoch = SWSEpoch;
        
        load(['LFPData/LFP',num2str(channel),'.mat'])
        [Rip,InputInfo,meanVal,stdVal] = FindRipplesSB(LFP, InputInfo)
        
        save('RipplesSB.mat','Rip','InputInfo','meanVal','stdVal')
        
        clear LFP channel Rip InputInfo meanVal stdVal
    end
end



%% Bimodality measure
%% This code was used for Fig1 in draft for 11th april 2016
%% Evaluate bimodality of distribution

clear all
AllSlScoringMice_SleepScoringArticle_SB
mousenum = 1;
smrange = [0.1,0.5,1,2,3,4,5];

for f = 1:length(filename2)
    cd(filename2{f})
    load('StateEpochSB.mat','NoiseEpoch','GndNoiseEpoch','Epoch');
    
    if     exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        load('ChannelsToAnalyse/dHPC_rip.mat')
        disp('calculating')
        %% Initiation
        % load HPC LCP
        load(strcat('LFPData/LFP',num2str(channel),'.mat'));
        rg=Range(LFP);
        TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
        
        Filgamma=FilterLFP(LFP,[50 70],1024);
        Restrict(Filgamma,TotalEpoch);
        Hilgamma=hilbert(Data(Filgamma));
        Hilgamma=tsd(Range(Filgamma),abs(Hilgamma));
        smfact=floor(smrange/median(diff(Range(Hilgamma,'s'))));

        for i=1:length(smfact)
            i
            smooth_ghi_hil{i}=tsd(Range(Hilgamma),runmean(Data(Hilgamma),smfact(i)));
        end
        save('HPCGammaSmoothedDiffWindowSizes.mat','smooth_ghi_hil')
        for i=1:length(smfact)
            [Y,X]=hist(log(Data(smooth_ghi_hil{i})),700);
            st_ = [1.0e-2 X(find(Y==max(Y),1,'first')) 0.101 5e-3 X(find(Y==max(Y),1,'first'))+1 0.21];
            [cf2,goodness2]=createFit2gauss(X,Y/sum(Y),st_);
            [cf1,goodness1]=createFit1gauss(X,Y/sum(Y));
            
            % goodness of fits
            rms{1}(mousenum,i)=goodness1.sse;
            rms{2}(mousenum,i)=goodness2.sse;
            rms{3}(mousenum,i)=goodness1.rsquare;
            rms{4}(mousenum,i)=goodness2.rsquare;
            rms{5}(mousenum,i)=goodness1.adjrsquare;
            rms{6}(mousenum,i)=goodness2.adjrsquare;
            rms{7}(mousenum,i)=goodness1.rmse;
            rms{8}(mousenum,i)=goodness2.rmse;
            % distance between peaks
            a= coeffvalues(cf2);
            dist{1}(mousenum,i)=abs(a(2)-a(5));
            b=(a(3)-a(6))^2/(a(3)^2+a(6)^2);
            dist{2}(mousenum,i)=1-sqrt(2*a(3)*a(6)/(a(3)^2+a(6)^2))*exp(-0.25*b);
            % overlap
            d=([min(X):max(X)/1000:max(X)]);
            Y1=normpdf(d,a(2),max(a(3)/sqrt(2),mean(diff(d))));
            Y2=normpdf(d,a(5),max(a(6)/sqrt(2),mean(diff(d))));
            dist{3}(mousenum,i)=sum(min(Y1,Y2)*mean(diff(d)));
            dist{4}(mousenum,i)=sqrt(2)*abs(a(2)-a(5))/sqrt(a(3).^2+a(6).^2);
            coeff{mousenum}(i,1:6)=a;
            coeff{mousenum}(i,7:8)=intersect_gaussians(a(2), a(5), a(3), a(6));
            
        end
        
        mousenum = mousenum+1;
        clear smooth_ghi_hil
    end
    
end

