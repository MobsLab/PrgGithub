%% Comodulation in three states : REM, SWS, Locomotion
% This code was changed on 28 nov 2016 and is now called ComoduloFzBis
clear all


Files=PathForExperimentsEmbReact('UMazeCond');
% Params
LowFreqRg=[0.5 10];
HighFreqRg=[15 250];
LowFreqBW=[0.5 0.5];
LowFreqStep=0.5;
HighFreqStep=4;
BinNumbers=18;
NumSurrogates=0;
Struc={'HPC','OB','PFCx'};
DidntWork={};d=1;
LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
LimFreq=20;



for pp=5:length(Files.path)
    
    pp
    for c=1:length(Files.path{pp})
        try
            cd(Files.path{pp}{c})
            
            load('behavResources.mat')
            load('StateEpochSB.mat','TotalNoiseEpoch')
            RemovEpoch=or(or(StimEpoch,SleepyEpoch),TotalNoiseEpoch);
            FreezeEpoch=FreezeEpoch-RemovEpoch;
            FreezeEpoch=dropShortIntervals(FreezeEpoch,3*1e4);
            
            if not(isempty( Start(FreezeEpoch)))
                load('B_Low_Spectrum.mat')
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                for f=1:length(Start(FreezeEpoch))
                    Sp=mean(Data(Restrict(Sptsd,subset(FreezeEpoch,f))),1);
                    [val,ind]=max(Sp(LimFreq:end).*Spectro{3}(LimFreq:end));
                    PeakFr(f)=Spectro{3}(min(ind+LimFreq,length(Spectro{3})));
                end
                LitEp{1}=subset(FreezeEpoch,PeakFr<3.8);
                LitEp{2}=subset(FreezeEpoch,PeakFr>4.2);
                
                try
                    load('ChannelsToAnalyse/dHPC_deep.mat')
                    Channel.HPC=channel;
                catch
                    
                    load('ChannelsToAnalyse/dHPC_rip.mat')
                    Channel.HPC=channel;
                end
                load('ChannelsToAnalyse/Bulb_deep.mat')
                Channel.OB=channel;
                load('ChannelsToAnalyse/PFCx_deep.mat')
                Channel.PFCx=channel;
                
                for z=1:2
                    if not(isempty(Start(LitEp{z})))
                        LitEptemp=intervalSet(Start(LitEp{z})+1e4,Stop((LitEp{z}))+1e4);
                        LitEptemp=CleanUpEpoch(LitEptemp);
                        for ss=1:length(Struc)
                            load(['LFPData/LFP',num2str(eval(['Channel.',Struc{ss}])),'.mat']);
                            temp=FilterRangeOfBdWidths(Restrict(LFP,LitEptemp),LowFreqRg,LowFreqStep,LowFreqBW,1);
                            for k=1:size(temp.FilLFP,2)
                                temp.FilLFP{k}=Restrict(temp.FilLFP{k},LitEptemp);
                            end
                            eval(['MultiFilLFP.',Struc{ss},'.Low=temp;']);
                            
                            for ff=1:length(LowFreqVals)
                                temp=FilterRangeOfBdWidths(Restrict(LFP,LitEptemp),HighFreqRg,HighFreqStep,[LowFreqVals(ff) LowFreqVals(ff)],1);
                                for k=1:size(temp.FilLFP,2)
                                    temp.FilLFP{k}=Restrict(temp.FilLFP{k},LitEptemp);
                                end
                                
                                eval(['MultiFilLFP.',Struc{ss},'.High.FilLFP{',num2str(ff),'}=temp.FilLFP;']);
                                eval(['MultiFilLFP.',Struc{ss},'.High.FreqRange{',num2str(ff),'}=temp.FreqRange;']);
                            end
                        end
                        
                        
                        
                        for ss=1:3
                            ss
                            for sss=1:3
                                [LowFreqVals,HighFreqVals,Dkl{z}{ss,sss},DklSurr,Prc99]=ComoduloPreFiltered(eval(['MultiFilLFP.',Struc{ss},'.Low.FilLFP']), eval(['MultiFilLFP.',Struc{sss},'.High.FilLFP']),...
                                    LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,0,0);
                            end
                        end
                        
                    else
                        Dkl{z}={};
                    end
                end
                
                save('CoModulo3StrucWhitFreqSep.mat','LowFreqVals','HighFreqVals','Dkl')
                clear Dkl MultiFilLFP PeakFr
            end
        catch
            keyboard
            DidntWork{d}=Files.path{pp}{c};
            disp([Files.path{pp}{c},' fail'])
            d=d+1;
        end
    end
end

%% Make figures
clear all

Files=PathForExperimentsEmbReact('UMazeCond');
% Params
LowFreqRg=[1 15];
HighFreqRg=[30 250];
LowFreqBW=[1 1];
LowFreqStep=1;
HighFreqStep=4;
BinNumbers=18;
NumSurrogates=200;
Struc={'HPC','OB','PFCx'};
DidntWork={};d=1;
LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
HighFreqVals=[HighFreqRg(1):HighFreqStep:HighFreqRg(2)];


for pp=2:length(Files.path)
    
    for sss=1:3
        for ss=1:3
            AvData{1,1}{ss,sss}=zeros(20,59);        AvData{2,1}{ss,sss}=zeros(20,59);
        end
    end
    
    pp
    for c=1:length(Files.path{pp})
        for z=1:2
            cd(Files.path{pp}{c})
            try
                load('CoModulo3StrucWhitFreqSep.mat')
                if not(isempty(Dkl{z}))
                    for ss=1:3
                        ss
                        for sss=1:3
                            Dkl{z}{ss,sss}=naninterp(Dkl{z}{ss,sss})
                            AvData{z,1}{ss,sss}=AvData{z,1}{ss,sss}+SmoothDec(Dkl{z}{ss,sss},[2,2]);
                        end
                    end
                end
            end
        end
    end
    RemDat{pp}=AvData;
    
    for z=1:2
        fig=figure('name',strcat(['pp=',num2str(pp),'z=',num2str(z)]));
        for ss=1:3
            ss
            for sss=1:3
                
                subplot(3,3,(ss-1)*3+sss)
                imagesc(LowFreqVals,HighFreqVals,SmoothDec(AvData{z,1}{ss,sss},[2,2])'), axis xy,
                title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
            end
        end
        
        cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/Fz/Comodulo/
        %         saveas(fig,['ComoduloHabituationSmoo',num2str(Files.ExpeInfo{pp}{1}.nmouse),'Z',num2str(z),'.png']);
        %         saveas(fig,['ComoduloHabituationSmoo',num2str(Files.ExpeInfo{pp}{1}.nmouse),'Z',num2str(z),'.fig']);
        %         close all
    end
    clear AvData
    
end

for z=1:2
figure
for ss=1:3
    ss
    for sss=1:3
        temp=zeros(15,56);
        for pp=2:length(Files.path)
            temp=temp+RemDat{pp}{z}{ss,sss};
        end
        subplot(3,3,(ss-1)*3+sss)
        imagesc(LowFreqVals,HighFreqVals,temp'), axis xy,
        title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
    end
end
end


%% Peaks
clear all

Files=PathForExperimentsEmbReact('UMazeCond');
% Params
LowFreqRg=[1 15];
HighFreqRg=[30 250];
LowFreqBW=[1 1];
LowFreqStep=1;
HighFreqStep=4;
BinNumbers=18;
NumSurrogates=200;
Struc={'HPC','OB','PFCx'};
DidntWork={};d=1;
LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
HighFreqVals=[HighFreqRg(1):HighFreqStep:HighFreqRg(2)];


for pp=2:length(Files.path)
    
    for sss=1:3
        for ss=1:3
            AvData{1,1}{ss,sss}=zeros(20,59);        AvData{2,1}{ss,sss}=zeros(20,59);
        end
    end
    
    pp
    for c=1:length(Files.path{pp})
        for z=1:2
            cd(Files.path{pp}{c})
            try
                load('CoModulo3StrucWhitFreqSep.mat')
                if not(isempty(Dkl{z}))
                    for ss=1:3
                        ss
                        for sss=1:3
                            Dkl{z}{ss,sss}=naninterp(Dkl{z}{ss,sss})
                            AvData{z,1}{ss,sss}=AvData{z,1}{ss,sss}+SmoothDec(Dkl{z}{ss,sss},[2,2]);
                        end
                    end
                end
            end
        end
    end
    RemDat{pp}=AvData;
    
    for z=1:2
        fig=figure('name',strcat(['pp=',num2str(pp),'z=',num2str(z)]));
        for ss=1:3
            ss
            for sss=1:3
                
                subplot(3,3,(ss-1)*3+sss)
                imagesc(LowFreqVals,HighFreqVals,SmoothDec(AvData{z,1}{ss,sss},[2,2])'), axis xy,                hold on
                sm=SmoothDec(AvData{z,1}{ss,sss},[2,2])';
                temp=(imregionalmax(sm).*sm>2*std(sm(:)));
                [row,col]=find(temp);
                plot(LowFreqVals(col),HighFreqVals(row),'r+')
                RemDat2{pp}{z,1}{ss,sss}=[row,col];
                title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
            end
        end
        cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/Fz/Comodulo/
                saveas(fig,['ComoduloHabituationWiPeaks',num2str(Files.ExpeInfo{pp}{1}.nmouse),'Z',num2str(z),'.png']);
                saveas(fig,['ComoduloHabituationWiPeaks',num2str(Files.ExpeInfo{pp}{1}.nmouse),'Z',num2str(z),'.fig']);
                close all
    end
    clear AvData
    
end

for z=1:2
    figure
    for ss=1:3
        ss
        for sss=1:3
            temp=zeros(20,59);
            for pp=2:length(Files.path)
                temp=temp+RemDat{pp}{z}{ss,sss};
            end
            subplot(3,3,(ss-1)*3+sss)
            imagesc(LowFreqVals,HighFreqVals,temp'), axis xy,hold on
            for pp=2:length(Files.path)
                plot(LowFreqVals(RemDat2{pp}{z,1}{ss,sss}(:,2)),HighFreqVals(RemDat2{pp}{z,1}{ss,sss}(:,1)),'*')
                
            end
            title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
        end
    end
end