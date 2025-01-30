%% File and Data info

% Delta Power analysis
for mouse=3
    mouse
    if mouse==1
        channels{1,1}={'B','H','PF','Pi','Am','Pa'};
        channels{1,2}={11,2,8,12,14,4};
        clear files
        files{1}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
        files{2}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD2/LPSD2-Mouse-124-01042014/';
        files{3}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD3/LPSD3-Mouse-124-02042014/';
        files{4}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD4/LPSD4-Mouse-124-03042014/';
        files{5}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD5/LPSD5-Mouse-124-04042014/';
        ass=[1,2;1,3;1,4;1,5;1,6;2,3;2,4;2,5;2,6;3,4;3,5;3,6;4,5;4,6];
        
        
    elseif mouse==2
        
        channels{1,1}={'B','H','PF','Pi','Am','Pa'};
        channels{1,2}={15,6,4,0,3,9};
        clear files
        files{1}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
        files{2}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D2/LPSD2-Mouse-123-01042014/';
        files{3}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D3/LPSD3-Mouse-123-02042014/';
        ass=[1,2;1,3;1,4;1,5;1,6;2,3;2,4;2,5;2,6;3,4;3,5;3,6;4,5;4,6];
        
    elseif mouse==3
        clear files
        files{1}='/media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013/';
        files{2}='/media/DataMOBs/ProjetLPS/Mouse051/20130221/BULB-Mouse-51-21022013/';
        files{3}='/media/DataMOBs/ProjetLPS/Mouse051/20130222/BULB-Mouse-51-22022013/';
        files{4}='/media/DataMOBs/ProjetLPS/Mouse051/20130223/BULB-Mouse-51-23022013/';

        channels{1,1}={'B','H','PF','Pa'};
        channels{1,2}={0,17,20,23};
        ass=[1,2;1,3;1,4;2,3;2,4;3,4];
        
        
    end
    
    %% Compute Cohero-grams
    
    % params.tapers=[3,5];
    params.fpass=[0 25];
    params.err=[2,0.05];
    params.pad=0;
    params.tapers=[3,5];
    movingwin=[3,0.5];
    
    for file=1:length(files)
        cd(files{file});
        load('LFPData/LFP0.mat');
        load('StateEpoch.mat')
        
        params.Fs=1/median(diff(Range(LFP,'s')));
        r=Range(LFP);
        TotalEpoch=intervalSet(0*1e4,r(end));
        TotalEpoch=intervalSet(0*1e4,r(end));
        Epoch=TotalEpoch-NoiseEpoch-GndNoiseEpoch;
        
        for z=1:length(ass)
            load(strcat('LFPData/LFP',num2str(channels{1,2}{ass(z,1)})));
            LFP1=LFP;
            load(strcat('LFPData/LFP',num2str(channels{1,2}{ass(z,2)})));
            LFP2=LFP;
            [Ctemp,phi,S12,S1temp,S2temp,t,f,confC,phitemp,Cerr]=cohgramc(Data(Restrict(LFP1,Epoch)),Data(Restrict(LFP2,Epoch)),movingwin,params);
            save(strcat('Coh_',num2str(channels{1,2}{ass(z,1)}),'_',num2str(channels{1,2}{ass(z,2)}),'.mat'),'Ctemp','phi','S12','S1temp','S2temp','t','f','confC','phitemp','Cerr')
        end
    end
    
    
    %% Look at small periods of time in relation to sleep stage throughout the day
    freqrg=[1.5 5];
    %
    Epdur=10*1e4; %10sec
    for file=1:length(files)
        file
        disp('calculating delta values by epoch')
        cd(files{file});
        load('StateEpochSB.mat')
        load('LFPData/LFP0.mat');
        r=Range(LFP);
        TotalEpoch=intervalSet(0*1e4,r(end));
        TotalEpoch=intervalSet(0*1e4,r(end));
        Epoch=TotalEpoch-NoiseEpoch-GndNoiseEpoch;
        Sl_W=[];
        Sl_R=[];
        
        %         Epoching
        stpSWS=Stop(SWSEpoch);
        stSWS=Start(SWSEpoch);
        SWSEpoch=And(SWSEpoch,Epoch);SWSEpoch=CleanUpEpoch(SWSEpoch);
        REMEpoch=And(REMEpoch,Epoch);REMEpoch=CleanUpEpoch(REMEpoch);
        Wake=And(Wake,Epoch);Wake=CleanUpEpoch(Wake);
        %         REM
        [aft_cell_R,bef_cell_R]=transEpoch(SWSEpoch,REMEpoch);
        SW_R=bef_cell_R{1,2}; %SWS after REM
        R_SW=aft_cell_R{2,1}; %REM before SWS
        RSt=Start(REMEpoch);
        RSt=[RSt,[1:length(RSt)]'];
        WSt=Start(Wake);
        WSt=[WSt,[1:length(WSt)]'];
        RStp=Stop(REMEpoch);
        RStp=[RStp,[1:length(RStp)]'];
        WStp=Stop(Wake);
        WStp=[WStp,[1:length(WStp)]'];
        SSt=Start(SW_R);
        SSt=[SSt,[1:length(SSt)]'];
        SStp=Stop(SW_R);
        SStp=[SStp,[1:length(SStp)]'];
        St=length(Start(SW_R));
        
        
        
        for w=1:size(freqrg,1)
            Hilbertbands=figure;
            for t=1:length(channels{1,1})
                load(strcat('LFPData/LFP',num2str(channels{1,2}{t}),'.mat'))
                FilDel=FilterLFP(LFP,freqrg(w,:),1024);
                HilDel=hilbert(Data(FilDel));
                HilDel=abs(HilDel);
                Del{t,w}=Restrict(tsd(Range(LFP),runmean(HilDel,2000)),Epoch);
            end
        end
        
        num=1;
        for g=1:St
            litEp=subset(SW_R,g);
            litREP=subset(R_SW,g);
            litST=Start(litEp);
            litSTP=Stop(litEp);
            subST=litST;
            subSTP=Epdur+litST;
            for w=1:size(freqrg,1)
                for t=1:length(channels{1,1})
                    localDel(t,w)=mean(Data(Restrict(Del{t},litEp)));
                end
            end
            
            while subSTP<litSTP
                subEp=intervalSet(subST,subSTP);
                for w=1:size(freqrg,1)
                    for t=1:length(channels{1,1})
                        Sl_R(num,t+(w-1)*length(channels{1,1}))=mean(Data(Restrict(Del{t,w},subEp)));
                    end
                end
                gotto=length(channels{1,1})*size(freqrg,1);
                
                RStin=RSt(RSt(:,1)>=subST,:);
                RStpin=RStp(RStp(:,1)<=subST,:);
                WStin=WSt(WSt(:,1)>=subST,:);
                WStpin=WStp(WStp(:,1)<=subST,:);
                % last Wake end and duration
                [C,I]=min(subST-WStpin(:,1));
                if size(C,1)==0
                    Sl_R(num,gotto+1)=NaN;
                    Sl_R(num,gotto+2)=NaN;
                else
                    Sl_R(num,gotto+1)=C;
                    [Sl_R(num,gotto+2),~,~]=EpochInfo(subset(Wake,WStpin(I,2)));
                end
                % next Wake beginning and duraton
                [C,I]=min(WStin(:,1)-subST);
                if size(C,1)==0
                    Sl_R(num,gotto+3)=NaN;
                    Sl_R(num,gotto+4)=NaN;
                else
                    Sl_R(num,gotto+3)=C;
                    [Sl_R(num,gotto+4),~,~]=EpochInfo(subset(Wake,WStin(I,2)));
                end
                % last REM end and duration
                [C,I]=min(subST-RStpin(:,1));
                if size(C,1)==0
                    Sl_R(num,gotto+5)=NaN;
                    Sl_R(num,gotto+6)=NaN;
                else
                    Sl_R(num,gotto+5)=C;
                    [Sl_R(num,gotto+6),~,~]=EpochInfo(subset(REMEpoch,RStpin(I,2)));
                end
                % next REM beginning and duraton
                [C,I]=min(RStin(:,1)-subST);
                if size(C,1)==0
                    Sl_R(num,gotto+7)=NaN;
                    Sl_R(num,gotto+8)=NaN;
                else  Sl_R(num,gotto+7)=C;
                    [Sl_R(num,gotto+8),~,~]=EpochInfo(subset(REMEpoch,RStin(I,2)));
                end
                % duration of current SWSEpoch
                [Sl_R(num,gotto+9),~,~]=EpochInfo(subset(SW_R,g));
                % time since beginning of day
                Sl_R(num,gotto+10)=subST;
                for w=1:size(freqrg,1)
                    for t=1:length(channels{1,1})
                        Sl_R(num,gotto+10+t+(w-1)*length(channels{1,1}))=localDel(t,w);
                    end
                end
                subSTP=subSTP+Epdur;
                subST=subST+Epdur;
                num=num+1;
            end
        end
        
        %Wake
        [aft_cell_W,bef_cell_W]=transEpoch(SWSEpoch,Wake);
        SW_W=bef_cell_W{1,2}; %SWS after wake
        W_SW=aft_cell_W{2,1}; %wake before SWS
        SSt=Start(SW_W);
        SSt=[SSt,[1:length(SSt)]'];
        SStp=Stop(SW_W);
        SStp=[SStp,[1:length(SStp)]'];
        St=length(Start(SW_W));
        
        num=1;
        for g=1:St
            litEp=subset(SW_W,g);
            litREP=subset(W_SW,g);
            litST=Start(litEp);
            litSTP=Stop(litEp);
            subST=litST;
            subSTP=Epdur+litST;
            for w=1:size(freqrg,1)
                for t=1:length(channels{1,1})
                    localDel(t,w)=mean(Data(Restrict(Del{t},litEp)));
                end
            end
            
            while subSTP<litSTP
                subEp=intervalSet(subST,subSTP);
                for w=1:size(freqrg,1)
                    for t=1:length(channels{1,1})
                        Sl_W(num,t+(w-1)*length(channels{1,1}))=mean(Data(Restrict(Del{t,w},subEp)));
                    end
                end
                gotto=length(channels{1,1})*size(freqrg,1);
                
                RStin=RSt(RSt(:,1)>=subST,:);
                RStpin=RStp(RStp(:,1)<=subST,:);
                WStin=WSt(WSt(:,1)>=subST,:);
                WStpin=WStp(WStp(:,1)<=subST,:);
                % last Wake end and duration
                [C,I]=min(subST-WStpin(:,1));
                if size(C,1)==0
                    Sl_W(num,gotto+1)=NaN;
                    Sl_W(num,gotto+2)=NaN;
                else
                    Sl_W(num,gotto+1)=C;
                    [Sl_W(num,gotto+2),~,~]=EpochInfo(subset(Wake,WStpin(I,2)));
                end
                % next Wake beginning and duraton
                [C,I]=min(WStin(:,1)-subST);
                if size(C,1)==0
                    Sl_W(num,gotto+3)=NaN;
                    Sl_W(num,gotto+4)=NaN;
                else
                    Sl_W(num,gotto+3)=C;
                    [Sl_W(num,gotto+4),~,~]=EpochInfo(subset(Wake,WStin(I,2)));
                end
                % last REM end and duration
                [C,I]=min(subST-RStpin(:,1));
                if size(C,1)==0
                    Sl_W(num,gotto+5)=NaN;
                    Sl_W(num,gotto+6)=NaN;
                else
                    Sl_W(num,gotto+5)=C;
                    [Sl_W(num,gotto+6),~,~]=EpochInfo(subset(REMEpoch,RStpin(I,2)));
                end
                % next REM beginning and duraton
                [C,I]=min(RStin(:,1)-subST);
                if size(C,1)==0
                    Sl_W(num,gotto+7)=NaN;
                    Sl_W(num,gotto+8)=NaN;
                else  Sl_W(num,gotto+7)=C;
                    [Sl_W(num,gotto+8),~,~]=EpochInfo(subset(REMEpoch,RStin(I,2)));
                end
                % duration of current SWSEpoch
                [Sl_W(num,gotto+9),~,~]=EpochInfo(subset(SW_W,g));
                % time since beginning of day
                Sl_W(num,gotto+10)=subST;
                
                for w=1:size(freqrg,1)
                    for t=1:length(channels{1,1})
                        Sl_W(num,gotto+10+t+(w-1)*length(channels{1,1}))=localDel(t,w);
                    end
                end
                subSTP=subSTP+Epdur;
                subST=subST+Epdur;
                num=num+1;
            end
        end
        
        
        save('DeltaInfo.mat','Sl_W','Sl_R')
        
    end
    
    
    
    
    %% Plot figures
    
    % Evolution of Spectrogram Power in different bands (10 subEp) (all strct)
    % Spectra superposed REM/SWS/Wake (all strct)
    % Spectra throughout day (all strct, sleep types separate)
    divday=4;
    cc= copper(3);
    cc2=summer((divday));
    for file=1:length(files)
        clear valS valW valR valSS valSR valSW
        cd(files{file});
        load('StateEpoch.mat')
        load('LFPData/LFP0.mat');
        
        params.Fs=1/median(diff(Range(LFP,'s')));
        r=Range(LFP);
        TotalEpoch=intervalSet(0*1e4,r(end));
        TotalEpoch=intervalSet(0*1e4,r(end));
        Epoch=TotalEpoch-NoiseEpoch-GndNoiseEpoch;
        %Epoching
        stpSWS=Stop(SWSEpoch);
        stSWS=Start(SWSEpoch);
        SWSEpoch=And(SWSEpoch,Epoch);SWSEpoch=CleanUpEpoch(SWSEpoch);
        REMEpoch=And(REMEpoch,Epoch);REMEpoch=CleanUpEpoch(REMEpoch);
        Wake=And(Wake,Epoch);Wake=CleanUpEpoch(Wake);
        a=(channels{1,2}(1));
        load(strcat(num2str(a{1}),'_Spectrum.mat'))
        f=Spectro{3};
        Sptsd=tsd(Spectro{2}*1e4,log(smooth2a(Spectro{1}',1,11))');dat=Data(Sptsd);
        DelPow=tsd(Range(Sptsd),mean(dat(:,find(f>1,1,'first'):find(f<4,1,'last'))')');
        threS1=mean(Data(Restrict(DelPow,SWSEpoch)))+std(Data(Restrict(DelPow,SWSEpoch)));
        threS2=mean(Data(Restrict(DelPow,SWSEpoch)))+2*std(Data(Restrict(DelPow,SWSEpoch)));
        threR1=mean(Data(Restrict(DelPow,REMEpoch)))+std(Data(Restrict(DelPow,REMEpoch)));
        threR2=mean(Data(Restrict(DelPow,REMEpoch)))+2*std(Data(Restrict(DelPow,REMEpoch)));
        threW1=mean(Data(Restrict(DelPow,Wake)))+std(Data(Restrict(DelPow,Wake)));
        threW2=mean(Data(Restrict(DelPow,Wake)))+2*std(Data(Restrict(DelPow,Wake)));
        EpS1=And(SWSEpoch,thresholdIntervals(DelPow,threS1));
        EpS2=And(SWSEpoch,thresholdIntervals(DelPow,threS2));
        EpR1=And(REMEpoch,thresholdIntervals(DelPow,threR1));
        EpR2=And(REMEpoch,thresholdIntervals(DelPow,threR2));
        EpW1=And(Wake,thresholdIntervals(DelPow,threW1));
        EpW2=And(Wake,thresholdIntervals(DelPow,threW2));
        
        
        a=(channels{1,2}(1));
        b=(channels{1,2}(3));
        
        load(strcat('Coh_',num2str(a{1}),'_',num2str(b{1}),'.mat'))
        Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
        dat=Data(Ctsd);
        DelPow=tsd(Range(Ctsd),mean(dat(:,find(f>1,1,'first'):find(f<4,1,'last'))')');
        threS1=mean(Data(Restrict(DelPow,SWSEpoch)))+std(Data(Restrict(DelPow,SWSEpoch)));
        threS2=mean(Data(Restrict(DelPow,SWSEpoch)))+2*std(Data(Restrict(DelPow,SWSEpoch)));
        threR1=mean(Data(Restrict(DelPow,REMEpoch)))+std(Data(Restrict(DelPow,REMEpoch)));
        threR2=mean(Data(Restrict(DelPow,REMEpoch)))+2*std(Data(Restrict(DelPow,REMEpoch)));
        threW1=mean(Data(Restrict(DelPow,Wake)))+std(Data(Restrict(DelPow,Wake)));
        threW2=mean(Data(Restrict(DelPow,Wake)))+2*std(Data(Restrict(DelPow,Wake)));
        EpCS1=And(SWSEpoch,thresholdIntervals(DelPow,threS1));
        EpCS2=And(SWSEpoch,thresholdIntervals(DelPow,threS2));
        EpCR1=And(REMEpoch,thresholdIntervals(DelPow,threR1));
        EpCR2=And(REMEpoch,thresholdIntervals(DelPow,threR2));
        EpCW1=And(Wake,thresholdIntervals(DelPow,threW1));
        EpCW2=And(Wake,thresholdIntervals(DelPow,threW2));
        
        lsS=(stpSWS(end)-stSWS(1))/divday;
        stpREM=Stop(REMEpoch);
        stREM=Start(REMEpoch);
        lsR=(stpREM(end)-stREM(1))/divday;
        stpW=Stop(Wake);
        stW=Start(Wake);
        lsW=(stpW(end)-stW(1))/divday;
        
        figchoS=figure;
        figchoR=figure;
        figchoW=figure;
        for w=1:size(freqrg,1)
            beg(w)=find(f>freqrg(w,1),1,'first');
            endin(w)=find(f<freqrg(w,2),1,'last');
            evolfig(w)=figure;
            
        end
        
        
        disp(' Spectra superposed REM/SWS/Wake (all strct)')
        % Spectra throughout day (all strct, sleep types separate)
        
        
        for t=1:length(channels{1,1})
            a=(channels{1,2}(t));
            load(strcat(num2str(a{1}),'_Spectrum.mat'))
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            [Sptsd,Th,Epoch]=CleanSpectro(Sptsd,Spectro{3},5);
            sptsd=Restrict(Sptsd,Epoch);
            f=Spectro{3};
            
            % Spectra depending on delta power +  Spectra superposed REM/SWS/Wake (strct by strct)
            h=figure;
            subplot(141)
            plot(f,smooth(mean(Data(Restrict(sptsd,Wake))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,EpW1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,EpW2))),3),'color',cc(3,:),'linewidth',2)
            ax(1)=gca;
            legend('Tot','High delta act','V High delta act')
            title('Wake')
            % ylim([0.35 0.8])
            subplot(142)
            plot(f,smooth(mean(Data(Restrict(sptsd,SWSEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,EpS1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,EpS2))),3),'color',cc(3,:),'linewidth',2)
            ax(2)=gca;
            title('SWS')
            % ylim([0.35 0.8])
            subplot(143)
            plot(f,smooth(mean(Data(Restrict(sptsd,REMEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,EpR1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,EpR2))),3),'color',cc(3,:),'linewidth',2)
            ax(3)=gca;
            title('REM')
            % ylim([0.35 0.8])
            subplot(144)
            plot(f,smooth(mean(Data(Restrict(sptsd,REMEpoch))),3),'color',[0.8 0.2 0.1],'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,SWSEpoch))),3),'color',[0 0.8 1],'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,Wake))),3),'color',[0.2 0.2 0.2],'linewidth',2)
            ax(4)=gca;
            legend('REM','SWS','Wake')
            % ylim([0.35 0.8])
            b=[get(ax(1),'Ylim');get(ax(2),'Ylim');get(ax(3),'Ylim');get(ax(4),'Ylim')];
            set(ax,'Ylim',[min(b(:,1)) max(b(:,2))])
            saveas(h,cell2mat(strcat('SpectraComparison_',channels{1,1}(t),'.png')))
            saveas(h,cell2mat(strcat('SpectraComparison_',channels{1,1}(t),'.fig')))
            delete(h)
            
            % Spectra depending on OB-PFC power +  Spectra superposed REM/SWS/Wake (strct by strct)
            h=figure;
            subplot(141)
            plot(f,smooth(mean(Data(Restrict(sptsd,Wake))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,EpCW1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,EpCW2))),3),'color',cc(3,:),'linewidth',2)
            ax(1)=gca;
            legend('Tot','High OB-PF coherence','V High OB-PF coherence')
            title('Wake')
            % ylim([0.35 0.8])
            subplot(142)
            plot(f,smooth(mean(Data(Restrict(sptsd,SWSEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,EpCS1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,EpCS2))),3),'color',cc(3,:),'linewidth',2)
            ax(2)=gca;
            title('SWS')
            % ylim([0.35 0.8])
            subplot(143)
            plot(f,smooth(mean(Data(Restrict(sptsd,REMEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,EpCR1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,EpCR2))),3),'color',cc(3,:),'linewidth',2)
            ax(3)=gca;
            title('REM')
            % ylim([0.35 0.8])
            subplot(144)
            plot(f,smooth(mean(Data(Restrict(sptsd,REMEpoch))),3),'color',[0.8 0.2 0.1],'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(sptsd,SWSEpoch))),3),'color',[0 0.8 1],'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(sptsd,Wake))),3),'color',[0.2 0.2 0.2],'linewidth',2)
            ax(4)=gca;
            legend('REM','SWS','Wake')
            % ylim([0.35 0.8])
            b=[get(ax(1),'Ylim');get(ax(2),'Ylim');get(ax(3),'Ylim');get(ax(4),'Ylim')];
            set(ax,'Ylim',[min(b(:,1)) max(b(:,2))])
            saveas(h,cell2mat(strcat('SpectraComparisonOnCoh_',channels{1,1}(t),'.png')))
            saveas(h,cell2mat(strcat('SpectraComparisonOnCoh_',channels{1,1}(t),'.fig')))
            delete(h)
            
            
            
            disp('% Spectra throughout day (all strct, sleep types separate)')
            % Evolution of coherence in different bands (10 subEp) (all strct)
            
            figure(figchoS)
            subplot(3,2,t)
            for g=1:divday
                subEp=And(intervalSet((g-1)*lsS,g*lsS),SWSEpoch);
                hold on
                plot(f,mean(Data(Restrict(sptsd,subEp))),'Color',cc2(g,:),'linewidth',2)
                int=mean(Data(Restrict(sptsd,subEp)));
                for w=1:size(freqrg,1)
                    valSS{w}(g,t)=sum(int(beg(w):endin(w)));
                end
            end
            title(channels{1,1}(t))
            
            figure(figchoW)
            subplot(3,2,t)
            for g=1:divday
                subEp=And(intervalSet((g-1)*lsW,g*lsW),Wake);
                hold on
                plot(f,mean(Data(Restrict(sptsd,subEp))),'Color',cc2(g,:),'linewidth',2)
                int=mean(Data(Restrict(sptsd,subEp)));
                for w=1:size(freqrg,1)
                    valSW{w}(g,t)=sum(int(beg(w):endin(w)));
                end
            end
            title(channels{1,1}(t))
            
            figure(figchoR)
            subplot(3,2,t)
            for g=1:divday
                subEp=And(intervalSet((g-1)*lsR,g*lsR),REMEpoch);
                hold on
                plot(f,mean(Data(Restrict(sptsd,subEp))),'Color',cc2(g,:),'linewidth',2)
                int=mean(Data(Restrict(sptsd,subEp)));
                for w=1:size(freqrg,1)
                    valSR{w}(g,t)=sum(int(beg(w):endin(w)));
                end
            end
            
            
            title(channels{1,1}(t))
            
            for w=1:size(freqrg,1)
                figure(evolfig(w))
                subplot(3,2,t)
                plot(valSR{w}(:,t),'color',[0.8 0.2 0.1])
                hold on
                plot(valSS{w}(:,t),'color',[0 0.8 1])
                plot(valSW{w}(:,t),'color',[0.2 0.2 0.2])
                title(channels{1,1}(t))
            end
            
        end
        
        
        saveas(figchoS,'SpectraDuringDayS.png')
        saveas(figchoS,'SpectraDuringDayS.fig')
        saveas(figchoR,'SpectraDuringDayR.png')
        saveas(figchoR,'SpectraDuringDayR.fig')
        saveas(figchoW,'SpectraDuringDayW.png')
        saveas(figchoW,'SpectraDuringDayW.fig')
        for w=1:size(freqrg,1)
            saveas(evolfig(w),cell2mat(strcat('SpectraEvolution',channels{1,1}(t),'Band',num2str(freqrg(w,1)),'_',num2str(freqrg(w,2)),'.fig')))
            saveas(evolfig(w),cell2mat(strcat('SpectraEvolution',channels{1,1}(t),'Band',num2str(freqrg(w,1)),'_',num2str(freqrg(w,2)),'.png')))
        end
        
        save ('Specvalues.mat','valSR','valSS','valSW');
        
        
        %% Coherence
        z=1;
        load(strcat('Coh_',num2str(channels{1,2}{ass(z,1)}),'_',num2str(channels{1,2}{ass(z,2)}),'.mat'));
        figchoS=figure;
        figchoR=figure;
        figchoW=figure;
        for w=1:size(freqrg,1)
            beg(w)=find(f>freqrg(w,1),1,'first');
            endin(w)=find(f<freqrg(w,2),1,'last');
            evolfig(w)=figure;
            
        end
        
        for z=1:length(ass)
            
            load(strcat('Coh_',num2str(channels{1,2}{ass(z,1)}),'_',num2str(channels{1,2}{ass(z,2)}),'.mat'))
            Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
            
            disp('Coherence depending on delta power + Coherence superposed REM/SWS/Wake strct by strct')
            h=figure;
            subplot(141)
            plot(f,smooth(mean(Data(Restrict(Ctsd,Wake))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpW1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpW2))),3),'color',cc(3,:),'linewidth',2)
            ax(1)=gca;
            legend('Tot','High delta act','V High delta act')
            title('Wake')
            % ylim([0.35 0.8])
            subplot(142)
            plot(f,smooth(mean(Data(Restrict(Ctsd,SWSEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpS1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpS2))),3),'color',cc(3,:),'linewidth',2)
            ax(2)=gca;
            title('SWS')
            % ylim([0.35 0.8])
            subplot(143)
            plot(f,smooth(mean(Data(Restrict(Ctsd,REMEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpR1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpR2))),3),'color',cc(3,:),'linewidth',2)
            ax(3)=gca;
            title('REM')
            % ylim([0.35 0.8])
            subplot(144)
            plot(f,smooth(mean(Data(Restrict(Ctsd,REMEpoch))),3),'color',[0.8 0.2 0.1],'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,SWSEpoch))),3),'color',[0 0.8 1],'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,Wake))),3),'color',[0.2 0.2 0.2],'linewidth',2)
            ax(4)=gca;
            legend('REM','SWS','Wake')
            % ylim([0.35 0.8])
            b=[get(ax(1),'Ylim');get(ax(2),'Ylim');get(ax(3),'Ylim');get(ax(4),'Ylim')];
            set(ax,'Ylim',[min(b(:,1)) max(b(:,2))])
            saveas(h,strcat('Cohercomparison_',num2str(channels{1,1}{ass(z,1)}),'_',num2str(channels{1,1}{ass(z,2)}),'.png'))
            saveas(h,strcat('Cohercomparison_',num2str(channels{1,1}{ass(z,1)}),'_',num2str(channels{1,1}{ass(z,2)}),'.fig'))
            delete(h)
            
            disp('Coherence depending on obpfc coherence + Coherence superposed REM/SWS/Wake strct by strct')
            h=figure;
            subplot(141)
            plot(f,smooth(mean(Data(Restrict(Ctsd,Wake))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpCW1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpCW2))),3),'color',cc(3,:),'linewidth',2)
            ax(1)=gca;
            legend('Tot','High delta act','V High delta act')
            title('Wake')
            % ylim([0.35 0.8])
            subplot(142)
            plot(f,smooth(mean(Data(Restrict(Ctsd,SWSEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpCS1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpCS2))),3),'color',cc(3,:),'linewidth',2)
            ax(2)=gca;
            title('SWS')
            % ylim([0.35 0.8])
            subplot(143)
            plot(f,smooth(mean(Data(Restrict(Ctsd,REMEpoch))),3),'color',cc(1,:),'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpCR1))),3),'color',cc(2,:),'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,EpCR2))),3),'color',cc(3,:),'linewidth',2)
            ax(3)=gca;
            title('REM')
            % ylim([0.35 0.8])
            subplot(144)
            plot(f,smooth(mean(Data(Restrict(Ctsd,REMEpoch))),3),'color',[0.8 0.2 0.1],'linewidth',2)
            hold on
            plot(f,smooth(mean(Data(Restrict(Ctsd,SWSEpoch))),3),'color',[0 0.8 1],'linewidth',2)
            plot(f,smooth(mean(Data(Restrict(Ctsd,Wake))),3),'color',[0.2 0.2 0.2],'linewidth',2)
            ax(4)=gca;
            legend('REM','SWS','Wake')
            % ylim([0.35 0.8])
            b=[get(ax(1),'Ylim');get(ax(2),'Ylim');get(ax(3),'Ylim');get(ax(4),'Ylim')];
            set(ax,'Ylim',[min(b(:,1)) max(b(:,2))])
            saveas(h,strcat('CohercomparisonOnCoh_',num2str(channels{1,1}{ass(z,1)}),'_',num2str(channels{1,1}{ass(z,2)}),'.png'))
            saveas(h,strcat('CohercomparisonOnCoh_',num2str(channels{1,1}{ass(z,1)}),'_',num2str(channels{1,1}{ass(z,2)}),'.fig'))
            delete(h)
            
            disp(' Coherence throughout day (all strct, sleep types separate)')
            % Evolution of coherence in different bands (10 subEp) (all strct)
            
            figure(figchoS)
            subplot(3,5,z)
            for g=1:divday
                subEp=And(intervalSet((g-1)*lsS,g*lsS),SWSEpoch);
                hold on
                plot(f,mean(Data(Restrict(Ctsd,subEp))),'Color',cc2(g,:),'linewidth',2)
                int=mean(Data(Restrict(Ctsd,subEp)));
                for w=1:size(freqrg,1)
                    valS{w}(g,z)=sum(int(beg(w):endin(w)));
                end
            end
            title(strcat(num2str(channels{1,1}{ass(z,1)}),'.',num2str(channels{1,1}{ass(z,2)})))
            
            figure(figchoW)
            subplot(3,5,z)
            for g=1:divday
                subEp=And(intervalSet((g-1)*lsW,g*lsW),Wake);
                hold on
                plot(f,mean(Data(Restrict(Ctsd,subEp))),'Color',cc2(g,:),'linewidth',2)
                int=mean(Data(Restrict(Ctsd,subEp)));
                for w=1:size(freqrg,1)
                    valW{w}(g,z)=sum(int(beg(w):endin(w)));
                end
            end
            title(strcat(num2str(channels{1,1}{ass(z,1)}),'.',num2str(channels{1,1}{ass(z,2)})))
            
            figure(figchoR)
            subplot(3,5,z)
            for g=1:divday
                subEp=And(intervalSet((g-1)*lsR,g*lsR),REMEpoch);
                hold on
                plot(f,mean(Data(Restrict(Ctsd,subEp))),'Color',cc2(g,:),'linewidth',2)
                int=mean(Data(Restrict(Ctsd,subEp)));
                for w=1:size(freqrg,1)
                    valR{w}(g,z)=sum(int(beg(w):endin(w)));
                end
            end
            
            title(strcat(num2str(channels{1,1}{ass(z,1)}),'.',num2str(channels{1,1}{ass(z,2)})))
            
            for w=1:size(freqrg,1)
                figure(evolfig(w))
                subplot(3,5,z)
                plot(valR{w}(:,z),'color',[0.8 0.2 0.1])
                hold on
                plot(valS{w}(:,z),'color',[0 0.8 1])
                plot(valW{w}(:,z),'color',[0.2 0.2 0.2])
                title(strcat(num2str(channels{1,1}{ass(z,1)}),'.',num2str(channels{1,1}{ass(z,2)})))
            end
            
        end
        
        
        save ('Cohvalues.mat','valR','valS','valW');
        saveas(figchoS,'CoherenceDuringDayS.png')
        saveas(figchoS,'CoherenceDuringDayS.fig')
        saveas(figchoR,'CoherenceDuringDayR.png')
        saveas(figchoR,'CoherenceDuringDayR.fig')
        saveas(figchoW,'CoherenceDuringDayW.png')
        saveas(figchoW,'CoherenceDuringDayW.fig')
        for w=1:size(freqrg,1)
            saveas(evolfig(w),strcat('CoherenceEvolution',num2str(channels{1,1}{ass(z,1)}),'_',num2str(channels{1,1}{ass(z,2)}),'Band',num2str(freqrg(w,1)),'_',num2str(freqrg(w,2)),'.fig'))
            saveas(evolfig(w),strcat('CoherenceEvolution',num2str(channels{1,1}{ass(z,1)}),'_',num2str(channels{1,1}{ass(z,2)}),'Band',num2str(freqrg(w,1)),'_',num2str(freqrg(w,2)),'.png'))
        end
        
        
        
    end
    
    
    
end