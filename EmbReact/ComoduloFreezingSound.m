%% Comodulation in three states : REM, SWS, Locomotion
clear all


Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
Dir=RestrictPathForExperiment(Dir,'nMice',[ 244 241 248 253 254 258 259 299]);
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
for pp=1:length(Dir.path)
    
    pp
    try
        cd(Dir.path{pp})
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
        load('behavResources.mat')
                

        disp('filtering')
        for ss=1:length(Struc)
            ss
            load(['LFPData/LFP',num2str(eval(['Channel.',Struc{ss}])),'.mat']);
            LFP=Restrict(LFP,FreezeEpoch);
            temp=FilterRangeOfBdWidths(LFP,LowFreqRg,LowFreqStep,LowFreqBW,1);
            eval(['MultiFilLFP.',Struc{ss},'.Low=temp;']);
            
            for ff=1:length(LowFreqVals)
                temp=FilterRangeOfBdWidths(LFP,HighFreqRg,HighFreqStep,[LowFreqVals(ff) LowFreqVals(ff)],1);
                eval(['MultiFilLFP.',Struc{ss},'.High.FilLFP{',num2str(ff),'}=temp.FilLFP;']);
                eval(['MultiFilLFP.',Struc{ss},'.High.FreqRange{',num2str(ff),'}=temp.FreqRange;']);
            end
        end
        disp('comoduling')
        
        for ss=1:3
            ss
            for sss=1:3
                [LowFreqVals,HighFreqVals,Dkl{ss,sss},DklSurr{ss,sss},Prc99{ss,sss}]=ComoduloPreFiltered(eval(['MultiFilLFP.',Struc{ss},'.Low.FilLFP']), eval(['MultiFilLFP.',Struc{sss},'.High.FilLFP']),...
                    LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,0,NumSurrogates);
            end
        end
        
        save('CoModulo3Struc.mat','Dkl','DklSurr','Prc99','LowFreqVals','HighFreqVals','-v7.3')
        clear Dkl MultiFilLFP
    catch
        DidntWork{d}=Files.path{pp}{c};
        disp([Files.path{pp}{c},' fail'])
        d=d+1;
    end
end

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

%% Make figures
clear all


Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
Dir=RestrictPathForExperiment(Dir,'nMice',[ 244 241 248 253 254 258 259 299]);
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
AvData=cell(3,3);
for sss=1:3
    for ss=1:3
        AvData{ss,sss}=zeros(15,58);
    end
end
for pp=1:length(Dir.path)
    
    pp
    try
        cd(Dir.path{pp})
        load('CoModulo3Struc.mat','Dkl','HighFreqVals','LowFreqVals')
        
        fig=figure('Position',[100,100,1000,1000]);
        for ss=1:3
            ss
            for sss=1:3
                subplot(3,3,(ss-1)*3+sss)
                Dkl{ss,sss}=naninterp(Dkl{ss,sss})
                sm=SmoothDec(Dkl{ss,sss},[2,2])';
                temp=(imregionalmax(sm).*sm>2*std(sm(:)));
                [row,col]=find(temp);
                RemDat2{pp}{ss,sss}=[row,col];
                imagesc(LowFreqVals,HighFreqVals,SmoothDec(Dkl{ss,sss},[2,2])'), axis xy,hold on
                plot(LowFreqVals(col),HighFreqVals(row),'r+')
                AvData{ss,sss}=AvData{ss,sss}+SmoothDec(Dkl{ss,sss},[2,2]);
                title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
            end
        end
        
        cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/FreezingSounds/Comodulo/
        saveas(fig,['ComoduloSmoo',num2str(pp),'.png']);
        saveas(fig,['ComoduloSmoo',num2str(pp),'.fig']);
        
        
        close all
    end
end


fig=figure('Position',[100,100,1000,1000]);
for ss=1:3
    ss
    for sss=1:3
        subplot(3,3,(ss-1)*3+sss)
        imagesc(LowFreqVals,HighFreqVals,AvData{ss,sss}'), axis xy,hold on
         for pp=1:length(Dir.path)
                plot(LowFreqVals(RemDat2{pp}{ss,sss}(:,2)),HighFreqVals(RemDat2{pp}{ss,sss}(:,1)),'*')
                
            end
        title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
    end
end
        cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/FreezingSounds/Comodulo/
saveas(fig,['ComoduloHabituationGranAvn=8.png']);
saveas(fig,['ComoduloHabituationGranAvn=8.fig']);



%% 
clear all
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');
Dir=RestrictPathForExperiment(Dir,'nMice',[ 244 241 248 253 254 258 259 299]);
% Params

params.Fs=1250;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 40];
movingwin=[3 0.2];
params.tapers=[3 5];
figure
for pp=1:length(Dir.path)
    
    pp
    try
        cd(Dir.path{pp})
        load('ChannelsToAnalyse/PFCx_deep.mat')
        
        load(strcat('LFPData/LFP',num2str(channel),'.mat'));
        [y, ARmodel] = WhitenSignal(Data(LFP),[],1,[],2);
        LFP=tsd(Range(LFP),y);
        [Sp,t,f]=mtspecgramc(Data(LFP),movingwin,params);
        Sptsd=tsd(t*1e4,Sp);
        load('behavResources.mat')
        plot(f,mean(Data(Restrict(Sptsd,FreezeEpoch)))), hold on
        SpKeep(pp,:)=mean(Data(Restrict(Sptsd,FreezeEpoch)));
        
    end
end
plot(f,mean(SpKeep),'linewidth',2,'color','k')
