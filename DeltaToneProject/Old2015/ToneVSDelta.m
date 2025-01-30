PFCx=1;dHPC=1;NRT=1;PaCx=1;MoCx=1;Bulb=1;
decal=500;


figure,
for i=1:32
    music=rawLFP_Tone{i};
    DeltAA=rawLFP_dMoCx{i};
    hold on, plot(music(:,1),music(:,2)+i*500,'g','linewidth',1)
    hold on, plot(DeltAA(:,1)+0.1,DeltAA(:,2)+i*500,'k','linewidth',1)
end

figure,
for i=1:32
    a=rawLFP_Tone{i};
    b=rawLFP_dPaCx{i};
    if strcmp('PFCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,1:2)
            hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'k','linewidth',2)
            hold on, plot(b(:,1),b(:,2)+PFCx*(decal*3),'r','linewidth',2)
            hold on, title('Prefrontal Cortex')
            PFCx=PFCx+1;
            hold on, xlim([-1 1])
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,1:2)
            hold on, plot(a(:,1),a(:,2)+PFCx*(decal*3),'k','linewidth',1)
            hold on, plot(b(:,1),b(:,2)+PFCx*(decal*3),'r','linewidth',1)
            hold on, title('Prefrontal Cortex')
            PFCx=PFCx+1;
            hold on, xlim([-1 1])
        end
    end
    if strcmp('MoCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,3)
            hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'k','linewidth',2)
            hold on, plot(b(:,1),b(:,2)+MoCx*(decal*3),'r','linewidth',2)
            hold on, title('Motor Cortex')
            MoCx=MoCx+1;
            hold on, xlim([-1 1])
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,3)
            hold on, plot(a(:,1),a(:,2)+MoCx*(decal*3),'k','linewidth',1)
            hold on, plot(b(:,1),b(:,2)+MoCx*(decal*3),'r','linewidth',1)
            hold on, title('Motor Cortex')
            MoCx=MoCx+1;
            hold on, xlim([-1 1])
        end
    end
    if strcmp('PaCx', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,4)
            hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'k','linewidth',2)
            hold on, plot(b(:,1),b(:,2)+PaCx*(decal*3),'r','linewidth',2)
            hold on, title('Parietal Cortex')
            PaCx=PaCx+1;
            hold on, xlim([-1 1])
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,4)
            hold on, plot(a(:,1),a(:,2)+PaCx*(decal*3),'k','linewidth',1)
            hold on, plot(b(:,1),b(:,2)+PaCx*(decal*3),'r','linewidth',1)
            hold on, title('Parietal Cortex')
            PaCx=PaCx+1;
            hold on, xlim([-1 1])
        end
    end
    if strcmp('dHPC', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,5)
            hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'k','linewidth',2)
            hold on, plot(b(:,1),b(:,2)+dHPC*(decal*3),'r','linewidth',2)
            hold on, title('Hippocampus')
            dHPC=dHPC+1;
            hold on, xlim([-1 1])
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,5)
            hold on, plot(a(:,1),a(:,2)+dHPC*(decal*3),'k','linewidth',1)
            hold on, plot(b(:,1),b(:,2)+dHPC*(decal*3),'r','linewidth',1)
            hold on, title('Hippocampus')
            dHPC=dHPC+1;
            hold on, xlim([-1 1])
        end
    end
    if strcmp('Bulb', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,7)
            hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'k','linewidth',2)
            hold on, plot(b(:,1),b(:,2)+Bulb*(decal*3),'r','linewidth',2)
            hold on, title('Bulb')
            Bulb=Bulb+1;
            hold on, xlim([-1 1])
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,7)
            hold on, plot(a(:,1),a(:,2)+Bulb*(decal*3),'k','linewidth',1)
            hold on, plot(b(:,1),b(:,2)+Bulb*(decal*3),'r','linewidth',1)
            hold on, title('Bulb')
            Bulb=Bulb+1;
            hold on, xlim([-1 1])
        end
    end
    if strcmp('NRT', InfoLFP.structure(i))
        if InfoLFP.depth(i)==0
            hold on, subplot(7,1,6)
            hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'k','linewidth',2)
            hold on, plot(b(:,1),b(:,2)+NRT*(decal*3),'r','linewidth',2)
            hold on, title('NRT')
            NRT=NRT+1;
            hold on, xlim([-1 1])
        elseif InfoLFP.depth(i)>0
            hold on, subplot(7,1,6)
            hold on, plot(a(:,1),a(:,2)+NRT*(decal*3),'k','linewidth',1)
            hold on, plot(b(:,1),b(:,2)+NRT*(decal*3),'r','linewidth',1)
            hold on, title('NRT')
            NRT=NRT+1;
            hold on, xlim([-1 1])
        end
    end
end


