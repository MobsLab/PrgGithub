 function MatNumber=AnalysePlusMaze(PosMat,mask,plo)

%% INPUTS

threshold_InOut=0.5; % remove serial entry
if ~exist('plo','var')
    plo=0;
end

nameIO={'entry','exit'}; 
nameArm={'left','right','up','down'};


PosWork=PosMat(~isnan(PosMat(:,2)),:);

%% get edges from mask
A=diff(mask);
B=diff(mask')';
yedge=find(sum(A,2)~=0);
xedge=find(sum(B,1)~=0);

y_up=yedge(2);
y_down=yedge(3);
x_left=xedge(2);
x_right=xedge(3);


%% times of entry and exit
% right arm
out=PosWork(:,2)<x_right;
in=PosWork(:,2)>x_right;
t_entry_right=PosWork(out(1:end-1) & in(2:end),1);
t_exit_right=PosWork(in(1:end-1) & out(2:end),1);

% left arm
out=PosWork(:,2)>x_left;
in=PosWork(:,2)<x_left;
t_entry_left=PosWork(out(1:end-1) & in(2:end),1);
t_exit_left=PosWork(in(1:end-1) & out(2:end),1);
% up arm
out=PosWork(:,3)>y_up;
in=PosWork(:,3)<y_up;
t_entry_up=PosWork(out(1:end-1) & in(2:end),1);
t_exit_up=PosWork(in(1:end-1) & out(2:end),1);

% down arm
out=PosWork(:,3)<y_down;
in=PosWork(:,3)>y_down;
t_entry_down=PosWork(out(1:end-1) & in(2:end),1);
t_exit_down=PosWork(in(1:end-1) & out(2:end),1);


MatNumber=zeros(length(nameIO),length(nameArm));
MatNumberth=MatNumber;
for i=1:length(nameIO)
    for j=1:length(nameArm)
        eval(['temp=t_',nameIO{i},'_',nameArm{j},';']);
        MatNumber(i,j)=length(temp);
        Dtemp=diff(temp);
        temp=temp(Dtemp>threshold_InOut);
        MatNumberth(i,j)=length(temp);
    end
end

%% display
if plo
    figure('Color',[1 1 1])
    imagesc(mask); colormap gray
    hold on, plot(PosWork(:,2),PosWork(:,3),'b')
    msg_box=msgbox('Continue PlusMaze Analysis','save','modal');
    waitfor(msg_box);
    close
end



