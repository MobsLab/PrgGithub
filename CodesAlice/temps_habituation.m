Filename564={
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_Habituation'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre1'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre2'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre3'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse564/20170706/ProjectEmbReact_M564_20170706_TestPre/TestPre4'
    }

Filename565={
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170726/ProjectEmbReact_M565_20170726_Habituation'
    %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre1'
    %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre2'
    %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre3'
    %  '/media/DataMOBS65/EmbReact_Eyeshock/Mouse565/20170706/ProjectEmbReact_M565_20170706_TestPre/TestPre4'
    }

Filename560={
    '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_Habituation'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre1'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre2'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre3'
    % '/media/DataMOBS65/EmbReact_Eyeshock/Mouse560/20170706/ProjectEmbReact_M560_20170706_TestPre/TestPre4'
    }
close all
MouseNumber=[564,565,560];
listefichiers={Filename564,Filename565,Filename560};
for var=1:length(listefichiers)
    fig=figure;
    for ff=1:length(listefichiers{var})
        cd(listefichiers{var}{ff})
        load('behavResources.mat')
        Xtsd(var)=tsd(PosMat(:,1)*1e4,PosMat(:,2));
        Ytsd(var)=tsd(PosMat(:,1)*1e4,PosMat(:,3));
        
        cols=lines(5);
        for k=1:5
            plot(Data(Restrict(Xtsd(var),ZoneEpoch{k})),Data(Restrict(Ytsd(var),ZoneEpoch{k})),'color',cols(k,:)), hold on
        end
        %        plot(Data(Xtsd(var)),Data(Ytsd(var))) % toute la trajectoire
        title(['Habituation : Mouse ',num2str(MouseNumber(var))])
        hold on
        for k=1:5
            Dur{var}(k)=(sum(Stop(ZoneEpoch{k},'s')-Start(ZoneEpoch{k},'s')));%./sum(sum((Zone{k})));
        end
    end
    saveas(fig.Number,['/home/vador/Dropbox/Mobs_member/AliceLallemand/Figures-Behaviour/TrajectoriesHabituationM',num2str(MouseNumber(var)),'.png'])
    
    
    
    % for k=1:5
    %     s=0;
    %     for var=1:length(listefichiers)
    %         s=s+Dur{var}(k);
    %     end
    %    moyenne(k)=s/3 ;
    % end
    
    
    %figure
    %bar(moyenne)
    %set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
    %title('Habituation : Moyenne')
    
    %for var=1:length(listefichiers)
    %  figure
    % bar(Dur{var})
    % set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
    %  if var==1
    %     title('Habituation : Mouse 564')
    %  elseif var==2
    %      title('Habituation : Mouse 565')
    % elseif var==3
    %     title('Habituation : Mouse 560')
    %  end
    %end
    
    %c'est plus efficace de travailler avec des matries que des boucles !!
    
end

test=Dur{1}./sum(Dur{1});
test(2,:)=Dur{2}./sum(Dur{2});
test(3,:)=Dur{3}./sum(Dur{3});
moyenne=mean(test);
ecarttype=std(test);
ecartmoyenne=stdError(test);


fig=figure; errorbar(mean(test),stdError(test),'.')
hold on, bar(mean(test))
title('moyenne habituation')
%figure
%PlotErrorBarN(test,1,1)
set(gca,'XTick',[1:5],'XTickLabel',{'Shock','NoShock','Centre','CentreShock','CentreNoShock'})
saveas(fig.Number,['/home/vador/Dropbox/Mobs_member/AliceLallemand/Figures-Behaviour/AverageOccupationHabituation.png'])
