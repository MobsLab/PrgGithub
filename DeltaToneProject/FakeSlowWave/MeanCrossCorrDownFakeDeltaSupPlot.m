%%MeanCrossCorrDownFakeDeltaSupPlot
% 05.09.2019 KJ
%
% Infos
%   script about real and fake slow waves : MUA and down
%
% see
%    MeanCrossCorrDownFakeDeltaSup 


% load
clear
load(fullfile(FolderDeltaDataKJ,'MeanCrossCorrDownFakeDeltaSup.mat'))

animals = unique(cross_res.name);
smoothing = 1;
normalized = 1;


cross_y.ondown.all  = [];
cross_y.ondown.good = [];
cross_y.ondown.fake = [];
cross_y.ondelta.all  = [];
cross_y.ondelta.good = [];
cross_y.ondelta.fake = [];

%loop
for m=1:length(animals)
    
    mouse_y.ondown.all  = [];
    mouse_y.ondown.good = [];
    mouse_y.ondown.fake = [];
    mouse_y.ondelta.all  = [];
    mouse_y.ondelta.good = [];
    mouse_y.ondelta.fake = [];

    
    for p=1:length(cross_res.path)
        if strcmpi(cross_res.name{p},animals{m})
            
            %x
            mouse_x.ondown.all = cross_res.ondown.all{p}(:,1);
            mouse_x.ondown.good = cross_res.ondown.good{p}(:,1);
            mouse_x.ondown.fake = cross_res.ondown.fake{p}(:,1);
            
            mouse_x.ondelta.all = cross_res.ondelta.all{p}(:,1);
            mouse_x.ondelta.good = cross_res.ondelta.good{p}(:,1);
            mouse_x.ondelta.fake = cross_res.ondelta.fake{p}(:,1);
            
            
            %normalisation factor
            if normalized
                x_norm = cross_res.ondown.all{p}(:,1)<-300;
                normfact.ondown.all  = mean(cross_res.ondown.all{p}(x_norm,2));
                normfact.ondown.good = mean(cross_res.ondown.good{p}(x_norm,2));
                normfact.ondown.fake = mean(cross_res.ondown.fake{p}(x_norm,2));
                
                normfact.ondelta.all  = mean(cross_res.ondelta.all{p}(x_norm,2));
                normfact.ondelta.good = mean(cross_res.ondelta.good{p}(x_norm,2));
                normfact.ondelta.fake = mean(cross_res.ondelta.fake{p}(x_norm,2));
            else
                normfact.ondown.all =  1; 
                normfact.ondown.good = 1;
                normfact.ondown.fake = 1; 
                
                normfact.ondelta.all =  1; 
                normfact.ondelta.good = 1;
                normfact.ondelta.fake = 1; 
            end
            
            %y
            mouse_y.ondown.all  = [mouse_y.ondown.all runmean(cross_res.ondown.all{p}(:,2) / normfact.ondown.all, smoothing)];
            mouse_y.ondown.good = [mouse_y.ondown.good runmean(cross_res.ondown.good{p}(:,2) / normfact.ondown.good, smoothing)];
            mouse_y.ondown.fake = [mouse_y.ondown.fake runmean(cross_res.ondown.fake{p}(:,2) / normfact.ondown.fake, smoothing)];
            
            mouse_y.ondelta.all  = [mouse_y.ondelta.all runmean(cross_res.ondelta.all{p}(:,2) / normfact.ondelta.all, smoothing)];
            mouse_y.ondelta.good = [mouse_y.ondelta.good runmean(cross_res.ondelta.good{p}(:,2) / normfact.ondelta.good, smoothing)];
            mouse_y.ondelta.fake = [mouse_y.ondelta.fake runmean(cross_res.ondelta.fake{p}(:,2) / normfact.ondelta.fake, smoothing)];
        end
    end
    
    %average per mouse
    cross_y.ondown.all  = [cross_y.ondown.all mean(mouse_y.ondown.all,2)];
    cross_y.ondown.good = [cross_y.ondown.good mean(mouse_y.ondown.good,2)];
    cross_y.ondown.fake = [cross_y.ondown.fake mean(mouse_y.ondown.fake,2)];
    
    cross_y.ondelta.all  = [cross_y.ondelta.all mean(mouse_y.ondelta.all,2)];
    cross_y.ondelta.good = [cross_y.ondelta.good mean(mouse_y.ondelta.good,2)];
    cross_y.ondelta.fake = [cross_y.ondelta.fake mean(mouse_y.ondelta.fake,2)];
    

end

%X
CC.ondown.all(:,1)  = mouse_x.ondown.all;
CC.ondown.good(:,1) = mouse_x.ondown.good;
CC.ondown.fake(:,1) = mouse_x.ondown.fake;

CC.ondelta.all(:,1)  = mouse_x.ondelta.all;
CC.ondelta.good(:,1) = mouse_x.ondelta.good;
CC.ondelta.fake(:,1) = mouse_x.ondelta.fake;

%mean
CC.ondown.all(:,2)  = mean(cross_y.ondown.all,2);
CC.ondown.good(:,2) = mean(cross_y.ondown.good,2);
CC.ondown.fake(:,2) = mean(cross_y.ondown.fake,2);

CC.ondelta.all(:,2)  = mean(cross_y.ondelta.all,2);
CC.ondelta.good(:,2) = mean(cross_y.ondelta.good,2);
CC.ondelta.fake(:,2) = mean(cross_y.ondelta.fake,2);

%std
CC.ondown.all(:,3)  = std(cross_y.ondown.all,0,2) / sqrt(size(cross_y.ondown.all,2));
CC.ondown.good(:,3) = std(cross_y.ondown.good,0,2) / sqrt(size(cross_y.ondown.good,2));
CC.ondown.fake(:,3) = std(cross_y.ondown.fake,0,2) / sqrt(size(cross_y.ondown.fake,2));

CC.ondelta.all(:,3)  = std(cross_y.ondelta.all,0,2) / sqrt(size(cross_y.ondelta.all,2));
CC.ondelta.good(:,3) = std(cross_y.ondelta.good,0,2) / sqrt(size(cross_y.ondelta.good,2));
CC.ondelta.fake(:,3) = std(cross_y.ondelta.fake,0,2) / sqrt(size(cross_y.ondelta.fake,2));

   


%% Plot
fontsize = 22;
color_all = [0.7 0.7 0.7];
color_good = 'b';
color_fake = 'r';

figure, hold on


%On down
subplot(1,2,1), hold on
%error shadow
Hsgood = shadedErrorBar(CC.ondown.good(:,1), CC.ondown.good(:,2), CC.ondown.good(:,3),{},0.4);
Hsfake = shadedErrorBar(CC.ondown.fake(:,1), CC.ondown.fake(:,2), CC.ondown.fake(:,3),{},0.4);
Hsgood.patch.FaceColor = color_good;
Hsfake.patch.FaceColor = color_fake;
%mean curves
h(1) = plot(CC.ondown.good(:,1), CC.ondown.good(:,2), 'color', color_good, 'linewidth',2);
h(2) = plot(CC.ondown.fake(:,1), CC.ondown.fake(:,2), 'color', color_fake, 'linewidth',2);
%properties
set(gca,'YLim', [0 8],'XLim',[-600 600],'Fontsize',fontsize);

line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
legend(h,'25% highest inversion', '25% lowest inversion');
xlabel('time from down states (ms)'),
ylabel('Normalized occurence of delta waves'), 


%On delta
subplot(1,2,2), hold on
%error shadow
Hsgood = shadedErrorBar(CC.ondelta.good(:,1), CC.ondelta.good(:,2), CC.ondelta.good(:,3),{},0.4);
Hsfake = shadedErrorBar(CC.ondelta.fake(:,1), CC.ondelta.fake(:,2), CC.ondelta.fake(:,3),{},0.4);
Hsgood.patch.FaceColor = color_good;
Hsfake.patch.FaceColor = color_fake;
%mean curves
h(1) = plot(CC.ondelta.good(:,1), CC.ondelta.good(:,2), 'color', color_good, 'linewidth',2);
h(2) = plot(CC.ondelta.fake(:,1), CC.ondelta.fake(:,2), 'color', color_fake, 'linewidth',2);
%properties
set(gca,'YLim', [0 11],'XLim',[-600 600],'Fontsize',fontsize);

line([0 0], ylim,'Linewidth',1,'color',[0.5 0.5 0.5]), hold on
legend(h,'25% highest inversion', '25% lowest inversion');
xlabel('time from delta waves (ms)'),
ylabel('Normalized occurence of down states'), 










