function[motivation,reactiontime,missed] = x(A)
%Verification pas de bug 3/5
A=cell2mat(A);
bugalpha=[];
cinqs=find(A==5);
for k=1:(length(cinqs))-1
    ansalpha=0;
    for j=cinqs(k):cinqs(k+1)
        if(A(j)==3)
            ansalpha=1;
        end
    end
    if(ansalpha==0)
        bugalpha=[bugalpha;cinqs(k)-length(A)];
        %bugalpha comporte le numero de la ligne du bug
    end
end
threes=find(A==3);
bugbeta=[];
for k=1:(length(threes))-1
    ansbeta=0;
    for j=threes(k):threes(k+1)
        if(A(j)==5)
            ansbeta=1;
        end
    end
    if(ansbeta==0)
        bugbeta=[bugbeta;threes(k)-length(A)];
    end 
end
%Deuxieme verification et suppression des bugs
todelete=[];
for k=1:length(bugalpha)
    id=find(cinqs==bugalpha(k)+length(A));
    dupli=cinqs(id+1);
    if((A(dupli-length(A))-A(bugalpha(k)))<0.1)
        todelete=[todelete dupli-length(A)];
    elseif((A(dupli-length(A))-A(bugalpha(k)))>0.1)
        disp('majorbugalpha')
    end
end
for k=1:length(bugbeta)
    id=find(threes==bugbeta(k)+length(A));
    dupli=threes(id+1);
    if((A(dupli-length(A))-A(bugbeta(k)))<0.1)
        todelete=[todelete dupli-length(A)];
    elseif((A(dupli-length(A))-A(bugbeta(k)))>0.1)
        disp('majorbugbeta')
    end
end
buffer=A;
A(todelete,:)=[];


sounds=find(A==1);
clearvars soundtime
% Matrice comportant toute l'information
B=[];
% Matrice comportant le temps des stim (totaux)
C=[];
%Matrice comportant les couleurs

for i=1:length(sounds)
    stim=4;
    soundtime=A(sounds(i)-length(A));
    try
        for k=sounds(i):sounds(i+1)
            if (A(k)==2)
                stim=1;
                stimtime=A(k-length(A));
            end    
        end
    catch
        for k=sounds(i):(2*length(A))
            if (A(k-length(A))==2)
                stim=1;
                stimtime=A(k-length(A));
            end    
        end    
    end    
    try
        B=[B;i stimtime-soundtime];
    catch
        B=[B;i 0];
    end
    clearvars stimtime
    C=[C;stim];   
end

%{
figure
scatter(B(:,1),B(:,2),30,C,'o')
ylim([0 3+timelength])
title(mousenumber)
xlabel('Indice du son')
ylabel('Delai de la stimulation')
%}

D=[];
%Matrice comportant les premiers NP
E=[];
F=[];
H=[];
I=[];
go=[];
gate='off';

for i=0:length(sounds)
    clearvars poketime betapokes betaexits soundtime
    first=1;
    pokenumber=0;
    betapokes=[];
    betaexits=[];
    color=[1 0 0];
    if(i~=0)
        soundtime=A(sounds(i)-length(A));
    end
    switchoff=[];
    try
        try
            k=sounds(i);
        catch
            k=1;
        end    
        
        while (k<sounds(i+1))
            if (A(k)==3 && first==1)
                first=0;
                color=[0 0 1];
                poketime=A(k-length(A));
            end
            if (A(k)==3)
                gate='on';
                transfer=0;
                pokenumber=pokenumber+1;
                if(i~=0)
                    betapoketime=A(k-length(A))-soundtime;
                    betapokes=[betapokes;i betapoketime];
                end
            end
            if (A(k)==5 && transfer==0)
                gate='off';
                if(i~=0)
                    betaexittime=A(k-length(A))-soundtime;
                    betaexits=[betaexits;i betaexittime];
                end
            end
            k=k+1;
        end
        
        if(strcmp(gate,'on')==1)
            try
                %switchoff=find(A(k:2*length(A))==5);
                %switchoff=switchoff(1)+k-1;
                %trash=A;
                %trash(1:(k/2)-1,:)=[];
                trash=A([k-length(A):length(A)],:);
                switchoff=find(trash==5,1,'first');
                %switchoff=switchoff(2)+k-1;
                switchoff=switchoff(1)+2*(k-length(A));
                if(i~=0)
                    betaexittime=A(switchoff-length(A))-soundtime;
                    betaexits=[betaexits;i betaexittime];
                end
                transfer=1;
            catch
                betapokes([2*length(betapokes);length(betapokes)])=[];
            end    
        end
               
    catch
        k=sounds(i);
        while(k<=(2*length(A)))
            if (A(k)==3 && first==1)
                first=0;
                color=[0 0 1];
                poketime=A(k-length(A));
            end
            if (A(k)==3)
                gate='on';
                transfer=0;
                pokenumber=pokenumber+1;
                betapoketime=A(k-length(A))-soundtime;
                betapokes=[betapokes;i betapoketime];
            end
            if (A(k)==5 && transfer==0)
                gate='off';
                betaexittime=A(k-length(A))-soundtime;
                betaexits=[betaexits;i betaexittime];
            end
            k=k+1;
        end
        
        if(strcmp(gate,'on')==1)
            try
                betapokes(length(betapokes),:)=[];
                %trash=A([k-length(A):length(A)],:);
                %switchoff=find(trash==5,1,'first');
                %switchoff=switchoff(1)+2*(k-length(A));
                %betaexittime=A(switchoff-length(A))-soundtime;
                %betaexits=[betaexits;i betaexittime];
                %transfer=1;
            catch
                betapokes(length(betapokes),:)=[];
            end    
        end
    end    
    if(first==0 && i~=0)
        try
            D=[D;i poketime-soundtime];
            H=[H;betapokes];
            I=[I;betaexits];
            E=[E;color];
            go=[go;1];
        catch
        end
    end
    if(first==1 && i~=0)
        D=[D;i 0];
        E=[E;color];
        go=[go;0];
    end
end

%{
figure
scatter(D(:,1),D(:,2),30,E,'o')
title(mousenumber)
xlabel('Indice du son')
ylabel('Delai du premier NP')

figure
%scatter(H(:,1),H(:,2),30,'o')
%quiver(H(:,1),H(:,2),I(:,1),I(:,2))

x=[H(:,1) I(:,1)];
y=[H(:,2) I(:,2)];
plot(x',y','b')

title(mousenumber)
xlabel('Indice du son')
ylabel('Temps des NP')
%}

F=D;
F([find(F==0);find(F==0)-length(F)])=[];
%F(find(F==0)-length(F),:)=[];
F=cat(1,F(1:(0.5*length(F))),F((0.5*length(F)+1):length(F)));
F=transpose(F);
G=sortrows(F,2);
pd=fitdist(G(:,2),'Lognormal');
%{
figure
pd=fitdist(G(:,2),'Lognormal');
plot(G(:,2),pdf(pd,G(:,2)))
hold on
plot(G(:,2),cdf(pd,G(:,2)))
hold on
hist(G(:,2),100)
title('Distribution du premier NP')
xlabel('Delai')
ylabel('Probabilité')
%}

%splitkeep
%splitdiscard

cutoff=G((cdf(pd,G(:,2))>0.90),2);
cutoff=cutoff(1);

keep=D(go==1,:);
discard=[];
investigate=D(go==0,:);
statement1='(investigate(i+1)==investigate(i)+1 && investigate(i+2)==investigate(i)+2)';
statement2='(investigate(i)==investigate(i-1)+1 && investigate(i+1)==investigate(i)+1)';
statement3='(investigate(i)==investigate(i-1)+1 && investigate(i)==investigate(i-2)+2)';
statement='((investigate(i+1)==investigate(i)+1 && investigate(i+2)==investigate(i)+2) || (investigate(i)==investigate(i-1)+1 && investigate(i+1)==investigate(i)+1) || (investigate(i)==investigate(i-1)+1 && investigate(i)==investigate(i-2)+2))';
%{
for i=1:length(investigate)
    try
        investigate(i+2)
        investigate(i-2)
        if eval(statement)
            discard=[discard;investigate(i,:)];
        else
            keep=[keep;investigate(i,:)];
        end
    catch error1
        switch error1.message
            case 'Index exceeds matrix dimensions.'
                try
                    investigate(i+1);
                    if (eval([statement3 '||' statement2]))
                        discard=[discard;investigate(i,:)];
                    else
                        keep=[keep;investigate(i,:)];
                    end
                catch error2
                    switch error2.message
                        case 'Index exceeds matrix dimensions.'
                            if (eval(statement3))
                                discard=[discard;investigate(i,:)];
                            else
                                keep=[keep;investigate(i,:)];
                            end
                        otherwise
                            rethrow(error2)
                    end
                end
            case 'Attempted to access investigate(0); index must be a positive integer or logical.'
                try
                    investigate(i-1);
                    if (eval([statement1 '||' statement2]))
                        discard=[discard;investigate(i,:)];
                    else
                        keep=[keep;investigate(i,:)];
                    end
                catch error2
                    switch error2.message
                        case 'Attempted to access investigate(0); index must be a positive integer or logical.'
                            if (eval(statement1))
                                discard=[discard;investigate(i,:)];
                            else
                                keep=[keep;investigate(i,:)];
                            end
                        otherwise
                            rethrow(error2)
                            disp('here')
                    end
                end
            otherwise
                rethrow(error1)
                disp('here')
        end
    end
        
    
    
    
    
    
    
    
    
    
    
    
    
    
    if((investigate(i+1)==investigate(i)+1 && investigate(i+2)==investigate(i)+2) || (investigate(i)==investigate(i-1)+1 && investigate(i+1)==investigate(i)+1) || (investigate(i)==investigate(i-1)+1 && investigate(i)==investigate(i-2)+2) )
        discard=[discard;investigate(i,:)];
    else
        keep=[keep;investigate(i,:)];
    end    
end
%}

for i=1:size(investigate,1)
    if (i==1)
        if(eval(statement1))
            discard=[discard;investigate(i,:)];
        else
            keep=[keep;investigate(i,:)];
        end
    elseif (i==2)
        if(eval([statement1 '||' statement2]))
            discard=[discard;investigate(i,:)];
        else
            keep=[keep;investigate(i,:)];
        end
    elseif (i==length(investigate))
        if(eval(statement3))
            discard=[discard;investigate(i,:)];
        else
            keep=[keep;investigate(i,:)];
        end
    elseif (i==length(investigate)-1)
        if(eval([statement3 '||' statement2]))
            discard=[discard;investigate(i,:)];
        else
            keep=[keep;investigate(i,:)];
        end
    else 
        if(eval(statement))
            discard=[discard;investigate(i,:)];
        else
            keep=[keep;investigate(i,:)];
        end
    end
end

motivation=100*length(discard)/length(sounds);
message=['Ratio motivation = ' num2str(motivation*100) '%'];
%disp(message);

inside=keep((keep(:,2)<=cutoff),:);
outside=keep((keep(:,2)>=cutoff),:);

reactiontime=mean(inside(:,2));
message=['Temps de reaction moyen = ' num2str(reactiontime) '(s)'];
%disp(message);

missed=100*(length(outside)+length(investigate)-length(discard))/length(keep);
message=['Ratio ratés = ' num2str(missed*100) '%'];
%disp(message);
end