
%% Comodulation in three states : REM, SWS, Locomotion
clear all


Files=PathForExperimentsEmbReact('BaselineSleep');
% Params
LowFreqRg=[1 15];
HighFreqRg=[20 250];
LowFreqBW=[1 1];
LowFreqStep=1;
HighFreqStep=4;
BinNumbers=18;
NumSurrogates=0;
Struc={'HPC','OB','PFCx'};
DidntWork={};d=1;
LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
bandThet=[6 11];
bandLow=[2 4];
bandMid=[5 6];
bandVhi=[11 13];
SaveTempName='/home/vador/Documents/ComodoluTemp'/;
warning off
for pp=2
    
    pp
    for c=1:length(Files.path{pp})
        try
            cd(Files.path{pp}{c})
            Files.path{pp}{c}
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
            
            load(['LFPData/LFP',num2str(eval(['Channel.',Struc{2}])),'.mat']);
            load('StateEpochSB.mat','REMEpoch')
            load('B_Low_Spectrum.mat')
            SpL.OB=Spectro{1};
            fspL=Spectro{3};
            tspL=Spectro{2};
            Hi=mean(SpL.OB(:,find(fspL<bandThet(1),1,'last'):find(fspL<bandThet(2),1,'last'))');
            Mid=mean(SpL.OB(:,find(fspL<bandMid(1),1,'last'):find(fspL<bandMid(2),1,'last'))');
            Lo=mean(SpL.OB(:,find(fspL<bandLow(1),1,'last'):find(fspL<bandLow(2),1,'last'))');
            VHi=mean(SpL.OB(:,find(fspL<bandVhi(1),1,'last'):find(fspL<bandVhi(2),1,'last'))');
            
            EpLow=thresholdIntervals(tsd(tspL*1e4,Lo'-Mid'*3),0);
            EpLow=dropShortIntervals(EpLow,3*1e4);
            EpLow=mergeCloseIntervals(EpLow,3*1e4);
            EpAll=intervalSet(min(Range(LFP)),max(Range(LFP)));
            EpNotLow=EpAll-EpLow;
            EpNotLow=dropShortIntervals(and(EpNotLow,REMEpoch),3*1e4);
            EpLow=dropShortIntervals(and(EpLow,REMEpoch),3*1e4);
            EpToUse={EpLow,EpNotLow};
            
            for z=1:2
                
                LitEp=EpToUse{z};
                
                disp('filtering')
                for ss=1:length(Struc)
                    ss
                    load(['LFPData/LFP',num2str(eval(['Channel.',Struc{ss}])),'.mat']);
                    temp=FilterRangeOfBdWidths(Restrict(LFP,LitEp),LowFreqRg,LowFreqStep,LowFreqBW,1);
                    eval(['MultiFilLFP.',Struc{ss},'.Low=temp;']);
                    
                    for ff=1:length(LowFreqVals)
                        temp=FilterRangeOfBdWidths(Restrict(LFP,LitEp),HighFreqRg,HighFreqStep,[LowFreqVals(ff) LowFreqVals(ff)],1);
                        eval(['MultiFilLFP.',Struc{ss},'.High.FilLFP{',num2str(ff),'}=temp.FilLFP;']);
                        eval(['MultiFilLFP.',Struc{ss},'.High.FreqRange{',num2str(ff),'}=temp.FreqRange;']);
                    end
                    
                    
                end
                
                disp('comoduling')
                
                for ss=1:3
                    ss
                    for sss=1:3
                        [LowFreqVals,HighFreqVals,Dkl{z,zz}{ss,sss},DklSurr{z,zz}{ss,sss},Prc99{z,zz}{ss,sss}]=ComoduloPreFiltered(eval(['MultiFilLFP.',Struc{ss},'.Low.FilLFP']), eval(['MultiFilLFP.',Struc{sss},'.High.FilLFP']),...
                            LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,0,NumSurrogates);
                    end
                end
                clear MultiFilLFP
            end
            keyboard
            save('CoModulo3StrucWhitREMLowNoLow.mat','Dkl','DurEp','LowFreqVals','HighFreqVals','-v7.3')
            clear Dkl MultiFilLFP DurEp
        catch
            DidntWork{d}=Files.path{pp}{c};
            disp([Files.path{pp}{c},' fail'])
            d=d+1;
        end
    end
end
                    
temp=zeros(15,58);
for z=1:9
temp=temp+Dkl{2,z}{3,3};
end

%% Make figures
clear all


Files=PathForExperimentsEmbReact('Habituation');
% Params
LowFreqRg=[2 15];
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

AvData=cell(3,3);
for sss=1:3
    for ss=1:3
        AvData{ss,sss}=zeros(14,56);
    end
end
for pp=2:length(Files.path)
    
    pp
    for c=1
        try
            cd(Files.path{pp}{c})
            load('CoModulo3StrucWhit.mat','Dkl')
            
            fig=figure;
            for ss=1:3
                ss
                for sss=1:3
                    subplot(3,3,(ss-1)*3+sss)
                    Dkl{ss,sss}=naninterp(Dkl{ss,sss})
                    
                    imagesc(LowFreqVals,HighFreqVals,SmoothDec(Dkl{ss,sss},[2,2])'), axis xy,
                    AvData{ss,sss}=AvData{ss,sss}+SmoothDec(Dkl{ss,sss},[2,2]);
                    title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
                end
            end
            
            cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/Gamma/HabituationComodulo
            saveas(fig,['ComoduloHabituationSmoo',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            saveas(fig,['ComoduloHabituationSmoo',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
            
            close all
            
            fig=figure;
            for ss=1:3
                ss
                for sss=1:3
                    subplot(3,3,(ss-1)*3+sss)
                    Dkl{ss,sss}=naninterp(Dkl{ss,sss})
                    
                    imagesc(LowFreqVals,HighFreqVals,Dkl{ss,sss}'), axis xy,
                    title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
                end
            end
            
            cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/Gamma/HabituationComodulo
            saveas(fig,['ComoduloHabituation',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            saveas(fig,['ComoduloHabituation',num2sstr(Files.ExpeInfo{pp}.nmouse),'.fig']);
            
            close all
        end
    end
end


fig=figure;
for ss=1:3
    ss
    for sss=1:3
        subplot(3,3,(ss-1)*3+sss)
        imagesc(LowFreqVals,HighFreqVals,AvData{ss,sss}'), axis xy,
        title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
    end
end
cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/Gamma/HabituationComodulo
saveas(fig,['ComoduloHabituationGranAvn=6.png']);
saveas(fig,['ComoduloHabituationGranAvn=6.fig']);
