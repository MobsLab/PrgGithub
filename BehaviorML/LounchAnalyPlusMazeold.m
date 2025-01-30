

%% INPUTS
MotherFolder=pwd;

% toujours construire : ProjetBULB\PlusMaze
erasePreviousA=0; % 0 to keep existing files, 1 otherwise


%% initiate
if sum(strfind(MotherFolder,'/'))==0
    mark='\';
else
    mark='/';
end

lis=dir(MotherFolder);

for i=3:length(lis)
    temp=lis(i).name;
    
    if ~isempty(strfind(temp,'Mouse-')) && ~isempty(strfind(temp,'Day')) && ~isempty(strfind(temp,'Session'))
        disp(' ')
        disp(temp)
        
        % ---------------------------------------------------------------
        % get infos
        index=strfind(temp,'-');
        index=index(index>strfind(temp,'Mouse-'));
        n_mouse=str2num(temp(index(1)+1:index(2)-1));
        n_day=str2num(temp(strfind(temp,'Day')+3));
        n_session=str2num(temp(strfind(temp,'Session')+7));
        
        % do Tracking_offline if not already
        try 
            Trackin_offline_RB(temp);
        catch
            disp('skipped')
        end
        % ---------------------------------------------------------------
        % get ref mask PosOFF
        clear ref mask PosOFF
        load([temp,mark,'TrackingOFFline.mat'],'ref','mask','PosOFF');
        
        
        % ---------------------------------------------------------------
        % AnalysePlusMaze
        
        MatNumber=AnalysePlusMaze(PosOFF,mask,1);
        disp('Done')
        
    end
end

