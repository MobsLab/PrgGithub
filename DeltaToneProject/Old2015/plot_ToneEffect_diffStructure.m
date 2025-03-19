%plot_ToneEffect_diffStructure
res=pwd;

%------------------------------------------------------
%                   load LFP PETH
%------------------------------------------------------
load([res,'/LFPData/InfoLFP']);
load([res,'/LFP_Tone']);
try
load([res,'/LFP_SeqTone']);
end
%-----------------------------------------------------

lim=4000;
pval=0.01;
smo=1;
decal=200;
%CxPF=1;hpc=1;NRT=1;CxM2=1;CxPar=1;OB=1;
PFCx=1;dHPC=1;NRT=1;PaCx=1;MoCx=1;Bulb=1;

%-----------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Single Tone Effect <><><><><><><><><><><><><><><
%-----------------------------------------------------------------------------
figure,
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


%---------------------------------------------------------------------------
%<><><><><><><><><><><><><><> Sequence Effect <><><><><><><><><><><><><><><
%---------------------------------------------------------------------------
figure, 
for i=1:32
    LFP_tone=Data(LFP_SeqTone(i))';
    LFP_tone(LFP_tone>lim)=nan;
    LFP_tone(LFP_tone<-lim)=nan;
    
    [Mtone,S1,Etone]=MeanDifNan(RemoveNan(LFP_tone));
    
    rg=Range(LFP_SeqTone(i),'ms');
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


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%<><><><><><><><><><><><> All comparison Effect <><><><><><><><><><><><><><
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

for i=1:32
    LFP_single=Data(LFP_SingleTone(i))';
    LFP_single(LFP_single>lim)=nan;
    LFP_single(LFP_single<-lim)=nan;
    [Msingle,S1,Esingle]=MeanDifNan(RemoveNan(LFP_single));
    
    LFP_seq=Data(LFP_SeqTone(i))';
    LFP_seq(LFP_seq>lim)=nan;
    LFP_seq(LFP_seq<-lim)=nan;
    [Mseq,S1,Eseq]=MeanDifNan(RemoveNan(LFP_seq));
    
    [h,p]=ttest2(RemoveNan(LFP_single),RemoveNan(LFP_seq));
    rg=Range(LFP_SingleTone(i),'ms');
    pr=rescale(p,100, -120);
    tps=Range(LFP_SingleTone(i),'ms');
    
    figure, plot(tps,i*(decal*3)+SmoothDec((Msingle),smo),'k','linewidth',1),
    hold on, plot(tps,i*(decal*3)+SmoothDec((Mseq),smo),'r','linewidth',1),
    hold on, plot(rg(p<pval),i*(decal*3)+pr(p<pval),'bd')
    ylabel('tone effect')
    xlabel('Time to first tone onset')
    title('Delta Tone feedback paradigm')
end


%------------------------------------------------------------------------------
%------------------------------------------------------------------------------
%<><><><><><><><><><><><> SWS versus REM comparison <><><><><><><><><><><><><><
%------------------------------------------------------------------------------
%------------------------------------------------------------------------------

for i=1:32
    LFP_single_SWS=Data(LFP_SingleTone_SWS(i))';
    LFP_single_SWS(LFP_single_SWS>lim)=nan;
    LFP_single_SWS(LFP_single_SWS<-lim)=nan;
    [M_SWS,S1,E_SWS]=MeanDifNan(RemoveNan(LFP_single_SWS));
    
    LFP_single_REM=Data(LFP_SingleTone_REM(i))';
    LFP_single_REM(LFP_single_REM>lim)=nan;
    LFP_single_REM(LFP_single_REM<-lim)=nan;
    [M_REM,S1,E_REM]=MeanDifNan(RemoveNan(LFP_single_REM));
    
    [h,p]=ttest2(RemoveNan(LFP_single_SWS),RemoveNan(LFP_single_REM));
    rg=Range(LFP_SingleTone_SWS(i),'ms');
    pr=rescale(p,100, -120);
    tps=Range(LFP_SingleTone_SWS(i),'ms');
    
    figure(4), 
    if strcmp('PFCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,1:2)
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',2),
            hold on, title('Prefrontal Cortex : SWS(blue) versus REM(black) ')
            PFCx=PFCx+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,1:2)
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',1),
            hold on, title('Prefrontal Cortex : SWS(blue) versus REM(black) ')
            PFCx=PFCx+1;
        end
    end
    if strcmp('MoCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,3)
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',2),
            hold on, title('PreMotor Cortex : SWS(blue) versus REM(black) ')
            MoCx=MoCx+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,3)
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',1),
            hold on, title('PreMotor Cortex : SWS(blue) versus REM(black) ')
            MoCx=MoCx+1;
        end
    end
    if strcmp('PaCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,4)
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',2),
            hold on, title('Parietal Cortex : SWS(blue) versus REM(black) ')
            PaCx=PaCx+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,4)
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',1),
            hold on, title('Parietal Cortex : SWS(blue) versus REM(black) ')
            PaCx=PaCx+1;
        end
    end
    if strcmp('Bulb', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,5)
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',2),
            hold on, title('Olfactory Bulb : SWS(blue) versus REM(black) ')
            Bulb=Bulb+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,5)
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',1),
            hold on, title('Olfactory Bulb : SWS(blue) versus REM(black) ')
            Bulb=Bulb+1;
        end
    end
    if strcmp('NRT', InfoLFP.structure(i))
        hold on, subplot(7,1,6)
        hold on, plot(tps,NRT*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
        hold on, plot(tps,NRT*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',1),
        hold on, title('thalamic reticule nucleus : SWS(blue) versus REM(black) ')
        NRT=NRT+1;
    end
    if strcmp('dHPC', InfoLFP.structure(i))
        hold on, subplot(7,1,7)
        hold on, plot(tps,dHPC*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
        hold on, plot(tps,dHPC*(decal*3)+SmoothDec((M_REM),smo),'r','linewidth',1),
        hold on, title('hippocampus : SWS(blue) versus REM(black) ')
        dHPC=dHPC+1;
    end
end

%------------------------------------------------------------------------------
%<><><><><><><><><><><><> SWS versus Wake comparison <><><><><><><><><><><><><>
%------------------------------------------------------------------------------

for i=1:32
    LFP_single_SWS=Data(LFP_SingleTone_SWS(i))';
    LFP_single_SWS(LFP_single_SWS>lim)=nan;
    LFP_single_SWS(LFP_single_SWS<-lim)=nan;
    [M_SWS,S1,E_SWS]=MeanDifNan(RemoveNan(LFP_single_SWS));
    
    LFP_single_Wake=Data(LFP_SingleTone_Wake(i))';
    LFP_single_Wake(LFP_single_Wake>lim)=nan;
    LFP_single_Wake(LFP_single_Wake<-lim)=nan;
    [M_Wake,S1,E_Wake]=MeanDifNan(RemoveNan(LFP_single_Wake));
    
    [h,p]=ttest2(RemoveNan(LFP_single_SWS),RemoveNan(LFP_single_Wake));
    rg=Range(LFP_SingleTone_SWS(i),'ms');
    pr=rescale(p,100, -120);
    tps=Range(LFP_SingleTone_SWS(i),'ms');
    
    figure(5), 
    if strcmp('PFCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,1:2)
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',2),
            hold on, title('Prefrontal Cortex : SWS(blue) versus Wake(black) ')
            PFCx=PFCx+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,1:2)
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,PFCx*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',1),
            hold on, title('Prefrontal Cortex : SWS(blue) versus Wake(black) ')
            PFCx=PFCx+1;
        end
    end
    if strcmp('MoCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,3)
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',2),
            hold on, title('PreMotor Cortex : SWS(blue) versus Wake(black) ')
            MoCx=MoCx+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,3)
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,MoCx*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',1),
            hold on, title('PreMotor Cortex : SWS(blue) versus Wake(black) ')
            MoCx=MoCx+1;
        end
    end
    if strcmp('PaCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,4)
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',2),
            hold on, title('Parietal Cortex : SWS(blue) versus Wake(black) ')
            PaCx=PaCx+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,4)
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,PaCx*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',1),
            hold on, title('Parietal Cortex : SWS(blue) versus Wake(black) ')
            PaCx=PaCx+1;
        end
    end
    if strcmp('Bulb', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,5)
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',2),
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',2),
            hold on, title('Olfactory Bulb : SWS(blue) versus Wake(black) ')
            Bulb=Bulb+1;
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,5)
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
            hold on, plot(tps,Bulb*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',1),
            hold on, title('Olfactory Bulb : SWS(blue) versus Wake(black) ')
            Bulb=Bulb+1;
        end
    end
    if strcmp('NRT', InfoLFP.structure(i))
        hold on, subplot(7,1,6)
        hold on, plot(tps,NRT*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
        hold on, plot(tps,NRT*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',1),
        hold on, title('thalamic reticule nucleus : SWS(blue) versus Wake(black) ')
        NRT=NRT+1;
    end
    if strcmp('dHPC', InfoLFP.structure(i))
        hold on, subplot(7,1,7)
        hold on, plot(tps,dHPC*(decal*3)+SmoothDec((M_SWS),smo),'b','linewidth',1),
        hold on, plot(tps,dHPC*(decal*3)+SmoothDec((M_Wake),smo),'k','linewidth',1),
        hold on, title('hippocampus : SWS(blue) versus Wake(black) ')
        dHPC=dHPC+1;
    end
end


