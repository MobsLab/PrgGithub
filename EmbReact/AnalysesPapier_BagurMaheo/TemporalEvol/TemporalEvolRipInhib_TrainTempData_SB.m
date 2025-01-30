% Train the SVM
clear all
DoZscore = 0;
ParToKeep = {[1,4,5]}; %ParToKeep = {[1,2,3,4,5]};
ParNames = {'All'};
SaveLoc = '/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/';
NumBins = 10;

%% Load data
% Controls
load('Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat')
% get hte hand corrected OB values
clear DATA_Ctrl
for param=[1:8]
    
    for mouse = 1:length(Mouse)
        try
            clear D, D = Data(OutPutData.(Session_type{1}).(Params{param}).tsd{mouse,5});
            if param==1, D(D<1.5) = NaN; end
            MaxBins = length(D);
            for ii =1:NumBins-1
                DATA_shock.(Params{param})(mouse,ii) = nanmean(D((ii-1)*MaxBins/NumBins+1:(ii)*MaxBins/NumBins));
            end
        catch
            DATA_shock.(Params{param})(mouse,1:NumBins-1) = NaN;
        end
        
        try
            clear D, D = Data(OutPutData.(Session_type{1}).(Params{param}).tsd{mouse,6});
            if param==1, D(D<1.5) = NaN; end
            for ii =1:NumBins-1
                
                DATA_safe.(Params{param})(mouse,ii) = nanmean(D((ii-1)*MaxBins/NumBins+1:(ii)*MaxBins/NumBins+1));
            end
        catch
            DATA_safe.(Params{param})(mouse,1:NumBins-1) = NaN;
        end
    end
end
     

for param=[1:8]
    DATA_Ctrl_Sk{param} =[];
    DATA_Ctrl_Sf{param} = [];
    for mouse = 1:length(Mouse)
        
        DATA_Ctrl_Sk{param} = [DATA_Ctrl_Sk{param}, DATA_shock.(Params{param})(mouse,:)];
        DATA_Ctrl_Sf{param} = [DATA_Ctrl_Sf{param},DATA_safe.(Params{param})(mouse,:)];
        
    end
end

for param=[1:8]
    DATA_Ctrl(param,:) = [ DATA_Ctrl_Sk{param}, DATA_Ctrl_Sf{param}];
end

figure
for parToUse = 1:length(ParNames)
    
    %% Contols train and test
    % Only keep subset of parameters
    DATA2 = DATA_Ctrl(ParToKeep{parToUse},:);
    
    % Only keep mice with no NaNs
    totnummice_train = size(DATA2,2)/2;
    BadGuys = sum(isnan(DATA2))>0;
    BadGuys = BadGuys(1:totnummice_train) + BadGuys(totnummice_train+1:end);
    GoodGuys = find(BadGuys==0);
    BadGuys = [BadGuys,BadGuys]>0;
    
    DATA2(:,BadGuys)=[];
    totnummice_train = size(DATA2,2)/2;
    if DoZscore
        Remstd = std(DATA2');
        RemMn = mean(DATA2');
        DATA2 = zscore(DATA2')';
    end
    
    classifier{parToUse} = fitcsvm(DATA2',[zeros(1,size(DATA2,2)/2),ones(1,size(DATA2,2)/2)],'ClassNames',[0,1]);
end




%%%%


% Plot temporal evolution on RipInhib


clearvars -except classifier ParToKeep NumBins 
parToUse=1;
GrpNames = {'RipInhib','RipCtrl'};
figure
smofact = 1;
for grp = 1:2
    
    if grp==1
        load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Cond_2sFullBins.mat')
    else
        load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat')
    end
    Session_type={'Cond'};
    Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power'};
    SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/AllMiceTempEvol';
    NumMice = length(Mouse);
    for param=1:8
        for mouse = 1:NumMice
            try
                clear D, D = Data(OutPutData.(Session_type{1}).(Params{param}).tsd{mouse,5});
                if param==1, D(D<1.5) = NaN; end
                MaxBins = length(D);
                for ii =1:NumBins-1
                    DATA_shock.(Params{param})(mouse,ii) = nanmean(D((ii-1)*MaxBins/NumBins+1:(ii)*MaxBins/NumBins));
                end
            catch
                DATA_shock.(Params{param})(mouse,1:NumBins-1) = NaN;
            end
            
            try
                clear D, D = Data(OutPutData.(Session_type{1}).(Params{param}).tsd{mouse,6});
                if param==1, D(D<1.5) = NaN; end
                for ii =1:NumBins-1
                    
                    DATA_safe.(Params{param})(mouse,ii) = nanmean(D((ii-1)*MaxBins/NumBins+1:(ii)*MaxBins/NumBins+1));
                end
            catch
                DATA_safe.(Params{param})(mouse,1:NumBins-1) = NaN;
            end
        end
        DATA_shock.(Params{param})(DATA_shock.(Params{param})==0) = NaN;
        DATA_safe.(Params{param})(DATA_safe.(Params{param})==0) = NaN;
    end
    
    % figure
    clear score_Sk score_Sf
    clear GoodGuys
    for mousenum = 1:NumMice
        
        
        clear Sk Sf Sk_Vect Sf_Vect
        for param = 1:8
            SkData = (DATA_shock.(Params{param})(mousenum,:));
            SfData = (DATA_safe.(Params{param})(mousenum,:));
            
            Sk_Vect(param,:) = SkData;
            Sf_Vect(param,:) = SfData;
            %         subplot(2,3,param)
            %         nhist({Sk_Vect(param,:),Sf_Vect(param,:)})
        end
        
        
        Sk_Vect = Sk_Vect(ParToKeep{parToUse},:);
        Sf_Vect = Sf_Vect(ParToKeep{parToUse},:);
        
        
        [prediction,score] = predict(classifier{1},Sk_Vect');
        score_Sk(mousenum,:) = score(:,1);
        score_Sk(mousenum,sum(isnan(Sk_Vect))>0) = NaN;
        [prediction,score] = predict(classifier{1},Sf_Vect');
        score_Sf(mousenum,:) = score(:,1);
        score_Sf(mousenum,sum(isnan(Sf_Vect))>0) = NaN;
        %     subplot(2,3,6)
        %     plot(    score_Sk(mousenum,:),'r')
        %     hold on
        %     plot(    score_Sf(mousenum,:),'b')
        
        %   pause, clf
        
        if  sum(sum(isnan(Sk_Vect'))==1)
            GoodGuys(mousenum) = 0;
        else
            GoodGuys(mousenum) = 1;
            
        end
        
    end
    
    GoodGuys = logical(GoodGuys);
    
    subplot(2,2,grp)
    errorbar(runmean(nanmean(score_Sf(GoodGuys,:)),smofact),stdError(score_Sf(GoodGuys,:)),'b')
    hold on
    errorbar(runmean(nanmean(score_Sk(GoodGuys,:)),smofact),stdError(score_Sk(GoodGuys,:)),'r')
    line(xlim,[0 0])
    title(GrpNames{grp})
    makepretty
    legend('Sf','Sk')
    ylim([-3 3])
    
    
    RemSf{grp} = score_Sf(GoodGuys,:);
    RemSk{grp} = score_Sk(GoodGuys,:);
end


subplot(2,2,3)
errorbar(runmean(nanmean(RemSf{1}),smofact),stdError(RemSf{1}),'b')
hold on
errorbar(runmean(nanmean(RemSf{2}),smofact),stdError(RemSf{2}),'c')
line(xlim,[0 0])
title('Safe Fz')
makepretty
legend(GrpNames)
ylim([-3 3])


subplot(2,2,4)
errorbar(runmean(nanmean(RemSk{1}),smofact),stdError(RemSk{1}),'r')
hold on
errorbar(runmean(nanmean(RemSk{2}),smofact),stdError(RemSk{2}),'m')
line(xlim,[0 0])
title('Shock Fz')
makepretty
legend(GrpNames)
ylim([-3 3])