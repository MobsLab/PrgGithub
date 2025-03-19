% working version
function xx = ft_oe_list_Spont(ss)
% Directory where you stored the data
if isstruct(ss) %a sturcture, recomputing the data
    for i=1:length(ss.experiment)
        dd(i).name=ss.experiment{i};
    end
else
      dd=dir([ss.datapath ss '*']);
end

% Change the directories according to where you stored the data

cfg.channelmapfile = [ss.datapath 'ECoG_channel_map.mat'];
cfg.path = ss.datapath;
cfg.bpath = [cfg.path 'mat_files'];
cfg.node = '100';
cfg.experiment = dd.name;
cfg.runclass = 'NSD';
cfg.ferret = ss.ferret;
if contains(ss.ferret, 'Aspen')
    cfg.numchans = 40;
elseif contains(ss.ferret, 'Mangrove')
    cfg.numchans = 40;    
end
%           cfg.date = dd.date; % This is date of the experiment. It will be released out of the ft_read_oe_data_py.m
      
for i= 1:length(dd)
    disp(['Loading ..... ' char(dd(i).name)]);
    cfg.experiment=dd(i).name;
    [data,cfg] = ft_read_oe_data_py(cfg, dd(2).name, 1);
    xx.runclass{i}=cfg.runclass;
    xx.experiment{i}=cfg.experiment;
    xx.data{i} = data;
end



% function [OK,cfg]=match_mfile1(cfg)
% p=dir(sprintf('M:\\daq\\%s\\%s*',cfg.ferret,cfg.ferret(1)));  %find recording subfolder under animal name 
% OK = 0;
% for i=1:length(p)
%     ff=dir(sprintf('M:\\daq\\%s\\%s\\*.m',cfg.ferret,p(i).name));
%     
%     for f = 1:length(ff)
%         if contains(ff(f).name,cfg.runclass)
%             cfg.mfile = ff(f).name;
%             OK = 1;
%         end
%     end
% end

% function [sti_mat] = get_stigmat(cfg)
% cfg.ferret=strtok(cfg.experiment,'_');
% [~, cfg]=match_mfile1(cfg);
% baphyFile = cfg.mfile;
% cfg.ferret=strtok(cfg.experiment,'_');
% ffn = [cfg.bpath cfg.ferret '/' baphyFile(1:6) '/' baphyFile];
% run(ffn)
% [sti_mat,~,~]=get_frelist(exptevents,exptparams.runclass,exptparams);

% function  figure_design(cfg,outp,ExpoFreq,idX,idF)
% if strcmp(cfg.ferret,'Mangrove')
%     set(gcf, 'Units', 'Inches', 'Position', [0, 0, 15,8], 'PaperUnits', 'Inches', 'PaperSize', [15,8])
%     XIdx = [29,30,31,32];
%     YIdx = [4,8,12,16,17,21,25,29];
% elseif strcmp(cfg.ferret,'Aspen')
%     set(gcf, 'Units', 'Inches', 'Position', [0, 0,8,15], 'PaperUnits', 'Inches', 'PaperSize', [8,15])
%     XIdx = [29,30,31,32];
%     YIdx = [1,5,9,13,20,24,28,32];
% end
% hA = findobj(gcf,'Type','Axes');
% for hh = 1:length(hA)
%     if ~ismember(hh,XIdx)
%         set(hA(hh),'xticklabel',{[]});
%     end
%     
%     if ~ismember(hh,YIdx)
%         set(hA(hh),'yticklabel',{[]});
%     end
%     f=unique(outp.stimat(:,2));
%     f1=f(1)*2.^(0:0.1:log2(f(end)/f(1)));
%     
%     if length(ExpoFreq) > 1
%         
%         for ll = 1:length(ExpoFreq)
%             diff = abs(f1-ExpoFreq(ll));
%             xp(ll) = find(diff == min(diff)) + 0.5;
%         end
%         
%         YMax = max(hA(hh).Children(1).YData);
%         hold on;
%         line(hA(hh),[xp(idX) xp(idX)],[0,YMax],'LineStyle','--','color',rgb('Black'));
%         line(hA(hh),[xp(idF) xp(idF)],[0,YMax],'LineStyle','--','color',rgb('Blue'),'LineWidth',2);
%     else
%         YMax = max(hA(hh).Children(1).YData);
%         hold on;
%         diff = abs(f1-ExpoFreq);
%         xp = find(diff == min(diff)) + 0.5;
%         line(hA(hh),[xp xp],[0,YMax],'LineStyle','--','color',rgb('Black'),'LineWidth',2);
%     end
%     
% end
% 
% 
% set(hA(hh), 'Position', [0.02,0.1,1,0.82])
% 
% function print_fig(cfg,FF)
% Path = 'C:\Users\rupesh\Dropbox\UMD_projects\Daniel_ECoG\Analysis\Figs\';
% fig = gcf;
% fig.PaperPositionMode = 'auto';
% fig_pos = fig.PaperPosition;
% fig.PaperSize = [fig_pos(3) fig_pos(4)];
% print(fig,'-dpng', '-r300', [Path [cfg.experiment 'FreBand' num2str(FF(1)) '-' num2str(FF(2))] '.png'])
% %print(fig,'-dpng', '-r300', [Path [cfg.experiment 'CH2' num2str(FF) '_TST_diff_flt.png']])

% function opt=tunning_sub_channelwise(outp,opt,ch)
% % this is the function to study the tuning in depth
% % For each Channel, we can compute the tuning and test the same for by
% % passing the ECoG in different frequency bands and plot the tuining curves
% 
% if nargin<2 || isempty(opt)
%     opt.twin=[10 60];
% end
% if ~isfield(opt,'power'), opt.power=1; end
% if ~isfield(opt,'flip'), opt.flip=0; end
% 
% for k = 1:size(outp,2)
%     [tc(k,:,:,:,:),bas(k,:,:)] = get_tc(outp{k},opt);
% end
% 
% tc1 = squeeze(tc(:,ch,:,:,:));
% bas = squeeze(bas(:,ch,:));
%   f = unique(outp{1}.stimat(:,2));
%  db = unique(outp{1}.stimat(:,5));
% db1 = min(db):2:max(db);
%  f1 = f(1)*2.^(0:0.1:log2(f(end)/f(1)));
%  
% [f1,db1]=meshgrid(f1,db1);
% 
% figure('units','inch','position',[0,0,15,4]);
% 
% for i=1:size(tc1,1)
%     subplot(1,size(tc1,1),i);
%     temp=squeeze(tc1(i,:,:)-bas(i,1))';
%     temp=interp2(f,db,temp,f1,db1);
%     temp=temp/std(temp(:),0,1); %z-score
%     imagesc(temp);
%     hold on;
%     [~,h1]=contour(temp,[2 2]);
%     set(h1,'color','k','linewidth',1);
%     [~,h1]=contour(temp,[3 3]);
%     set(h1,'color','w','linewidth',1);
% %     line([33.5,33.5],[0,length(h1.YData),'LineStyle','--','color','k']);
% %     line([54.5,54.5],[0,length(h1.YData),'LineStyle','--','color','k'])
%     title(outp{i}.label{i});
%     axis xy;
%     caxis([-4,5]);
%     title(['flt: ' num2str(outp{i}.flt)]);
%     %set(gca,'clim',[-1 1]*max([4;temp(:)]));
%     set(gca,'xtick',1:10:size(f1,2),'xticklabel',f1(1,1:10:end));
%     set(gca,'ytick',1:5:size(db1,1),'yticklabel',{[]});
%     if i == size(tc1,1)
%         colorbar;
%     end
% end
% %set_bigfont(4,6); 
% colormap('jet');
% 
% function [tc,bas] = get_tc(outp,opt)
% twin=opt.twin(1):opt.twin(2);
% tc0=outp.tc;
% if opt.power
%     for kk1=1:size(tc0,3)
%         for kk2=1:size(tc0,4)
% %             [evU,evL]=envelope(tc0(:,:,kk1,kk2));
% %             tc0(:,:,kk1,kk2)=evU;
%             tc0(:,:,kk1,kk2)=abs(hilbert(tc0(:,:,kk1,kk2)));
%         end
%     end
% end
% 
% bas=squeeze(mean(tc0(round(outp.pre*outp.fs)-(1:outp.pre*outp.fs)+1,:,:,:),1)); 
% bas=reshape(bas,size(bas,1),size(bas,2)*size(bas,3));
% bas=[mean(bas,2) std(bas,0,2)];
% tc=squeeze(mean(tc0(round(outp.pre*outp.fs)+twin,:,:,:),1));  %mean power over duation

