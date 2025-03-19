clear all
close all

% Generate data that comes from three PCs
NumPC = 3;
numNeur = 1000;
numTimeSteps = 10000;
PC_base = randn(NumPC,numNeur);
WeightPC = [10,5,1];
NoiseLevels_Template = [0.01:0.1:4];
NoiseLevels_Match = [0.01:0.1:1];
RemoveDiagonal = 1;

for ns_template = 1:length(NoiseLevels_Template)
    
    clear PC_timecourse Neur_timecourse_noisefree Neur_timecourse eigenvectors strength
    
    NoiseRat = NoiseLevels_Template(ns_template);
    
    % Simulate the data
    PC_timecourse = randn(NumPC,numTimeSteps);
    for pc = 1 : length(WeightPC)
        PC_timecourse(pc,:) = PC_timecourse(pc,:)*WeightPC(pc);
    end
    Neur_timecourse_noisefree = PC_timecourse'*PC_base;
    
    % add gaussian noise
    NsMat = randn(size(Neur_timecourse_noisefree))*mean(var(Neur_timecourse_noisefree))*NoiseRat;
    Neur_timecourse = Neur_timecourse_noisefree + NsMat;
    
    % Z-score
    Neur_timecourse = zscore(Neur_timecourse);
    
    % Compute eigenvalues/vectors and sort in descending order
    correlations = corrcoef(Neur_timecourse);
    [eigenvectors,eigenvalues] = eig(correlations);
    [eigenvalues,i] = sort(diag(eigenvalues),'descend');
    eigenvectors = eigenvectors(:,i);
    
    % Sanity check
    figure('Name',['Noise= ' num2str(NoiseLevels_Template(ns_template))])
    for i = 1:NumPC
        subplot(3,NumPC,i)
        plot(PC_timecourse(i,:),Neur_timecourse*eigenvectors(:,i))
        hold on
        xlabel('True timecourse')
        ylabel('PCA estimate timecourse')
        
    end
    for i = 1:NumPC
        subplot(3,NumPC,i+NumPC)
        plot(PC_base(i,:),eigenvectors(:,i),'.')
        hold on
        xlabel('True weights')
        ylabel('Eigenvalue')
    end
    
    % Calculate reactivation score
    for i = 1:NumPC
        template = eigenvectors(:,i)*eigenvectors(:,i)';
        if RemoveDiagonal
            template = template - diag(diag(template)); % remove the diagonal
        end
        strength(:,i) = nansum(Neur_timecourse*(template).*Neur_timecourse,2);
        subplot(3,NumPC,i+NumPC*2)
        plot(PC_timecourse(i,:).^2,strength(:,i))
        hold on
        xlabel('True timecourse')
        ylabel('Reactivation timecourse')
    end
    
    % Simulate different levels of noise and calculate reactivation score
    
    for ns = 1:length(NoiseLevels_Match)
        
        PC_timecourse_Match = randn(NumPC,numTimeSteps);
        for pc = 1 : length(WeightPC)
            PC_timecourse_Match(pc,:) = PC_timecourse_Match(pc,:)*WeightPC(pc);
        end
        Neur_timecourse_noisefree_Match = PC_timecourse_Match'*PC_base;
        
        % add gaussian noise
        NsMat = randn(size(Neur_timecourse_noisefree_Match))*mean(var(Neur_timecourse_noisefree))*NoiseLevels_Match(ns);
        Neur_timecourse_Match = Neur_timecourse_noisefree_Match + NsMat;
        
        % Z-score
        Neur_timecourse = zscore(Neur_timecourse);
        
        % Calculate reactivation score
        for i = 1:NumPC
            template = eigenvectors(:,i)*eigenvectors(:,i)';
            strength_sim_widiag{ns_template}(i,ns,:) = nansum(Neur_timecourse_Match*(template).*Neur_timecourse_Match,2);

            if RemoveDiagonal
                template = template - diag(diag(template)); % remove the diagonal
            end
            strength_sim_nodiag{ns_template}(i,ns,:) = nansum(Neur_timecourse_Match*(template).*Neur_timecourse_Match,2);
        end
        
    end
    
end

figure
clear React_templatenoise_widiag React_matchtnoise_widiag React_templatenoise_nodiag React_matchtnoise_nodiag
for i = 1:NumPC
    clear temp 
    for ns_template = 1:length(NoiseLevels_Template)
        React_templatenoise_widiag(i,ns_template) = nanmean(squeeze(nanmean(strength_sim_widiag{ns_template}(i,:,:),3)));
        temp(ns_template,:) = squeeze(nanmean(strength_sim_widiag{ns_template}(i,:,:),3));
    end
    React_matchtnoise_widiag(i,:) = squeeze(nanmean(temp,1));
    React_bothnoise_widiag(i,:,:) = temp;
    
       clear temp 
    for ns_template = 1:length(NoiseLevels_Template)
        React_templatenoise_nodiag(i,ns_template) = nanmean(squeeze(nanmean(strength_sim_nodiag{ns_template}(i,:,:),3)));
        temp(ns_template,:) = squeeze(nanmean(strength_sim_nodiag{ns_template}(i,:,:),3));
    end
    React_matchtnoise_nodiag(i,:) = squeeze(nanmean(temp,1));
        React_bothnoise_nodiag(i,:,:) = temp;

end

subplot(221)
plot(zscore(React_templatenoise_widiag'))
legend({'PC1','PC2','PC3'})
xlabel('template noise')
ylabel('ReactStrength - norm')
title('No diag removal')

subplot(223)
plot(zscore(React_matchtnoise_widiag'))
legend({'PC1','PC2','PC3'})
xlabel('match noise')
ylabel('ReactStrength - norm')


subplot(222)
plot(zscore(React_templatenoise_nodiag'))
legend({'PC1','PC2','PC3'})
xlabel('template noise')
ylabel('ReactStrength - norm')
title('No diag removal')

subplot(224)
plot(zscore(React_matchtnoise_nodiag'))
legend({'PC1','PC2','PC3'})
xlabel('match noise')
ylabel('ReactStrength - norm')

