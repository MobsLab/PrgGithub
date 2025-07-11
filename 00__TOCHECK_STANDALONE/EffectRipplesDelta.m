%EffectRipplesDelta


par=0;


if par
    load DeltaPaCx;  
    %%channels LFP PaCx
    a=13; b=2; c=2; 
else
    load DeltaPFCx; 
    %%channels LFP PFCx
    a=4; b=9; c=6;
end



eval(['load(''LFPData/LFP',num2str(a),'.mat'')'])
[Md,Td]=PlotRipRaw(LFP,Range(tDeltaT2,'s'),500);close
[Mr,Tr]=PlotRipRaw(LFP,Rip(:,2),500);close
LFPd=LFP;
eval(['load(''LFPData/LFP',num2str(b),'.mat'')'])
[Md2,Td2]=PlotRipRaw(LFP,Range(tDeltaT2,'s'),500);close
[Mr2,Tr2]=PlotRipRaw(LFP,Rip(:,2),500);close
figure, plot(Md(:,1),Md(:,2),'k','linewidth',2), hold on, plot(Md2(:,1),Md2(:,2),'b','linewidth',2), yl=ylim; hold on,line([0 0],yl,'color','r')
if par
title('delta waves, Par superficial vs. Par deep')
else
    title('delta waves, Pfc superficial vs. Pfc deep')
end

figure, plot(Mr(:,1),Mr(:,2),'k','linewidth',2), hold on, plot(Mr2(:,1),Mr2(:,2),'b','linewidth',2), yl=ylim; hold on,line([0 0],yl,'color','r')
if par
    title('ripples, Par superficial vs. Par deep')
else
    title('ripples, Pfc superficial vs. Pfc deep')
end

[Mdiff,Tdiff]=PlotRipRaw(tsd(Range(LFP),Data(LFPd)-Data(LFP)),Rip(:,2),500);close
% figure, subplot(3,1,1),imagesc(Tr), subplot(3,1,2),imagesc(Tr2),subplot(3,1,3),imagesc(Tdiff)
% title('LFP')

[BE,id]=sort(mean(Tdiff(:,630:670),2));
figure, subplot(3,2,1),imagesc(Tr), caxis([-6000 6000]),subplot(3,2,3),imagesc(Tr2),caxis([-6000 6000]),subplot(3,2,5),imagesc(Tdiff),caxis([-6000 6000])
title('Ripples, LFP')
subplot(3,2,2),imagesc(Tr(id,:)), caxis([-6000 6000]),subplot(3,2,4),imagesc(Tr2(id,:)),caxis([-6000 6000]),subplot(3,2,6),imagesc(Tdiff(id,:)),caxis([-6000 6000])
title('Ripples, LFP')

[Mdiffb,Tdiffb]=PlotRipRaw(tsd(Range(LFP),Data(LFPd)-Data(LFP)),Range(tDeltaT2,'s'),500);close
[BE,idb]=sort(mean(Tdiffb(:,630:670),2));
figure, subplot(3,2,1),imagesc(Td), caxis([-6000 6000]),subplot(3,2,3),imagesc(Td2),caxis([-6000 6000]),subplot(3,2,5),imagesc(Tdiffb),caxis([-6000 6000])
title('Delta, LFP')
subplot(3,2,2),imagesc(Td(idb,:)), caxis([-6000 6000]),subplot(3,2,4),imagesc(Td2(idb,:)),caxis([-6000 6000]),subplot(3,2,6),imagesc(Tdiffb(idb,:)),caxis([-6000 6000])
title('Delta, LFP')




eval(['load(''LFPData/LFP',num2str(a),'.mat'')'])
[Md3,Td3]=PlotRipRaw(LFP,Range(tDeltaT2,'s'),500);close
[Mr3,Tr3]=PlotRipRaw(LFP,Rip(:,2),500);close
LFPd=LFP;
eval(['load(''LFPData/LFP',num2str(c),'.mat'')'])
[Md4,Td4]=PlotRipRaw(LFP,Range(tDeltaT2,'s'),500);close
[Mr4,Tr4]=PlotRipRaw(LFP,Rip(:,2),500);close
figure, plot(Md3(:,1),Md3(:,2),'k','linewidth',2), hold on, plot(Md4(:,1),Md4(:,2),'b','linewidth',2), yl=ylim; hold on,line([0 0],yl,'color','r')
if par
    title('delta waves, ECoG Par vs. Par deep')
else
    title('delta waves, ECoG Pfc vs. Pfc deep')
end

    figure, plot(Mr3(:,1),Mr3(:,2),'k','linewidth',2), hold on, plot(Mr4(:,1),Mr4(:,2),'b','linewidth',2), yl=ylim; hold on,line([0 0],yl,'color','r')
if par
    title('ripples, ECoG Par vs. Par deep')
else
        title('ripples, ECoG Pfc vs. Pfc deep')
end

[Mdiff2,Tdiff2]=PlotRipRaw(tsd(Range(LFP),Data(LFPd)-Data(LFP)),Rip(:,2),500);close
[BE,id2]=sort(mean(Tdiff2(:,630:670),2));
figure, subplot(3,2,1),imagesc(Tr3), caxis([-6000 6000]),subplot(3,2,3),imagesc(Tr4),caxis([-6000 6000]),subplot(3,2,5),imagesc(Tdiff2),caxis([-6000 6000])
title('Ripples, EcoG')
subplot(3,2,2),imagesc(Tr3(id2,:)), caxis([-6000 6000]),subplot(3,2,4),imagesc(Tr4(id2,:)),caxis([-6000 6000]),subplot(3,2,6),imagesc(Tdiff2(id2,:)),caxis([-6000 6000])
title('Ripples, EcoG')

[Mdiff2b,Tdiff2b]=PlotRipRaw(tsd(Range(LFP),Data(LFPd)-Data(LFP)),Range(tDeltaT2,'s'),500);close
[BE,id2b]=sort(mean(Tdiff2b(:,630:670),2));
figure, subplot(3,2,1),imagesc(Td3), caxis([-6000 6000]),subplot(3,2,3),imagesc(Td4),caxis([-6000 6000]),subplot(3,2,5),imagesc(Tdiff2b),caxis([-6000 6000])
title('Delta, EcoG')
subplot(3,2,2),imagesc(Td3(id2b,:)), caxis([-6000 6000]),subplot(3,2,4),imagesc(Td4(id2b,:)),caxis([-6000 6000]),subplot(3,2,6),imagesc(Tdiff2b(id2b,:)),caxis([-6000 6000])
title('Delta, EcoG')




load SpindlesRipples LFPh
[MR1,TR1]=PlotRipRaw(LFPh{1},Rip(:,2),500);close
[MR2,TR2]=PlotRipRaw(LFPh{2},Rip(:,2),500);close
[MR3,TR3]=PlotRipRaw(LFPh{3},Rip(:,2),500);close
figure, plot(MR1(:,1),MR1(:,2),'k','linewidth',2), 
hold on, plot(MR2(:,1),MR2(:,2),'b','linewidth',2), 
hold on, plot(MR3(:,1),MR3(:,2),'r','linewidth',2), 
yl=ylim; hold on,line([0 0],yl,'color','r')
title('ripples, Hippocampus')


[MR1d,TR1d]=PlotRipRaw(LFPh{1},Range(tDeltaT2,'s'),500);close
[MR2d,TR2d]=PlotRipRaw(LFPh{2},Range(tDeltaT2,'s'),500);close
[MR3d,TR3d]=PlotRipRaw(LFPh{3},Range(tDeltaT2,'s'),500);close
figure, plot(MR1d(:,1),MR1d(:,2),'k','linewidth',2), 
hold on, plot(MR2d(:,1),MR2d(:,2),'b','linewidth',2), 
hold on, plot(MR3d(:,1),MR3d(:,2),'r','linewidth',2), 
yl=ylim; hold on,line([0 0],yl,'color','r')
title('delta waves, Hippocampus')


if 1
    figure,
for i=1:9
subplot(1,9,i), plot(Mdiff(:,1),mean(Tdiff(id((i-1)*200+1:min(i*200,length(id))),:)),'g','linewidth',2)
hold on
plot(Mr2(:,1),mean(Tr2(id((i-1)*200+1:min(i*200,length(id))),:)),'b')
plot(Mr(:,1),mean(Tr(id((i-1)*200+1:min(i*200,length(id))),:)),'k')
title(num2str(i*200))
end

figure,
for i=1:9
subplot(1,9,i), plot(MR1(:,1),mean(TR1(id((i-1)*200+1:min(i*200,length(id))),:)),'k','linewidth',2)
hold on
plot(MR2(:,1),mean(TR2(id((i-1)*200+1:min(i*200,length(id))),:)),'b','linewidth',2)
plot(MR3(:,1),mean(TR3(id((i-1)*200+1:min(i*200,length(id))),:)),'r','linewidth',2)
title(num2str(i*200))
% xlim([-0.08 0.08])
end


end

    
LFPres=ResampleTSD(tsd(Range(LFPd),Data(LFP)-Data(LFPd)),100);
Filt_LFP = FilterLFP(LFPres, [1 5], 1024);
Filt_LFP=Restrict(Filt_LFP,SWSEpoch-NoiseEpoch-GndNoiseEpoch);
% get threshold
% for thD=[1.5,1.75,2,2.25,2.5,3]        
thD=3;
DetectThresholdP=+mean(Data(Filt_LFP))+thD*std(Data(Filt_LFP));
DetectThresholdT=-mean(Data(Filt_LFP))-thD*std(Data(Filt_LFP));
TdiffDP=[];
TdiffDT=[];
clear PeaksT PeaksP tDeltatempT tDeltatempP
RippleEpoch=intervalSet((Rip(:,2)-0.5)*1e4,(Rip(:,2)+0.5)*1e4);
%see if there are peaks in the triggered data
for k=1:length(start(RippleEpoch))
    Rdiff=Data(Restrict(Filt_LFP,subset(RippleEpoch,k)))';
    RdiffT=Range(Restrict(Filt_LFP,subset(RippleEpoch,k)))';
 de = diff(Rdiff);
  de1 = [de 0];
  de2 = [0 de];
  %finding peaks
  upPeaksIdx = find(de1 < 0 & de2 > 0);
  downPeaksIdx = find(de1 > 0 & de2 < 0);
  PeaksIdx = [upPeaksIdx downPeaksIdx];
  PeaksIdx = sort(PeaksIdx);
  Peaks = Rdiff(PeaksIdx);
  tDeltatemp= RdiffT(PeaksIdx);
  idsT=find((Peaks<DetectThresholdT));
  idsP=find((Peaks>DetectThresholdP));
  tDeltatempT{k}=tDeltatemp(idsT)/1e4-Rip(k,2);
tDeltatempP{k}=tDeltatemp(idsP)/1e4 -Rip(k,2);
PeaksT{k}=Peaks(idsT);
PeaksP{k}=Peaks(idsP);


  if size(idsT,2)>1
      TdiffDT=[TdiffDT k];
  end
      if size(idsP,2)>1
      TdiffDP=[TdiffDP k];
      end 
%       figure(5)
%   plot(RdiffT/1e4,Rdiff,'g','linewidth',2)
%  hold on
% 
%  plot(Range(Restrict(LFPd,subset(RippleEpoch,k)),'s'),Data(Restrict(LFP,subset(RippleEpoch,k))),'b','linewidth',2)
%  plot(Range(Restrict(LFPd,subset(RippleEpoch,k)),'s'),Data(Restrict(LFPd,subset(RippleEpoch,k))),'k','linewidth',2)
%  
%   scatter(tDeltatempT{k},PeaksT{k},'r')
%     scatter(tDeltatempP{k},PeaksP{k},'r')
% 
%   pause 
%   clf
end
% figure(6)
% scatter(thD,length(TdiffDT)/length(start(RippleEpoch)),'b')
% hold on
% scatter(thD,length(TdiffDP)/length(start(RippleEpoch)),'r')
% legend('Trough','Peak')
% end
Tdifftot=[TdiffDT TdiffDP];
Tdifftot=unique(Tdifftot);
Tdifftot=sort(Tdifftot);
alltimesP=[];
for k=1:size(TdiffDP,2)
    alltimesP=[alltimesP tDeltatempP{TdiffDP(k)}];
end
alltimesT=[];
for k=1:size(TdiffDT,2)
    alltimesT=[alltimesT tDeltatempP{TdiffDT(k)}];
end
figure, hist(alltimesP,50)
title('dist of Peak times')
figure, hist(alltimesT,50)
title('dist of Trough times')
[MdD,TdD]=PlotRipRaw(LFPd,Rip(Tdifftot,2),500);
[MsD,TsD]=PlotRipRaw(LFP,Rip(Tdifftot,2),500);
[MfD,TfD]=PlotRipRaw(Filt_LFP,Rip(Tdifftot,2),500);

figure
 plot(MdD(:,1),MdD(:,2),'k','linewidth',2)
hold on
plot(MsD(:,1),MsD(:,2),'b','linewidth',2)
plot(MfD(:,1),MfD(:,2),'g','linewidth',2)

for k=1:size(TdiffDT,2)
scatter( tDeltatempT{TdiffDT(k)}, PeaksT{TdiffDT(k)},50,'r')
end
for k=1:size(TdiffDP,2)
scatter( tDeltatempP{TdiffDP(k)}, PeaksP{TdiffDP(k)},'r')
end
title(strcat('Peak + Trough th=',num2str(thD),' events=',num2str(length(Tdifftot))))


[MdD,TdD]=PlotRipRaw(LFPd,Rip(TdiffDT,2),500);
[MsD,TsD]=PlotRipRaw(LFP,Rip(TdiffDT,2),500);
[MfD,TfD]=PlotRipRaw(Filt_LFP,Rip(TdiffDT,2),500);

figure
 plot(MdD(:,1),MdD(:,2),'k','linewidth',2)
hold on
plot(MsD(:,1),MsD(:,2),'b','linewidth',2)
plot(MfD(:,1),MfD(:,2),'g','linewidth',2)

for k=1:size(TdiffDT,2)
scatter( tDeltatempT{TdiffDT(k)}, PeaksT{TdiffDT(k)},50,'r')
end
title(strcat('Trough  th=',num2str(thD),' events=',num2str(length(Tdifftot))))

[MdD,TdD]=PlotRipRaw(LFPd,Rip(TdiffDP,2),500);
[MsD,TsD]=PlotRipRaw(LFP,Rip(TdiffDP,2),500);
[MfD,TfD]=PlotRipRaw(Filt_LFP,Rip(TdiffDP,2),500);

figure
 plot(MdD(:,1),MdD(:,2),'k','linewidth',2)
hold on
plot(MsD(:,1),MsD(:,2),'b','linewidth',2)
plot(MfD(:,1),MfD(:,2),'g','linewidth',2)
for k=1:size(TdiffDP,2)
scatter( tDeltatempP{TdiffDP(k)}, PeaksP{TdiffDP(k)},'r')
end
title(strcat('Peaks  th=',num2str(thD),' events=',num2str(length(Tdifftot))))
