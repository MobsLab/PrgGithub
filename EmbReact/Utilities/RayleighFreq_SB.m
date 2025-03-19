% [HS,Ph,ModTheta]=RayleighFreq_SB(LFP,S) plot the distribution of phases for
% LFP filtered in 2Hz band windows from 2 to 42 Hz
%
% INPUTS:
% LFP: unfiltered local field potential (must be in tsd format)
% S: time of sipkes (must be in tsd or tsdArray format)
%
% OUTPUT:
% HS: Matrix of Phases distribution for frequencies ranging from 2 to 42 Hz
% Ph: cell Array of phases of spikes for each frequencies
% ModTheta: Von Misses parameters for each frequencies
% theta: the mean direction
% Kappa; the concentration factor to be used with Von Mises distribution
% pval: the signficance of the mean direction against an uniformity null
% Rmean: the mean resultant length
% delta: the sample ciricualr dispersion
% hypothesis (with a Rayleigh test)
% see Fisher N.I. Analysis of Circular Data p. 30-35

% copyright (c) 2009 Karim Benchenane
% This software is released under the GNU GPL
% www.gnu.org/copyleft/gpl.html



%---------------------------------------------------------------
% option
%---------------------------------------------------------------


function [HS,PhFinal,ModInfo,PhaseLFPCorr]=RayleighFreq_SB(LFP,S,varargin)




% Check number of parameters
if nargin < 2 || mod(length(varargin),2) ~= 0
    error('Incorrect number of parameters (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).']);
    end
    switch(lower(varargin{i}))
        case 'arrowsize'
            scal =  varargin{i+1};
            if ~isdvector(scal,'#1','>0')
                error('Incorrect value for arrowsize'' (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).');
            end
        case 'freqrange'
            FreqRange =  varargin{i+1};
            if ~isdvector(FreqRange,'#2','>0')
                error('Incorrect value for property ''freqrange'' (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).');
            end
        case 'freqstep'
            FreqStep =  varargin{i+1};
            if ~isdvector(FreqStep,'#1','>0')
                error('Incorrect value for property ''freqstep'' (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).');
            end
        case 'doplot'
            doplot=  varargin{i+1};
            if ~isdvector(doplot,'#1','>0')
                error('Incorrect value for property ''doplot'' (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).');
            end
        case 'plotctrl'
            plotCtrl=  varargin{i+1};
            if ~isdvector(plotCtrl,'#1','>0')
                error('Incorrect value for property ''doplot'' (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).');
            end
        case 'filterbands'
            FilterBands= varargin{i+1};
            if ~isdmatrix(FilterBands)
                error('Incorrect value for property ''FilterBands'' (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help RayleighFreq_SB">RayleighFreq_SB</a>'' for details).']);
    end
end

if ~exist('scal','var')
    scal=0.01;
end
if ~exist('FreqRange','var')
    FreqRange = [2 42];
end
if ~exist('FreqStep','var')
    FreqStep = 2;
end
if ~exist('doplot','var')
    doplot = 0;
end
if ~exist('plotCtrl','var')
    plotCtrl = 0;
end
if ~exist('FilterBands','var')
    FilterBands = [FreqRange(1):FreqStep:FreqRange(2);FreqRange(1)+FreqStep:FreqStep:FreqRange(2)+FreqStep];
end

fi=512;


try
    S=tsdArray(S);
end
phasectrl=[];



for i = 1 : size(FilterBands,2)
    
    disp(['Freq band: ' num2str(FilterBands(1,i)) ' to '  num2str(FilterBands(2,i))])
    % Filter LFP
    disp('LFP filter')
    Filt = [FilterBands(1,i),FilterBands(2,i)];
    FilLFP = FilterLFP(LFP,Filt,fi);
    
    % Get LFP phase
    PhaseLFP = GetPhaseFilteredLFP(FilLFP);
    
    % Correct the LFP phase
    PhaseLFPCorr{i} = CorrectLFPPhaseDistrib(PhaseLFP);
    
    % Get all phases for figure at the end
    [histphzr,echel]=hist(Data(PhaseLFPCorr{i}.Nontransf),[2*pi/40:2*pi/20:2*pi-2*pi/40]);
    phasectrl(i,:) = histphzr;
    
    disp('Neuron phases')
    % Get phase neuron by neuron
    for neurnum = 1 : size(S,1)
        if length(Range(S{neurnum}))==0
            PhaseNeuronCorr{neurnum} = NaN;
            h{i,neurnum} = NaN;
            Ph.Transf{neurnum}(i,:) = NaN;
            Ph.Nontransf{neurnum}(i,:)=NaN;
            mu.Transf(i,neurnum)=NaN; Kappa.Transf(i,neurnum)=NaN; pval.Transf(i,neurnum)=NaN; Rmean.Transf(i,neurnum)=NaN;
            mu.Nontransf(i,neurnum)=NaN; Kappa.Nontransf(i,neurnum)=NaN; pval.Nontransf(i,neurnum)=NaN; Rmean.Nontransf(i,neurnum)=NaN;
        else
            PhaseNeuronCorr{neurnum} = GetNeuronPhaseFromLFPPhase(S{neurnum},PhaseLFPCorr{i});
            
            % histogram of phases to make plot
            he=hist(Data(PhaseNeuronCorr{neurnum}.Transf),20);
            h{i,neurnum}=[he he];
            
            % transform the format so that at the end there is one tsd with
            % phase for each spike in each frequency band
            Ph.Transf{neurnum}(i,:)=Data(PhaseNeuronCorr{neurnum}.Transf);
            Ph.Nontransf{neurnum}(i,:)=Data(PhaseNeuronCorr{neurnum}.Nontransf);
            
            % Get basic info on phase locking
            [mu.Transf(i,neurnum), Kappa.Transf(i,neurnum), pval.Transf(i,neurnum), Rmean.Transf(i,neurnum)] = CircularMean((Ph.Transf{neurnum}(i,:)));
            [mu.Nontransf(i,neurnum), Kappa.Nontransf(i,neurnum), pval.Nontransf(i,neurnum), Rmean.Nontransf(i,neurnum)] = CircularMean((Ph.Nontransf{neurnum}(i,:)));
        end
        clear he
    end
end

disp('Assembling output')
% Assemble phase of each spike into a tsd
for neurnum = 1 : size(S,1)
    if length(Range(S{neurnum}))>0
        PhFinal.Transf{neurnum} = tsd(Range(S{neurnum}),Ph.Transf{neurnum}');
        PhFinal.Nontransf{neurnum} = tsd(Range(S{neurnum}),Ph.Nontransf{neurnum}');
    else
        PhFinal.Transf{neurnum} = NaN;
        PhFinal.Nontransf{neurnum} = NaN;
        
    end
end

% Assemble historgams into final matrix for plotting
for neurnum = 1 : size(S,1)
    if length(Range(S{neurnum}))>0
        
        for i=1:size(FilterBands,2)
            H(i,:)=h{i,neurnum};
        end
        Hs=SmoothDec(H,[0.001,0.8]);
        HS{neurnum}=Hs;
        HS{neurnum}(:,40)=Hs(:,20);
        HS{neurnum}(:,1)=Hs(:,21);
    else
        HS{neurnum} = nan(size(FilterBands,2),40);
    end
end

% Assemble modulation info
ModInfo.mu = mu;
ModInfo.Kappa = Kappa;
ModInfo.pval = pval;
ModInfo.Rmean = Rmean;
% 
% Assemble PhaseLFP into final version
for i=1:size(FilterBands,2)
    PhaseLFPCorr{i} = rmfield(PhaseLFPCorr{i},'Nontransf');
    PhaseLFPCorr{i} = rmfield(PhaseLFPCorr{i},'Transf');
end

disp('Done')
if doplot
    neurnum = 1
    figure, imagesc([0:4*pi],mean(FilterBands),HS{neurnum}), axis xy
    ylabel('Frequency (Hz)')
    xlabel('Phase (rad)')
    title('Phase distribution after correction')
    
    FigArrow([ModInfo.mu.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,neurnum),FilterBands(1,find(ModInfo.pval.Transf(:,neurnum)<0.05))'+FreqStep/2],...
        ModInfo.Kappa.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,neurnum),ModInfo.mu.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,1),scal)
    FigArrow([ModInfo.mu.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,neurnum)+2*pi,FilterBands(1,find(ModInfo.pval.Transf(:,neurnum)<0.05))'+FreqStep/2],...
        ModInfo.Kappa.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,neurnum),ModInfo.mu.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,1),scal)
    
    ca=caxis;
    caxis([ca(1) ca(2)+ca(2)/10]);
end

if plotCtrl
    figure, imagesc(echel,mean(FilterBands),D), axis xy
    caxis([max(max(phasectrl))/1.25 max(max(phasectrl))])
    ylabel('Frequence (Hz)')
    xlabel('Phase (rad)')
end



%%
% for k = 1:10:500
% Ep = intervalSet(230*1e4+k*1e4,238*1e4+k*1e4);
% LittleLFP = Restrict(LFP,Ep);
% plot(Range(LittleLFP,'s'),Data(LittleLFP))
% FilLFP = FilterLFP(LittleLFP,[1 3],512);
% hold on
% plot(Range(FilLFP,'s'),Data(FilLFP),'linewidth',3)
% FilLFP = FilterLFP(LittleLFP,[7 9],512);
% plot(Range(FilLFP,'s'),Data(FilLFP),'linewidth',3)
% FilLFP = FilterLFP(LittleLFP,[12 15],512);
% plot(Range(FilLFP,'s'),Data(FilLFP),'linewidth',3)
% legend('Raw','1-3Hz','7-9Hz','12-15Hz')
% pause
% clf
% end