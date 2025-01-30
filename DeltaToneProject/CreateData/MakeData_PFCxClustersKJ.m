%%MakeData_PFCxClustersKJ
% 02.10.2018 KJ
%
%   Create PFCx_clusters
%   
%
% see
%

clear
load(fullfile(FolderDeltaDataKJ,'LFPonDownStatesLayer.mat'));


%get data for each record
for p=1:length(layer_res.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(layer_res.path{',num2str(p),'}'')'])
    disp(pwd)
    
%     if exist('ChannelsToAnalyse/PFCx_clusters.mat','file')==2
%         continue
%     end
    
    clearvars -except layer_res p
    
    rec_curves = layer_res.down.meandown2{p};
    rec_channels = layer_res.channels{p};
    
    clusters = [];
    channels = rec_channels;
    
    for i=1:length(rec_channels)
        x = rec_curves{i}(:,1);
        y = rec_curves{i}(:,2);
        
        %% features
        %postive deflection
        if sum(y(x>0 & x<=150))>0
            x1 = x>0 & x<=200;
            x2 = x>150 & x<=350;
            [feat1, feat3] = max(y(x1));
            [feat2, feat4] = min(y(x2));
            x1 = x(x1);
            x2 = x(x2);
            feat3 = x1(feat3);
            feat4 = x2(feat4);

        %negative deflection
        else
            x1 = x>0 & x<=250;
            x2 = x>200 & x<=350;
            [feat1, feat3] = min(y(x1));
            [feat2, feat4] = max(y(x2));
            x1 = x(x1);
            x2 = x(x2);
            feat3 = x1(feat3);
            feat4 = x2(feat4);
        end
        
        %% clusters
        xp = feat1;
        yp = feat2;

        if yp>(0.8*xp-200)
            clusters(i) = 1;
        elseif yp<=(0.8*xp-200) & yp>(0.8*xp-900)
            clusters(i) = 2;
        elseif yp<=(0.8*xp-900) & yp>(0.8*xp-1600)
            clusters(i) = 3;
        elseif yp<=(0.8*xp-1600) & yp>(0.7*xp-2140)
            clusters(i) = 4;
        elseif yp<=(0.7*xp-2140)
            clusters(i) = 5;
        end
        
    end
    
    save ChannelsToAnalyse/PFCx_clusters.mat clusters channels
    
end

