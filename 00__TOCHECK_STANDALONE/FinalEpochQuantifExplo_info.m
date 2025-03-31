%FinalEpochQuantifExplo_info.m


%% inputs
basename='-wideband';
filename='InfoQuantifExplo.txt';

%% initialization
res=pwd;
load('behavResources.mat');

fil=fopen(filename,'w');
fprintf(fil,'%s\n',res);
fprintf(fil,'%s\n',' ');
%% find FinalEpochQuantifExplo
lis=dir([res,basename]);
index=[];
for i=1:length(lis)
    if length(lis(i).name)>22 && strcmp(lis(i).name(1:22),'FinalEpochQuantifExplo')
        index=[index,i];
    end
end

%% write info
lQE=length(Start(QuantifExploEpoch));
disp(['num QExplo = ',num2str(lQE)]);
fprintf(fil,'%s\n',['num QExplo = ',num2str(lQE)]);

a=0;
for i=1:length(index)
    load([res,basename,'/',lis(index(i)).name]);
    lQE=length(Start(FinalEpoch));
    disp(['   ',lis(index(i)).name,': [',num2str(a+1),':',num2str(a+lQE),']']);
    fprintf(fil,'%s\n',['   ',lis(index(i)).name,': [',num2str(a+1),':',num2str(a+lQE),']']);
    a=a+lQE;
end


%% closing
disp(['--> info saved in ',filename])
fclose(fil);

