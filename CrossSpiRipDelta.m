function [Ct,Bt]=CrossSpiRipDelta(spi,rip,tDeltaT2,tDeltaP2,Epoch1,Epoch2)

%load behavResources

nbin=1000; %default 1000
bin=50;%default 50
try
    Epoch1;
    Epoch2;
catch
    
    try
        Epoch2=CPEpoch;
    catch
        Epoch2=DPCPXEpoch;
    end        

    Epoch1=or(PreEpoch,VEHEpoch);
end

Rip(:,1)=Range(rip,'s');
Rip(:,2)=Range(rip,'s');


        figure('color',[1 1 1])
try
        [C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(spi,Epoch1)),nbin,bin); 
        Ct{1}=C;
        Bt{1}=B;
        
        subplot(2,4,1), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        title('Ripples versus Spindles'); ylabel('Epoch1')
      xlim([B(1)/1E3 B(end)/1E3])
end
try
clear C
clear B
        [C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(spi,Epoch2)),nbin,bin); 
         Ct{2}=C;
        Bt{2}=B;
        subplot(2,4,5), bar(B/1E3,C,1,'k'),yl=ylim; hold on, line([0 0],yl,'color','r')
        %title(['Channel: ',ch])
        xlim([B(1)/1E3 B(end)/1E3]); ylabel('Epoch2')
end
try
clear C
clear B
        [C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(spi,Epoch1)),20,50); 
         Ct{3}=C;
        Bt{3}=B;
        subplot(2,4,2), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        title('Ripples versus Spindles')
        xlim([B(1)/1E3 B(end)/1E3])
end
try
       clear C
clear B
[C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(spi,Epoch2)),20,50); 
         Ct{4}=C;
        Bt{4}=B;
        subplot(2,4,6), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        xlim([B(1)/1E3 B(end)/1E3])
        %title(['Channel: ',InfoLFP.structure(InfoLFP.channel==i)])
end
try
clear C
clear B
[C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(tDeltaT2,Epoch1)),nbin,bin); 
         Ct{5}=C;
        Bt{5}=B;
        subplot(2,4,3), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        xlim([B(1)/1E3 B(end)/1E3])
        title('Ripples versus DeltaT2')
end
try
clear C
clear B
[C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(tDeltaT2,Epoch2)),nbin,bin); 
         Ct{6}=C;
        Bt{6}=B;
        subplot(2,4,7), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        %ylim([0 0.3])
        xlim([B(1)/1E3 B(end)/1E3])
end
try
clear C
clear B
[C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(tDeltaP2,Epoch1)),nbin,bin);
          Ct{7}=C;
        Bt{7}=B;
        subplot(2,4,4), bar(B/1E3,C,1,'k'),yl=ylim; hold on, line([0 0],yl,'color','r')
        %ylim([0 0.3])
        xlim([B(1)/1E3 B(end)/1E3])
        title('Ripples versus DeltaP2')
end
try
       clear C
clear B
[C,B]=CrossCorrKB(Rip(:,2)*1E4,Range(Restrict(tDeltaP2,Epoch2)),nbin,bin); 
         Ct{8}=C;
        Bt{8}=B;
        subplot(2,4,8), bar(B/1E3,C,1,'k'),yl=ylim; hold on, line([0 0],yl,'color','r')
        %ylim([0 0.3])
        xlim([B(1)/1E3 B(end)/1E3])
end
        set(gcf,'position',[69         477        1383         419])
       
        % add by Marie 5june2015
%         try
%             folderfig='/home/vador/Dropbox/MOBsProjetBULB/FiguresDataClub_8juin2015';
%             nameFig='/CrossCorrML';
%             while exist([folderfig,nameFig,'.eps'],'file')
%                 nameFig=[nameFig,'0'];
%             end
%             subplot(2,4,1), ylabel('S12')
%             subplot(2,4,5), ylabel('S34')
%             subplot(2,4,6), title(pwd)
%             disp(['saving in ',folderfig,nameFig])
%             saveFigure(gcf,nameFig(2:end),folderfig); pause(2)
%         end
%         
        