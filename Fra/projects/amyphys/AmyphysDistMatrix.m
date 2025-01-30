function AmyphysDistMatrix

datasets = List2Cell('datasets_2way.list');
A = Analysis(pwd);
doMonkeyOnly = true;
A = getResource(A, 'StimSet', datasets);

allStimSets = unique(stimSet);

allStimSets = allStimSets(~cellfun('isempty', allStimSets));
load AmyphysStimCodes
ddTotGlob = [];
ddMkGlob = [];
ddHuGlob = [];
ddObGlob = [];
ddThreatGlob = [];
ddNeutralGlob = [];
ddLipsmackGlob = [];
ddExprGlob = [];

for st = 1:length(allStimSets)
    dsetsSt = datasets(strmatch(allStimSets{st}, stimSet, 'exact'));
    A = getResource(A, 'StimRates', dsetsSt);
    A = getResource(A, 'Experiment', dsetsSt);
    experiment = experiment{1};
    experiment(1) = experiment(1)-32;
    eval(['stims = ' experiment 'Stims;']);
    eval(['stimsId = ' experiment 'StimsId;']);
    eval(['stimsExpr = ' experiment 'StimsExpr;']);    
    rateMat = [];
    srd = [];
    for i = 1:length(stimRates)
        sr = stimRates{i};
        if nanstd(sr) > 0.3
            rateMat = [rateMat; (sr-nanmean(sr))/nanstd(sr)];
           
        end
         srd(i) = nanstd(sr);
    end
    rateMat(isnan(rateMat)) = 0;
    rateMat = rateMat';
    mkStim = find(stimsId < 100);
  
    
    if doMonkeyOnly
        stimsId = stimsId(mkStim);
        stimsExpr = stimsExpr(mkStim);
        stims = stims(mkStim);
        
        rateMat = rateMat(mkStim,:);
    end
    
    dissimilarities = pdist(rateMat);
    [Y,stress, disparities] = mdscale(dissimilarities,2,'criterion','stress');
    
    
    mkNeutral = find(stimsId < 100&stimsExpr == 1);
    mkThreat = find(stimsId < 100&stimsExpr == 2);
    mkLipsmack = find(stimsId < 100&stimsExpr == 3);
    mkFullbody = find(stimsId < 100&stimsExpr == 4);
    
    figure(1)
    clf
    plot(Y(mkNeutral,1), Y(mkNeutral,2),'.', 'MarkerSize', 15);
    hold on 
    plot(Y(mkThreat,1), Y(mkThreat,2),'x');
    plot(Y(mkLipsmack,1), Y(mkLipsmack,2),'o');
    plot(Y(mkFullbody,1), Y(mkFullbody,2),'d');
    
    huStim = find(stimsId <200 & stimsId >100);
    plot(Y(huStim,1), Y(huStim,2),'r.', 'MarkerSize', 15)
    obStim = find(stimsId < 300&stimsId > 200);
    
    plot(Y(obStim,1), Y(obStim,2),'g.', 'MarkerSize', 15)
    
    amStim =  find(stimsId < 400&stimsId > 300);
    plot(Y(amStim,1), Y(amStim,2),'c.', 'MarkerSize', 15)

    
    
    si = stimsId(mkStim);
    for j = 1:length(si)
        sis{j} = num2str(si(j));
    end
    xl = get(gca, 'XLim');
    xl = xl(2)-xl(1);
    
    text(Y(mkStim,1)-xl*0.01, Y(mkStim,2),sis, 'HorizontalAlignment', 'right');
    
    si = stimsId(huStim)-100;
    sis = {};
    for j = 1:length(si)
        sis{j} = num2str(si(j));
    end
    xl = get(gca, 'XLim');
    xl = xl(2)-xl(1);
    
    text(Y(huStim,1)-xl*0.01, Y(huStim,2),sis, 'HorizontalAlignment', 'right');
    
    
    si = stimsId(obStim)-200;
    sis = {};
    for j = 1:length(si)
        sis{j} = num2str(si(j));
    end
    xl = get(gca, 'XLim');
    xl = xl(2)-xl(1);
    
    text(Y(obStim,1)-xl*0.01, Y(obStim,2),sis, 'HorizontalAlignment', 'right');
    
    title(allStimSets{st});
    saveas(gcf, ['cmds_' allStimSets{st} ], 'fig');
    print('-depsc2', ['cmds_' allStimSets{st} ]);
    
    
    figure(2)
    distances = dissimilarities;
    [dum,ord] = sortrows([disparities(:) dissimilarities(:)]);
    plot(dissimilarities,distances,'bo', ...
        dissimilarities(ord),disparities(ord),'r.-', ...
        [0 25],[0 25],'k-');
    xlabel('Dissimilarities'); ylabel('Distances/Disparities')
    legend({'Distances' 'Disparities' '1:1 Line'},...
        'Location','NorthWest')
   
      figure(3)
      
      dd = squareform(pdist(Y));
      stK = zeros(1, size(dd, 1));
      stK(mkStim) = 1;
      stK(huStim) = 2;
      stK(obStim) = 3;
      exK = zeros(1, size(dd, 1));
      exK(mkThreat) = 1;
      exK(mkNeutral) = 2;
      exK(mkLipsmack)= 3;
      
      
     
      [AA, B] = meshgrid(1:size(dd, 1), 1:size(dd, 1));
      if doMonkeyOnly
          ixtot = find(AA > B);
      else
          ixtot = find(AA > B & stK(AA) ~= stK(B));
      end
      
      ixmk = find((AA >  B) & ismember(AA, mkStim) & ismember(B,mkStim));
      ixhu = find((AA >  B) & ismember(AA,huStim) & ismember(B,huStim));
      ixob= find((AA >  B) & ismember(AA, obStim) & ismember(B, obStim));
      ixexpr = find((AA > B) & (exK(AA) ~= exK(B)) & (exK(AA) ~= 0) & (exK(B) ~= 0));
      ixthreat = find((AA > B) & (exK(AA) == 1) & (exK(B) == 1));
      ixneutral = find((AA > B) & (exK(AA) == 2) & (exK(B) == 2));
      ixlipsmack = find((AA > B) & (exK(AA) == 3) & (exK(B) == 3));
      
      %        keyboard
      xh = linspace(0, 10, 20);
      ddTotGlob = [ddTotGlob; dd(ixtot(:)) / mean(dd(ixtot))];
      ddMkGlob = [ddMkGlob; dd(ixmk(:)) / mean(dd(ixtot))];
      ddHuGlob = [ddHuGlob; dd(ixhu(:)) / mean(dd(ixtot))];
      ddObGlob = [ddObGlob; dd(ixob(:)) / mean(dd(ixtot))];
      ddExprGlob = [ddExprGlob; dd(ixexpr(:)) / mean(dd(ixtot))];
      ddThreatGlob = [ddThreatGlob; dd(ixthreat(:)) / mean(dd(ixtot))];
      ddNeutralGlob = [ddNeutralGlob; dd(ixneutral(:)) / mean(dd(ixtot))];
      ddLipsmackGlob = [ddLipsmackGlob; dd(ixlipsmack(:)) / mean(dd(ixtot))];
      
      htot = hist(dd(ixtot), linspace(0,10,20)) / length(ixtot);
      hmk = hist(dd(ixmk), linspace(0,10,20)) / length(ixmk);
      hhu = hist(dd(ixhu), linspace(0,10,20)) / length(ixhu);
      hob = hist(dd(ixob), linspace(0,10,20)) / length(ixob);
      hold off
      plot(xh, htot, 'k', 'linewidth', 2);
      hold on
      plot(xh, hmk, 'r', 'linewidth', 2);
      plot(xh, hhu, 'b', 'linewidth', 2);
      plot(xh, hob, 'g', 'linewidth', 2);

      saveas(gcf, ['disth_' allStimSets{st} ], 'fig');
      print('-depsc2', ['disth_' allStimSets{st} ]);
      
      figure(4)

 
      hexpr = hist(dd(ixexpr), linspace(0,10,20)) / length(ixexpr);
      hthreat = hist(dd(ixthreat), linspace(0,10,20)) / length(ixthreat);
      hneutral = hist(dd(ixneutral), linspace(0,10,20)) / length(ixneutral);
      hlipsmack = hist(dd(ixlipsmack), linspace(0,10,20)) / length(ixlipsmack);
      hold off
      plot(xh, hexpr, 'k', 'linewidth', 2);
      hold on
      plot(xh, hthreat, 'r', 'linewidth', 2);
      plot(xh, hneutral, 'g', 'linewidth', 2);
      plot(xh, hlipsmack, 'b', 'linewidth', 2);
      keyboard
end


xhglob= linspace(0, 4, 25);
hgtot = hist(ddTotGlob, xhglob)/length(ddTotGlob);
hgmk = hist(ddMkGlob, xhglob)/length(ddMkGlob);
hghu = hist(ddHuGlob, xhglob)/length(ddHuGlob);
hgob = hist(ddObGlob, xhglob)/length(ddObGlob);

figure(5)
plot(xhglob, hgtot, 'k', 'linewidth', 2);
hold on 
plot(xhglob, hgmk, 'b', 'linewidth', 2)
plot(xhglob, hghu, 'r', 'linewidth', 2)
plot(xhglob, hgob, 'g', 'linewidth', 2)
if ~doMonkeyOnly
[H, pKsGlobMk]  =kstest2(ddTotGlob, ddMkGlob)
[H, pKsGlobHu]  =kstest2(ddTotGlob, ddHuGlob)
[H, pKsGlobOb]  =kstest2(ddTotGlob, ddObGlob)
end


figure(6)
hgexpr = hist(ddExprGlob, xhglob)/length(ddExprGlob);
hgthreat = hist(ddThreatGlob, xhglob)/length(ddThreatGlob);

hgneutral = hist(ddNeutralGlob, xhglob)/length(ddNeutralGlob);
hglipsmack = hist(ddLipsmackGlob, xhglob)/length(ddLipsmackGlob);

plot(xhglob, hgexpr, 'k', 'linewidth', 2);
hold on 
plot(xhglob, hgthreat, 'r', 'linewidth', 2)
plot(xhglob, hgneutral, 'g', 'linewidth', 2)
plot(xhglob, hglipsmack, 'b', 'linewidth', 2)
keyboard
