%%PethNeuronsAtTransitionsPlot
% 03.07.2018 KJ
%
%
%   Look at the response of neurons on tones and transitions
%
% see
%   PethNeuronsAtTransitions_KJ 
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'PethNeuronsAtTransitions_KJ.mat'))

p=2;
speth = peth_res.speth{p};

MatEndo = zeros(length(speth.endo.x), length(speth.endo.y{1}));
MatIndu = zeros(length(speth.indu.x), length(speth.indu.y{1}));
for i=1:length(speth.endo.x)
    MatEndo(i,:) = speth.endo.y{i}' / max(speth.endo.y{i});
    MatIndu(i,:) = speth.indu.y{i}' / max(speth.indu.y{i});
end

x_endo = speth.endo.x{1};
x_indu = speth.indu.x{1};


%% PLOT
figure, hold on

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);


%Endogeneous - raster plot
subplot(2,1,1), hold on
imagesc(x_endo, 1:size(MatEndo,1), MatEndo), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
set(gca,'YLim', [0 size(MatEndo,1)], 'XLim',[-100 100]);
xlabel('time relative up start (s)'), ylabel('#'),
title('Transitions down>up endogeneous')

%Induced - raster plot
subplot(2,1,2), hold on
imagesc(x_indu, 1:size(MatIndu,1), MatIndu), hold on
axis xy, hold on
line([0 0], ylim,'Linewidth',2,'color','w'), hold on
set(gca,'YLim', [0 size(MatIndu,1)], 'XLim',[-100 100]);
xlabel('time relative up start (s)'), ylabel('#'),
title('Transitions down>up induced')


% 
% %% plot
% for p=1:length(peth_res.path)
% 
%     speth = peth_res.speth{p};
% 
%     for i=1:length(speth.endo.x)
%         %endo
%         endo.x_peth{i} = speth.endo.x{i};
%         endo.y_peth{i} = Smooth(speth.endo.y{i},1);
% 
%         xp = endo.x_peth{i}(endo.x_peth{i}>0);
%         yp = endo.y_peth{i}(endo.x_peth{i}>0);
% 
%         endo.masscenter(i) = sum(xp.*yp')/sum(yp);
% 
%         %indu
%         indu.x_peth{i} = speth.indu.x{i};
%         indu.y_peth{i} = Smooth(speth.indu.y{i},1);
% 
%         xp = indu.x_peth{i}(indu.x_peth{i}>0);
%         yp = indu.y_peth{i}(indu.x_peth{i}>0);
% 
%         indu.masscenter(i) = sum(xp.*yp')/sum(yp);
% 
%     end
% 
%     figure, hold on
%     
%     subplot(2,1,1),hold on
%     for i=1:length(speth.endo.x)
%         hold on, plot(endo.x_peth{i}, endo.y_peth{i}),
%     end
%     subplot(2,1,2),hold on
%     for i=1:length(speth.indu.x)
%         hold on, plot(indu.x_peth{i}, indu.y_peth{i}),
%     end
% 
% end
% 
% 
% 
% 
