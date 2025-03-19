%%FigCaracterisationBciTonesEffectOneNight
% 25.09.2019 KJ
%
% Infos
%   
%
% see
%     CaracterisationBciTonesEffectOneNight
%
%



clear
load(fullfile(FolderDeltaDataKJ,'CaracterisationBciTonesEffectOneNight.mat'))

labels = {'PFC deep', 'PFC', 'PFC sup'};
color_channels = {'r',[1 0 0.5], 'b'};
factorLFP = 0.195;
XL = [-700 700];
YL = [-260 420];
border = size(Data(pfc_rasters.success),2);


%Mat
mua_x = Range(pfc_rasters.success)/10;

mat_success = Data(pfc_rasters.success)';
vmean = mean(mat_success(:,mua_x>0 & mua_x<200),2);
[~,idx] = sort(vmean);
raster_mat = [mat_success(idx,:) ; Data(pfc_rasters.failed)'];



%% PLOT - figure2 : Raster + Average LFP (many PFC depth)


figure, hold on
%LFP average - not inducing
s1=subplot(13,1,1:3); hold on
for ch=1:length(met_pfc.failed)
    h(ch) = plot(met_pfc.failed{ch}(:,1), met_pfc.failed{ch}(:,2)*factorLFP, 'color', color_channels{ch}, 'Linewidth',2);
end
set(gca, 'YTick',-200:200:400,'Xticklabel',{[]},'XLim',XL, 'YLim',YL,'fontsize',18);
line([0 0], ylim,'color',[0.6 0.6 0.6]), hold on
% legend(h, labels),


%MUA raster
s2=subplot(13,1,4:10); hold on
imagesc(mua_x, 1:size(raster_mat,1), raster_mat), hold on

axis xy, ylabel('# sound'), hold on
set(gca,'YLim', [0 size(raster_mat,1)], 'XLim',XL, 'Yticklabel',{[]},'Xticklabel',{[]},'fontsize',18);
line([0 0],ylim,'linewidth',2,'color',[0.7 0.7 0.7]);
% line(xlim, [border border],'color','k'), hold on
%color map style
caxis([0 3])
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);
hb = colorbar('location','eastoutside'); hold on


%LFP average - inducing
s3=subplot(13,1,11:13); hold on
for ch=1:length(met_pfc.success)
    h(ch) = plot(met_pfc.success{ch}(:,1), met_pfc.success{ch}(:,2)*factorLFP, 'color', color_channels{ch}, 'Linewidth',2);
end
set(gca, 'YTick',-200:200:400,'XLim',XL, 'YLim',YL,'fontsize',18);
line([0 0], ylim,'color',[0.6 0.6 0.6]), hold on


%align subplots
s1Pos = get(s1,'position');
s2Pos = get(s2,'position');
s2Pos(3) = s1Pos(3);
set(s2,'position',s2Pos);



%% Plot difference
%LFP average - inducing
figure, hold on
s3=subplot(13,1,1:3); hold on
for ch=1:length(met_pfc.success)
    h(ch) = plot(met_pfc.success{ch}(:,1), (met_pfc.success{ch}(:,2)-met_pfc.failed{ch}(:,2))*factorLFP, 'color', color_channels{ch}, 'Linewidth',2);
end
set(gca, 'YTick',-200:200:400,'XLim',XL, 'YLim',YL,'fontsize',18);
line([0 0], ylim,'color',[0.6 0.6 0.6]), hold on


%align subplots
s1Pos = get(s1,'position');
s2Pos = get(s2,'position');
s2Pos(3) = s1Pos(3);
set(s2,'position',s2Pos);


