% 05.04.2020
figure;
load('/Users/JulieLefort/Dropbox/MOBS_workingON/Julie/Spectro_ForFig_05-05-2020/259-EXT-24h/Spectrum8.mat')
subplot(3,1,1)
imagesc(t,f,log10(Sp'))
caxis([2 7])

load('/Users/JulieLefort/Dropbox/MOBS_workingON/Julie/Spectro_ForFig_05-05-2020/259-EXT-24h/Spectrum13.mat')
subplot(3,1,2)
imagesc(t,f,log10(Sp'))
caxis([2 5.5])

subplot(3,1,3)
load('/Users/JulieLefort/Dropbox/MOBS_workingON/Julie/Spectro_ForFig_05-05-2020/259-EXT-24h/Cohgram_13_8.mat')
imagesc(t,f,C')
caxis([0.6 1])

load('/Users/JulieLefort/Dropbox/MOBS_workingON/Julie/Spectro_ForFig_05-05-2020/259-EXT-24h/behavResources.mat')

for k=1:3
    subplot(3,1,k), hold on,
    axis xy
    colormap('jet')
    xlim([1100 1400])
    plot([Start(FreezeEpoch) End(FreezeEpoch)]*1E-4,[12 12],'-k','LineWidth',2)
    colorbar
end
cd('/Users/JulieLefort/Dropbox/MOBS_workingON/Julie/Spectro_ForFig_05-05-2020/')

saveas(gcf,'Spectro_cohero_ex_fig2.png')