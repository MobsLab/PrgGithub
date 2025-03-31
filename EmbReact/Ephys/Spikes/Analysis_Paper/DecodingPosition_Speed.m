cd('/media/DataMOBsRAIDN/ProjectEmbReact/Figures/UnitAnalysisphD')
load('OverallInfoPhysioSpikesAllSess0.5.mat')
 DecodingLimits = [0.3,0.7]; 
 
 % Project onto fz no fz and shock vs safe
for mm = 1:length(MiceNumber)
    IsFz =  MouseByMouse.UMazeCond.IsFz{mm};
    Sp = MouseByMouse.UMazeCond.Speed{mm}+1e-5;
    FR = MouseByMouse.UMazeCond.FR{mm};
    LinPos =  MouseByMouse.UMazeCond.LinPos{mm};
    BadBins = find(isnan(Sp));
    Sp(BadBins) = [];
    IsFz(BadBins) = [];
    FR(:,BadBins) = [];
    LinPos(BadBins) = [];
  FR = zscore(FR')';
     
    
    
    % Create projection vectors but equalizing for other value - position,
    % equalize for speed
    xlims = [0:1:15];
    Sp_Sf = Sp(LinPos<DecodingLimits(1));
    Id_Sf = find(LinPos<DecodingLimits(1));
    Sp_Sk = Sp(LinPos>DecodingLimits(2));
    Id_Sk = find(LinPos>DecodingLimits(2));
    
    [Y_Sf,X] = hist(Sp_Sf,xlims+0.5);
    [Y_Sk,X] = hist(Sp_Sk,xlims+0.5);
    Y_Com = min([Y_Sf;Y_Sk]);
    Sp_Sf_balanced = [];
    Sp_Sk_balanced = [];
    for xx = 1:length(xlims)-1
        Id = Id_Sf(find(Sp_Sf>xlims(xx) & Sp_Sf<xlims(xx+1)));
        Id = Id(randperm(length(Id)));
        Sp_Sf_balanced = [Sp_Sf_balanced,Id(1:Y_Com(xx))];
        
        Id = Id_Sk(find(Sp_Sk>xlims(xx) & Sp_Sk<xlims(xx+1)));
        Id = Id(randperm(length(Id)));
        Sp_Sk_balanced = [Sp_Sk_balanced,Id(1:Y_Com(xx))];
        
    end
    
    W_Pos = nanmean(FR(:,Sp_Sf_balanced),2) - nanmean(FR(:,Sp_Sk_balanced),2);
    
    % Create projection vectors but equalizing for other value - speed,
    % equalize for position
    xlims = [0:0.1:1];
    Pos_Fz = LinPos(IsFz==1);
    Id_Fz = find(IsFz==1);
    Pos_NoFz = LinPos(IsFz==0);
    Id_NoFz = find(IsFz==0);
    
    [Y_Fz,X] = hist(Pos_Fz,xlims+0.05);
    [Y_NoFz,X] = hist(Pos_NoFz,xlims+0.05);
    Y_Com = min([Y_Fz;Y_NoFz]);
    Pos_NoFz_balanced = [];
    Pos_Fz_balanced = [];
    for xx = 1:length(xlims)-1
        Id = Id_Fz(find(Pos_Fz>xlims(xx) & Pos_Fz<xlims(xx+1)));
        Id = Id(randperm(length(Id)));
        Pos_Fz_balanced = [Pos_Fz_balanced,Id(1:Y_Com(xx))];
        
        Id = Id_NoFz(find(Pos_NoFz>xlims(xx) & Pos_NoFz<xlims(xx+1)));
        Id = Id(randperm(length(Id)));
        Pos_NoFz_balanced = [Pos_NoFz_balanced,Id(1:Y_Com(xx))];
        
    end
    W_Sp =  nanmean(FR(:,Pos_Fz_balanced),2) - nanmean(FR(:,Pos_NoFz_balanced),2);
    
    subplot(221)
    nhist({LinPos(Pos_NoFz_balanced),LinPos(Pos_Fz_balanced)})
    subplot(222)
    nhist({Sp(Sp_Sf_balanced),Sp(Sp_Sk_balanced)})
    subplot(2,2,3)
%     scatter(FR'*W_Pos,FR'*W_Sp,Sp*20,LinPos,'filled')
nhist({FR(:,LinPos<DecodingLimits(1))'*W_Pos,FR(:,LinPos>DecodingLimits(2))'*W_Pos})
subplot(2,2,4)
nhist({FR(:,IsFz==0)'*W_Sp,FR(:,IsFz==1)'*W_Sp})
    pause
    clf
end