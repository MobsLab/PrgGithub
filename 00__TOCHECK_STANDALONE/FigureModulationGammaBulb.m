%FigureModulationGammaBulb

cd /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX

%DataSet=1; yl=5E3;  NameDir={'BASAL'}; % BASAL 
DataSet=2; yl=5E-4;  NameDir={'PLETHYSMO'}; % PLETHYSMO 
DataSet=3; % generate data.........

 %'PLETHYSMO' 'CANAB' 'DPCPX'
 NameDir={'PLETHYSMO'};%'PLETHYSMO' 'CANAB' 'DPCPX'
 
 
if DataSet==1
    load DataFigureModulationGammaBulbBASAL
    MTs(8:10,:)=[];
    M2Ts(8:10,:)=[];
    MTr(8:10,:)=[];
    M2Tr(8:10,:)=[];
    MTwi(8:10,:)=[];
    M2Twi(8:10,:)=[];
    MTwm(8:10,:)=[];
    M2Twm(8:10,:)=[];

    MTsKO(8:9,:)=[];
    M2TsKO(8:9,:)=[];
    MTrKO(8:9,:)=[];
    M2TrKO(8:9,:)=[];
    MTwiKO(8:9,:)=[];
    M2TwiKO(8:9,:)=[];
    MTwmKO(8:9,:)=[];
    M2TwmKO(8:9,:)=[];
    

    
elseif DataSet==2
   load DataFigureModulationGammaBulbPLETHYSMO 
   
else

lim=1200;
plo=0;

MTs=[];
MTr=[];
MTwi=[];
MTwm=[];
M2Ts=[];
M2Tr=[];
M2Twi=[];
M2Twm=[];

MTsKO=[];
MTrKO=[];
MTwiKO=[];
MTwmKO=[];
M2TsKO=[];
M2TrKO=[];
M2TwiKO=[];
M2TwmKO=[];


a=1;
b=1;


  
  
    for i=1:length(NameDir)
        Dir=PathForExperimentsML(NameDir{i});
        
        for man=1:length(Dir.path)
            
            try
            disp('  ')
            cd(Dir.path{man})
            load behavResources
            clear chHPC
            clear LFP
            clear LFPb
            
            res=pwd;
            tempchHPC=load([res,'/ChannelsToAnalyse/Bulb_deep.mat'],'channel');
            chHPC=tempchHPC.channel;
            
            
            if isempty(chHPC)
            disp('No Bulb channel!!! skipping...')
            %keyboard
            
            else
                try
            eval(['tempLoad=load([''',res,'/LFPData/LFP',num2str(chHPC),'.mat''],''LFP'');'])
            LFPb=tempLoad.LFP;
            
            res=pwd;
%             tempLoad=load(['',res,'/StateEpochSB.mat'],'SWSEpoch','MovEpoch','REMEpoch','NoiseEpoch','GndNoiseEpoch');
            load StateEpochSB SWSEpoch REMEpoch Wake wakeper TotalNoiseEpoch GndNoiseEpoch NoiseEpoch WeirdNoiseEpoch ThresholdedNoiseEpoch
            load StateEpoch ThetaEpoch
            load behavResources PreEpoch
%             SWSEpoch=tempLoad.SWSEpoch-tempLoad.GndNoiseEpoch;
%             SWSEpoch=SWSEpoch-tempLoad.NoiseEpoch;
            SWSEpoch=and(SWSEpoch,PreEpoch);
 
%             REMEpoch=tempLoad.REMEpoch-tempLoad.GndNoiseEpoch;
%             REMEpoch=REMEpoch-tempLoad.NoiseEpoch;
            REMEpoch=and(REMEpoch,PreEpoch);
            
%             MovEpoch=tempLoad.MovEpoch-tempLoad.GndNoiseEpoch;
%             MovEpoch=MovEpoch-tempLoad.NoiseEpoch;
            MovEpoch=and(Wake,PreEpoch);
            
            MovTEpoch=and(MovEpoch,ThetaEpoch);
            MovIEpoch=MovEpoch-ThetaEpoch;
            
            close all
            [Ms,M2s]=ModulationGammaBulb(LFPb,LFPb,SWSEpoch,lim,1);
            title(pwd)
            
            [Mr,M2r]=ModulationGammaBulb(LFPb,LFPb,REMEpoch,lim,plo);
            [Mwi,M2wi]=ModulationGammaBulb(LFPb,LFPb,MovIEpoch,lim,plo);
            [Mwm,M2wm]=ModulationGammaBulb(LFPb,LFPb,MovTEpoch,lim,plo);            
            close all
            
            if Dir.group{man}(1)=='W'
                
                MTs=[MTs;Ms(:,2)'];
                MTr=[MTr;Mr(:,2)'];
                MTwi=[MTwi;Mwi(:,2)'];
                MTwm=[MTwm;Mwm(:,2)'];

                M2Ts=[M2Ts;M2s(:,2)'];
                M2Tr=[M2Tr;M2r(:,2)'];
                M2Twi=[M2Twi;M2wi(:,2)'];
                M2Twm=[M2Twm;M2wm(:,2)'];        
                listMice{a}=Dir.path{man};
                a=a+1;
            else
                
                MTsKO=[MTsKO;Ms(:,2)'];
                MTrKO=[MTrKO;Mr(:,2)'];
                MTwiKO=[MTwiKO;Mwi(:,2)'];
                MTwmKO=[MTwmKO;Mwm(:,2)'];

                M2TsKO=[M2TsKO;M2s(:,2)'];
                M2TrKO=[M2TrKO;M2r(:,2)'];
                M2TwiKO=[M2TwiKO;M2wi(:,2)'];
                M2TwmKO=[M2TwmKO;M2wm(:,2)'];        
                listMiceKO{b}=Dir.path{man};
                b=b+1;
            end
            
            
            
                end
                
            end
            end
        end
    end
    
    close
    
tps=Ms(:,1);
    
end

figure('color',[1 1 1]), 
subplot(1,4,1), hold on
plot(tps,mean(MTs),'k')
plot(tps,mean(MTsKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(1,4,2), hold on
plot(tps,mean(MTr),'k')
plot(tps,mean(MTrKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(1,4,3), hold on
plot(tps,mean(MTwi),'k')
plot(tps,mean(MTwiKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(1,4,4), hold on
plot(tps,mean(MTwm),'k')
plot(tps,mean(MTwmKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])




figure('color',[1 1 1]), 
subplot(2,4,1), hold on
plot(tps,mean(MTs),'k')
plot(tps,mean(MTsKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(2,4,2), hold on
plot(tps,mean(MTr),'k')
plot(tps,mean(MTrKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(2,4,3), hold on
plot(tps,mean(MTwi),'k')
plot(tps,mean(MTwiKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(2,4,4), hold on
plot(tps,mean(MTwm),'k')
plot(tps,mean(MTwmKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTs)'),[50 60],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTsKO)'),[50 60],256);
subplot(2,4,5), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTr)'),[50 60],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTrKO)'),[50 60],256);
subplot(2,4,6), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTwi)'),[50 60],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTwiKO)'),[50 60],256);
subplot(2,4,7), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTwm)'),[50 60],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(MTwmKO)'),[50 60],256);
subplot(2,4,8), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)








   
figure('color',[1 1 1]), 
subplot(1,4,1), hold on
plot(tps,mean(M2Ts),'k')
plot(tps,mean(M2TsKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(1,4,2), hold on
plot(tps,mean(M2Tr),'k')
plot(tps,mean(M2TrKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(1,4,3), hold on
plot(tps,mean(M2Twi),'k')
plot(tps,mean(M2TwiKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(1,4,4), hold on
plot(tps,mean(M2Twm),'k')
plot(tps,mean(M2TwmKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])





figure('color',[1 1 1]), 
subplot(2,4,1), hold on
plot(tps,mean(M2Ts),'k')
plot(tps,mean(M2TsKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(2,4,2), hold on
plot(tps,mean(M2Tr),'k')
plot(tps,mean(M2TrKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(2,4,3), hold on
plot(tps,mean(M2Twi),'k')
plot(tps,mean(M2TwiKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

subplot(2,4,4), hold on
plot(tps,mean(M2Twm),'k')
plot(tps,mean(M2TwmKO),'r') 
xlim([-lim/1000 lim/1000])
ylim([-yl yl])

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2Ts)'),[70 90],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2TsKO)'),[70 90],256);
subplot(2,4,5), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2Tr)'),[70 90],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2TrKO)'),[70 90],256);
subplot(2,4,6), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2Twi)'),[70 90],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2TwiKO)'),[70 90],256);
subplot(2,4,7), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)

fil=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2Twm)'),[70 90],256);
filKO=FilterLFP(tsd((tps-tps(1))*1E4,mean(M2TwmKO)'),[70 90],256);
subplot(2,4,8), hold on
plot(tps,Data(fil),'k')
plot(tps,Data(filKO),'r') 
 xlim([-lim/3000 lim/3000])
ylim([-yl yl]/2)


%ylim([-5E3 5E3])
    















% 
% 
% 
% cd /media/DataMOBs/ProjetDPCPX/Mouse052/20121113/BULB-Mouse-52-13112012/
% 
% 
% 
% 
% 
% 
% cd /media/DataMOBsRAID5/ProjetAstro/ProjetDPCPX
% 
% 
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% 
% 
% 
% 
% load DataFigureModulationGammaBulbPLETHYSMO 
% figure('color',[1 1 1])
% subplot(2,2,1), imagesc(MTs), title('PLETHYSMO '), colorbar, ylabel('WT')
% subplot(2,2,2), imagesc(M2Ts), colorbar
% subplot(2,2,3), imagesc(MTsKO), colorbar,ylabel('KO')
% subplot(2,2,4), imagesc(M2TsKO), colorbar
% 
% figure('color',[1 1 1])
% subplot(2,2,1), imagesc(zscore(MTs')'), title('PLETHYSMO (zscore)'), colorbar, ylabel('WT')
% subplot(2,2,2), imagesc(zscore(M2Ts')'), colorbar
% subplot(2,2,3), imagesc(zscore(MTsKO')'), colorbar,ylabel('KO')
% subplot(2,2,4), imagesc(zscore(M2TsKO')'), colorbar
% 
% 
% 
% 
% 
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% %--------------------------------------------------------------------------
% 
% load DataFigureModulationGammaBulbBASAL
% 
% %     MTs(8:10,:)=[];
% %     M2Ts(8:10,:)=[];
% %     MTr(8:10,:)=[];
% %     M2Tr(8:10,:)=[];
% %     MTwi(8:10,:)=[];
% %     M2Twi(8:10,:)=[];
% %     MTwm(8:10,:)=[];
% %     M2Twm(8:10,:)=[];
% % 
% %     MTsKO(8:9,:)=[];
% %     M2TsKO(8:9,:)=[];
% %     MTrKO(8:9,:)=[];
% %     M2TrKO(8:9,:)=[];
% %     MTwiKO(8:9,:)=[];
% %     M2TwiKO(8:9,:)=[];
% %     MTwmKO(8:9,:)=[];
% %     M2TwmKO(8:9,:)=[];
% 
%     
% figure('color',[1 1 1])
% subplot(2,2,1), imagesc(MTs), title('BASAL'), colorbar,ylabel('WT')
% subplot(2,2,2), imagesc(M2Ts), colorbar
% subplot(2,2,3), imagesc(MTsKO), colorbar,ylabel('KO')
% subplot(2,2,4), imagesc(M2TsKO), colorbar
% 
% figure('color',[1 1 1])
% subplot(2,2,1), imagesc(zscore(MTs')'), title('BASAL (zscore)'), colorbar,ylabel('WT')
% subplot(2,2,2), imagesc(zscore(M2Ts')'), colorbar
% subplot(2,2,3), imagesc(zscore(MTsKO')'), colorbar,ylabel('KO')
% subplot(2,2,4), imagesc(zscore(M2TsKO')'), colorbar
% 
% 
% 
% 
% 
% 
% 
% 
