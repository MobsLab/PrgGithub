

%% after SD
for m=1:8
    PathExplo.SD{m}{1}=['/media/nas7/Modelling_Behaviour/Others/10' num2str(m) '/FEAR-Mouse-10' num2str(m) '-08082023-Hab_00/'];
    i=2;
    for c=0:3
        PathExplo.SD{m}{i}=['/media/nas7/Modelling_Behaviour/Others/10' num2str(m) '/FEAR-Mouse-10' num2str(m) '-08082023-TestPre_0',num2str(c)];
        i=i+1;
    end
end

%% after DZP
for m=4:7
    PathExplo.DZP{m}{1}=['/media/nas7/Modelling_Behaviour/Others/148' num2str(m) '/FEAR-Mouse-148' num2str(m) '-08082023-Hab_00/'];
    i=2;
    for c=0:3
        PathExplo.DZP{m}{i}=['/media/nas7/Modelling_Behaviour/Others/148' num2str(m) '/FEAR-Mouse-148' num2str(m) '-08082023-TestPre_0',num2str(c)];
        i=i+1;
    end
end




