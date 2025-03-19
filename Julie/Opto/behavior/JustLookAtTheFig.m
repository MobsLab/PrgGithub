step=24;date='27072017';
% step=48;date='28072017';
for mousename=[537 540 542 543]

% mousename=537;
cd(['/media/DataMOBs57/Fear_July2017/behavior/FEAR-Mouse-' num2str(mousename) '-' num2str(date) '-01-EXT-' num2str(step) ])
uiopen('FigBilan.fig',1)
subplot(2,3,[1:3]),hold on
title([ num2str(mousename) '   EXT' num2str(step)])
if mousename==542 && step==48
ylim([0 10000])
line([csp csp+30],[6000 6000],'Color','b','LineWidth',2)
elseif mousename==537 && step==24
     line([csp csp+30],[60 60],'Color','b','LineWidth',2)
else 
ylim([0 80])
end
cd('/home/mobs/Dropbox/MOBS_workingON/Julie/fg_20170817_fearJuly17/')
saveas(gcf,['EXT' num2str(step) '_' num2str(mousename) '_CHR2.fig'])
saveas(gcf,['EXT' num2str(step) '_' num2str(mousename) '_CHR2.png'])
end

close all

 try 
        load Behavior csm csp CSplInt CSmiInt
        csm; csp; CSplInt;CSmiInt;
    catch
        DiffTimes=diff(TTL(:,1));
        ind=DiffTimes>2;
        times=TTL(:,1);
        event=TTL(:,2);
        CStimes=times([1; find(ind)+1]);  %temps du premier TTL de chaque s�rie de son
        CSevent=event([1; find(ind)+1]);  %valeur du premier TTL de chaque s�rie de son (CS+ ou CS-)
        % %definir CS+ et CS- selon les groupes
        if ~isempty(strfind(Dir.path{man},'EXT'))||~isempty(strfind(Dir.path{man},'COND'))
            if sum(strcmp(num2str(m),CSplu_bip_Gp))==1
                CSpluCode=4; %bip -Append
                CSminCode=3; %White Noise
            elseif sum(strcmp(num2str(m),CSplu_WN_Gp))==1
                CSpluCode=3;
                CSminCode=4;
            end
        elseif ~isempty(strfind(Dir.path{man},'HAB'))
            CSpluCode=3;
            CSminCode=4;
        end

        CSplu=CStimes(CSevent==CSpluCode);
        CSmin=CStimes(CSevent==CSminCode);

        CSplInt=intervalSet(CSplu*1e4,(CSplu+29)*1e4); % intervals for CS+
        CSmiInt=intervalSet(CSmin*1e4,(CSmin+29)*1e4);

        csp=CStimes(CSevent==CSpluCode);
        csm=CStimes(CSevent==CSminCode);

        save Behavior  csm csp CSplInt CSmiInt -Append
 end
 hold on
 line([csp csp+30],[6000 6000],'Color','b','LineWidth',2)