Channels{61}=[11,9,8,12,6,2,0,3];
Channels{51}=[15,2,30,21,20,26,24,28,23];
Channels{60}=[1,7,4,5,11,2,8,10];
a=0;
a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130422/BULB-Mouse-61-22042013';
mouse(a)=61;
a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse061/20130415/BULB-Mouse-61-15042013';
mouse(a)=61;
a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013';
mouse(a)=61;
a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013';
mouse(a)=51;
a=a+1; Dir.path{a}='/media/DataMOBs/ProjetLPS/Mouse051/20130221/BULB-Mouse-51-21022013';
mouse(a)=51;
%       a=a+1; Dir.path{a}='/media/DataMOBs/ProjetDPCPX/Mouse047/20121108/BULB-Mouse-47-08112012';
a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
mouse(a)=60;
%     a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130422/BULB-Mouse-60-22042013';
a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013';
mouse(a)=60;
a=a+1; Dir.path{a}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013';
mouse(a)=60;

for n=[5,6,7,4,8]
    cd(Dir.path{n});
    load('StateEpoch.mat')
    channels=Channels{mouse(n)};
    if n==4
        channles=channels(4:end);
    end
    for s=1:length(channels)
        try
        dirname=cd;
        dirname=strrep(dirname,'/','_');
        
        load(strcat('LFPData/LFP',num2str(channels(s)),'.mat'))
        display('calculating  spectrum...')
        
        params.trialave=0;
        params.err=[1 0.0500];
        params.pad=2;
        params.Fs=1250;
        params.fpass=[20 150];
        params.tapers=[3 5];
        movingwin=[0.1 0.005];
        
        
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
%         save(strcat('SpectrumHigh_',num2str(channels(s)),'.mat'),'-v7.3','Sp','t','f','params','movingwin');
        save(strcat('/media/USBDisk1/Data_Gamma_Spectrum/',dirname,'SpectrumHigh_',num2str(channels(s)),'.mat'),'-v7.3','Sp','t','f','params','movingwin');
        
        h=figure('color',[1 1 1])
        sptsd=tsd(t'*10000,Sp);
        hold on
        Epoch=SWSEpoch-GndNoiseEpoch-NoiseEpoch;
        plot(f,f.*(mean(Data(Restrict(sptsd,Epoch)))),'k','linewidth',2)
        Epoch=REMEpoch-GndNoiseEpoch-NoiseEpoch;
        plot(f,f.*(mean(Data(Restrict(sptsd,Epoch)))),'r','linewidth',2)
        Epoch=MovEpoch-GndNoiseEpoch-NoiseEpoch;
        plot(f,f.*(mean(Data(Restrict(sptsd,Epoch)))),'b','linewidth',2)
        legend('SWS','REM','Wake')
        title(strcat('Channel_',num2str(channels(s)),'-local averaged'))
        
        saveas(h,strcat('/media/USBDisk1/Data_Gamma_Spectrum/',dirname,'Channel-',num2str(channels(s)),'-local averaged.png'))
        saveas(h,strcat('/media/USBDisk1/Data_Gamma_Spectrum/',dirname,'Channel-',num2str(channels(s)),'-local averaged.fig'))
        
%         saveas(h,strcat('/media/DataMOBs/NotSavedElsewhere/',dirname,'Channel-',num2str(channels(s)),'-local averaged.png'))
%         saveas(h,strcat('/media/DataMOBs/NotSavedElsewhere/',dirname,'Channel-',num2str(channels(s)),'-local averaged.fig'))
        %% calculate period by period
        Epoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
        St=[];
        clear Freq
        for i=1:length(Start(Epoch))
            try
                Epoch1=subset(Epoch,i);
                [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
                try
                    Freq;
                catch
                    Freq=f;
                end
                Stsd=tsd(f,S);
                S2=Restrict(Stsd,ts(Freq(1:10:end)));
                St=[St;Data(S2)'];
            end
        end
        
        
        g=figure('color',[1 1 1]), plot(Freq(1:10:end),smooth(Freq(1:10:end).*(nanmean(St)),10),'k','linewidth',2)
        
        Epoch=REMEpoch-NoiseEpoch-GndNoiseEpoch;
        St=[];
        clear Freq
        for i=1:length(Start(Epoch))
            try
                Epoch1=subset(Epoch,i);
                [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
                try
                    Freq;
                catch
                    Freq=f;
                end
                Stsd=tsd(f,S);
                S2=Restrict(Stsd,ts(Freq(1:10:end)));
                St=[St;Data(S2)'];
            end
        end
        
        hold on
       plot(Freq(1:10:end),smooth(Freq(1:10:end).*(nanmean(St)),10),'r','linewidth',2)
        
        Epoch=MovEpoch-NoiseEpoch-GndNoiseEpoch;
        St=[];
        clear Freq
        for i=1:length(Start(Epoch))
            try
                Epoch1=subset(Epoch,i);
                [S,f]=mtspectrumc(Data(Restrict(LFP,Epoch1)),params);
                try
                    Freq;
                catch
                    Freq=f;
                end
                Stsd=tsd(f,S);
                S2=Restrict(Stsd,ts(Freq(1:10:end)));
                St=[St;Data(S2)'];
            end
        end
        hold on
        plot(Freq(1:10:end),Freq(1:10:end).*(nanmean(St)),'b','linewidth',2)
        legend('SWS','REM','Wake')
        title(strcat('Channel_',num2str(channels(s)),'_period averaged'))
        
        saveas(g,strcat('/media/USBDisk1/Data_Gamma_Spectrum/',dirname,'Channel_',num2str(channels(s)),'_period averaged.png'))
        saveas(g,strcat('/media/USBDisk1/Data_Gamma_Spectrum/',dirname,'Channel_',num2str(channels(s)),'_period averaged.fig'))
%                 saveas(g,strcat('/media/DataMOBs/NotSavedElsewhere/',dirname,'Channel_',num2str(channels(s)),'_period averaged.png'))
%         saveas(g,strcat('/media/DataMOBs/NotSavedElsewhere/',dirname,'Channel_',num2str(channels(s)),'_period averaged.fig'))

        
        %%
        FiltGam1=FilterLFP(LFP,[30 49]);
        FiltGam2=FilterLFP(LFP,[50 70]);
        
        DataGam1=Data(FiltGam1)-mean(Data(FiltGam1));
        td=Range(FiltGam1,'s');
        eegdplus1=[0 DataGam1'];
        eegdplus0=[DataGam1' 0];
        zeroCross1=find(eegdplus0<0 & eegdplus1>0);
        zeroCross2=find(eegdplus0>0 & eegdplus1<0);
        zeroCrossIdx = [zeroCross1 zeroCross2];
        zeroCrossIdx = sort(zeroCrossIdx);
        zeroCrossGam1=td(zeroCrossIdx);
        zeroCrossGam1=ts(zeroCrossGam1*1e4);
        DataGam1ts=tsd(Range(FiltGam1),DataGam1);
        
        % for z=1:length(zeroCrossGam1)-1
        %     try
        %     Dat=Data(Restrict(FiltGam1,intervalSet(zeroCrossGam1(z)*1e4,zeroCrossGam1(z+1)*1e4)));
        %     zeroCrossGam1info(z,1)=zeroCrossGam1(z)+(zeroCrossGam1(z+1)-zeroCrossGam1(z))/2;
        %     zeroCrossGam1info(z,2)=zeroCrossGam1(z+1)-zeroCrossGam1(z);
        %     zeroCrossGam1info(z,3)=max(abs(Dat));
        %     zeroCrossGam1info(z,4)=sum(abs(Dat));
        %     catch
        %             zeroCrossGam1info(z,1)=NaN;
        %     zeroCrossGam1info(z,2)=NaN;
        %     zeroCrossGam1info(z,3)=NaN;
        %     zeroCrossGam1info(z,4)=NaN;
        %
        %     end
        % end
        % Gam1Dur=tsd(zeroCrossGam1info(:,1),zeroCrossGam1info(:,2));
        % Gam1Max=tsd(zeroCrossGam1info(:,1),zeroCrossGam1info(:,3));
        % Gam1Int=tsd(zeroCrossGam1info(:,1),zeroCrossGam1info(:,4));
        
        DataGam2=Data(FiltGam2)-mean(Data(FiltGam2));
        eegdplus1=[0 DataGam2'];
        eegdplus0=[DataGam2' 0];
        zeroCross1=find(eegdplus0<0 & eegdplus1>0);
        zeroCross2=find(eegdplus0>0 & eegdplus1<0);
        zeroCrossIdx = [zeroCross1 zeroCross2];
        zeroCrossIdx = sort(zeroCrossIdx);
        zeroCrossGam2=td(zeroCrossIdx);
        zeroCrossGam2=ts(zeroCrossGam2*1e4);
        DataGam2ts=tsd(Range(FiltGam2),DataGam2);
        
        Epoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
        for i=1:length(Start(Epoch))
            Epoch1=subset(Epoch,i);
            SWSnum(i,1:2)=[length(Data(Restrict(zeroCrossGam1,Epoch1))),length(Data(Restrict(zeroCrossGam2,Epoch1)))];
            SWSnum(i,5)=(End(Epoch1)-Start(Epoch1))/1e4;
            SWSnum(i,3:4)=[mean(Data(Restrict(DataGam1ts,Epoch1)).^2),mean(Data(Restrict(DataGam2ts,Epoch1)).^2)];
        end
        
        Epoch=REMEpoch-NoiseEpoch-GndNoiseEpoch;
        for i=1:length(Start(Epoch))
            Epoch1=subset(Epoch,i);
            REMnum(i,1:2)=[length(Data(Restrict(zeroCrossGam1,Epoch1))),length(Data(Restrict(zeroCrossGam2,Epoch1)))];
            REMnum(i,5)=(End(Epoch1)-Start(Epoch1))/1e4;
            REMnum(i,3:4)=[mean(Data(Restrict(DataGam1ts,Epoch1)).^2),mean(Data(Restrict(DataGam2ts,Epoch1)).^2)];
        end
        
        Epoch=MovEpoch-NoiseEpoch-GndNoiseEpoch;
        for i=1:length(Start(Epoch))
            Epoch1=subset(Epoch,i);
            Wakenum(i,1:2)=[length(Data(Restrict(zeroCrossGam1,Epoch1))),length(Data(Restrict(zeroCrossGam2,Epoch1)))];
            Wakenum(i,5)=(End(Epoch1)-Start(Epoch1))/1e4;
            Wakenum(i,3:4)=[mean(Data(Restrict(DataGam1ts,Epoch1)).^2),mean(Data(Restrict(DataGam2ts,Epoch1)).^2)];
        end
        scrsz = get(0,'ScreenSize');
        
        w=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3) scrsz(4)/2]),Gf=gcf;
        subplot(1,4,1)
        line([1 1], [0 nanmean(SWSnum(:,1)./SWSnum(:,5))],'color','k','linewidth',25)
        line([2 2], [0 nanmean(REMnum(:,1)./REMnum(:,5))],'color','r','linewidth',25)
        line([3 3], [0 nanmean(Wakenum(:,1)./Wakenum(:,5))],'color','b','linewidth',25)
        xlim([0 4])
        title('Low Gamma duration')
        
        subplot(1,4,2)
        line([1 1], [0 nanmean(SWSnum(:,2)./SWSnum(:,5))],'color','k','linewidth',25)
        line([2 2], [0 nanmean(REMnum(:,2)./REMnum(:,5))],'color','r','linewidth',25)
        line([3 3], [0 nanmean(Wakenum(:,2)./Wakenum(:,5))],'color','b','linewidth',25)
        xlim([0 4])
        title('High Gamma duration')
        
        subplot(1,4,3)
        line([1 1], [0 nanmean(SWSnum(:,3))],'color','k','linewidth',25)
        line([2 2], [0 nanmean(REMnum(:,3))],'color','r','linewidth',25)
        line([3 3], [0 nanmean(Wakenum(:,3))],'color','b','linewidth',25)
        xlim([0 4])
        title('Low Gamma Amp')
        
        subplot(1,4,4)
        line([1 1], [0 nanmean(SWSnum(:,4))],'color','k','linewidth',25)
        line([2 2], [0 nanmean(REMnum(:,4))],'color','r','linewidth',25)
        line([3 3], [0 nanmean(Wakenum(:,4))],'color','b','linewidth',25)
        xlim([0 4])
        title('High Gamma Amp')
        saveas(w,strcat('/media/USBDisk1/Data_Gamma_Spectrum/',dirname,'Channel_',num2str(channels(s)),'_PAA.png'))
        saveas(w,strcat('/media/USBDisk1/Data_Gamma_Spectrum/',dirname,'Channel_',num2str(channels(s)),'_PAA.fig'))
%                 saveas(w,strcat('/media/DataMOBs/NotSavedElsewhere/',dirname,'Channel_',num2str(channels(s)),'_PAA.png'))
%         saveas(w,strcat('/media/DataMOBs/NotSavedElsewhere/',dirname,'Channel_',num2str(channels(s)),'_PAA.fig'))

        close all
        
        catch
           dirname=cd      
        end
    end
end