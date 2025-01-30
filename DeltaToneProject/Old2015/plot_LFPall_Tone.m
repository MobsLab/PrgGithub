%plot_LFPall_Tone
res=pwd;

%------------------------------------------------------
%                   load LFP PETH
%------------------------------------------------------
load([res,'/LFPData/InfoLFP']);
load([res,'/LFP_Tone']);

lim=4000;
pval=0.01;
smo=1;
decal=200;
PFCx=1;dHPC=1;NRT=1;PaCx=1;MoCx=1;Bulb=1;

%-----------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Single Tone Effect <><><><><><><><><><><><><><><
%-----------------------------------------------------------------------------
figure,
try LFP_SingleTone;
    for i=1:32
        LFP_tone=Data(LFP_SingleTone(i))';
        LFP_tone(LFP_tone>lim)=nan;
        LFP_tone(LFP_tone<-lim)=nan;
        
        [Mtone,S1,Etone]=MeanDifNan(RemoveNan(LFP_tone));
        tps=Range(LFP_SingleTone(i),'ms');
        
        if strcmp('PFCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,1:2)
                hold on, plot(tps,PFCx*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,1:2)
                hold on, plot(tps,PFCx*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
            end
        end
        if strcmp('MoCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,3)
                hold on, plot(tps,MoCx*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('PreMotor Cortex')
                MoCx=MoCx+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,3)
                hold on, plot(tps,MoCx*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('PreMotor Cortex')
                MoCx=MoCx+1;
            end
        end
        if strcmp('PaCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,4)
                hold on, plot(tps,PaCx*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,4)
                hold on, plot(tps,PaCx*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
            end
        end
        if strcmp('Bulb', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,5)
                hold on, plot(tps,Bulb*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('Olfactory Bulb')
                Bulb=Bulb+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,5)
                hold on, plot(tps,Bulb*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('Olfactory Bulb')
                Bulb=Bulb+1;
            end
        end
        if strcmp('NRT', InfoLFP.structure(i))
            hold on, subplot(7,1,6)
            hold on, plot(tps,NRT*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
            hold on, title('thalamic reticule nucleus')
            NRT=NRT+1;
        end
        if strcmp('dHPC', InfoLFP.structure(i))
            hold on, subplot(7,1,7)
            hold on, plot(tps,dHPC*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
            hold on, title('hippocampus')
            dHPC=dHPC+1;
        end
    end
end

%-----------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Sequence Tone Effect <><><><><><><><><><><><><><><
%-----------------------------------------------------------------------------
figure,
try LFP_SeqTone;
    for i=1:32
        LFP_tone=Data(LFP_SeqTone(i))';
        LFP_tone(LFP_tone>lim)=nan;
        LFP_tone(LFP_tone<-lim)=nan;
        
        [Mtone,S1,Etone]=MeanDifNan(RemoveNan(LFP_tone));
        tps=Range(LFP_SeqTone(i),'ms');
        
        if strcmp('PFCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,1:2)
                hold on, plot(tps,PFCx*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,1:2)
                hold on, plot(tps,PFCx*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
            end
        end
        if strcmp('MoCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,3)
                hold on, plot(tps,MoCx*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('PreMotor Cortex')
                MoCx=MoCx+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,3)
                hold on, plot(tps,MoCx*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('PreingleMotor Cortex')
                MoCx=MoCx+1;
            end
        end
        if strcmp('PaCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,4)
                hold on, plot(tps,PaCx*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,4)
                hold on, plot(tps,PaCx*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
            end
        end
        if strcmp('Bulb', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,5)
                hold on, plot(tps,Bulb*(decal*3)+SmoothDec((Mtone),smo),'r','linewidth',2),
                hold on, title('Olfactory Bulb')
                Bulb=Bulb+1;
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,5)
                hold on, plot(tps,Bulb*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
                hold on, title('Olfactory Bulb')
                Bulb=Bulb+1;
            end
        end
        if strcmp('NRT', InfoLFP.structure(i))
            hold on, subplot(7,1,6)
            hold on, plot(tps,NRT*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
            hold on, title('thalamic reticule nucleus')
            NRT=NRT+1;
        end
        if strcmp('dHPC', InfoLFP.structure(i))
            hold on, subplot(7,1,7)
            hold on, plot(tps,dHPC*(decal*3)+SmoothDec((Mtone),smo),'k','linewidth',1),
            hold on, title('hippocampus')
            dHPC=dHPC+1;
        end
    end
end