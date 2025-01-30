clear filename
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

Ripch=[17,14,11,11];
PFCxch=[20,21;1,1;6,2;10,8]; %deep then sup
PaCxch=[23,28;10,11;12,8;3,0];


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


%% Compare Oscillations
DT=2000/2501;
timeS=([DT:DT:2000]-1000)/1e3;
DT=100/125;
timeR=([DT:DT:100]-50)/1e3;
DT=1000/1251;
timeD=([DT:DT:1000]-500)/1e3;
Bds=[-30000:1500:30000]/1E3;
TRS=([800/1001:800/1001:800]-400)/1e3;

%% Parietal
for t=1:2
      if t==1
        spin{1}='8:12Hz';
        spin{2}='10:15Hz';
        spin{3}='15:20Hz';
        spin{4}='10:20Hz';
        load(strcat('DataLPS',num2str(t),'.mat'))
                        Spf=[8 12;10 15;15 20;10 20];

        
    else
        spin{1}='5:10Hz';
        spin{2}='10:14Hz';
        spin{3}='6:8Hz';
        spin{4}='8:12Hz';
        load(strcat('DataLPS',num2str(t),'.mat'))
                            Spf=[5 10; 10 14;6 8; 8 12];

      end
        
struct='PaCx'

    
for num=1:6
    meanArrayS=cell(1,length(Spf));
    scrsz = get(0,'ScreenSize');
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    
    % what they look like
    for s=1:length(Spf)
        subplot(4,6,s)
        hold on
        for m=[1,2,4]
            plot(timeS,zscore(DataLPS{num,1+s,m}),'k')
        end
        dim = ndims(DataLPS{num,1+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,1+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        meanArrayS{s} = mean(M,dim+1);  %# Get the mean across arrays
        
        plot(timeS,zscore(meanArray),'r')
        title(spin{s})
        
    end
    
    subplot(4,6,5)
    for m=[1,2,4]
        plot(timeR,zscore(DataLPS{num,1,m}),'k')
        hold on
    end
    dim = ndims(DataLPS{num,1,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,1,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(timeR,zscore(meanArray),'r')
    title('Ripples')
    
    subplot(4,6,6)
    for m=[1,2,4]
        plot(timeD,zscore(DataLPS{num,6,m}),'k')
        hold on
        plot(timeD,zscore(DataLPS{num,7,m}),'k','linewidth',2)
    end
    dim = ndims(DataLPS{num,6,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,6,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(timeD,zscore(meanArray),'r')
    dim = ndims(DataLPS{num,7,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,7,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(timeD,zscore(meanArray),'r','linewidth',2)
    title('Delta')
    
    
    % Cross correlograms
    for s=1:length(Spf)
        subplot(4,6,6+s)
        for m=[1,2,4]
            plot(Bds, DataLPS{num,13+s,m}/sum(DataLPS{num,13+s,m}),'k')
            DataLPS{num,13+s,m}=DataLPS{num,13+s,m}/sum(DataLPS{num,13+s,m});
            hold on
        end
        
        dim = ndims(DataLPS{num,13+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,13+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        plot(Bds,(meanArray),'r','linewidth',3)
        a=ylim;
            xlim([-30 30])   
        line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
        if s==1
            ylabel('Delta wave rel to Spindle')
        end
        
        subplot(4,6,12+s)
        for m=[1,2,4]
            plot(Bds,DataLPS{num,17+s,m}/sum(DataLPS{num,17+s,m}),'k')
            hold on
            DataLPS{num,17+s,m}=DataLPS{num,17+s,m}/sum(DataLPS{num,17+s,m});
        end
        dim = ndims(DataLPS{num,17+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,17+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        plot(Bds,(meanArray),'r','linewidth',3)
        a=ylim;
            xlim([-30 30])   
        line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
        if s==1
            ylabel('Ripple rel to Spindle')
        end
        
        subplot(4,6,18+s)
        for m=[1,2,4]
            plot(TRS, DataLPS{num,21+s,m},'k');
            hold on
        end
        dim = ndims(DataLPS{num,21+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,21+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        plot(TRS,(meanArray),'r','linewidth',3)
        a=ylim;
        xlim([-0.4 0.4])
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',3)
        plot(timeS,zscore(meanArrayS{s})/2-5,'b','linewidth',2)
        if s==1
            ylabel('Ripple Power rel to Spindle')
        end
        
    end
    
    subplot(4,6,11)
    for m=[1,2,4]
        
        plot(Bds,DataLPS{num,26,m}/sum(DataLPS{num,26,m}),'k')
        DataLPS{num,26,m}=DataLPS{num,26,m}/sum(DataLPS{num,26,m});
        hold on
    end
    dim = ndims(DataLPS{num,26,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,26,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(Bds,(meanArray),'r','linewidth',3)
    xlim([-30 30])   
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
    title('Delta wave rel to Ripple')
    
    cd('/media/DataMOBs14/LPSAnalysis')
    a=cd;
    saveas(f,strcat('Oscillations',num2str(t),'_',num2str(num),'_',struct,'.fig'))
    try
        saveFigure(f,strcat('Oscillations1_',num2str(t),'_',struct),a)
    end
    saveas(f,strcat('Oscillations1_',num2str(t),'_',struct,'.png'))
    
    
    
    
    
    
end
close all
%% PreFrontal
struct='PFCx'

for num=1:6
    scrsz = get(0,'ScreenSize');
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    
    % what they look like
    for s=1:length(Spf)
        subplot(4,6,s)
        hold on
        for m=[1,2,4]
            plot(timeS,zscore(DataLPS{num,7+s,m}),'k')
        end
        dim = ndims(DataLPS{num,7+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,7+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        meanArrayS{s} = mean(M,dim+1);  %# Get the mean across arrays
        plot(timeS,zscore(meanArray),'r')
        title(spin{s})
        
    end
    
    subplot(4,6,5)
    for m=[1,4]
        plot(timeR,zscore(DataLPS{num,1,m}),'k')
        hold on
    end
    dim = ndims(DataLPS{num,1,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,1,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(timeR,zscore(meanArray),'r')
    title('Ripples')
    
    subplot(4,6,6)
    for m=[1,4]
        plot(timeD,zscore(DataLPS{num,12,m}),'k')
        hold on
        plot(timeD,zscore(DataLPS{num,13,m}),'k','linewidth',2)
    end
    dim = ndims(DataLPS{num,12,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,12,[1,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(timeD,zscore(meanArray),'r')
    dim = ndims(DataLPS{num,13,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,13,[1,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(timeD,zscore(meanArray),'r','linewidth',2)
    title('Delta')
    
    
    % Cross correlograms
    for s=1:length(Spf)
        subplot(4,6,6+s)
        for m=[1,4]
            plot(Bds, DataLPS{num,26+s,m}/sum(DataLPS{num,26+s,m}),'k')
            DataLPS{num,26+s,m}=DataLPS{num,26+s,m}/sum(DataLPS{num,26+s,m});
            hold on
        end
        
        dim = ndims(DataLPS{num,26+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,26+s,[1,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        plot(Bds,(meanArray),'r','linewidth',3)
        a=ylim;
        line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
        if s==1
            ylabel('Delta wave rel to Spindle')
        end
            xlim([-30 30])   

        subplot(4,6,12+s)
        for m=[1,2,4]
            plot(Bds,DataLPS{num,30+s,m}/sum(DataLPS{num,30+s,m}),'k')
            hold on
            DataLPS{num,30+s,m}=DataLPS{num,30+s,m}/sum(DataLPS{num,30+s,m});
        end
        dim = ndims(DataLPS{num,30+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,30+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        plot(Bds,(meanArray),'r','linewidth',3)
        a=ylim;
            xlim([-30 30])   
        line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
        if s==1
            ylabel('Ripple rel to Spindle')
        end
        
        subplot(4,6,18+s)
        for m=[1,2,4]
            plot(TRS, DataLPS{num,34+s,m},'k');
            hold on
        end
        dim = ndims(DataLPS{num,34+s,m});          %# Get the number of dimensions for your arrays
        M = cat(dim+1,DataLPS{num,34+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArray = mean(M,dim+1);  %# Get the mean across arrays
        plot(TRS,(meanArray),'r','linewidth',3)
        
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',3)
        plot(timeS,zscore(meanArrayS{s})/2-5,'b','linewidth',2)
        
        xlim([-0.4 0.4])
        if s==1
            ylabel('Ripple Power rel to Spindle')
        end
        
    end
    
    subplot(4,6,11)
    for m=[1,4]
        
        plot(Bds,DataLPS{num,39,m}/sum(DataLPS{num,39,m}),'k')
        DataLPS{num,39,m}=DataLPS{num,39,m}/sum(DataLPS{num,39,m});
        hold on
    end
    dim = ndims(DataLPS{num,39,m});          %# Get the number of dimensions for your arrays
    M = cat(dim+1,DataLPS{num,39,[1,4]});        %# Convert to a (dim+1)-dimensional matrix
    meanArray = mean(M,dim+1);  %# Get the mean across arrays
    plot(Bds,(meanArray),'r','linewidth',3)
    
    
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color','k','linewidth',3)
    title('Delta wave rel to Ripple')
        xlim([-30 30])   

    
    cd('/media/DataMOBs14/LPSAnalysis')
    a=cd;
    saveas(f,strcat('Oscillations',num2str(t),'_',num2str(num),'_',struct,'.fig'))
    try
        saveFigure(f,strcat('Oscillations',num2str(t),'_',num2str(num),'_',struct),a)
    end
    saveas(f,strcat('Oscillations',num2str(t),'_',num2str(num),'_',struct,'.png'))
    
    
    
    
    
    
end
end

close all
filename='/media/DataMOBs14/LPSAnalysis';
for t=1:2
    if t==1
        spin{1}='8:12Hz';
        spin{2}='10:15Hz';
        spin{3}='15:20Hz';
        spin{4}='10:20Hz';
        load('DataLPS1.mat')
        
    else
        spin{1}='5:10Hz';
        spin{2}='10:14Hz';
        spin{3}='6:8Hz';
        spin{4}='8:12Hz';
        load(strcat('DataLPS',num2str(t),'.mat'))
        
        
    end
    %% compare ripple power
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Parietal
    struct='PaCx'
    
    for s=1:4
        for num=1:6
            dim = ndims(DataLPS{num,21+s,m});          %# Get the number of dimensions for your arrays
            M = cat(dim+1,DataLPS{num,21+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
            meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
        end
        
        subplot(3,4,s)
        plot(TRS,(meanArrayR{1}),'k','linewidth',2)
        hold on
        plot(TRS,(meanArrayR{2}),'r','linewidth',2)
        ylim([-3 4])
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        
        title(spin{s})
        if s==1
            legend('Pre','VEH')
        end
        
        subplot(3,4,s+4)
        plot(TRS,(meanArrayR{3}),'k','linewidth',2)
        hold on
        plot(TRS,(meanArrayR{4}),'r','linewidth',2)
        ylim([-3 4])
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('Pre','LPS')
        end
        
        subplot(3,4,s+8)
        plot(TRS,(meanArrayR{5}),'k','linewidth',2)
        hold on
        plot(TRS,(meanArrayR{6}),'r','linewidth',2)
        ylim([-3 4])
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('24','48')
        end
        
    end
    saveas(f,strcat('RipplePower_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('RipplePower_',num2str(t),'_',struct,'.fig'))
    saveFigure(f,strcat('RipplePower_',num2str(t),'_',struct),filename)
    
    close all
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Prefrontal
    struct='PFCx'
    for s=1:4
        for num=1:6
            dim = ndims(DataLPS{num,34+s,m});          %# Get the number of dimensions for your arrays
            M = cat(dim+1,DataLPS{num,34+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
            meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
        end
        subplot(3,4,s)
        plot(TRS,(meanArrayR{1}),'k','linewidth',2)
        hold on
        plot(TRS,(meanArrayR{2}),'r','linewidth',2)
        ylim([-3 3])
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        
        title(spin{s})
        if s==1
            legend('Pre','VEH')
        end
        
        subplot(3,4,s+4)
        plot(TRS,(meanArrayR{3}),'k','linewidth',2)
        hold on
        plot(TRS,(meanArrayR{4}),'r','linewidth',2)
        ylim([-3 4])
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('Pre','LPS')
        end
        
        subplot(3,4,s+8)
        plot(TRS,(meanArrayR{5}),'k','linewidth',2)
        hold on
        plot(TRS,(meanArrayR{6}),'r','linewidth',2)
        ylim([-3 4])
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('24','48')
        end
        
    end
    saveas(f,strcat('RipplePower_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('RipplePower_',num2str(t),'_',struct,'.png'))
    saveFigure(f,strcat('RipplePower_',num2str(t),'_',struct),filename)
    
    
    %% compare delta/spindle correlation
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Parietal
    struct='PaCx'
    
    for s=1:4
        for num=1:6
            dim = ndims(DataLPS{num,13+s,m});          %# Get the number of dimensions for your arrays
            for m=[1,2,4]
                DataLPS{num,13+s,m}=DataLPS{num,13+s,m}/sum(DataLPS{num,13+s,m});
            end
            M = cat(dim+1,DataLPS{num,13+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
            meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
        end
        
        subplot(3,4,s)
        plot(Bds,(meanArrayR{1}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{2}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        title(spin{s})
        if s==1
            legend('Pre','VEH')
        end
        
        subplot(3,4,s+4)
        plot(Bds,(meanArrayR{3}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{4}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('Pre','LPS')
        end
        
        subplot(3,4,s+8)
        plot(Bds,(meanArrayR{5}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{6}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('24','48')
        end
    end
    saveas(f,strcat('SpindleDeltacorr_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('SpindleDeltacorr_',num2str(t),'_',struct,'.fig'))
    saveFigure(f,strcat('SpindleDeltacorr_',num2str(t),'_',struct),filename)
    
    close all
    
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Prefrontal
    struct='PFCx'
    for s=1:4
        for num=1:6
            dim = ndims(DataLPS{num,26+s,m});          %# Get the number of dimensions for your arrays
            for m=[1,4]
                DataLPS{num,26+s,m}=DataLPS{num,26+s,m}/sum(DataLPS{num,26+s,m});
            end
            M = cat(dim+1,DataLPS{num,26+s,[1,4]});        %# Convert to a (dim+1)-dimensional matrix
            meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
        end
        
        subplot(3,4,s)
        plot(Bds,(meanArrayR{1}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{2}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        
        title(spin{s})
        if s==1
            legend('Pre','VEH')
        end
        
        subplot(3,4,s+4)
        plot(Bds,(meanArrayR{3}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{4}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('Pre','LPS')
        end
        
        
        subplot(3,4,s+8)
        plot(Bds,(meanArrayR{5}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{6}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('24','48')
        end
        
    end
    saveas(f,strcat('SpindleDeltacorr_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('SpindleDeltacorr_',num2str(t),'_',struct,'.png'))
    saveFigure(f,strcat('SpindleDeltacorr_',num2str(t),'_',struct),filename)
    
    close all
    
    %% compare spindle/ripple correlation
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Parietal
    struct='PaCx'
    
    for s=1:4
        for num=1:6
            dim = ndims(DataLPS{num,17+s,m});          %# Get the number of dimensions for your arrays
            for m=[1,2,4]
                DataLPS{num,17+s,m}=DataLPS{num,17+s,m}/sum(DataLPS{num,17+s,m});
            end
            M = cat(dim+1,DataLPS{num,17+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
            meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
        end
        subplot(3,4,s)
        plot(Bds,(meanArrayR{1}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{2}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        title(spin{s})
        if s==1
            legend('Pre','VEH')
        end
        
        
        subplot(3,4,s+4)
        plot(Bds,(meanArrayR{3}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{4}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('Pre','LPS')
        end
        
        subplot(3,4,s+8)
        plot(Bds,(meanArrayR{5}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{6}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('24','48')
        end
        
    end
    
    saveas(f,strcat('SpindleRipplecorr_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('SpindleRipplecorr_',num2str(t),'_',struct,'.fig'))
    saveFigure(f,strcat('SpindleRipplecorr_',num2str(t),'_',struct),filename)
    
    close all
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Prefrontal
    struct='PFCx'
    for s=1:4
        for num=1:6
            dim = ndims(DataLPS{num,30+s,m});          %# Get the number of dimensions for your arrays
            for m=[1,2,4]
                DataLPS{num,30+s,m}=DataLPS{num,30+s,m}/sum(DataLPS{num,30+s,m});
            end
            M = cat(dim+1,DataLPS{num,30+s,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
            meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
        end
        
        subplot(3,4,s)
        plot(Bds,(meanArrayR{1}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{2}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        
        title(spin{s})
        if s==1
            legend('Pre','VEH')
        end
        
        subplot(3,4,s+4)
        plot(Bds,(meanArrayR{3}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{4}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('Pre','LPS')
        end
        
        subplot(3,4,s+8)
        plot(Bds,(meanArrayR{5}),'k','linewidth',2)
        hold on
        plot(Bds,(meanArrayR{6}),'r','linewidth',2)
        a=ylim;
        hold on
        line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
        if s==1
            legend('24','48')
        end
        
    end
    saveas(f,strcat('SpindleRipplecorr_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('SpindleRipplecorr_',num2str(t),'_',struct,'.png'))
    saveFigure(f,strcat('SpindleRipplecorr_',num2str(t),'_',struct),filename)
    
    close all
    
    %% compare delta/ripple correlation
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Parietal
    struct='PaCx'
    
    for num=1:6
        dim = ndims(DataLPS{num,26,m});          %# Get the number of dimensions for your arrays
        for m=[1,2,4]
            DataLPS{num,26,m}=DataLPS{num,26,m}/sum(DataLPS{num,26,m});
        end
        M = cat(dim+1,DataLPS{num,26,[1,2,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
    end
    subplot(3,1,1)
    plot(Bds,(meanArrayR{1}),'k','linewidth',2)
    hold on
    plot(Bds,(meanArrayR{2}),'r','linewidth',2)
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
    
    title(spin{s})
    legend('Pre','VEH')
    
    
    subplot(3,1,2)
    plot(Bds,(meanArrayR{3}),'k','linewidth',2)
    hold on
    plot(Bds,(meanArrayR{4}),'r','linewidth',2)
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
    legend('Pre','LPS')
    
    
    subplot(3,1,3)
    plot(Bds,(meanArrayR{5}),'k','linewidth',2)
    hold on
    plot(Bds,(meanArrayR{6}),'r','linewidth',2)
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
    legend('24','48')
    
    
    saveas(f,strcat('DeltaRipplecorr_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('DeltaRipplecorr_',num2str(t),'_',struct,'.fig'))
    saveFigure(f,strcat('DeltaRipplecorr_',num2str(t),'_',struct),filename)
    
    f=figure('color',[1 1 1],'Position',[2 scrsz(4) scrsz(3)/2 scrsz(4)]);
    %Parietal
    struct='PFCx'
    
    for num=1:6
        dim = ndims(DataLPS{num,39,m});          %# Get the number of dimensions for your arrays
        for m=[1,4]
            DataLPS{num,39,m}=DataLPS{num,39,m}/sum(DataLPS{num,39,m});
        end
        M = cat(dim+1,DataLPS{num,39,[1,4]});        %# Convert to a (dim+1)-dimensional matrix
        meanArrayR{num} = mean(M,dim+1);  %# Get the mean across arrays
    end
    subplot(3,1,1)
    plot(Bds,(meanArrayR{1}),'k','linewidth',2)
    hold on
    plot(Bds,(meanArrayR{2}),'r','linewidth',2)
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
    
    title(spin{s})
    legend('Pre','VEH')
    
    
    subplot(3,1,2)
    plot(Bds,(meanArrayR{3}),'k','linewidth',2)
    hold on
    plot(Bds,(meanArrayR{4}),'r','linewidth',2)
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
    legend('Pre','LPS')
    
    subplot(3,1,3)
    plot(Bds,(meanArrayR{5}),'k','linewidth',2)
    hold on
    plot(Bds,(meanArrayR{6}),'r','linewidth',2)
    a=ylim;
    hold on
    line([0 0],[a(1) a(2)],'LineStyle','--','color',[0.7 0.7 0.7],'linewidth',2)
    legend('24','48')
    
    saveas(f,strcat('DeltaRipplecorr_',num2str(t),'_',struct,'.png'))
    saveas(f,strcat('DeltaRipplecorr_',num2str(t),'_',struct,'.fig'))
    saveFigure(f,strcat('DeltaRipplecorr_',num2str(t),'_',struct),filename)
    
end
close all