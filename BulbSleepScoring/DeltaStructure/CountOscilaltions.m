clear all
close all

%% Cacluate desired Spectra
struc={'B','H','Pi','PF','Pa','PFSup','PaSup','Amyg'};
clear todo chan dataexis
m=1;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[1,8,NaN,4,13,6,2,NaN];

m=2;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse082/20130730/BULB-Mouse-82-30072013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[2,9,NaN,10,7,8,3,NaN];

m=3;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[6,10,NaN,5,13,1,7,NaN];

m=4;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[3,17,NaN,20,23,21,28,NaN];

m=5;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013/';
todo(m,:)=[1,1,1,1,0,1,1,1];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[7,10,NaN,1,2,0,6,NaN];
scrsz = get(0,'ScreenSize');


for file=1:5
    
    try
        file
        cd(filename2{file})
        res=filename2{file};
        load('StateEpoch.mat')
        filetosave=['/home/mobs/Documents/BulbOscillationEffect/','M',num2str(file),'/'];
        try 
            load('behavResources','PreEpoch')
            SWSEpoch=And(SWSEpoch,PreEpoch);
        end
        
        %%%%
        %% Get OB Epochs
        %%%%
        
        disp('getting Epochs')
        load(['SpectrumDataL/Spectrum',num2str(chan(file,1)),'.mat']);
        rg=t(end)*1e4;
        TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
        
        Spectsd=tsd(t*1e4,Sp);
        Spectsd=Restrict(Spectsd,SWSEpoch);
        
        % First Way : divide into four parts
        sptsd=tsd(t*1e4,mean(Sp(:,find(f>1.5,1,'first'):find(f<5,1,'last'))')');
        sptsd=Restrict(sptsd,SWSEpoch);
        [Sc,Th,CleanEp]=CleanSpectro(Spectsd,f,4);
        size(Range(Restrict(sptsd,CleanEp)))./size(Range(Restrict(sptsd,SWSEpoch)))
        sptsd=Restrict(sptsd,CleanEp);
        
        dat=Data(sptsd);
        lim(1)=percentile(dat,0.75);
        lim(2)=percentile(dat,0.90);
        lim(3)=percentile(dat,0.25);
        lim(4)=percentile(dat,0.10);
        
        tempEp=thresholdIntervals(sptsd,lim(1),'Direction','Above');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{1}=tempEp;
        name{1}=['Top 25% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{1})))/size(Data(sptsd))*100)),'%'];
        
        tempEp=thresholdIntervals(sptsd,lim(3),'Direction','Below');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{2}=tempEp;
        name{2}=['Bottom 25% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{2})))/size(Data(sptsd))*100)),'%'];
        
        tempEp=thresholdIntervals(sptsd,lim(2),'Direction','Above');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{3}=tempEp;
        name{3}=['Top 10% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{3})))/size(Data(sptsd))*100)),'%'];
        
        tempEp=thresholdIntervals(sptsd,lim(4),'Direction','Below');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{4}=tempEp;
        name{4}=['Bottom 10% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{4})))/size(Data(sptsd))*100)),'%'];
        
        
        
        % Second Way : get bursts
        load(['LFPData/LFP',num2str(chan(file,1)),'.mat']);
        FilOB=FilterLFP(LFP,[1.5 5],1024);
        FilOB=Restrict(FilOB,SWSEpoch);
        mnOB=nanmean(Data(FilOB));
        stdOB=nanstd(Data(FilOB));
        
     
        pks=findpeaks(Data(FilOB),mnOB+2*stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),0.5);
        OBEp{5}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{5}=['2stddev burst 0.5s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{5})))/size(Data(sptsd))*100)),'%'];
        
        pks=findpeaks(Data(FilOB),mnOB+2*stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),1);
        OBEp{6}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{6}=['2stddev burst 1s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{6})))/size(Data(sptsd))*100)),'%'];
        
        pks=findpeaks(Data(FilOB),mnOB+stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),0.5);
        OBEp{7}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{7}=['1stddev burst 0.5s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{7})))/size(Data(sptsd))*100)),'%'];
        OBEp{8}=SWSEpoch;
        
        % Random simulation of such low percentages
        durations=(Stop(OBEp{5})-Start(OBEp{5}));
        durationS=(Stop(SWSEpoch)-Start(SWSEpoch));
        sumdurS=cumsum(durationS);
        sumdurS=sumdurS/max(sumdurS);
        clear BootEp
        for rep=1:50
            BootEp{rep}=intervalSet(0,0);
            for k=1:length(durations)
                go=0;
                while go==0
                    pick=find(sumdurS>rand,1,'first');
                    if durationS(pick)>durations(k)
                        go=1;
                        window=[Start(subset(SWSEpoch,pick)),Stop(subset(SWSEpoch,pick))-durations(k)];
                        begin=window(1)+rand*(window(2)-window(1));
                        BootEp{rep}=Or(BootEp{rep},intervalSet(begin,begin+durations(k)));
                    else
                        go=0;
                    end
                end
            end
        end
        BootEp{51}=SWSEpoch;
        save([filetosave,'Boots/Epochsv5.mat'],'BootEp')
        
        CountSpindlesRipplesSB(res,[filetosave,'Boots/'],BootEp,0)
        
        %%%%
        %% Spectra
        %%%%
        clear SpecInfo
        disp('plotting spectra')
        spfig=figure('color',[1 1 1],'Position',[1 1 scrsz(3)/2 scrsz(4)]);
        
        subplot(2,4,1)
        col=copper(4);
        plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
        for k=1:4
            spec=mean(Data(Restrict(Spectsd,OBEp{k})'));
            SpecInfo{1}(k,1)=mean(spec(find(f>1.5,1,'first'):find(f<5,1,'last')));
            SpecInfo{1}(k,2)=mean(spec(find(f>5,1,'first'):find(f<10,1,'last')));
            SpecInfo{1}(k,3)=mean(Data(Restrict(sptsd,OBEp{k})));
            Spectra{1,k}=spec;
            plot(f,mean(Data(Restrict(Spectsd,OBEp{k})')),'color',col(k,:),'linewidth',2)
            hold on
        end
        legend({'Tot',name{1},name{2},name{3},name{4}});
        title('OB')
        subplot(2,4,5)
        col=copper(3);
        plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
        for k=1:3
            plot(f,mean(Data(Restrict(Spectsd,OBEp{k+4})')),'color',col(k,:),'linewidth',2)
            hold on
            spec=mean(Data(Restrict(Spectsd,OBEp{k})'));
            SpecInfo{1}(k+4,1)=mean(spec(find(f>1.5,1,'first'):find(f<5,1,'last')));
            SpecInfo{1}(k+4,2)=mean(spec(find(f>5,1,'first'):find(f<10,1,'last')));
            SpecInfo{1}(k+4,3)=mean(Data(Restrict(sptsd,OBEp{k})));
            Spectra{1,k+4}=spec;
        end
        legend({'Tot',name{5},name{6},name{7}});
        spec=mean(Data(Restrict(Spectsd,OBEp{8})'));
        SpecInfo{1}(8,1)=mean(spec(find(f>1.5,1,'first'):find(f<5,1,'last')));
        SpecInfo{1}(8,2)=mean(spec(find(f>5,1,'first'):find(f<10,1,'last')));
        SpecInfo{1}(8,3)=mean(Data(Restrict(sptsd,OBEp{8})));
        Spectra{1,8}=spec;
        
        strint=[2,4,5];
        for i=1:3
            load(['SpectrumDataL/Spectrum',num2str(chan(file,strint(i))),'.mat']);
            sptsd=tsd(t*1e4,mean(Sp(:,find(f>1.5,1,'first'):find(f<5,1,'last'))')');
            sptsd=Restrict(sptsd,SWSEpoch);
            Spectsd=tsd(t*1e4,Sp);
            Spectsd=Restrict(Spectsd,SWSEpoch);
            subplot(2,4,1+i)
            col=copper(4);
            plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
            for k=1:4
                plot(f,mean(Data(Restrict(Spectsd,OBEp{k}))),'color',col(k,:),'linewidth',2)
                hold on
                spec=mean(Data(Restrict(Spectsd,OBEp{k})'));
                SpecInfo{i+1}(k,1)=mean(spec(find(f>1.5,1,'first'):find(f<5,1,'last')));
                SpecInfo{i+1}(k,2)=mean(spec(find(f>5,1,'first'):find(f<10,1,'last')));
                SpecInfo{i+1}(k,3)=mean(Data(Restrict(sptsd,OBEp{k})));
                Spectra{i+1,k}=spec;
                
            end
            title(struc{strint(i)})
            subplot(2,4,5+i)
            col=copper(3);
            plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
            for k=1:3
                plot(f,mean(Data(Restrict(Spectsd,OBEp{k+4}))),'color',col(k,:),'linewidth',2)
                hold on
                spec=mean(Data(Restrict(Spectsd,OBEp{k})'));
                SpecInfo{i+1}(k+4,1)=mean(spec(find(f>1.5,1,'first'):find(f<5,1,'last')));
                SpecInfo{i+1}(k+4,2)=mean(spec(find(f>5,1,'first'):find(f<10,1,'last')));
                SpecInfo{i+1}(k+4,3)=mean(Data(Restrict(sptsd,OBEp{k})));
                Spectra{i+1,k+4}=spec;
                
            end
            spec=mean(Data(Restrict(Spectsd,OBEp{8})'));
            SpecInfo{i+1}(8,1)=mean(spec(find(f>1.5,1,'first'):find(f<5,1,'last')));
            SpecInfo{i+1}(8,2)=mean(spec(find(f>5,1,'first'):find(f<10,1,'last')));
            SpecInfo{i+1}(8,3)=mean(Data(Restrict(sptsd,OBEp{k})));
            Spectra{i+1,8}=spec;
            
        end
        
        saveFigure(spfig,'SpectraOnOBv5',filetosave)
        save([filetosave,'Spectinfov5.mat'],'SpecInfo','OBEp','Spectra')
        close all
        
        %%%%
        %% Modulation of oscillations
        %%%%
        CountSpindlesRipplesSB(res,filetosave,OBEp,1)
        
    catch
        disp([num2str(file), 'failed'])
        keyboard
    end
end
