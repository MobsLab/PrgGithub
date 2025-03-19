function [Ct,Bt]=CrossSpiRipDeltaML(spi,rip,tDelta,Epoch,sizbin,nbin,plo)

% CrossSpiRipDeltaML
% 
% INPUTS:
% spi = spindles ts
% rip = ripples ts
% tDelta = delta ts
% Epoch = intervalSet
% nbin = (default 1000)
% sizbin = (default 100)
% plo (optional) =1 to display, 0 otherwise
%
% OUTPUTS:
% Ct = cell array with crosscorr values
% Bt = cell array with crosscorr times (in ms)

%% <<<<<<<<<<<<<<<<<<<<<<<<< INITIATION <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
if ~exist('sizbin','var'), sizbin=50; end
if ~exist('nbin','var'), nbin=50; end
if ~exist('plo','var'), plo=0;end
if plo, figure('color',[1 1 1],'position',[69 477 383 419]);end

Ct{1}=NaN; Bt{1}=NaN;
Ct{2}=NaN; Bt{2}=NaN;
Ct{3}=NaN; Bt{3}=NaN;
Ct{4}=NaN; Bt{4}=NaN;
Ct{5}=NaN; Bt{5}=NaN;
Ct{6}=NaN; Bt{6}=NaN;
NameCrossCorr={'Rip at Spin','Rip at Delt','Spin at Delt','Delt at Rip','Spin at Rip','Delt at SPin'};

%% <<<<<<<<<<<<<<<<<<<<<<<<< Ripples by SPindles <<<<<<<<<<<<<<<<<<<<<<<<<<
try
    [C,B]=CrossCorrKB(Range(Restrict(spi,Epoch)),Range(Restrict(rip,Epoch)),sizbin,nbin);
    % look at ripples at time of spindles
    Ct{1}=C;Bt{1}=B;
    if plo
        subplot(2,3,1), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        ylabel('count Ripples'); xlabel('Spindles time (s)');
        title('Ripples versus Spindles')
        xlim([B(1)/1E3 B(end)/1E3])
    end
end

%% <<<<<<<<<<<<<<<<<<<<<<<<< Ripples by Delta <<<<<<<<<<<<<<<<<<<<<<<<<<

try
    clear C B
    [C,B]=CrossCorrKB(Range(Restrict(tDelta,Epoch)),Range(Restrict(rip,Epoch)),sizbin,nbin);
    % look at ripples at time of delta
    Ct{2}=C;Bt{2}=B;
    if plo
        subplot(2,3,2), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        xlim([B(1)/1E3 B(end)/1E3])
        ylabel('count Ripples'); xlabel('Delta time (s)');
        title('Ripples versus Delta')
    end
end


%% <<<<<<<<<<<<<<<<<<<<<<<<< Spindles by Delta <<<<<<<<<<<<<<<<<<<<<<<<<<
try
    clear C B
    [C,B]=CrossCorrKB(Range(Restrict(tDelta,Epoch)),Range(Restrict(spi,Epoch)),sizbin,nbin);
    % look at Spindles at time of Delta
    Ct{3}=C;Bt{3}=B;
    if plo
        subplot(2,3,3), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        xlim([B(1)/1E3 B(end)/1E3])
        ylabel('count Spindles'); xlabel('Delta time (s)');
        title('Spindles versus Delta')
    end
end

%% <<<<<<<<<<<<<<<<<<<<<<<<< Delta by Ripples <<<<<<<<<<<<<<<<<<<<<<<<<<
try
    clear C B
    [C,B]=CrossCorrKB(Range(Restrict(rip,Epoch)),Range(Restrict(tDelta,Epoch)),sizbin,nbin);
    % look at delta at time of ripples
    Ct{4}=C;Bt{4}=B;
    if plo
        subplot(2,3,4), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        xlim([B(1)/1E3 B(end)/1E3])
        ylabel('count Ripples'); xlabel('Delta time (s)');
        title('Delta versus Ripples')
    end
end

%% <<<<<<<<<<<<<<<<<<<<<<<<< Spindles by Ripples <<<<<<<<<<<<<<<<<<<<<<<<<<
try
    [C,B]=CrossCorrKB(Range(Restrict(rip,Epoch)),Range(Restrict(spi,Epoch)),sizbin,nbin);
    % look at spindles at time of ripples
    Ct{5}=C;Bt{5}=B;
    if plo
        subplot(2,3,5), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        ylabel('count Ripples'); xlabel('Spindles time (s)');
        title('Spindles versus Ripples')
        xlim([B(1)/1E3 B(end)/1E3])
    end
end

%% <<<<<<<<<<<<<<<<<<<<<<<<< Delta by Spindles <<<<<<<<<<<<<<<<<<<<<<<<<<
try
    clear C B
    [C,B]=CrossCorrKB(Range(Restrict(spi,Epoch)),Range(Restrict(tDelta,Epoch)),sizbin,nbin);
    % look at Delta at time of Spindles
    Ct{6}=C;Bt{6}=B;
    if plo
        subplot(2,3,6), bar(B/1E3,C,1,'k'), yl=ylim; hold on, line([0 0],yl,'color','r')
        xlim([B(1)/1E3 B(end)/1E3])
        ylabel('count Spindles'); xlabel('Delta time (s)');
        title('Delta versus Spindles')
    end
end
