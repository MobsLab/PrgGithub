

cd('/media/nas6/ProjetEmbReact/Mouse1230/20220118/ProjectEmbReact_M1230_20220118_Habituation')
load('behavResources.mat', 'ref')
figure
imagesc(ref)
caxis([0.1 0.4])
hold on

ShockMask =[42 130 41 58 103 55 106 130 42 130];
NoShockMask = [43 160 40 231 109 232 106 157 43 160];
CentreMask = [149 124 151 162  205 162 205 124 149 124];
CentreNoShockMask = [151 162 205 162 205 231 152 231 151 162];
CentreShockMask = [149 124 205 124 205 54 149 54 149 124];
FarShockMask = [106 130 149 131 149 54 103 54 106 130];
FarNoShockMask = [106 156 150 155 152 231 109 232 106 156];

% ShockMask =[246 43 246 129 155 131 149 45 246 43];
% NoShockMask = [119 36 121 124 22 129 21 37 119 36];
% CentreMask = [163 179 165 225 106 226 109 177 163 179];
% FarShockMask = [158 177 155 131 246 129 248 176 158 177];
% FarNoShockMask = [117 177 23 180 22 129 121 124 117 177];
% CentreShockMask = [163 178 248 176 248 225 165 225 163 178];
% CentreNoShockMask = [23 180 109 177 106 227 24 231 23 180];

% ShockMask =[41 153 119 157 119 230 36 226 41 153];
% NoShockMask = [117 128 117 49 32 49 35 125 117 128];
% CentreMask = [155 158 217 158 217 114 158 110 155 158];
% CentreShockMask = [155 158 217 158 218 232 155 227 155 158];
% CentreNoShockMask = [158 109 158 47 211 44 217 114 158 109];
% FarShockMask = [155 158 119 157 118 229 154 227 155 158];
% FarNoShockMask = [117 128 117 49 158 47 158 123 117 128];


plot(ShockMask(1:2:end),ShockMask(2:2:end),'linewidth',2);
plot(NoShockMask(1:2:end),NoShockMask(2:2:end),'linewidth',2);
plot(CentreMask(1:2:end),CentreMask(2:2:end),'linewidth',2);
plot(CentreShockMask(1:2:end),CentreShockMask(2:2:end),'linewidth',2);
plot(CentreNoShockMask(1:2:end),CentreNoShockMask(2:2:end),'linewidth',2);
plot(FarShockMask(1:2:end),FarShockMask(2:2:end),'linewidth',2);
plot(FarNoShockMask(1:2:end),FarNoShockMask(2:2:end),'linewidth',2);



for sess=1:length(Sess.M11249)
    
    cd(Sess.M11249{sess})
    
    load('behavResources.mat', 'ref')
    load('behavResources.mat', 'Xtsd')
    load('behavResources.mat', 'Ytsd')
    load('behavResources.mat', 'Ratio_IMAonREAL')
%     im = insertShape(ref,'Polygon',mask_UMaze);
%     im = rgb2gray(im);
    
    Shock = roipoly(ref,ShockMask(1:2:end),ShockMask(2:2:end)); Zone{1}=uint8(Shock);
    %plot(ShockMask(1:2:end),ShockMask(2:2:end),'linewidth',2);
    NoShock = roipoly(ref,NoShockMask(1:2:end),NoShockMask(2:2:end)); Zone{2}=uint8(NoShock);
    %plot(NoShockMask(1:2:end),NoShockMask(2:2:end),'linewidth',2);
    Centre = roipoly(ref,CentreMask(1:2:end),CentreMask(2:2:end)); Zone{3}=uint8(Centre);
    %plot(CentreMask(1:2:end),CentreMask(2:2:end),'linewidth',2);
    CentreShock = roipoly(ref,CentreShockMask(1:2:end),CentreShockMask(2:2:end)); Zone{4}=uint8(CentreShock);
    %plot(CentreShockMask(1:2:end),CentreShockMask(2:2:end),'linewidth',2);
    CentreNoShock = roipoly(ref,CentreNoShockMask(1:2:end),CentreNoShockMask(2:2:end)); Zone{5}=uint8(CentreNoShock);
    %plot(CentreNoShockMask(1:2:end),CentreNoShockMask(2:2:end),'linewidth',2);
    FarShock = roipoly(ref,FarShockMask(1:2:end),FarShockMask(2:2:end)); Zone{8}=uint8(FarShock);
    %plot(FarShockMask(1:2:end),FarShockMask(2:2:end),'linewidth',2);
    FarNoShock = roipoly(ref,FarNoShockMask(1:2:end),FarNoShockMask(2:2:end)); Zone{9}=uint8(FarNoShock);
    %plot(FarNoShockMask(1:2:end),FarNoShockMask(2:2:end),'linewidth',2);
    
    
    XXX = floor(Data(Xtsd)*Ratio_IMAonREAL);
    XXX(isnan(XXX)) = 240;
    YYY = floor(Data(Ytsd)*Ratio_IMAonREAL);
    YYY(isnan(YYY)) = 320;
    Xtemp=Data(Xtsd);
    T1=Range(Xtsd);
    for t = 1:length(Zone)
        try
            ZoneIndices{t}=find(diag(Zone{t}(XXX,YYY)));
            Xtemp2=Xtemp*0;
            Xtemp2(ZoneIndices{t})=1;
            ZoneEpoch{t}=thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above');
            Occup(t)=size(ZoneIndices{t},1)./size(XXX,1);
        catch
            ZoneIndices{t}=[];
            ZoneEpoch{t}=intervalSet(0,0);
            Occup(t)=0;
            FreezeTime(t)=0;
        end
    end
    try
    load('behavResources_SB.mat', 'Behav')
    Behav.ZoneEpoch = ZoneEpoch;
      save('behavResources_SB.mat','Behav','-append')
  end
    save('behavResources.mat','ZoneEpoch','Occup','ZoneIndices','-append')
    
end






