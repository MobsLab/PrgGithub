
%textMarieUno

cd /media/DataMOBsRAID5/ProjetAstro

%Epoch=or(PreEpoch,VEHEpoch);

try
    
    load DatatextMarieUnoBASAL
    M;
    CT;
    
    
catch
    

            try
            cd /Volumes/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013
            catch
                cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013
            end

            n=1;

            
            load SpindlesRipples Rip
            load behavResources
            
            Epoch=or(PreEpoch,VEHEpoch);
            
            rip=tsd(Rip(:,2)*1E4,Rip);
            Rip=Range(Restrict(rip,Epoch),'s');
            Rip(:,2)=Rip;
            
            load SpiDeltaRipMariePaCxDeep        



                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct1,Bt1]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);    
                    for i=1:8; CT{n,1,i}=Ct1{i};end
                    for i=1:8; BT{n,1,i}=Bt1{i};end

                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct2,Bt2]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);
                    for i=1:8; CT{n,2,i}=Ct2{i};end
                    for i=1:8; BT{n,2,i}=Bt2{i};end 



              load SpiDeltaRipMariePFCxDeep       


                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct3,Bt3]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,3,i}=Ct3{i};end
                    for i=1:8; BT{n,3,i}=Bt3{i};end


                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct4,Bt4]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,4,i}=Ct4{i};end
                    for i=1:8; BT{n,4,i}=Bt4{i};end 




            load ChannelsToAnalyse/dHPC_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])
            Fil=FilterLFP(LFP,[150 200]);
            Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));

            M{n,1}=PlotRipRaw(LFP,Rip(:,2),100);
            M{n,2}=PlotRipRaw(Fil,Rip(:,2),100);

            load ChannelsToAnalyse/PaCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePaCxDeep 
            M{n,3}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,4}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,5}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,6}=PlotRipRaw(LFP,SpiL(:,2),800);

            load ChannelsToAnalyse/PFCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePFCxDeep   
            M{n,7}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,8}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,9}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,10}=PlotRipRaw(LFP,SpiL(:,2),800);


            n=n+1;

                close all    


            try
            cd /Volumes/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013
            catch
                cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013
            end

            load SpindlesRipples Rip
            load behavResources
            Epoch=or(PreEpoch,VEHEpoch);
            
            rip=tsd(Rip(:,2)*1E4,Rip);
            Rip=Range(Restrict(rip,Epoch),'s');
            Rip(:,2)=Rip;
            load SpiDeltaRipMariePaCxDeep        



                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct1,Bt1]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);


                    for i=1:8; CT{n,1,i}=Ct1{i};end
                    for i=1:8; BT{n,1,i}=Bt1{i};end

                    spi=ts(SpiH(:,2)*1E4);
                    [Ct2,Bt2]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);
                    for i=1:8; CT{n,2,i}=Ct2{i};end
                    for i=1:8; BT{n,2,i}=Bt2{i};end 



              load SpiDeltaRipMariePFCxDeep       


                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct3,Bt3]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,3,i}=Ct3{i};end
                    for i=1:8; BT{n,3,i}=Bt3{i};end


                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct4,Bt4]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,4,i}=Ct4{i};end
                    for i=1:8; BT{n,4,i}=Bt4{i};end 



            load ChannelsToAnalyse/dHPC_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])
            Fil=FilterLFP(LFP,[150 200]);
            Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));

            M{n,1}=PlotRipRaw(LFP,Rip(:,2),100);
            M{n,2}=PlotRipRaw(Fil,Rip(:,2),100);

            load ChannelsToAnalyse/PaCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePaCxDeep 
            M{n,3}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,4}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,5}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,6}=PlotRipRaw(LFP,SpiL(:,2),800);

            load ChannelsToAnalyse/PFCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePFCxDeep   
            M{n,7}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,8}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,9}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,10}=PlotRipRaw(LFP,SpiL(:,2),800);


                    n=n+1;

                   close all




                   try
                   cd /Volumes/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013
                   catch
                       cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013
                   end

           load SpindlesRipples Rip
            load behavResources
            Epoch=or(PreEpoch,VEHEpoch);
            rip=tsd(Rip(:,2)*1E4,Rip);
            Rip=Range(Restrict(rip,Epoch),'s');
            Rip(:,2)=Rip;
            load SpiDeltaRipMariePaCxDeep        



                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct1,Bt1]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);


                    for i=1:8; CT{n,1,i}=Ct1{i};end
                    for i=1:8; BT{n,1,i}=Bt1{i};end

                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct2,Bt2]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);
            %         CT{n,2}=Ct2;
            %         BT{n,2}=Bt2;
                    for i=1:8; CT{n,2,i}=Ct2{i};end
                    for i=1:8; BT{n,2,i}=Bt2{i};end        

              load SpiDeltaRipMariePFCxDeep       


                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct3,Bt3]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

            %         CT{n,3}=Ct3;
            %         BT{n,3}=Bt3;
                    for i=1:8; CT{n,3,i}=Ct3{i};end
                    for i=1:8; BT{n,3,i}=Bt3{i};end

                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct4,Bt4]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

            %         CT{n,4}=Ct4;
            %         BT{n,4}=Bt4;
                    for i=1:8; CT{n,4,i}=Ct4{i};end
                    for i=1:8; BT{n,4,i}=Bt4{i};end       




            load ChannelsToAnalyse/dHPC_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])
            Fil=FilterLFP(LFP,[150 200]);
            Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));

            M{n,1}=PlotRipRaw(LFP,Rip(:,2),100);
            M{n,2}=PlotRipRaw(Fil,Rip(:,2),100);

            load ChannelsToAnalyse/PaCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePaCxDeep 
            M{n,3}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,4}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,5}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,6}=PlotRipRaw(LFP,SpiL(:,2),800);

            load ChannelsToAnalyse/PFCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePFCxDeep   
            M{n,7}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,8}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,9}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,10}=PlotRipRaw(LFP,SpiL(:,2),800);


                    n=n+1;

                   close all





            try
                cd /Volumes/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse052/20130122/BULB-Mouse-52-22012013
            catch
            cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse052/20130122/BULB-Mouse-52-22012013
            end

           load SpindlesRipples Rip
            load behavResources
            Epoch=or(PreEpoch,VEHEpoch);
            rip=tsd(Rip(:,2)*1E4,Rip);
            Rip=Range(Restrict(rip,Epoch),'s');
            Rip(:,2)=Rip;
            load SpiDeltaRipMariePaCxDeep        



                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct1,Bt1]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);


                    for i=1:8; CT{n,1,i}=Ct1{i};end
                    for i=1:8; BT{n,1,i}=Bt1{i};end

                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct2,Bt2]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);
                    for i=1:8; CT{n,2,i}=Ct2{i};end
                    for i=1:8; BT{n,2,i}=Bt2{i};end 



              load SpiDeltaRipMariePFCxDeep       


                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct3,Bt3]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,3,i}=Ct3{i};end
                    for i=1:8; BT{n,3,i}=Bt3{i};end


                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct4,Bt4]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);
                    for i=1:8; CT{n,4,i}=Ct4{i};end
                    for i=1:8; BT{n,4,i}=Bt4{i};end 



            load ChannelsToAnalyse/dHPC_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])
            Fil=FilterLFP(LFP,[150 200]);
            Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));

            M{n,1}=PlotRipRaw(LFP,Rip(:,2),100);
            M{n,2}=PlotRipRaw(Fil,Rip(:,2),100);

            load ChannelsToAnalyse/PaCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePaCxDeep 
            M{n,3}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,4}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,5}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,6}=PlotRipRaw(LFP,SpiL(:,2),800);

            load ChannelsToAnalyse/PFCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePFCxDeep   
            M{n,7}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,8}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,9}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,10}=PlotRipRaw(LFP,SpiL(:,2),800);


            n=n+1;

            close all


            try
            cd /Volumes/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse054/20130314/BULB-Mouse-54-14032013
            catch
            cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse054/20130314/BULB-Mouse-54-14032013
            end


           load SpindlesRipples Rip
            load behavResources
            Epoch=or(PreEpoch,VEHEpoch);
            rip=tsd(Rip(:,2)*1E4,Rip);
            Rip=Range(Restrict(rip,Epoch),'s');
            Rip(:,2)=Rip;
            load SpiDeltaRipMariePaCxDeep        



                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct1,Bt1]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);


                    for i=1:8; CT{n,1,i}=Ct1{i};end
                    for i=1:8; BT{n,1,i}=Bt1{i};end

                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct2,Bt2]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);
                    for i=1:8; CT{n,2,i}=Ct2{i};end
                    for i=1:8; BT{n,2,i}=Bt2{i};end 



              load SpiDeltaRipMariePFCxDeep       


                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct3,Bt3]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,3,i}=Ct3{i};end
                    for i=1:8; BT{n,3,i}=Bt3{i};end


                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct4,Bt4]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,4,i}=Ct4{i};end
                    for i=1:8; BT{n,4,i}=Bt4{i};end 



            load ChannelsToAnalyse/dHPC_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])
            Fil=FilterLFP(LFP,[150 200]);
            Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));

            M{n,1}=PlotRipRaw(LFP,Rip(:,2),100);
            M{n,2}=PlotRipRaw(Fil,Rip(:,2),100);

            load ChannelsToAnalyse/PaCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePaCxDeep 800
            M{n,3}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,4}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,5}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,6}=PlotRipRaw(LFP,SpiL(:,2),800);

            load ChannelsToAnalyse/PFCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePFCxDeep   
            M{n,7}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,8}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,9}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,10}=PlotRipRaw(LFP,SpiL(:,2),800);


            n=n+1;



                   close all

            try
            cd /Volumes/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse066/BULB-Mouse-66-05062013
            catch
            cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse066/BULB-Mouse-66-05062013
            end


           load SpindlesRipples Rip
            load behavResources
            Epoch=or(PreEpoch,VEHEpoch);
            rip=tsd(Rip(:,2)*1E4,Rip);
            Rip=Range(Restrict(rip,Epoch),'s');
            Rip(:,2)=Rip;
            load SpiDeltaRipMariePaCxDeep        



                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct1,Bt1]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);


                    for i=1:8; CT{n,1,i}=Ct1{i};end
                    for i=1:8; BT{n,1,i}=Bt1{i};end

                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct2,Bt2]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);
                    for i=1:8; CT{n,2,i}=Ct2{i};end
                    for i=1:8; BT{n,2,i}=Bt2{i};end 



              load SpiDeltaRipMariePFCxDeep       


                    spi=ts(SpiL(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct3,Bt3]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,3,i}=Ct3{i};end
                    for i=1:8; BT{n,3,i}=Bt3{i};end


                    spi=ts(SpiH(:,2)*1E4);spi=Restrict(spi,Epoch);
                    [Ct4,Bt4]=CrossSpiRipDelta(spi,Rip,tDeltaT2,tDeltaP2);

                    for i=1:8; CT{n,4,i}=Ct4{i};end
                    for i=1:8; BT{n,4,i}=Bt4{i};end 



            load ChannelsToAnalyse/dHPC_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])
            Fil=FilterLFP(LFP,[150 200]);
            Pow=tsd(Range(Fil),abs(hilbert(Data(Fil))));

            M{n,1}=PlotRipRaw(LFP,Rip(:,2),100);
            M{n,2}=PlotRipRaw(Fil,Rip(:,2),100);

            load ChannelsToAnalyse/PaCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePaCxDeep 
            M{n,3}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,4}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,5}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,6}=PlotRipRaw(LFP,SpiL(:,2),800);

            load ChannelsToAnalyse/PFCx_deep.mat
            eval(['load LFPData/LFP',num2str(channel)])

            load SpiDeltaRipMariePFCxDeep   
            M{n,7}=PlotRipRaw(Pow,SpiH(:,2),800);
            M{n,8}=PlotRipRaw(Pow,SpiL(:,2),800);
            M{n,9}=PlotRipRaw(LFP,SpiH(:,2),800);
            M{n,10}=PlotRipRaw(LFP,SpiL(:,2),800);


            n=n+1;



            close all

            
            clear Fil
            clear LFP
            cd /media/DataMOBsRAID5/ProjetAstro
            save DatatextMarieUnoBASAL
end

%--------------------------------------------------------------------------
%----------------------------------------------------------------------





    
    
    
    
nameParam{1}='Par  low';
nameParam{2}='Par  high';
nameParam{3}='Pfc  low';
nameParam{4}='Pfc  high';


nameParam2{1}='Spi vs Rip';
nameParam2{2}='Spi vs Rip, CP';
nameParam2{3}='Spi vs Rip (detail)';
nameParam2{4}='Spi vs Rip (detail), CP';
nameParam2{5}='tDelta T vs Rip';
nameParam2{6}='tDelta T vs Rip, CP';
nameParam2{7}='tDelta P vs Rip';
nameParam2{8}='tDelta P vs Rip, CP';

smo=0.07;

for k=1%:2:8;

for j=1% [1,3,4]%:4

figure('color',[1 1 1]), 
subplot(2,2,1), hold on
plot(BT{1,2}/1E3,SmoothDec(mean([CT{1,j,k} CT{2,j,k} CT{3,j,k}]'),smo),'k','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
plot(BT{1,2}/1E3,SmoothDec(mean([CT{4,j,k} CT{5,j,k} CT{6,j,k}]'),smo),'r','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
xlim([-25 25])
title([nameParam{j},' ',nameParam2{k}])
subplot(2,2,2), hold on
plot(BT{1,2}/1E3,SmoothDec(zscore(mean([CT{1,j,k} CT{2,j,k} CT{3,j,k}]')),smo),'k','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
plot(BT{1,2}/1E3,SmoothDec(zscore(mean([CT{4,j,k} CT{5,j,k} CT{6,j,k+1}]')),smo),'r','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
xlim([-25 25])

subplot(2,2,3), hold on
plot(BT{1,2}/1E3,SmoothDec(mean([CT{1,j,k+1} CT{2,j,k+1} CT{3,j,k+1}]'),smo),'k','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
plot(BT{1,2}/1E3,SmoothDec(mean([CT{4,j,k+1} CT{5,j,k+1} CT{6,j,k}]'),smo),'r','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
xlim([-25 25])
title(nameParam{j})
subplot(2,2,4), hold on
plot(BT{1,2}/1E3,SmoothDec(zscore(mean([CT{1,j,k+1} CT{2,j,k+1} CT{3,j,k+1}]')),smo),'k','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
plot(BT{1,2}/1E3,SmoothDec(zscore(mean([CT{4,j,k+1} CT{5,j,k+1} CT{6,j,k+1}]')),smo),'r','linewidth',2), yl=ylim; hold on, line([0 0],yl,'color','b')
xlim([-25 25])


%set(gcf,'position',[ 131         476        1198         363])

end
end

% 
% for k=1:10
% 
% figure, 
% subplot(2,1,1),plot(M{1,k}(:,1),M{1,k}(:,2),'k')
% hold on, plot(M{2,k}(:,1),M{2,k}(:,2),'k')
% hold on, plot(M{3,k}(:,1),M{3,k}(:,2),'k')
% hold on, plot(M{4,k}(:,1),M{4,k}(:,2),'r')
% hold on, plot(M{5,k}(:,1),M{5,k}(:,2),'r')
% hold on, plot(M{6,k}(:,1),M{6,k}(:,2),'r')
% 
% subplot(2,1,2), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
% hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
% 
% end


% 
% for k=1:2:10
% 
% figure, 
% subplot(2,1,1), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
% hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
% 
% subplot(2,1,2), plot(M{1,k+1}(:,1),(M{1,k+1}(:,2)+M{2,k+1}(:,2)+M{3,k+1}(:,2))/3,'k','linewidth',2)
% hold on, plot(M{1,k+1}(:,1),(M{4,k+1}(:,2)+M{5,k+1}(:,2)+M{6,k+1}(:,2))/3,'r','linewidth',2)
% 
% end




figure('color',[1 1 1]), 
k=1;
subplot(2,1,1), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
title('Ripples Hpc')
k=2;
subplot(2,1,2), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)


figure('color',[1 1 1]), 
k=5;
subplot(2,1,1), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
title('Fast Spindles Parietal')
yl=ylim;
line([0 0],yl,'color','b')
k=3;
subplot(2,1,2), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color','b')


figure('color',[1 1 1]), 
k=6;
subplot(2,1,1), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color','b')
title('Slow Spindles Parietal')
k=4;
subplot(2,1,2), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
ylim([0 400])
yl=ylim;
line([0 0],yl,'color','b')




figure('color',[1 1 1]), 
k=9;
subplot(2,1,1), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
title('Fast Spindles PFC')
yl=ylim;
line([0 0],yl,'color','b')
k=7;
subplot(2,1,2), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
ylim([0 400])
yl=ylim;
line([0 0],yl,'color','b')


figure('color',[1 1 1]), 
k=10;
subplot(2,1,1), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
yl=ylim;
line([0 0],yl,'color','b')
title('Slow Spindles PFC')
k=8;
subplot(2,1,2), plot(M{1,k}(:,1),(M{1,k}(:,2)+M{2,k}(:,2)+M{3,k}(:,2))/3,'k','linewidth',2)
hold on, plot(M{1,k}(:,1),(M{4,k}(:,2)+M{5,k}(:,2)+M{6,k}(:,2))/3,'r','linewidth',2)
ylim([0 400])
yl=ylim;
line([0 0],yl,'color','b')



