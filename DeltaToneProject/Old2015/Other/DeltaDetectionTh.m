function [m,m2,m3,t,l,l2,l3,tt,nb,nb2,nb3,nbDelta,nbDelta2,mD1,tD1,mD2,mD3,mDlfp1,mDlfp2,mDlfp3,mD1b,tD1b,mD2b,mD3b,mDlfp1b,mDlfp2b,mDlfp3b,NbNumNeu]=DeltaDetectionTh(sav,prof)


try
    prof;
catch
    prof=1;
end


try 
    sav;
catch
    sav=0;
end

try
    load DownSpk NumNeurons
    NbNumNeu=length(NumNeurons);
    load DataDeltaDetect m t m2 m3 t2 l l2 l3 tt nb nb2 nb3 nbDelta nbDelta2 mD1 tD1 mD2 mD3 mDlfp1 mDlfp2 mDlfp3 mD1b tD1b mD2b mD3b mDlfp1b mDlfp2b mDlfp3b
    save DataDeltaDetect -Append NbNumNeu
catch
    

        load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP

           load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP

        load SpikeData
        load StateEpochSB SWSEpoch REMEpoch Wake

        [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
        NbNumNeu=length(NumNeurons);
        [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,1,[0 70],1);close
        [Down2,Qt2,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.03,1,2,[10 70],1);close

        a=1;
        for i=0.2:0.2:4
        [tDelta,DeltaEpoch]=FindDeltaWavesChanGL('PFCx',SWSEpoch,[],0,i,75,[1 5]);
        [m(a,:),s,t]=mETAverage(tDelta,Range(Qt),Data(Qt),10,200);
        [l(a,:),s,tt]=mETAverage(tDelta,Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        nb(a)=length(tDelta);
        a=a+1;
        end

        a=1;
        for i=0.2:0.2:4
        [tDelta,DeltaEpoch]=FindDeltaWavesSingleChanGL('PFCx_deep',SWSEpoch,[],0,i,75,[1 5]);
        de=Range(tDelta);
        [m2(a,:),s2,t2]=mETAverage(de(2:end-1),Range(Qt),Data(Qt),10,200);
        [l2(a,:),s2,tt2]=mETAverage(de(2:end-1),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        nb2(a)=length(tDelta);
        a=a+1;
        end

        if prof
            a=1;
            for i=0.2:0.2:4
            [tDelta,DeltaEpoch]=FindDeltaWavesSingleChanGL('PFCx_sup',SWSEpoch,prof,0,i,75,[1 5]);
            de=Range(tDelta);
            [m3(a,:),s3,t3]=mETAverage(de(2:end-1),Range(Qt),Data(Qt),10,200);
            [l3(a,:),s3,tt3]=mETAverage(de(2:end-1),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
            nb3(a)=length(tDelta);
            a=a+1;
            end
         end
        

        nb=nb/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        nb2=nb2/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        nb3=nb3/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));

        nbDelta=length(Start(Down))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));
        nbDelta2=length(Start(Down2))/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));

        [mD1,sD1,tD1]=mETAverage((Start(Down)+End(Down))/2,Range(Qt),Data(Qt),10,200);
        [mD2,sD2,tD2]=mETAverage(Start(Down),Range(Qt),Data(Qt),10,200);
        [mD3,sD3,tD3]=mETAverage(End(Down),Range(Qt),Data(Qt),10,200);

        [mDlfp1,sD1,tDlfp1]=mETAverage((Start(Down)+End(Down))/2,Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        [mDlfp2,sD2,tDlfp2]=mETAverage(Start(Down),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        [mDlfp3,sD3,tDlfp3]=mETAverage(End(Down),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);


        [mD1b,sD1b,tD1b]=mETAverage((Start(Down2)+End(Down2))/2,Range(Qt),Data(Qt),10,200);
        [mD2b,sD2b,tD2b]=mETAverage(Start(Down2),Range(Qt),Data(Qt),10,200);
        [mD3b,sD3b,tD3b]=mETAverage(End(Down2),Range(Qt),Data(Qt),10,200);

        [mDlfp1b,sD1b,tDlfp1b]=mETAverage((Start(Down2)+End(Down2))/2,Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        [mDlfp2b,sD2b,tDlfp2b]=mETAverage(Start(Down2),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
        [mDlfp3b,sD3b,tDlfp3b]=mETAverage(End(Down2),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);

end


if prof==0
     load ChannelsToAnalyse/PFCx_deep
            eval(['load LFPData/LFP',num2str(channel)])
            LFPd=LFP;
            clear LFP

            load ChannelsToAnalyse/PFCx_sup
            eval(['load LFPData/LFP',num2str(channel)])
            LFPs=LFP;
            clear LFP

            load SpikeData
            load StateEpochSB SWSEpoch REMEpoch Wake

            [Spfc,NumNeurons]=GetSpikesFromStructure('PFCx');
            NbNumNeu=length(NumNeurons);
            [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.01,1,1,[0 70],1);close
            [Down2,Qt2,B,h1,b1,h2,b2,h3,b3,h4,b4]=FindDown(S,NumNeurons,SWSEpoch,10,0.03,1,2,[10 70],1);close

        
            a=1;
            for i=0.2:0.2:4
            [tDelta,DeltaEpoch]=FindDeltaWavesSingleChanGL('PFCx_sup',SWSEpoch,prof,0,i,75,[1 5]);
            de=Range(tDelta);
            [m3(a,:),s3,t3]=mETAverage(de(2:end-1),Range(Qt),Data(Qt),10,200);
            [l3(a,:),s3,tt3]=mETAverage(de(2:end-1),Range(LFPd),Data(LFPd)-Data(LFPs),10,200);
            nb3(a)=length(tDelta);
            a=a+1;
            end
end

            

figure('color',[1 1 1])
subplot(2,2,1), plot(t,m,'k'), hold on, plot(tD1,mD1,'g','linewidth',2), plot(tD1,mD1b,'m','linewidth',2), yl=ylim; ylim([0 yl(2)])
subplot(2,2,3), plot(t,l,'k'), hold on, plot(tD1,mDlfp1,'g','linewidth',2), plot(tD1,mDlfp1b,'m','linewidth',2)
subplot(2,2,2), plot(0.2:0.2:4,m(:,98),'ko-'), yl=ylim; ylim([0 yl(2)])
subplot(2,2,4), plot(0.2:0.2:4,nb,'ko-'), xl=xlim; line(xl,[nbDelta nbDelta],'color','r'),  line(xl,[nbDelta2 nbDelta2],'color','r')


figure('color',[1 1 1])
subplot(2,2,1), plot(t,m2,'b'), hold on, plot(tD1,mD1,'g','linewidth',2), plot(tD1,mD1b,'m','linewidth',2), yl=ylim; ylim([0 yl(2)])
subplot(2,2,3), plot(t,l2,'b'), hold on, plot(tD1,mDlfp1,'g','linewidth',2), plot(tD1,mDlfp1b,'m','linewidth',2)
subplot(2,2,2), plot(0.2:0.2:4,m2(:,98),'ko-'), yl=ylim; ylim([0 yl(2)])
subplot(2,2,4), plot(0.2:0.2:4,nb2,'ko-'), xl=xlim; line(xl,[nbDelta nbDelta],'color','r'),  line(xl,[nbDelta2 nbDelta2],'color','r')


figure('color',[1 1 1])
subplot(2,2,1), plot(t,m3,'r'), hold on, plot(tD1,mD1,'g','linewidth',2), plot(tD1,mD1b,'m','linewidth',2), yl=ylim; ylim([0 yl(2)])
subplot(2,2,3), plot(t,l3,'r'), hold on, plot(tD1,mDlfp1,'g','linewidth',2), plot(tD1,mDlfp1b,'m','linewidth',2)
subplot(2,2,2), plot(0.2:0.2:4,m3(:,86),'ko-'), yl=ylim; ylim([0 yl(2)])
subplot(2,2,4), plot(0.2:0.2:4,nb3,'ko-'), xl=xlim; line(xl,[nbDelta nbDelta],'color','r'),  line(xl,[nbDelta2 nbDelta2],'color','r')
 

if sav
save DataDeltaDetect
end
