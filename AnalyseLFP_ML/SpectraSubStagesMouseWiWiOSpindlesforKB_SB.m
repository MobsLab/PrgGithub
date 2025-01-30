cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170204/ProjectEmbReact_M510_20170204_BaselineSleep
channels = [3,8,12,16,20];
cols = [0,0,0.8;0.2,0.4,1;0.4,0.2,0.8;1,0,0;0,0,0];
clf
for ch = 1:length(channels)
  load(['Spectra/Specg_ch',num2str(channels(ch)),'.mat'])
  sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
  subplot(1,5,ch)
  for ep = 1:5
      plot(Spectro{3}, log(nanmean(Data(Restrict(sptsd,Epoch{ep})))),'color',cols(ep,:),'linewidth',2), hold on
  end
  title(num2str(channels(ch)))
    xlim([0 20])
    if ch==1
        legend('N1','N2','N3','REM','Wake')
    end

end
