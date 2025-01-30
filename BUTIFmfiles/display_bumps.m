function bumpogram = display_bumps(model,options)
% This function displays a bump model
%
% Parameters:
% model = ButIf bump model
% options = optional parameter
%     '2D' = shows 2D figures for all models, 
%     pause between each model, press a key to display next
%     '3D' = shows 3D figures for all models, 
%     pause between each model, press a key to display next
%     number = shows only the figure for model nb N
%     if ommited, options will be automatically attribted as 2D plot
%
% Copyright (C) 2008 Lab. ABSP, Riken (Japan) Francois-B. Vialatte et al.
% Please cite related papers when publishing results obtained with this
% toolbox

if nargin < 1
   disp(['display_bumps needs a bump model as first input parameter']);
   return;
end;
indices = 1:model.N;
if nargin < 2
    option = 2;
    NBITS = 256;
else
    if (isa(options,'char'))
        if (strcmp(options,'2D'))
            NBITS = 256;
            option = 2;
        else
            if (strcmp(options,'3D'))
               option = 3;
            else
               disp(['unknown option: ',options,' - ending program display_bumps.m']);
               return;
            end;
        end;
    else
        if ((options > model.N) | (options <= 0)) 
            disp(['impossible option: ',num2str(options),' must be within 1:',num2str(model.N),'- ending program display_bumps.m']);
            return;
        else
            option = 1;
            indices = options;
            NBITS = 256;
        end;
    end;
end;



figure;
for i=indices
   dispmat = zeros(model.size_freq,model.size_time);
   for j=1:model.num
      d = model.dec((i-1)*model.num+j,:);
      w = model.windows((i-1)*model.num+j,:);
      if (d(1) > 0)
         xl = w(4);
         yl = w(3);      
         up = w(1);  
         lf = w(2);
         mat = calc_demi_ellips(d,xl,yl);
         dispmat(up:up+yl-1,lf:lf+xl-1) = max(dispmat(up:up+yl-1,lf:lf+xl-1),mat);
      end;
   end;   
   if (option < 3)
        colormap(jet(NBITS)); 
        imagesc(dispmat);
        maxtime = model.size_time / model.freqdown;
        border_bottom = model.ByDn;
        border_top    = model.ByUp; 
        Xticks = maxtime/4;
        Xaxis = 0:Xticks:maxtime;
        Xpos = [1 round(model.size_time/4) round(model.size_time/2)...
            round(3*model.size_time/4) model.size_time];
        Yticks = (model.freqmax-model.freqmin)/4;
        Yaxis = fliplr([model.freqmin model.freqmin+Yticks model.freqmin+(2*Yticks) model.freqmin+(3*Yticks) model.freqmax]);
        LengthF = model.size_freq-(border_top+border_bottom);
        Ypos = [border_bottom+1 border_bottom+round(LengthF/4) border_bottom+2*round(LengthF/4)...
            border_bottom+3*round(LengthF/4) model.size_freq-border_top];  
        Ypos = fliplr(model.size_freq-Ypos+1);
        set(gca,'XTick',Xpos);
        set(gca,'XTickLabel',Xaxis);
        set(gca,'YTick',Ypos);
        set(gca,'YTickLabel',Yaxis);
        xlabel('Time (sec)');
        ylabel('Frequency (Hz)');
   else
       surf(dispmat);
   end;
   bumpogram{i} = dispmat;
   title(['Bump decomposition ',num2str(i),' / ',num2str(model.N)]);
   pause;
end;
