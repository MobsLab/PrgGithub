%gen_rawLFP_Tone_Delta

plo=0;
res=pwd;
load([res,'/LFPData/InfoLFP']);
load ToneEvent

disp(' ')
toto=input('Single or Seq Tone ?   ');
disp(' ')

if strcmp('Single', toto)
    Tone=SingleTone;
elseif strcmp('Seq', toto)
    Tone=SeqTone;
end

%--------------------------------------------------------------------------
i=1;
for num=InfoLFP.channel(1):InfoLFP.channel(end);
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP_Tone=PlotRipRaw(LFP,Tone/1E4,1000);close
    rawLFP_Tone{i}=LFP_Tone;
    i=i+1;
    disp(['channel # ',num2str(num),' > done']) 
end
save rawLFP_Tone rawLFP_Tone
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
load DeltaMoCx
Epoch=intervalSet(Tone-1E4,Tone+1E4);
Tone_Epoch=mergeCloseIntervals(Epoch,1);
load StateEpochSB SWSEpoch
DeltaNOTone=Restrict(ts(sort([Range(tDeltaT2)])),SWSEpoch-Tone_Epoch);

i=1;
for num=InfoLFP.channel(1):InfoLFP.channel(end);
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP_dMoCx=PlotRipRaw(LFP,Range(DeltaNOTone)/1E4,1000);close
    rawLFP_dMoCx{i}=LFP_dMoCx;
    i=i+1;
    disp(['channel # ',num2str(num),' > done']) 
end
save rawLFP_Delta rawLFP_dMoCx
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
load DeltaPFCx
Epoch=intervalSet(Tone-1E4,Tone+1E4);
Tone_Epoch=mergeCloseIntervals(Epoch,1);
load StateEpochSB SWSEpoch
DeltaNOTone=Restrict(ts(sort([Range(tDeltaT2)])),SWSEpoch-Tone_Epoch);

i=1;
for num=InfoLFP.channel(1):InfoLFP.channel(end);
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP_dPFCx=PlotRipRaw(LFP,Range(DeltaNOTone)/1E4,1000);close
    rawLFP_dPFCx{i}=LFP_dPFCx;
    i=i+1;
    disp(['channel # ',num2str(num),' > done']) 
end
save rawLFP_Delta -append rawLFP_dPFCx
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
load DeltaPaCx
Epoch=intervalSet(Tone-1E4,Tone+1E4);
Tone_Epoch=mergeCloseIntervals(Epoch,1);
load StateEpochSB SWSEpoch
DeltaNOTone=Restrict(ts(sort([Range(tDeltaT2)])),SWSEpoch-Tone_Epoch);

i=1;
for num=InfoLFP.channel(1):InfoLFP.channel(end);
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP_dPaCx=PlotRipRaw(LFP,Range(DeltaNOTone)/1E4,1000);close
    rawLFP_dPaCx{i}=LFP_dPaCx;
    i=i+1;
    disp(['channel # ',num2str(num),' > done']) 
end
save rawLFP_Delta -append rawLFP_dPaCx
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
if plo==1;
%--------------------------------------------------------------------------
    PFCx=1;dHPC=1;NRT=1;PaCx=1;MoCx=1;Bulb=1;
    decal=500;
    
    figure,
    for i=1:32
        a=rawLFP_Tone{i};
        hold on, plot(a(:,1),a(:,2)+i*500,'b','linewidth',1)
    end
    
    figure,
    for i=1:32
        a=rawLFP_Tone{i};
        if strcmp('PFCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'r','linewidth',2)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'k','linewidth',1)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('MoCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'r','linewidth',2)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'k','linewidth',1)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('PaCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'r','linewidth',2)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'k','linewidth',1)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('dHPC', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'r','linewidth',2)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'k','linewidth',1)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('Bulb', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'r','linewidth',2)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'k','linewidth',1)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('NRT', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'r','linewidth',2)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'k','linewidth',1)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            end
        end
    end
    xlabel('Raw LFP Tone')
    
    
    figure,
    for i=1:32
        a=rawLFP_dPFCx{i};
        if strcmp('PFCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'r','linewidth',2)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'k','linewidth',1)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('MoCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'r','linewidth',2)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'k','linewidth',1)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('PaCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'r','linewidth',2)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'k','linewidth',1)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('dHPC', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'r','linewidth',2)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'k','linewidth',1)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('Bulb', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'r','linewidth',2)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'k','linewidth',1)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('NRT', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'r','linewidth',2)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'k','linewidth',1)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            end
        end
    end
    xlabel('Raw LFP Delta PFCx')
    
    figure,
    for i=1:32
        a=rawLFP_dPaCx{i};
        if strcmp('PFCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'r','linewidth',2)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'k','linewidth',1)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('MoCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'r','linewidth',2)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'k','linewidth',1)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('PaCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'r','linewidth',2)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'k','linewidth',1)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('dHPC', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'r','linewidth',2)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'k','linewidth',1)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('Bulb', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'r','linewidth',2)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'k','linewidth',1)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('NRT', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'r','linewidth',2)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'k','linewidth',1)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            end
        end
    end
    xlabel('Raw LFP Delta PaCx')
    
    figure,
    for i=1:32
        a=rawLFP_dMoCx{i};
        if strcmp('PFCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'r','linewidth',2)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,1:2)
                hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'k','linewidth',1)
                hold on, title('Prefrontal Cortex')
                PFCx=PFCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('MoCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'r','linewidth',2)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,3)
                hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'k','linewidth',1)
                hold on, title('Motor Cortex')
                MoCx=MoCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('PaCx', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'r','linewidth',2)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,4)
                hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'k','linewidth',1)
                hold on, title('Parietal Cortex')
                PaCx=PaCx+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('dHPC', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'r','linewidth',2)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,5)
                hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'k','linewidth',1)
                hold on, title('Hippocampus')
                dHPC=dHPC+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('Bulb', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'r','linewidth',2)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,7)
                hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'k','linewidth',1)
                hold on, title('Bulb')
                Bulb=Bulb+1;
                hold on, xlim([-1 1])
            end
        end
        if strcmp('NRT', InfoLFP.structure(i))
            if InfoLFP.depth(i)==0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'r','linewidth',2)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            elseif InfoLFP.depth(i)>0
                hold on, subplot(7,1,6)
                hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'k','linewidth',1)
                hold on, title('NRT')
                NRT=NRT+1;
                hold on, xlim([-1 1])
            end
        end
    end
    xlabel('Raw LFP Delta MoCx')
    
end
            
            
            
            