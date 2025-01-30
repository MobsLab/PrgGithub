%% Cacluate desired Spectra
struc={'B','H','Pi','PF','Pa','PFSup','PaSup','Amyg'};
clear todo chan dataexis
m=1;
filename2{m}='/media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX/Mouse060/20130415/BULB-Mouse-60-15042013/';
todo(m,:)=[1,1,0,1,1,1,1,0];
dataexis(m,:)=[1,1,0,1,1,1,1,0];
chan(m,:)=[1,10,NaN,4,13,6,2,NaN];

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
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse123/LPS_D1/LPSD1-Mouse-123-31032014/';
todo(m,:)=[1,1,1,1,1,1,1,1];
dataexis(m,:)=[1,1,1,1,1,1,1,1];
chan(m,:)=[15,6,0,4,9,12,NaN,3];

m=5;
filename2{m}='/media/DataMobs15/OB_behaviour/ProjetLPS/Mouse124/LPSD1/LPSD1-Mouse-124-31032014/';
todo(m,:)=[1,1,1,1,0,1,1,1];
dataexis(m,:)=[1,1,1,1,1,0,0,1];
chan(m,:)=[11,2,12,8,4,15,NaN,15];


for file=4:5
    file
    cd(filename2{file})
    for s=[5,length(struc)]
        s
        if todo(file,s)==1
            try
                HighSpectrum(filename2{file},chan(file,s),struc{s})
            catch
                disp('fail')
            end
        end
    end
end


%% now look at the spectra in different phases

for file=1:5
    file
    cd(filename2{file})
    load('StateEpochSB.mat','NoiseEpoch','GndNoiseEpoch')
    try
        load('LFPData/LFP0.mat')
    catch
        try
            load('LFPData/LFP1.mat')
        catch
            load('LFPData/LFP2.mat')
        end
    end
    rg=Range(LFP);
    if file==[2,5,6]
        TotalEpoch=intervalSet(0,rg(end)/3)-NoiseEpoch-GndNoiseEpoch;
    else
        TotalEpoch=intervalSet(0,rg(end))-NoiseEpoch-GndNoiseEpoch;
    end
    load('StateEpoch.mat')
    try
        load('behavResources.mat','PreEpoch');
        TotalEpoch=And(TotalEpoch,PreEpoch);
    end
    
    for s=[1,2,3,4,5,8]
        disp(struc(s))
        if todo(file,s)==1
                load(cell2mat(strcat(struc(s),'_High_Spectrum.mat')))
                sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                a=sum(log(Data(Restrict(sptsd,TotalEpoch)))');
                atsd=tsd(Range(Restrict(sptsd,TotalEpoch)),a');
                thr=mean(a)+1.8*std(a);
                NnoiseEp=thresholdIntervals(atsd,thr,'Direction','Below');
                specS{file,s}=mean(Data(Restrict(sptsd,And(And(SWSEpoch,TotalEpoch),NnoiseEp))));
                specR{file,s}=mean(Data(Restrict(sptsd,And(And(REMEpoch,TotalEpoch),NnoiseEp))));
                specW{file,s}=mean(Data(Restrict(sptsd,And(And(MovEpoch,TotalEpoch),NnoiseEp))));
                f1=Spectro{3};
            
        end
    end
end


%%Have a look at them
close all
figure(1)
figure(2)
specStot=[];
specRtot=[];
specWtot=[];
specS2tot=[];
specR2tot=[];
specW2tot=[];
f1=[20:81/32:100];
for i=[1,2,3,4,5,8]
    i
    specStotint=[];
    specRtotint=[];
    specWtotint=[];
    specStot2int=[];
    specRtot2int=[];
    specWtot2int=[];
    for file=1:5
        if todo(file,i)==1
            totpower=sum([specS{file,i},specW{file,i},specR{file,i}]);
            figure(1)
            subplot(3,6,min(i,6))
            plot(f1,specS{file,i}/totpower,'color',[0.4 0.5 1])
            hold on
            plot(f1,specR{file,i}/totpower,'color',[1 0.2 0.2])
            plot(f1,specW{file,i}/totpower,'color',[0.6 0.6 0.6])
            subplot(3,6,min(i,6)+6)
            plot(f1,10*log10(specS{file,i}/totpower),'color',[0 0.8 1])
            hold on
            plot(f1,10*log10(specR{file,i}/totpower),'color',[0.8 0.2 0.1])
            plot(f1,10*log10(specW{file,i}/totpower),'color',[0.2 0.2 0.2])
            subplot(3,6,min(i,6)+12)
            plot(f1,f1.*(specS{file,i}/totpower),'color',[0 0.8 1])
            hold on
            plot(f1,f1.*(specR{file,i}/totpower),'color',[0.8 0.2 0.1])
            plot(f1,f1.*(specW{file,i}/totpower),'color',[0.2 0.2 0.2])
            specStotint=[specStotint;smooth(specS{file,i}/totpower,5)'];
            specRtotint=[specRtotint;smooth(specR{file,i}/totpower,5)'];
            specWtotint=[specWtotint;smooth(specW{file,i}/totpower,5)'];
            
            
        end
        
    end
    specStot{min(i,6)}=specStotint;
    specRtot{min(i,6)}=specRtotint;
    specWtot{min(i,6)}=specWtotint;
    specS2tot{min(i,6)}=specStot2int;
    specR2tot{min(i,6)}=specRtot2int;
    specW2tot{min(i,6)}=specWtot2int;
    
end

nummice=[5,5,2,5,5,2];
titre={'OB','Hpc','PiCx','PF','Pa','Amyg'};
figure
for i=1:6
    subplot(1,6,i)
    y1=mean(specStot{i})-std(specStot{i})/sqrt(nummice(i));                  %#create first curve
    y2=mean(specStot{i})+std(specStot{i})/sqrt(nummice(i));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f1,mean(specStot{i}),'linewidth',3)
    
    y1=mean(specRtot{i})-std(specRtot{i})/sqrt(nummice(i));                  %#create first curve
    y2=mean(specRtot{i})+std(specRtot{i})/sqrt(nummice(i));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f1,mean(specRtot{i}),'color',[0.5 0 0],'linewidth',3)
    
    y1=mean(specWtot{i})-std(specWtot{i})/sqrt(nummice(i))                  %#create first curve
    y2=mean(specWtot{i})+std(specWtot{i})/sqrt(nummice(i))                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
    hold on
    plot(f1,mean(specWtot{i}),'k','linewidth',3)
    title(titre{i})
    
end

figure
for i=1:6
    subplot(1,6,i)
    y1=10*log10(mean(specStot{i})-std(specStot{i})/sqrt(nummice(i)));                  %#create first curve
    y2=10*log10(mean(specStot{i})+std(specStot{i})/sqrt(nummice(i)));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f1,10*log10(mean(specStot{i})),'linewidth',3);
    
    y1=10*log10(mean(specRtot{i})-std(specRtot{i})/sqrt(nummice(i)));                  %#create first curve
    y2=10*log10(mean(specRtot{i})+std(specRtot{i})/sqrt(nummice(i)));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f1,10*log10(mean(specRtot{i})),'color',[0.5 0 0],'linewidth',3)
    
    y1=10*log10(mean(specWtot{i})-std(specWtot{i})/sqrt(nummice(i)));                  %#create first curve
    y2=10*log10(mean(specWtot{i})+std(specWtot{i})/sqrt(nummice(i)));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
    hold on
    plot(f1,10*log10(mean(specWtot{i})),'k','linewidth',3)
    title(titre{i})
    
end

figure
n=1;
for i=[1,3,6,4,2,5]
    subplot(1,6,n)
    y1=f1.*(mean(specStot{i})-std(specStot{i})/sqrt(nummice(i)));                 %#create first curve
    y2=f1.*(mean(specStot{i})+std(specStot{i})/sqrt(nummice(i)));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[0.4 0.5 1],'EdgeColor',[0.4 0.5 1])
    hold on
    plot(f1,f1.*mean(specStot{i}),'linewidth',3)
    
    y1=f1.*(mean(specRtot{i})-std(specRtot{i})/sqrt(nummice(i)));                  %#create first curve
    y2=f1.*(mean(specRtot{i})+std(specRtot{i})/sqrt(nummice(i)));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[1 0.2 0.2],'EdgeColor',[1 0.2 0.2])
    hold on
    plot(f1,f1.*mean(specRtot{i}),'color',[0.5 0 0],'linewidth',3)
    
    y1=f1.*(mean(specWtot{i})-std(specWtot{i})/sqrt(nummice(i)));                  %#create first curve
    y2=f1.*(mean(specWtot{i})+std(specWtot{i})/sqrt(nummice(i)));                  %#create second curve
    X=[f1,fliplr(f1)];                %#create continuous x value array for plotting
    Y=[y1,fliplr(y2)];              %#create y values for out and then back
    f=fill(X,Y,'b');
    set(f,'FaceColor',[0.6 0.6 0.6],'EdgeColor',[0.6 0.6 0.6])
    hold on
    plot(f1,f1.*mean(specWtot{i}),'k','linewidth',3)
    box off
    title(titre{i})
    n=n+1;
end


