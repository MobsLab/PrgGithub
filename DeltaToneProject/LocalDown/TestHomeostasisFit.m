%%TestHomeostasisFit
% 08.09.2019 KJ
%
% Infos
%   plot quantif on homeostasis for global, local, fake delta waves
%
% see
%    ParcoursHomeostasieLocalDeltaDensityPlot ParcoursHomeostasieLocalDeltaOccupancy
%




% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasieLocalDeltaOccupancy.mat'))

for p=1:length(homeo_res.path)
    
    for tt=1:homeo_res.nb.tetrodes{p}

        figure, hold on

        

        %global down states
        xdens = homeo_res.down.global.x_intervals{p};
        ydens = homeo_res.down.global.y_density{p};
        xpeaks = homeo_res.down.global.x_peaks{p};
        ypeaks = homeo_res.down.global.y_peaks{p};
        %exponential fit
        [f, gof] = fit(xpeaks, ypeaks,'exp1');
        Hstat.a = f.b;
        Hstat.b = f.a;
        Hstat.R2 = gof.rsquare;
        %double split
        limSplit = 15.5;
        idx1 =  xdens<limSplit;
        idx2 =  xdens>limSplit; 

        subplot(3,2,[1 3]), hold on
        plot(xdens, ydens,'b')
        plot(xdens, homeo_res.down.global.reg0{p},'r.')
        plot(xdens(idx1), homeo_res.down.global.reg1{p}(idx1),'k.')
        plot(xdens(idx2), homeo_res.down.global.reg2{p}(idx2),'k.')
        plot(xdens, f(xdens), 'color', [0 0.5 0])
        
        hold on, scatter(homeo_res.down.global.x_peaks{p}, homeo_res.down.global.y_peaks{p},'r')
        
                
        %table        
        textbox_str = {['Exp (r2= ' num2str(gof.rsquare) ' / b=' num2str(f.b) ') '],...
                       ['1fit (r2= ' num2str(homeo_res.down.global.R2_0{p}) ' / p=' num2str(homeo_res.down.global.p0{p}) ') '],...
                       ['2fit (r2= ' num2str(homeo_res.down.global.R2_1{p}) ' / p=' num2str(homeo_res.down.global.p1{p}) ') '],...
                       ['2fit (r2bis= ' num2str(homeo_res.down.global.R2_2{p}) ' / pbis=' num2str(homeo_res.down.global.p2{p}) ') ']};
        
        subplot(3,2,5), hold on
        textbox_dim = get(subplot(3,2,5),'position');
        delete(subplot(3,2,5))

        annotation(gcf,'textbox',...
        textbox_dim,...
        'String',textbox_str,...
        'LineWidth',1,...
        'HorizontalAlignment','center',...
        'FontWeight','bold',...
        'FitBoxToText','off');
        
        
        %% local down states
        xdens = homeo_res.down.local.x_intervals{p};
        ydens = homeo_res.down.local.y_density{p};
        xpeaks = homeo_res.down.local.x_peaks{p};
        ypeaks = homeo_res.down.local.y_peaks{p};
        %exponential fit
        [f, gof] = fit(xpeaks, ypeaks,'exp1');
        Hstat.a = f.b;
        Hstat.b = f.a;
        Hstat.R2 = gof.rsquare;
        %double split
        limSplit = 15.5;
        idx1 =  xdens<limSplit;
        idx2 =  xdens>limSplit; 

        subplot(3,2,[2 4]), hold on
        plot(xdens, ydens,'b')
        plot(xdens, homeo_res.down.local.reg0{p,tt},'r.')
        plot(xdens(idx1), homeo_res.down.local.reg1{p,tt}(idx1),'k.')
        plot(xdens(idx2), homeo_res.down.local.reg2{p,tt}(idx2),'k.')
        plot(xdens, f(xdens), 'color', [0 0.5 0])
        
        hold on, scatter(homeo_res.down.local.x_peaks{p,tt}, homeo_res.down.local.y_peaks{p,tt},'r')
        
        %table        
        textbox_str = {['Exp (r2= ' num2str(gof.rsquare) ' / b=' num2str(f.b) ') '],...
                       ['1fit (r2= ' num2str(homeo_res.down.local.R2_0{p,tt}) ' / p=' num2str(homeo_res.down.local.p0{p,tt}) ') '],...
                       ['2fit (r2= ' num2str(homeo_res.down.local.R2_1{p,tt}) ' / p=' num2str(homeo_res.down.local.p1{p,tt}) ') '],...
                       ['2fit (r2bis= ' num2str(homeo_res.down.local.R2_2{p,tt}) ' / pbis=' num2str(homeo_res.down.local.p2{p,tt}) ') ']};
       
        subplot(3,2,6), hold on
        textbox_dim = get(subplot(3,2,6),'position');
        delete(subplot(3,2,6))

        annotation(gcf,'textbox',...
        textbox_dim,...
        'String',textbox_str,...
        'LineWidth',1,...
        'HorizontalAlignment','center',...
        'FontWeight','bold',...
        'FitBoxToText','off');
        
        
        



        
    end
end
