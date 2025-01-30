function CalibrateCamera(fbasename)

Fs = 1250/32;

fname = [fbasename filesep];
d = dir([fname '*.whl']);

for ii=1:length(d)
    whl = dlmread([fname d(ii).name]);
    [whl GoodRangest] = CleanWhlForR(whl);
    
    figure(1),clf
    plot(whl(:,1),whl(:,2))

    done=0;
    while ~done
        fprintf('Draw a line on the figure\n')
        gg = ginput(2);
        lpixel = norm(gg(1,:)-gg(2,:));
        lcms = input('What is the actual size of this line (in cms)','s');
        ratio = str2num(lcms)/lpixel;
        fprintf('Ratio cms/pixel is: %f\n',ratio)
        answer = input('Satisfied? [Y/N]','s');
        keyboard
        if strcmp(answer,'Y')
            done=1;
        elseif strcmp(answer,'N')
            fprintf('OK, then let''s restart!\n')
        else
            fprintf('Don''t understand the answer, so we restart\n')
        end
    end
    dlmwrite([fname d(ii).name '_calibration'],ratio,'precision','%5.5f');
end
