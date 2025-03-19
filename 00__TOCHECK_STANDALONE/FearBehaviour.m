clear all,
AllFearData={'ManipFeb15Bulbectomie',...
    'FearCBNov15'};
n=1;
for ss=1:length(AllFearData)
    Dir=PathForExperimentFEAR(AllFearData{ss},'fear',1);
    DirR = RestrictPathForExperiment(Dir,'Group',{'CTRL'});
    DirR = RestrictPathForExperiment(Dir,'Session',{'COND'});
    
    for mm=1:size(DirR.path,2)
        try
            cd(DirR.path{mm})
            load('Behavior.mat')
            if exist('TTL','var')
                % Get CSPlusBlock beginnings
                Shocks=TTL(find(TTL(:,2)==5),1);
                CSplu=TTL(find(TTL(:,2)==3),1);
                CSmoin=TTL(find(TTL(:,2)==4),1);
                if length(CSmoin)==215
                   CSmoin(216)=CSmoin(215)+1.1;
                end
                CSpluInd=reshape(CSplu,length(CSplu)/8,8);
                CSpluBegEnd=[CSpluInd(1,:);CSpluInd(end,:)];
                CSPlusEpoch=intervalSet(CSpluBegEnd(1,:)*1e4,CSpluBegEnd(2,:)*1e4);
                CSPlusEpochBrd=intervalSet(CSpluBegEnd(1,:)*1e4-10*1e4,CSpluBegEnd(2,:)*1e4);
                CSmoinInd=reshape(CSmoin,length(CSmoin)/8,8);
                CSmoinBegEnd=[CSmoinInd(1,:);CSmoinInd(end,:)];
                CSMoinsEpoch=intervalSet(CSmoinBegEnd(1,:)*1e4,CSmoinBegEnd(2,:)*1e4);
                CSMoinsEpochBrd=intervalSet(CSmoinBegEnd(1,:)*1e4-10*1e4,CSmoinBegEnd(2,:)*1e4);
                PostShockEpoch=intervalSet(Shocks*1e4,Shocks*1e4+30*1e4);
            else
                CSPlusEpoch=intervalSet(StimInfo(1:3:end-1,1)*1e4,StimInfo(1:3:end-1,1)*1e4+30*1e4);
                CSPlusEpochBrd=intervalSet(StimInfo(1:3:end-1,1)*1e4-10*1e4,StimInfo(1:3:end-1,1)*1e4+30*1e4);
                CSMoinsEpoch=intervalSet(StimInfo(3:3:end,1)*1e4,StimInfo(3:3:end,1)*1e4+30*1e4);
                CSMoinsEpochBrd=intervalSet(StimInfo(3:3:end,1)*1e4-10*1e4,StimInfo(3:3:end,1)*1e4+30*1e4);
                PostShockEpoch=intervalSet(StimInfo(2:3:end,1)*1e4+2*1e4,StimInfo(2:3:end,1)*1e4+30*1e4);
            end
            
            % Variables to get
            %Freezing during sounds
            %Mean speed during sounds
            %Mean speed during sounds outisde freezing
            %Movement triggered on sound onset
            %Movement just before sound
            for k=1:length(Start(CSPlusEpoch))
                Var{ss,1}(k)=length(Data(Restrict(Movtsd,And(FreezeEpoch,subset(CSPlusEpoch,k)))))./length(Data(Restrict(Movtsd,subset(CSPlusEpoch,k))));
                Var{ss,2}(k)=mean(Data(Restrict(Movtsd,subset(CSPlusEpoch,k))));
                Var{ss,3}(k)=mean(Data(Restrict(Movtsd,And(FreezeEpoch,subset(CSPlusEpoch,k)))));
                Var{ss,4}(k,:)=Data(Restrict(Movtsd,subset(CSPlusEpochBrd,k)));
            end
            
            %Freezing during sounds
            %Mean speed during sounds
            %Mean speed during sounds outisde freezing
            %Movement triggered on sound onset
            %Movement just before sound
            for k=1:length(Start(CSMoinsEpoch))
                Var{ss,5}(k)=length(Data(Restrict(Movtsd,And(FreezeEpoch,subset(CSMoinsEpoch,k)))))./length(Data(Restrict(Movtsd,subset(CSMoinsEpoch,k))));
                Var{ss,6}(k)=mean(Data(Restrict(Movtsd,subset(CSMoinsEpoch,k))));
                Var{ss,7}(k)=mean(Data(Restrict(Movtsd,And(FreezeEpoch,subset(CSMoinsEpoch,k)))));
                Var{ss,8}(k,:)=Data(Restrict(Movtsd,subset(CSMoinsEpochBrd,k)));
            end
            
            %Freezing after shock
            %Mean speed after sounds
            %Mean speed after sounds ouside freezing
            %Movement triggered on shock
            for k=1:length(Start(PostShockEpoch))
                Var{ss,9}(k)=length(Data(Restrict(Movtsd,And(FreezeEpoch,subset(PostShockEpoch,k)))))./length(Data(Restrict(Movtsd,subset(PostShockEpoch,k))));
                Var{ss,10}(k)=mean(Data(Restrict(Movtsd,subset(PostShockEpoch,k))));
                Var{ss,11}(k)=mean(Data(Restrict(Movtsd,And(FreezeEpoch,subset(PostShockEpoch,k)))));
                Var{ss,12}(k,:)=Data(Restrict(Movtsd,subset(PostShockEpoch,k)));
            end

            
            n=n+1;
            
            clear TTL Movtsd StimInfo
        end
    end
    
end


% examples
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246]);
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'});
% Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Dir=RestrictPathForExperiment(Dir,'Treatment','CNO1');
%
% other function:
% MergePathForExperiment.m