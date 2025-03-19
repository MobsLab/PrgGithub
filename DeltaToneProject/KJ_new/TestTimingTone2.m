% TestTimingTone2
% 13.02.2017 KJ
%
% for each night, look at the timing of tones and if it is coherent with
% ohter data
%
% see
%   TestTimingToneLFP TestTimingToneLFP2 TestTimingTone



a=0;
% ----------- 403 ----------------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse403/';
Dir.delay{a}=0.32; Dir.manipe{a}='DeltaToneAll';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse403/';
Dir.delay{a}=0.49; Dir.manipe{a}='DeltaToneAll';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse403/';
Dir.delay{a}=0.49; Dir.manipe{a}='RdmTone';

% % ----------- 451 ----------------------
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170130/Breath-Mouse-403-451-30012017/Mouse451/';
Dir.delay{a}=0.32; Dir.manipe{a}='RdmTone';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170213/Breath-Mouse-403-451-13022017/Mouse451/';
Dir.delay{a}=0.49; Dir.manipe{a}='RdmTone';
a=a+1; Dir.path{a}='/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice403-451/20170215/Breath-Mouse-403-451-15022017/Mouse451/';
Dir.delay{a}=0.49; Dir.manipe{a}='DeltaToneAll';



for p=1:length(Dir.path)

    %mouse name
    Dir.name{p}=Dir.path{p}(strfind(Dir.path{p},'/Mouse'):strfind(Dir.path{p},'/Mouse')+8);
    Dir.name{p}(Dir.name{p}=='-')=[];
    Dir.name{p}(Dir.name{p}=='/')=[];
    
    %date
    ind = strfind(Dir.path{p},'/201');
    Dir.date{p} = Dir.path{p}(ind + [7 8 5 6 1:4]);
    
    
    if strcmpi(Dir.manipe{p},'RdmTone')
        Dir.condition{p} = ['Random' num2str(Dir.delay{p}*1000) 'ms'];
    elseif strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end



for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    clearvars -except Dir p


    %SWS
    load('SleepScoring_OBGamma.mat', 'SWSEpoch')

    %LFP
    load ChannelsToAnalyse/PFCx_deep
    eval(['load LFPData/LFP',num2str(channel)])
    LFPdeep=LFP;
    clear LFP

    %Tones
    load('DeltaSleepEvent.mat', 'TONEtime1')
    TONEtime1_SWS = Range(Restrict(ts(TONEtime1), SWSEpoch));

    load('DeltaSleepEvent.mat', 'TONEtime2')
    if exist('TONEtime2','var')
        real_time = 1;
        TONEtime2_SWS = Range(Restrict(ts(TONEtime2), SWSEpoch));
    else
        real_time=0;
    end

    %Mean curves
    Md_detect = PlotRipRaw(LFPdeep,TONEtime1_SWS/1E4, 1000); close
    met_detect_x = Md_detect(:,1);
    met_detect_y = Md_detect(:,2);
    if real_time
        Md_tone = PlotRipRaw(LFPdeep,TONEtime2_SWS/1E4, 1000); close
        met_tone_x = Md_tone(:,1);
        met_tone_y = Md_tone(:,2);
    end


    %% PLOT AND SAVE FIG
    figure, hold on
    plot(met_detect_x,met_detect_y,'k'), hold on
    if real_time
        plot(met_tone_x,met_tone_y,'b'), hold on
        legend('detection', 'tones'), 
    else
        legend('detection'), 
    end
    ylim([-1000 2300]), hold on
    line([0 0],get(gca,'YLim')), hold on

    % save fig
    title(['CorrelogramToneLFP ' Dir.name{p}  ' - ' Dir.condition{p} ' - ' Dir.date{p}]);
    %name_fig
    filename_fig = ['CorrelogramToneLFP_' Dir.name{p}  '_' Dir.date{p}];
    filename_png = [filename_fig  '.png'];
    %save figure
    cd([FolderFigureDelta 'IDfigures/CorrelogramToneLFP/'])
    saveas(gcf,filename_png,'png')
    close

end











