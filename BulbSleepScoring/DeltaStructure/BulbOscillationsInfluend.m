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


for file =3:5
    
    try
        file
        cd(filename2{file})
        res=filename2{file};
        load('StateEpoch.mat')
        filetosave=['/home/mobs/Documents/BulbOscillationEffect/','M',num2str(file),'/'];
        
        
        %%%%
        %% Get OB Epochs
        %%%%
        
        disp('getting Epochs')
        load(['SpectrumDataL/Spectrum',num2str(chan(file,1)),'.mat']);
        rg=t(end)*1e4;
        TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
        
        % First Way : divide into four parts
        sptsd=tsd(t*1e4,mean(Sp(:,find(f>1.5,1,'first'):find(f<5,1,'last'))')');
        sptsd=Restrict(sptsd,SWSEpoch);
        dat=Data(sptsd);
        lim(1)=percentile(dat,0.75);
        lim(2)=percentile(dat,0.55);
        lim(3)=percentile(dat,0.25);
        tempEp=thresholdIntervals(sptsd,lim(1),'Direction','Above');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{1}=tempEp;
        name{1}=['Top 75% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{1})))/size(Data(sptsd))*100)),'%'];
        tempEp=thresholdIntervals(Restrict(sptsd,TotalEpoch-OBEp{1}),lim(2),'Direction','Above');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{2}=tempEp;
        name{2}=['Top 50% to 75% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{1})))/size(Data(sptsd))*100)),'%'];
        tempEp=thresholdIntervals(Restrict(sptsd,TotalEpoch-Or(OBEp{1},OBEp{2})),lim(3),'Direction','Above');
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{3}=tempEp;
        name{3}=['Top 25% to 50% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{2})))/size(Data(sptsd))*100)),'%'];
        tempEp=SWSEpoch-Or(OBEp{3},Or(OBEp{1},OBEp{2}));
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{4}=tempEp;
        name{4}=['Bottom 25% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{3})))/size(Data(sptsd))*100)),'%'];
        tempEp=SWSEpoch-OBEp{1};
        tempEp=mergeCloseIntervals(tempEp,2*1E4);
        tempEp=dropShortIntervals(tempEp,2*1E4);
        OBEp{5}=tempEp;
        name{5}=['Bottom 75% -',num2str(floor(size(Data(Restrict(sptsd,OBEp{4})))/size(Data(sptsd))*100)),'%'];
        % Second Way : get bursts
        load(['LFPData/LFP',num2str(chan(file,1)),'.mat']);
        FilOB=FilterLFP(LFP,[1.5 5],1024);
        FilOB=Restrict(FilOB,SWSEpoch);
        mnOB=nanmean(Data(FilOB));
        stdOB=nanstd(Data(FilOB));
        
        pks=findpeaks(Data(FilOB),mnOB+3*stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),0.5);
        OBEp{6}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{6}=['3stddev burst 0.5s-',num2str(floor(size(Data(Restrict(sptsd,OBEp{6})))/size(Data(sptsd))*100)),'%'];
        
        pks=findpeaks(Data(FilOB),mnOB+2*stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),0.5);
        OBEp{7}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{7}=['2stddev burst 0.5s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{7})))/size(Data(sptsd))*100)),'%'];
        
        pks=findpeaks(Data(FilOB),mnOB+2*stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),1);
        OBEp{8}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{8}=['2stddev burst 1s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{8})))/size(Data(sptsd))*100)),'%'];
        
        pks=findpeaks(Data(FilOB),mnOB+stdOB);
        r=Range(FilOB,'s');
        BRST=burstinfo(r(pks.loc),1);
        OBEp{9}=intervalSet(BRST.t_start*1e4,BRST.t_end*1e4);
        name{9}=['1stddev burst 1s -',num2str(floor(size(Data(Restrict(sptsd,OBEp{9})))/size(Data(sptsd))*100)),'%'];
        OBEp{10}=SWSEpoch;
        
        
        %%%%
        %% Spectra
        %%%%
        disp('plotting spectra')
        spfig=figure('color',[1 1 1],'Position',[1 1 scrsz(3)/2 scrsz(4)]);
        subplot(2,4,1)
        Spectsd=tsd(t*1e4,Sp);
        Spectsd=Restrict(Spectsd,SWSEpoch);
        col=copper(5);
        plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
        for i=1:5
            plot(f,mean(Data(Restrict(Spectsd,OBEp{i})')),'color',col(i,:),'linewidth',2)
            hold on
        end
        legend({'Tot',name{1},name{2},name{3},name{4},name{5}});
        title('OB')
        subplot(2,4,5)
        col=copper(4);
        plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
        for i=1:4
            plot(f,mean(Data(Restrict(Spectsd,OBEp{i+5})')),'color',col(i,:),'linewidth',2)
            hold on
        end
        legend({'Tot',name{6},name{7},name{8},name{9}});
        
        strint=[2,4,5];
        for i=1:3
            load(['SpectrumDataL/Spectrum',num2str(chan(file,strint(i))),'.mat']);
            Spectsd=tsd(t*1e4,Sp);
            Spectsd=Restrict(Spectsd,SWSEpoch);
            subplot(2,4,1+i)
            col=copper(5);
            plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
            for k=1:5
                plot(f,mean(Data(Restrict(Spectsd,OBEp{k}))),'color',col(k,:),'linewidth',2)
                hold on
            end
            title(struc{strint(i)})
            subplot(2,4,5+i)
            col=copper(4);
            plot(f,mean(Data(Spectsd)),'--b','linewidth',2), hold on
            for k=1:4
                plot(f,mean(Data(Restrict(Spectsd,OBEp{k+5}))),'color',col(k,:),'linewidth',2)
                hold on
            end
        end
        
        saveFigure(spfig,'SpectraOnOB',filetosave)
        %%%%
        %% Modulation of oscillations
        %%%%
        
        disp('Looking at oscillations')
        PETHSpindlesRipplesMLSB(res,filetosave,OBEp)
    catch
        disp([num2str(file), 'failed'])
        PETHSpindlesRipplesMLSB(res,filetosave,OBEp)
    end
end

% By OB


% By sleep length period


% By distance from REM1