%%LPS data
% first digit is mouse / second is day
filename{1,1}='/media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013';
filename{1,2}='/media/DataMOBs/ProjetLPS/Mouse051/20130221/BULB-Mouse-51-21022013';
filename{1,3}='/media/DataMOBs/ProjetLPS/Mouse051/20130222/BULB-Mouse-51-22022013';
filename{1,4}='/media/DataMOBs/ProjetLPS/Mouse051/20130223/BULB-Mouse-51-23022013';


filename{2,1}='/media/DataMOBs/ProjetLPS/Mouse055/20130402/BULB-Mouse-55-56-02042013';
filename{2,2}='/media/DataMOBs/ProjetLPS/Mouse055/20130403/BULB-Mouse-55-03042013';
filename{2,3}='/media/DataMOBs/ProjetLPS/Mouse055/20130404/BULB-Mouse-55-04042013';
filename{2,4}='/media/DataMOBs/ProjetLPS/Mouse055/20130405/BULB-Mouse-55-05042013';

filename{3,1}='/media/DataMOBs/ProjetLPS/Mouse056/20130409/BULB-Mouse-56-09042013';
filename{3,2}='/media/DataMOBs/ProjetLPS/Mouse056/20130410/BULB-Mouse-56-10042013';
filename{3,3}='/media/DataMOBs/ProjetLPS/Mouse056/20130411/BULB-Mouse-56-11042013';
filename{3,4}='/media/DataMOBs/ProjetLPS/Mouse056/20130412/BULB-Mouse-56-12042013';

filename{4,1}='/media/DataMOBs/ProjetLPS/Mouse063/20130424/BULB-Mouse-63-24042013';
filename{4,2}='/media/DataMOBs/ProjetLPS/Mouse063/20130425/BULB-Mouse-63-25042013';
filename{4,3}='/media/DataMOBs/ProjetLPS/Mouse063/20130426/BULB-Mouse-63-26042013';
filename{4,4}='/media/DataMOBs/ProjetLPS/Mouse063/20130427/BULB-Mouse-63-27042013';

filename{5,1}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD2/LPSD2-Mouse-124-01042014/';
filename{5,2}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD3/LPSD3-Mouse-124-02042014/';
filename{5,3}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD4/LPSD4-Mouse-124-03042014/';
filename{5,4}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD5/LPSD5-Mouse-124-04042014/';


Ripch=[17,14,11,11];
% Spf=[8 12;10 15;15 20;10 20];
Spf=[5 10; 10 14;6 8; 8 12];
PFCxch=[20,21;1,1;6,2;10,8;8,8]; %deep then sup
PaCxch=[23,28;10,11;12,8;3,0];


% Get Spindles, Ripples and Delta Waves
err=[];
for m=1:4
    m
    for d=1:4
        try
            d
            cd(filename{m,d})
            load('StateEpoch.mat');
            SWSEpoch=SWSEpoch-NoiseEpoch;
            SWSEpoch=SWSEpoch-GndNoiseEpoch;
            SWSEpoch=CleanUpEpoch(SWSEpoch);
            
            
            %% Ripples
            %             load(strcat('LFPData/LFP',num2str(Ripch(m)),'.mat'));
            %             [Rip,usedEpoch]=FindRipplesKarimSB(LFP,SWSEpoch);
            %             Ripples{1}=tsd(Rip(:,2)*1E4,Rip(:,2)*1E4);
            %             Ripples{2}=usedEpoch;
            %             Filsp=FilterLFP(LFP,[120 200],1024);
            %             HilRip=hilbert(Data(Filsp));
            %             HRip=tsd(Range(Filsp),abs(HilRip));
            
            %% Spindles and Delta
            struct='PFCx'
            
            ch=PFCxch(m,2);
            load(strcat('LFPData/LFP',num2str(ch),'.mat'));
            for s=1:length(Spf)
                [Spi,SWA,stdev,usedEpoch]=FindSpindlesKarimNewSB(LFP,Spf(s,:),SWSEpoch);
                SpindlesPF{s,1}=tsd(Spi(:,2)*1E4,Spi(:,3)*1E4-Spi(:,1)*1e4);
                SpindlesPF{s,2}=usedEpoch;
                
            end
            
            %             if PFCxch(m,1)~=PFCxch(m,2)
            %                 [tDeltaT2,tDeltaP2,usedEpoch]=FindDeltaWavesChan(struct,SWSEpoch,PFCxch(m,:));
            %                 DeltaPF{1}=tsd(Range(tDeltaT2),Range(tDeltaT2));
            %                 DeltaPF{2}=usedEpoch;
            %             else
            %                 DeltaPF{1}=[];
            %                 DeltaPF{2}=[];
            %             end
            
            struct='PaCx'
            ch=PaCxch(m,2);
            load(strcat('LFPData/LFP',num2str(ch),'.mat'));
            for s=1:length(Spf)
                [Spi,SWA,stdev,usedEpoch]=FindSpindlesKarimNewSB(LFP,Spf(s,:),SWSEpoch);
                SpindlesPa{s,1}=tsd(Spi(:,2)*1E4,Spi(:,3)*1E4-Spi(:,1)*1e4);
                SpindlesPa{s,2}=usedEpoch;
                
            end
            
            %             if PaCxch(m,1)~=PaCxch(m,2)
            %                 [tDeltaT2,tDeltaP2,usedEpoch]=FindDeltaWavesChan(struct,SWSEpoch,PaCxch(m,:));
            %                 DeltaPa{1}=tsd(Range(tDeltaT2),Range(tDeltaT2));
            %                 DeltaPa{2}=usedEpoch;
            %             else
            %                 DeltaPa{1}=[];
            %                 DeltaPa{2}=[];
            %             end
            %
            save('NewSpindles.mat','SpindlesPF','SpindlesPa')
            
            %             save('Oscillations.mat','Ripples','HRip','SpindlesPF','SpindlesPa','DeltaPa','DeltaPF')
        catch
            err=[err;m,d]
        end
    end
end


%% Look at quality of oscillations and cross correlograms
for t=2
                        clear DataLPS

    spin{1}='8:12Hz';
    spin{2}='10:15Hz';
    spin{3}='15:20Hz';
    spin{4}='10:20Hz';
    % spin{1}='5:10Hz';
    % spin{2}='10:14Hz';
    % spin{3}='6:8Hz';
    % spin{4}='8:12Hz';
    
    erross=[];
    for m= 1:4
        num=0;
        m
        for d=1:4
            d
            try
                num=num+1;
                cd(filename{m,d})
                load('StateEpoch.mat');
                load('behavResources.mat');
                load('Oscillations.mat');
                Spf=[8 12;10 15;15 20;10 20];
                if t==2
                    Spf=[5 10; 10 14;6 8; 8 12];
                    load('NewSpindles.mat')
                    spin{1}='5:10Hz';
                    spin{2}='10:14Hz';
                    spin{3}='6:8Hz';
                    spin{4}='8:12Hz';
                    
                    
                end
                load(strcat('LFPData/LFP',num2str(Ripch(m)),'.mat'));
                
                if d==1
                    for g=1:2
                        if g==1
                            
                            Epoch=And(SWSEpoch,PreEpoch);
                            Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                            Epoch=CleanUpEpoch(Epoch);
                            if size(Start(Epoch),1)~=0
                                FIguresScript
                                num=num+1;
                            else
                                num=num+1;
                            end
                        else
                            Epoch=And(SWSEpoch,VEHEpoch);
                            Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                            Epoch=CleanUpEpoch(Epoch);
                            FIguresScript
                            if size(Start(Epoch),1)~=0
                                FIguresScript
                            end
                            
                        end
                    end
                elseif d==2
                    for g=1:2
                        if g==1
                            Epoch=And(SWSEpoch,PreEpoch);
                            Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                            Epoch=CleanUpEpoch(Epoch);
                            FIguresScript
                            if size(Start(Epoch),1)~=0
                                FIguresScript
                                num=num+1;
                            else
                                num=num+1;
                            end
                            
                        else
                            Epoch=And(SWSEpoch,LPSEpoch);
                            Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                            Epoch=CleanUpEpoch(Epoch);
                            FIguresScript
                            if size(Start(Epoch),1)~=0
                                FIguresScript
                            end
                        end
                    end
                else
                    g=1;
                    Epoch=SWSEpoch;
                    Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                    Epoch=CleanUpEpoch(Epoch);
                    FIguresScript
                    
                end
            catch
                erross=[erross;m,d]
            end
            
        end
    end
    if t==1
        cd('/media/DataMOBs14/LPSAnalysis')
        save('DataLPS1.mat','DataLPS')
    else
        cd('/media/DataMOBs14/LPSAnalysis')
        save('DataLPS2.mat','DataLPS')
    end
end
%% Look at number of different things
errnum=[];
totinfo=cell(1,11);
for k=1:11
    totinfo{k}=zeros(4,6);
end

for m= 1:4
    num=0;
    m
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    
    for d=1:4
        d
        try
            cd(filename{m,d})
            load('StateEpoch.mat');
            load('behavResources.mat');
            load('Oscillations.mat');
            
            if d==1
                try
                    load('LFPData/LFP0.mat')
                catch
                    try
                        load('LFPData/LFP1.mat')
                        
                    catch
                        try
                            load('LFPData/LFP2.mat')
                        catch
                            load('LFPData/LFP3.mat')
                        end
                    end
                end
                
                for g=1:2
                    if g==1
                        
                        Epoch=And(SWSEpoch,PreEpoch);
                        Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                        Epoch=CleanUpEpoch(Epoch);
                        num=num+1;
                        if size(Start(Epoch),1)~=0
                            NumbersLPS
                        end
                        
                    else
                        Epoch=And(SWSEpoch,VEHEpoch);
                        Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                        Epoch=CleanUpEpoch(Epoch);
                        num=num+1;
                        if size(Start(Epoch),1)~=0
                            NumbersLPS
                        end
                        
                    end
                end
            elseif d==2
                try
                    load('LFPData/LFP0.mat')
                catch
                    try
                        load('LFPData/LFP1.mat')
                        
                    catch
                        try
                            load('LFPData/LFP2.mat')
                        catch
                            load('LFPData/LFP3.mat')
                        end
                    end
                end
                for g=1:2
                    if g==1
                        
                        Epoch=And(SWSEpoch,PreEpoch);
                        Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                        Epoch=CleanUpEpoch(Epoch);
                        num=num+1;
                        if size(Start(Epoch),1)~=0
                            NumbersLPS
                        end
                        
                    else
                        
                        Epoch=And(SWSEpoch,LPSEpoch);
                        Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                        Epoch=CleanUpEpoch(Epoch);
                        num=num+1;
                        if size(Start(Epoch),1)~=0
                            NumbersLPS
                        end
                        
                    end
                end
            else
                try
                    load('LFPData/LFP0.mat')
                catch
                    try
                        load('LFPData/LFP1.mat')
                        
                    catch
                        try
                            load('LFPData/LFP2.mat')
                        catch
                            load('LFPData/LFP3.mat')
                        end
                    end
                end
                g=1;
                Epoch=SWSEpoch;
                Epoch=Epoch-NoiseEpoch-GndNoiseEpoch;
                Epoch=CleanUpEpoch(Epoch);
                num=num+1;
                NumbersLPS
                
            end
        catch
            errnum=[errnum;m,d]
        end
        
    end
end

NumbersLPStot



%% Look at spectra in PFCx
errsp=[];
clear SpPV  SpV  SpPL  SpL
for m=1:5
    m
    for d=1:4
        try
            d
            cd(filename{m,d})
            clear LPSEpoch VEHEpoch t Sp Spectro
            try load('StateEpoch.mat'); catch, load('StateEpochSB.mat'); end
            if d<3
         try load('behavResources.mat'); catch, load('behavRessources.mat'); end
            end
         try
            load(strcat('SpectrumDataL/Spectrum',num2str(PFCxch(m,1)),'.mat'))
         catch
             load('8_Spectrum.mat')
         end
            SWSEpoch=SWSEpoch-NoiseEpoch;
            SWSEpoch=SWSEpoch-GndNoiseEpoch;
            SWSEpoch=CleanUpEpoch(SWSEpoch);
            try
                sptsd=tsd(t*1e4,Sp);
                f1=f;
                disp('1')
            catch
                 sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                 f2=Spectro{3};
                 disp('2')
            end
            
            if d==1
                PVEH=And(SWSEpoch,PreEpoch);
                VEH=And(SWSEpoch,VEHEpoch);
                SpPV{m}=nanmean(Data(Restrict(sptsd,PVEH)));
                SpV{m}=nanmean(Data(Restrict(sptsd,VEH)));
            elseif d==2
                PLPS=And(SWSEpoch,PreEpoch);
                LPS=And(SWSEpoch,LPSEpoch);
                SpPL{m}=nanmean(Data(Restrict(sptsd,PLPS)));
                SpL{m}=nanmean(Data(Restrict(sptsd,LPS)));
            elseif d==3
                Sp24{m}=nanmean(Data(Restrict(sptsd,SWSEpoch)));
            else
                Sp48{m}=nanmean(Data(Restrict(sptsd,SWSEpoch)));
            end
        catch
            
            errsp=[errsp;m,d]
        end
    end
end
SpPV{5}=resample(SpPV{5},326,263);
SpV{5}=resample(SpV{5},326,263);
SpL{5}=resample(SpL{5},326,263);
SpPL{5}=resample(SpPL{5},326,263);
Sp24{5}=resample(Sp24{5},326,263);
Sp48{5}=resample(Sp48{5},326,263);

figure
for m=1:5
  
    subplot(2,3,m)
    plot(f,f.*SpPV{m},'color',col(1,:),'linewidth',2)
    hold on
    plot(f,f.*SpPL{m},'color',col(2,:),'linewidth',2)
    plot(f,f.*SpV{m},'color',col(3,:),'linewidth',2)
    plot(f,f.*SpL{m},'color','k','linewidth',2)
    try
        plot(f,f.*Sp24{m},'color',col(5,:),'linewidth',2)
    end
    plot(f,f.*Sp48{m},'color',col(6,:),'linewidth',2)
end


figure
dim=2;
M=cat(dim+1,SpPV{:});
plot(f,f.*(nanmean(M,dim+1)),'color',col(1,:),'linewidth',2)
hold on
M=cat(dim+1,SpPL{:});
plot(f,f.*(nanmean(M,dim+1)),'color',col(2,:),'linewidth',2)
M=cat(dim+1,SpV{:});
plot(f,f.*(nanmean(M,dim+1)),'color',col(3,:),'linewidth',2)
M=cat(dim+1,SpL{:});
plot(f,f.*(nanmean(M,dim+1)),'color','k','linewidth',2)
try
    M=cat(dim+1,Sp24{:});
    plot(f,f.*(nanmean(M,dim+1)),'color',col(5,:),'linewidth',2)
end
M=cat(dim+1,Sp48{:});
plot(f,f.*(nanmean(M,dim+1)),'color',col(6,:),'linewidth',2)


figure
for m=2:5
    subplot(2,2,m-1)
    plot(f,log10(SpPV{m}),'b','linewidth',2)
    hold on
    plot(f,log10(SpPL{m}),'y','linewidth',2)
    plot(f,log10(SpV{m}),'c','linewidth',2)
    plot(f,log10(SpL{m}),'k','linewidth',2)
    try
        plot(f,log10(Sp24{m}),'m','linewidth',2)
    end
    plot(f,log10(Sp48{m}),'r','linewidth',2)
end


figure
for m=2:5
    subplot(2,2,m-1)
    line([0 0],[0 sum(SpPV{m}(30:70))/sum(SpPV{m})],'color','b','linewidth',10)
    hold on
    line([1 1],[0 sum(SpPL{m}(30:70))/sum(SpPL{m})],'color','b','linewidth',10)
    line([2 2],[0 sum(SpV{m}(30:70))/sum(SpV{m})],'color','c','linewidth',10)
    line([3 3],[0 sum(SpL{m}(30:70))/sum(SpL{m})],'color','k','linewidth',10)
    try
        line([4 4],[0 sum(Sp24{m}(30:70))/sum(Sp24{m})],'color','m','linewidth',10)
    end
    line([5 5],[0 sum(Sp48{m}(30:70))/sum(Sp48{m})],'color','r','linewidth',10)
    xlim([-1 6])
    
end



figure
dim=2;
    M=cat(dim+1,SpPV{:});
    plot(f,f.*(nanmean(M,dim+1)),'r','linewidth',2)
    hold on
    M=cat(dim+1,SpPL{:});
    plot(f,f.*(nanmean(M,dim+1)),'b','linewidth',2)
    M=cat(dim+1,SpV{:});
    plot(f,f.*(nanmean(M,dim+1)),'m','linewidth',2)
    M=cat(dim+1,SpL{:});
    plot(f,f.*(nanmean(M,dim+1)),'c','linewidth',2)
    try
        M=cat(dim+1,Sp24{:});
        plot(f,f.*(nanmean(M,dim+1)),'k','linewidth',2)
    end
    M=cat(dim+1,Sp48{:});
    plot(f,f.*(nanmean(M,dim+1)),'y','linewidth',2)


figure
dim=2;
    M=cat(dim+1,SpPV{:});
    plot(f,log10(nanmean(M,dim+1)),'r','linewidth',2)
    hold on
    M=cat(dim+1,SpPL{:});
    plot(f,log10(nanmean(M,dim+1)),'b','linewidth',2)
    M=cat(dim+1,SpV{:});
    plot(f,log10(nanmean(M,dim+1)),'m','linewidth',2)
    M=cat(dim+1,SpL{:});
    plot(f,log10(nanmean(M,dim+1)),'c','linewidth',2)
    try
        M=cat(dim+1,Sp24{:});
        plot(f,log10(nanmean(M,dim+1)),'k','linewidth',2)
    end
    M=cat(dim+1,Sp48{:});
    plot(f,log10(nanmean(M,dim+1)),'y','linewidth',2)


    
save('SpData.mat','SpPV','SpPL','SpV','SpL','Sp24','Sp48')


%%
%% File and Data info

% Delta Power analysis
clear valP valB
for mouse=1:2
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
        %         files{3}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D3/LPSD3-Mouse-123-02042014/';
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
    freqrg=[1.5 5];
    
    % params.tapers=[3,5];
    params.fpass=[0 25];
    params.err=[2,0.05];
    params.pad=0;
    params.tapers=[3,5];
    movingwin=[3,0.5];
    
    
    
    
    %% Plot figures
    
    % Evolution of Spectrogram Power in different bands (10 subEp) (all strct)
    % Spectra superposed REM/SWS/Wake (all strct)
    % Spectra throughout day (all strct, sleep types separate)
    divday=[4,6,8,10,20];
    cc= copper(3);
    for file=1:length(files)
        file
        clear valS valW valR valSS valSR valSW
        cd(files{file});
        load('StateEpochSB.mat')
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
        f=Spectro{3};
        
        
        a=(channels{1,2}(1));
        load(strcat(num2str(a{1}),'_Spectrum.mat'))
        sptsdB=tsd(Spectro{2}*1e4,log(smooth2a(Spectro{1}',1,11))');
        a=(channels{1,2}(3));
        load(strcat(num2str(a{1}),'_Spectrum.mat'))
        sptsdP=tsd(Spectro{2}*1e4,log(smooth2a(Spectro{1}',1,11))');
        f=Spectro{3};
        beg=find(f>freqrg(1),1,'first');
        endin=find(f<freqrg(2),1,'last');
        
        % figure
        for divtype=1:length(divday)
            cc2=summer(divday(divtype));
            stpSWS=Stop(SWSEpoch);
            stSWS=Start(SWSEpoch);
            lsS=(stpSWS(end)-stSWS(1))/divday(divtype);
            %             lsS=r(end)/divday(divtype);
            % Ts=Range(Restrict(LFP,SWSEpoch));
            % lsS=size(Ts,1)/divday(divtype);
            
            for g=1:divday(divtype)
                subEp=And(intervalSet((g-1)*lsS+stSWS(1),g*lsS+stSWS(1)),SWSEpoch);
                % subEp=ts(Ts(1+(g-1)*lsS:g*lsS-1));
                int=mean(Data(Restrict(sptsdP,subEp)));
                % plot(int,'color',cc2(g,:),'linewidth',2)
                % hold on
                % pause
                valP{file,divtype}(g,1)=nansum(int(beg:endin));
                valP{file,divtype}(g,2)=max(int(beg:endin));
                
            end
            
            
            for g=1:divday(divtype)
                subEp=And(intervalSet((g-1)*lsS+stSWS(1),g*lsS+stSWS(1)),SWSEpoch);
                %                 subEp=ts(Ts(1+(g-1)*lsS:g*lsS-1));
                int=mean(Data(Restrict(sptsdB,subEp)));
                for w=1:size(freqrg,1)
                    valB{file,divtype}(g,1)=nansum(int(beg:endin));
                    valB{file,divtype}(g,2)=max(int(beg:endin));
                end
            end
        end
    end
    
    cd ..
    cd ..
    save('evolutionofdelta.mat','valB','valP')
end


%% figures
load('/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/evolutionofdelta.mat')
figure
subplot(221)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2,3]
        valP{i,k}(valP{i,k}(:,1)==0,1)=NaN;
        plot(valP{i,k}(:,1)/mean(valP{i,k}(1:5,1)),'linewidth',2,'color','k')
        if i==3
            plot(valP{i,k}(:,1)/mean(valP{i,k}(1:5,1)),'linewidth',2,'color',[1 0.6 0.6])
            
        end
        hold on
    end
end
ylabel('PFCx')
title('1.5-5 Hz integrated power')

subplot(223)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2,3]
        valB{i,k}(valB{i,k}(:,1)==0,1)=NaN;
        plot(valB{i,k}(:,1)/mean(valB{i,k}(1:5,1)),'linewidth',2,'color','k')
        if i==3
            plot(valB{i,k}(:,1)/mean(valB{i,k}(1:5,1)),'linewidth',2,'color',[1 0.6 0.6])
        end
        hold on
    end
end
ylabel('OB')


subplot(222)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2,3]
        valP{i,k}(valP{i,k}(:,2)==0,1)=NaN;
        plot(valP{i,k}(:,2)/mean(valP{i,k}(1:5,2)),'linewidth',2,'color','k')
        if i==3
            plot(valP{i,k}(:,2)/mean(valP{i,k}(1:5,2)),'linewidth',2,'color',[1 0.6 0.6])
            
        end
        hold on
    end
end
title('max value 1.5-5Hz')

subplot(224)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2,3]
        valB{i,k}(valB{i,k}(:,2)==0,1)=NaN;
        plot(valB{i,k}(:,2)/mean(valB{i,k}(1:5,2)),'linewidth',2,'color','k')
        if i==3
            plot(valB{i,k}(:,2)/mean(valB{i,k}(1:5,2)),'linewidth',2,'color',[1 0.6 0.6])
            
        end
        hold on
    end
end

%%

%% figures
load('/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/evolutionofdelta.mat')
figure
subplot(221)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2]
        valP{i,k}(valP{i,k}(:,1)==0,1)=NaN;
        plot(valP{i,k}(:,1)/mean(valP{i,k}(1:5,1)),'linewidth',2,'color','k')
        if i==3
            plot(valP{i,k}(:,1)/mean(valP{i,k}(1:5,1)),'linewidth',2,'color',[1 0.6 0.6])
            
        end
        hold on
    end
end
ylabel('PFCx')
title('1.5-5 Hz integrated power')

subplot(223)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2]
        valB{i,k}(valB{i,k}(:,1)==0,1)=NaN;
        plot(valB{i,k}(:,1)/mean(valB{i,k}(1:5,1)),'linewidth',2,'color','k')
        if i==3
            plot(valB{i,k}(:,1)/mean(valB{i,k}(1:5,1)),'linewidth',2,'color',[1 0.6 0.6])
        end
        hold on
    end
end
ylabel('OB')


subplot(222)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2]
        valP{i,k}(valP{i,k}(:,2)==0,1)=NaN;
        plot(smooth(valP{i,k}(:,2),3)/mean(valP{i,k}(1:5,2)),'linewidth',2,'color','k')
        if i==3
            plot(valP{i,k}(:,2)/mean(valP{i,k}(1:5,2)),'linewidth',2,'color',[1 0.6 0.6])
            
        end
        hold on
    end
end
title('max value 1.5-5Hz')

subplot(224)
for k=5
    %     subplot(1,length(divday),k)
    for i=[1,2]
        valB{i,k}(valB{i,k}(:,2)==0,1)=NaN;
        plot(valB{i,k}(:,2)/mean(valB{i,k}(1:5,2)),'linewidth',2,'color','k')
        if i==3
            plot(valB{i,k}(:,2)/mean(valB{i,k}(1:5,2)),'linewidth',2,'color',[1 0.6 0.6])
            
        end
        hold on
    end
end

%%
scrsz=get(0,'ScreenSize');
close all
for file=1:length(files)
    file
    cd(files{file});
    load('DeltaInfo.mat')
   newfig= figure('Position',scrsz/2);
    Sl=[Sl_R;Sl_W];
    Sl=sortrows(Sl,16);
    for t=1:6
        Sltsd{t}=tsd(Sl(:,16),Sl(:,t));
    end
    
    for k=1:5
        k
        if file==3
            load('behavRessources.mat')
            subplot(2,3,k)
            plot(Data(Restrict(Sltsd{1},PreEpoch)),Data(Restrict(Sltsd{k+1},PreEpoch)),'k.')
            hold on
            plot(Data(Restrict(Sltsd{1},LPSEpoch)),Data(Restrict(Sltsd{k+1},LPSEpoch)),'.','color',[1 0.6 0.6])
                [R1,P0]=corrcoef(Data(Restrict(Sltsd{1},PreEpoch)),Data(Restrict(Sltsd{k+1},PreEpoch)));
                [R2,P0]=corrcoef(Data(Restrict(Sltsd{1},LPSEpoch)),Data(Restrict(Sltsd{k+1},LPSEpoch)));
                title(strcat(num2str(R1(1,2)),'-',num2str(R2(1,2))))
        elseif file==2
                        load('behavRessources.mat')
            subplot(2,3,k)
            plot(Data(Restrict(Sltsd{1},PreEpoch)),Data(Restrict(Sltsd{k+1},PreEpoch)),'k.')
            hold on
            plot(Data(Restrict(Sltsd{1},VEHEpoch)),Data(Restrict(Sltsd{k+1},VEHEpoch)),'.','color',[1 0.6 0.6])
                [R1,P0]=corrcoef(Data(Restrict(Sltsd{1},PreEpoch)),Data(Restrict(Sltsd{k+1},PreEpoch)));
                [R2,P0]=corrcoef(Data(Restrict(Sltsd{1},VEHEpoch)),Data(Restrict(Sltsd{k+1},VEHEpoch)));
                title(strcat(num2str(R1(1,2)),'-',num2str(R2(1,2))))

            
        else
            subplot(2,3,k)
            plot(Sl(:,1),Sl(:,k+1),'k.')
            hold on
            try
                plot(Sl(:,1),Sl(:,k+1),'k.')
            end
            try
                [R,P0]=corrcoef([Sl(:,1);Sl(:,1)],[Sl(:,k+1);Sl(:,k+1)]);
            catch
                [R,P0]=corrcoef([Sl(:,1)],[Sl(:,k+1)]);
            end
            title(num2str(R(1,2)))
        end
    end
    
    cd('/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/')
    saveFigure(newfig,strcat('DeltaCorr',num2str(file)),cd)
end

%% lps spectra

figure
cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD2/LPSD2-Mouse-124-01042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,nanmean(Data(Restrict(sptsdB,And(SWSEpoch,intervalSet(min(Start(VEHEpoch)),min(Start(VEHEpoch))+7200*1e4))))),'linewidth',3)
hold on
subplot(132)
plot(f,nanmean(Data(Restrict(sptsdP,And(SWSEpoch,intervalSet(min(Start(VEHEpoch)),min(Start(VEHEpoch))+7200*1e4))))),'linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,intervalSet(min(Start(VEHEpoch)),min(Start(VEHEpoch))+7200*1e4))))),'linewidth',3)
hold on

cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD3/LPSD3-Mouse-124-02042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,nanmean(Data(Restrict(sptsdB,And(SWSEpoch,intervalSet(min(Start(LPSEpoch)),min(Start(LPSEpoch))+7200*1e4))))),'r','linewidth',3)
hold on
subplot(132)
plot(f,nanmean(Data(Restrict(sptsdP,And(SWSEpoch,intervalSet(min(Start(LPSEpoch)),min(Start(LPSEpoch))+7200*1e4))))),'r','linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,intervalSet(min(Start(LPSEpoch)),min(Start(LPSEpoch))+7200*1e4))))),'r','linewidth',3)
hold on

 figure
cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD2/LPSD2-Mouse-124-01042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,nanmean(Data(Restrict(sptsdB,And(SWSEpoch,VEHEpoch)))),'linewidth',3)
hold on
subplot(132)
plot(f,nanmean(Data(Restrict(sptsdP,And(SWSEpoch,VEHEpoch)))),'linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,VEHEpoch)))),'linewidth',3)
hold on

cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD3/LPSD3-Mouse-124-02042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,nanmean(Data(Restrict(sptsdB,And(SWSEpoch,LPSEpoch)))),'r','linewidth',3)
hold on
subplot(132)
plot(f,nanmean(Data(Restrict(sptsdP,And(SWSEpoch,LPSEpoch)))),'r','linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,LPSEpoch)))),'r','linewidth',3)
hold on

figure
cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD2/LPSD2-Mouse-124-01042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,f.*(nanmean(Data(Restrict(sptsdB,And(SWSEpoch,intervalSet(min(Start(VEHEpoch)),min(Start(VEHEpoch))+7200*1e4)))))),'linewidth',3)
hold on
subplot(132)
plot(f,f.*(nanmean(Data(Restrict(sptsdP,And(SWSEpoch,intervalSet(min(Start(VEHEpoch)),min(Start(VEHEpoch))+7200*1e4)))))),'linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,intervalSet(min(Start(VEHEpoch)),min(Start(VEHEpoch))+7200*1e4))))),'linewidth',3)
hold on

cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD3/LPSD3-Mouse-124-02042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,f.*(nanmean(Data(Restrict(sptsdB,And(SWSEpoch,intervalSet(min(Start(LPSEpoch)),min(Start(LPSEpoch))+7200*1e4)))))),'r','linewidth',3)
hold on
subplot(132)
plot(f,f.*(nanmean(Data(Restrict(sptsdP,And(SWSEpoch,intervalSet(min(Start(LPSEpoch)),min(Start(LPSEpoch))+7200*1e4)))))),'r','linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,intervalSet(min(Start(LPSEpoch)),min(Start(LPSEpoch))+7200*1e4))))),'r','linewidth',3)
hold on

 figure
cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD2/LPSD2-Mouse-124-01042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,f.*(nanmean(Data(Restrict(sptsdB,And(SWSEpoch,VEHEpoch))))),'linewidth',3)
hold on
subplot(132)
plot(f,f.*(nanmean(Data(Restrict(sptsdP,And(SWSEpoch,VEHEpoch))))),'linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,VEHEpoch)))),'linewidth',3)
hold on

cd /media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD3/LPSD3-Mouse-124-02042014/
load 8_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 11_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavRessources.mat
load StateEpochSB.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,f.*(nanmean(Data(Restrict(sptsdB,And(SWSEpoch,LPSEpoch))))),'r','linewidth',3)
hold on
subplot(132)
plot(f,f.*(nanmean(Data(Restrict(sptsdP,And(SWSEpoch,LPSEpoch))))),'r','linewidth',3)
hold on
load Coh_11_8.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,LPSEpoch)))),'r','linewidh',3)
hold on

%% M51
figure
cd /media/DataMOBs/ProjetLPS/Mouse051/20130220/BULB-Mouse-51-20022013/
load 20_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 4_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavResources.mat
load StateEpoch.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,f.*(nanmean(Data(Restrict(sptsdB,And(SWSEpoch,VEHEpoch))))),'linewidth',3)
hold on
subplot(132)
plot(f,f.*(nanmean(Data(Restrict(sptsdP,And(SWSEpoch,VEHEpoch))))),'linewidth',3)
hold on
load Coh_20_4.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,VEHEpoch)))),'linewidth',3)
hold on

cd /media/DataMOBs/ProjetLPS/Mouse051/20130221/BULB-Mouse-51-21022013/
load 20_Spectrum.mat
sptsdP=tsd(Spectro{2}*1e4,(Spectro{1}')');
load 4_Spectrum.mat
sptsdB=tsd(Spectro{2}*1e4,(Spectro{1}')');
f=Spectro{3};
load behavResources.mat
load StateEpoch.mat
SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
subplot(131)
plot(f,f.*(nanmean(Data(Restrict(sptsdB,And(SWSEpoch,LPSEpoch))))),'r','linewidth',3)
hold on
subplot(132)
plot(f,f.*(nanmean(Data(Restrict(sptsdP,And(SWSEpoch,LPSEpoch))))),'r','linewidth',3)
hold on
load Coh_20_4.mat
Ctsd=tsd((t+movingwin(2)/2)*1E4,Ctemp);
subplot(133)
plot(f,nanmean(Data(Restrict(Ctsd,And(SWSEpoch,LPSEpoch)))),'r','linewidth',3)
hold on
