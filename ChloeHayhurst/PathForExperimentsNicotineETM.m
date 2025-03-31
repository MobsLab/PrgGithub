function Dir=PathForExperimentsNicotineETM(experiment)

a=0;


% Sessions types : 'Sleep' , 'ClosedArm' , 'OpenArm'

if strcmp(experiment,'Sleep')
    
    % Mouse 1393
    
    a=a+1; Dir.path{a}{1}='/media/nas7/ETM/Mouse1393/20230316/NicotineETM_M1393_20230316_Sleep/';
    load([Dir.path{a}{1},'ExpeInfo.mat']),Dir.ExpeInfo{a}{1}=ExpeInfo;
    
    
elseif strcmp(experiment,'ClosedArm')
    %% withdraw nicotine
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1376/20230228/NicotineETM_M1376_20230228_ETM/NicotineETM_M1376_20230228_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1385/20230228/NicotineETM_M1385_20230228_ETM/NicotineETM_M1385_20230228_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1386/20230228/NicotineETM_M1386_20230228_ETM/NicotineETM_M1386_20230228_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1391/20230301/NicotineETM_M1391_20230301_ETM/NicotineETM_M1391_20230301_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1393/20230301/NicotineETM_M1393_20230301_ETM/NicotineETM_M1393_20230301_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1394/20230301/NicotineETM_M1394_20230301_ETM/NicotineETM_M1394_20230301_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
    %% control
        % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1376/20230316/NicotineETM_M1376_20230316_ETM/NicotineETM_M1376_20230316_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1385/20230316/NicotineETM_M1385_20230316_ETM/NicotineETM_M1385_20230316_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1386/20230316/NicotineETM_M1386_20230316_ETM/NicotineETM_M1386_20230316_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1391/20230316/NicotineETM_M1391_20230316_ETM/NicotineETM_M1391_20230316_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1393/20230316/NicotineETM_M1393_20230316_ETM/NicotineETM_M1393_20230316_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1394/20230316/NicotineETM_M1394_20230316_ETM/NicotineETM_M1394_20230316_ClosedArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
elseif strcmp(experiment,'OpenArm')
    
    %% withdraw nicotine
    % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1376/20230228/NicotineETM_M1376_20230228_ETM/NicotineETM_M1376_20230228_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1385/20230228/NicotineETM_M1385_20230228_ETM/NicotineETM_M1385_20230228_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1386/20230228/NicotineETM_M1386_20230228_ETM/NicotineETM_M1386_20230228_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1391/20230301/NicotineETM_M1391_20230301_ETM/NicotineETM_M1391_20230301_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1393/20230301/NicotineETM_M1393_20230301_ETM/NicotineETM_M1393_20230301_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1394/20230301/NicotineETM_M1394_20230301_ETM/NicotineETM_M1394_20230301_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    
        %% control
        % Mouse 1376
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1376/20230316/NicotineETM_M1376_20230316_ETM/NicotineETM_M1376_20230316_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1385
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1385/20230316/NicotineETM_M1385_20230316_ETM/NicotineETM_M1385_20230316_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1386
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1386/20230316/NicotineETM_M1386_20230316_ETM/NicotineETM_M1386_20230316_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1391
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1391/20230316/NicotineETM_M1391_20230316_ETM/NicotineETM_M1391_20230316_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
    % Mouse 1393
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1393/20230316/NicotineETM_M1393_20230316_ETM/NicotineETM_M1393_20230316_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
        % Mouse 1394
    a=a+1;
    cc=1;
    for c=1:5
        Dir.path{a}{cc}=['/media/nas7/Nicotine/Mouse1394/20230316/NicotineETM_M1394_20230316_ETM/NicotineETM_M1394_20230316_OpenArm/Sess',num2str(c),'/'];
        load([Dir.path{a}{cc},'ExpeInfo.mat']),Dir.ExpeInfo{a}{cc}=ExpeInfo;
        cc=cc+1;
    end
    
else
    error('Invalid name of experiment')
end

end