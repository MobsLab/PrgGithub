%% Comodulation in three states : REM, SWS, Locomotion
clear all


Files=PathForExperimentsEmbReact('Habituation');
% Params
LowFreqRg=[1 15];
HighFreqRg=[20 250];
LowFreqBW=[1 1];
LowFreqStep=1;
HighFreqStep=4;
BinNumbers=18;
NumSurrogates=100;
Struc={'HPC','OB','PFCx'};
DidntWork={};d=1;
LowFreqVals=[LowFreqRg(1):LowFreqStep:LowFreqRg(2)];
for pp=4:5
    
    pp
    for c=1
        try
            cd(Files.path{pp}{c})
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
            
            disp('filtering')
            for ss=1:length(Struc)
                ss
                load(['LFPData/LFP',num2str(eval(['Channel.',Struc{ss}])),'.mat']);
                temp=FilterRangeOfBdWidths(LFP,LowFreqRg,LowFreqStep,LowFreqBW,1);
                eval(['MultiFilLFP.',Struc{ss},'.Low=temp;']);
                
                for ff=1:length(LowFreqVals)
                    temp=FilterRangeOfBdWidths(LFP,HighFreqRg,HighFreqStep,[LowFreqVals(ff) LowFreqVals(ff)],1);
                    eval(['MultiFilLFP.',Struc{ss},'.High.FilLFP{',num2str(ff),'}=temp.FilLFP;']);
                    eval(['MultiFilLFP.',Struc{ss},'.High.FreqRange{',num2str(ff),'}=temp.FreqRange;']);
                end
            end
            
            Epoch=intervalSet(0,max(Range(LFP)));
            disp('comoduling')

            for ss=1:3
                ss
                for sss=1:3
                    [LowFreqVals,HighFreqVals,Dkl{ss,sss},DklSurr{ss,sss},Prc99{ss,sss}]=ComoduloPreFiltered(eval(['MultiFilLFP.',Struc{ss},'.Low.FilLFP']), eval(['MultiFilLFP.',Struc{sss},'.High.FilLFP']),...
                        LowFreqRg,HighFreqRg,LowFreqStep,HighFreqStep,BinNumbers,0,NumSurrogates);
                end
            end
            
            save('CoModulo3StrucWhitRandom.mat','Dkl','DklSurr','Prc99','LowFreqVals','HighFreqVals','-v7.3')
            clear Dkl MultiFilLFP
        catch
            DidntWork{d}=Files.path{pp}{c};
            disp([Files.path{pp}{c},' fail'])
            d=d+1;
        end
    end
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          

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

% Peaks
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
            
            fig=figure('Position',[100,100,1000,1000]);
            for ss=1:3
                ss
                for sss=1:3
                    subplot(3,3,(ss-1)*3+sss)
                    Dkl{ss,sss}=naninterp(Dkl{ss,sss})
                    
                    imagesc(LowFreqVals,HighFreqVals,SmoothDec(Dkl{ss,sss},[2,2])'), axis xy,hold on
                    thres = (max([min(max(Dkl{ss,sss}',[],1))  min(max(Dkl{ss,sss}',[],2))])) ;
                    sm=SmoothDec(Dkl{ss,sss},[2,2])';
                    temp=(imregionalmax(sm).*sm>2*std(sm(:)));
                    [row,col]=find(temp);
                    plot(LowFreqVals(col),HighFreqVals(row),'r+')
                    RemDat2{pp}{ss,sss}=[row,col];
                    
                    
                    %                     cent=FastPeakFind(Dkl{ss,sss}');
                    %                     plot(LowFreqVals(cent(1:2:end)),HighFreqVals(cent(2:2:end)),'r+')
                    %                     RemDat2{pp}{ss,sss}=cent;
                    AvData{ss,sss}=AvData{ss,sss}+SmoothDec(Dkl{ss,sss},[2,2]);
                    title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
                end
            end
            cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/Habituation/Comodulo/
            saveas(fig,['ComoduloHabituationSmooPeaks',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
            saveas(fig,['ComoduloHabituationSmooPeaks',num2str(Files.ExpeInfo{pp}.nmouse),'.fig']);
%            
%             close all
%             
%             fig=figure;
%             for ss=1:3
%                 ss
%                 for sss=1:3
%                     subplot(3,3,(ss-1)*3+sss)
%                     Dkl{ss,sss}=naninterp(Dkl{ss,sss})
%                     
%                     imagesc(LowFreqVals,HighFreqVals,Dkl{ss,sss}'), axis xy,
%                     title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
%                 end
%             end
%             
%             cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/Gamma/HabituationComodulo
%             saveas(fig,['ComoduloHabituationPeaks',num2str(Files.ExpeInfo{pp}.nmouse),'.png']);
%             saveas(fig,['ComoduloHabituationPeaks',num2sstr(Files.ExpeInfo{pp}.nmouse),'.fig']);
%            
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
      hold on
      for pp=2:length(Files.path)
          plot(LowFreqVals(RemDat2{pp}{ss,sss}(:,2)),HighFreqVals(RemDat2{pp}{ss,sss}(:,1)),'*')
          
      end

        title(['Sl:',Struc{ss},'  Fst:',Struc{sss}])
    end
end
            cd /media/DataMOBsRAID/ProjectEmbReact/Figures/Nov2016/CouplageRythmes/Habituation/Comodulo/
saveas(fig,['ComoduloHabituationGranAvWiPeaksn=6.png']);
saveas(fig,['ComoduloHabituationGranAvnWiPeaks=6.fig']);

