close all
% clear Session
% Session{1}  ='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_UMazeCondExplo_PostDrug/Cond1';
% Session{2}  ='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_UMazeCondExplo_PostDrug/Cond2';
% Session{3}  ='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_UMazeCondExplo_PostDrug/Cond3';
% 
% clear Session
% Session{1}  ='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_UMazeCondExplo_PostDrug/Cond1';
% Session{2}  ='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_UMazeCondExplo_PostDrug/Cond2';
% Session{3}  ='/media/nas7/ProjetEmbReact/Mouse1350/20220823/ProjectEmbReact_M41350_20220823_UMazeCondExplo_PostDrug/Cond3';
% 


% clear Session
% Session{1}  ='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_TestPre_PreDrug/TestPre1';
% Session{2}  ='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_TestPre_PreDrug/TestPre2';
% Session{3}  ='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_TestPre_PreDrug/TestPre3';
% Session{4}  ='/media/nas7/ProjetEmbReact/Mouse1352/20220823/ProjectEmbReact_M1352_20220823_TestPre_PreDrug/TestPre4';
%
clear all
group = 9;
AllMice.Sal = Drugs_Groups_UMaze_BM(group);

group =11;
AllMice.DZP = Drugs_Groups_UMaze_BM(group);

group = 18;
AllMice.RipCtrl = Drugs_Groups_UMaze_BM(group);

group = 17;
AllMice.RipInhib = Drugs_Groups_UMaze_BM(group);

%%
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')

MouseGroup = {'Sal','DZP'};%,'RipCtrl','RipInhib'};
clear Trans MeanStay
for gr = 1:length(MouseGroup)
    for mm  = 1:length(AllMice.(MouseGroup{gr}))
        TempSess = Sess.(['M' num2str(AllMice.(MouseGroup{gr})(mm))]);
        
        
        TempSess = TempSess(not(cellfun(@isempty,strfind(TempSess,'Cond'))));
        
        % Get transition matrix
        [Trans{gr}(mm,:,:),MeanStay{gr}(mm,:,:),NumEp{gr}(mm,:,:),TotTime{gr}(mm,:,:)] =  ProbabilitiesBehaviour_UMaze(TempSess);
    end
end

figure
Tot = {'Sk-Act','SkCt-Act','Ct-Act','SfCt-Act','Sf-Act',...
    'Sk-Fz','SkCt-Fz','Ct-Fz','SfCt-Fz','Sf-Fz'};
for ii = 1:5
    subplot(2,5,ii)
    p = MakeSpreadAndBoxPlot2_SB({MeanStay{1}(:,ii,1),MeanStay{2}(:,ii,1)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii})
    ylabel('Stay Time')
    ylim([0 50])
    subplot(2,5,ii+5)
    p = MakeSpreadAndBoxPlot2_SB({MeanStay{1}(:,ii,2),MeanStay{2}(:,ii,2)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii+5})
    ylabel('Stay Time')
    ylim([0 20])
end

figure
Tot = {'Sk-Act','SkCt-Act','Ct-Act','SfCt-Act','Sf-Act',...
    'Sk-Fz','SkCt-Fz','Ct-Fz','SfCt-Fz','Sf-Fz'};
for ii = 1:5
    subplot(2,5,ii)
    p = MakeSpreadAndBoxPlot2_SB({TotTime{1}(:,ii,1),TotTime{2}(:,ii,1)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii})
    ylabel('Total Time')
        ylim([0 3500])
    subplot(2,5,ii+5)
    p = MakeSpreadAndBoxPlot2_SB({TotTime{1}(:,ii,2),TotTime{2}(:,ii,2)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii+5})
    ylabel('Total Time')
        ylim([0 700])

end

figure
Tot = {'Sk-Act','SkCt-Act','Ct-Act','SfCt-Act','Sf-Act',...
    'Sk-Fz','SkCt-Fz','Ct-Fz','SfCt-Fz','Sf-Fz'};
for ii = 1:5
    subplot(2,5,ii)
    p = MakeSpreadAndBoxPlot2_SB({NumEp{1}(:,ii,1),NumEp{2}(:,ii,1)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii})
    ylabel('NUmber entries')
    ylim([0 200])
    subplot(2,5,ii+5)
    p = MakeSpreadAndBoxPlot2_SB({NumEp{1}(:,ii,2),NumEp{2}(:,ii,2)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii+5})
    ylabel('NUmber entries')
    ylim([0 200])
    
end


%%
figure
MakeBehaviourProabFigure_UMaze_CompareGroups(Trans{1},Trans{2});



% Simulate number of steps

clear Trans_Sim MnStayTime_Sim NumEp_Sim TotTime_Sim
clear Fz Zn State
for grp = 1:2
    TransMat = squeeze(nanmean(Trans{grp},1));
    TransC = [zeros(size(TransMat,1),1), cumsum(TransMat,2)];
    clear Trans_Sim
    for perm = 1:100
        State(1) = 3;
        for i = 2:(5*60*9)
            %Start in centre, moving
            State(i) = find(histc(rand,TransC(State(i-1),:)));
        end
        clear Fz Zn
        Fz = zeros(length(State),1);
        Zn = zeros(length(State),1);
        
        for ii = 1:5
            Zn(State==ii | State==ii+5) = ii;
        end
        Fz = State'>5;
        Fz = Fz+1;
        [Trans_Sim{grp}(perm ,:,:),MnStayTime_Sim{grp}(perm ,:,:),NumEp_Sim{grp}(perm ,:,:),TotTime_Sim{grp}(perm,:,:)] = TransMatFromFzZn(Fz',Zn',1);
        
    end
    
end



figure
Tot = {'Sk-Act','SkCt-Act','Ct-Act','SfCt-Act','Sf-Act',...
    'Sk-Fz','SkCt-Fz','Ct-Fz','SfCt-Fz','Sf-Fz'};
for ii = 1:5
    subplot(2,5,ii)
    p = MakeSpreadAndBoxPlot2_SB({NumEp_Sim{1}(:,ii,1),NumEp_Sim{2}(:,ii,1)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii})
    ylabel('NUmber entries')
    subplot(2,5,ii+5)
    p = MakeSpreadAndBoxPlot2_SB({NumEp_Sim{1}(:,ii,2),NumEp_Sim{2}(:,ii,2)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii+5})
    ylabel('NUmber entries')
       ylim([0 200])
 
end

figure
Tot = {'Sk-Act','SkCt-Act','Ct-Act','SfCt-Act','Sf-Act',...
    'Sk-Fz','SkCt-Fz','Ct-Fz','SfCt-Fz','Sf-Fz'};
for ii = 1:5
    subplot(2,5,ii) 
    p = MakeSpreadAndBoxPlot2_SB({TotTime_Sim{1}(:,ii,1),TotTime_Sim{2}(:,ii,1)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii})
    ylabel('Total time')
           ylim([0 3500])
    subplot(2,5,ii+5)
    p = MakeSpreadAndBoxPlot2_SB({TotTime_Sim{1}(:,ii,2),TotTime_Sim{2}(:,ii,2)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii+5})
    ylabel('Total time')
       ylim([0 1800])
 
end

figure
Tot = {'Sk-Act','SkCt-Act','Ct-Act','SfCt-Act','Sf-Act',...
    'Sk-Fz','SkCt-Fz','Ct-Fz','SfCt-Fz','Sf-Fz'};
for ii = 1:5
    subplot(2,5,ii)
    p = MakeSpreadAndBoxPlot2_SB({MnStayTime_Sim{1}(:,ii,1),MnStayTime_Sim{2}(:,ii,1)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii})
    ylabel('Mean Stay time ')
           ylim([0 50])
    subplot(2,5,ii+5)
    p = MakeSpreadAndBoxPlot2_SB({MnStayTime_Sim{1}(:,ii,2),MnStayTime_Sim{2}(:,ii,2)},{},[1,2],{'sal','dzp'},'showpoints',1,'paired',0);
    title(Tot{ii+5})
    ylabel('Mean Stay time')
       ylim([0 20])
 
end