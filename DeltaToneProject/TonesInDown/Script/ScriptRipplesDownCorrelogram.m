%%ScriptRipplesDownCorrelogram
% 19.07.2019 KJ
%
% effect of ripples in Up states
% in N2 and N3
%
%   see 
%       
%
%

clear

Dir=PathForExperimentsBasalSleepSpike;
Dir=RestrictPathForExperiment(Dir, 'nMice', [243,244,403,451,508,509]);
animals = unique(Dir.name);




for m=1:length(animals)
    
    mouse.ripples.x = [];
    mouse.ripples.y = [];
    mouse.sham.x = [];
    mouse.sham.y = [];
    
    for p=1:length(Dir.path)
        if strcmpi(Dir.name{p},animals{m})
            disp(' ')
            disp('****************************************************************')
            eval(['cd(Dir.path{',num2str(p),'}'')'])
            disp(pwd)
            clearvars -except Dir p m mouse animals ripples sham

            %params
            minDuration = 0.75e4; %75ms

            %MUA & Down
            down_PFCx = GetDownStates;
            st_down = Start(down_PFCx);
            end_down = End(down_PFCx);
            %Up
            up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
            up_PFCx = dropShortIntervals(up_PFCx, minDuration);
            st_up = Start(up_PFCx);
            end_up = End(up_PFCx);

            %substages
            load('SleepSubstages.mat','Epoch')
            N2 = Epoch{2} ; N3 = Epoch{3};
            NREM = or(or(N2,N3), Epoch{1});

            %ripples       
            [tRipples, RipplesEpoch] = GetRipples;
            tRipples = Restrict(Restrict(tRipples, NREM),up_PFCx);

            %% Create sham
            nb_sham = min(4000, length(st_up));
            idx = randsample(length(st_up), nb_sham);
            sham_tmp = [];

            for i=1:length(idx)
                min_tmp = st_up(idx(i));
                duree = end_up(idx(i))-st_up(idx(i));
                sham_tmp = [sham_tmp min_tmp+rand(1)*duree];
            end    
            ShamEvent = ts(sort(sham_tmp));

            
            %% Cross-corr
            %ripples
            [C,B] = CrossCorr(Range(tRipples), st_down, 5,150);
            mouse.ripples.x = B;
            mouse.ripples.y = [mouse.ripples.y C];

            %sham
            [C,B] = CrossCorr(Range(ShamEvent), st_down, 5,150);
            mouse.sham.x = B;
            mouse.sham.y = [mouse.sham.y C];
            
        end
    end
    
    ripples.mean.x{m} = mouse.ripples.x;
    ripples.mean.y{m} = mean(mouse.ripples.y,2);
    sham.mean.x{m} = mouse.sham.x;
    sham.mean.y{m} = mean(mouse.sham.y,2);
    
end

%plot
figure, hold on

for m=1:length(animals)

    %ripples
    subplot(1,2,1), hold on
    plot(ripples.mean.x{m},ripples.mean.y{m}), hold on


    %random
    subplot(1,2,2), hold on
    plot(sham.mean.x{m},sham.mean.y{m}), hold on
end


%ripples
subplot(1,2,1), hold on
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])

%random
subplot(1,2,2), hold on
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])


