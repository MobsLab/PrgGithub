function [HS,ModInfo] = MakeRayleighFigure_SB(Phases,FilterBands,varargin)

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'newfig'
            newfig = varargin{i+1};
            if newfig~=0 && newfig ~=1
                error('Incorrect value for property ''newfig''.');
            end
        case 'doplot'
            doplot = varargin{i+1};
            if doplot~=0 && doplot ~=1
                error('Incorrect value for property ''doplot''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('newfig','var')
    newfig = 1;
end
if ~exist('doplot','var')
    doplot = 1;
end

FreqStep = median(diff(FilterBands));

% Make histograms
% Assemble historgams into final matrix for plotting
for i=1:size(FilterBands,2)
    he=hist(Phases(:,i),20);
    H(i,:)=[he he];
    [mu(i), Kappa(i), pval(i), Rmean(i)] = CircularMean((Phases(:,i)));
end
Hs = SmoothDec(H,[0.001,0.8]);
HS = Hs;
HS(:,40) = Hs(:,20);
HS(:,1) = Hs(:,21);



ModInfo.mu = mu;
ModInfo.Kappa = Kappa;
ModInfo.pval = pval;
ModInfo.Rmean = Rmean;

if doplot
    if newfig,figure, end
    imagesc([0:4*pi],mean(FilterBands),HS), axis xy
    ylabel('Frequency (Hz)')
    xlabel('Phase (rad)')
    title(['Phase distribution NumSpikes=' num2str(size(Phases,1))])
    
    FigArrow([ModInfo.mu(ModInfo.pval<0.05);FilterBands(1,find(ModInfo.pval<0.05))+FreqStep/2]',...
        ModInfo.Kappa(ModInfo.pval<0.05),ModInfo.mu(ModInfo.pval<0.05),1)
    FigArrow([ModInfo.mu(ModInfo.pval<0.05)+2*pi;FilterBands(1,find(ModInfo.pval<0.05))+FreqStep/2]',...
        ModInfo.Kappa(ModInfo.pval<0.05),ModInfo.mu(ModInfo.pval<0.05),1)
    
    ca=caxis;
    caxis([ca(1) ca(2)+ca(2)/10]);
end