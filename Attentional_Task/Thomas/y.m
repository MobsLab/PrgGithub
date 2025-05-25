function[motivation,reactiontime,missed,distrib] = y(A,timelength)
A=cell2mat(A);
timelength=cell2mat(timelength);
%Verification pas de bug 3/5
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

D=[];
%Matrice comportant les premiers NP
E=[];
%Matrice codant la couleur des points (diff�rencier un �chec d'une
%r�ussite)
F=[];
%Copie de D (utilis� apr�s la boucle)
H=[];
%Matrice comportant tous les d�buts de NP
I=[];
%Matrice comportant toutes les fins de NP
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


F=D;
%F([find(F==0);find(F==0)-length(F)])=[];
F(find(F==0)-length(F),:)=[];
%F=cat(1,F(1:(0.5*length(F))),F((0.5*length(F)+1):length(F)));
%F=transpose(F);
G=sortrows(F,2);
%figure
pd=fitdist(G(:,2),'Lognormal');
counts2=hist(G(:,2),0:0.5:15);
counts2=100*counts2/length(G);
distrib=G(:,2);
cutoff=3+timelength;

keep=D(go==1,:);
discard=[];
investigate=D(go==0,:);
statement1='(investigate(i+1)==investigate(i)+1 && investigate(i+2)==investigate(i)+2)';
statement2='(investigate(i)==investigate(i-1)+1 && investigate(i+1)==investigate(i)+1)';
statement3='(investigate(i)==investigate(i-1)+1 && investigate(i)==investigate(i-2)+2)';
statement='((investigate(i+1)==investigate(i)+1 && investigate(i+2)==investigate(i)+2) || (investigate(i)==investigate(i-1)+1 && investigate(i+1)==investigate(i)+1) || (investigate(i)==investigate(i-1)+1 && investigate(i)==investigate(i-2)+2))';

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

motivation=length(discard)/length(sounds);
message=['Ratio motivation = ' num2str(motivation*100) '%'];
%disp(message);

inside=keep((keep(:,2)<=cutoff),:);
outside=keep((keep(:,2)>=cutoff),:);

reactiontime=mean(inside(:,2));
message=['Temps de reaction moyen = ' num2str(reactiontime) '(s)'];
%disp(message);

mediantime=median(inside(:,2));
message=['Temps de reaction m�dian = ' num2str(mediantime) '(s)'];
%disp(message);

missed=100*(length(outside)+length(investigate)-length(discard))/length(keep);
message=['Ratio rat�s = ' num2str(missed) '%'];
%disp(message);


%Analyse regret (lorsque la souris rate de peu la stimulation (2sec apr�s
%la fermeture de la fen�tre de r�compense)

withstim=B;
withstim(find(withstim==0)-length(withstim),:)=[];
withoutstim=B(find(B==0)-length(B),:);


[success, closefail, farfail]=deal(D);

success(find(success(:,2)==0),:)=[];
success(find(success(:,2)>(3+timelength)),:)=[];

closefail=closefail(find(closefail(:,2)>(3+timelength)),:);
closefail(find(closefail(:,2)>((3+timelength)*2)),:)=[];

farfail=farfail(find(farfail(:,2)>((3+timelength)*2)),:);

lastsuccess=[];
for i=1:length(success)
    p=success(i);
    lastsuccess=[lastsuccess;H(find(H(:,1)==p,1,'last'),2)];
end

lastclosefail=[];
for i=1:length(closefail)
    p=closefail(i);
    lastclosefail=[lastclosefail;H(find(H(:,1)==p,1,'last'),2)];
end

lastfarfail=[];
for i=1:length(farfail)
    p=farfail(i);
    lastfarfail=[lastfarfail;H(find(H(:,1)==p,1,'last'),2)];
end
keep2=D(go==1,:);
last=[];
for i=1:length(keep2)
    p=keep2(i);
    last=[last;H(find(H(:,1)==p,1,'last'),2)];
end
both=cat(2,keep2(:,2),last);
sortedboth=sortrows(both,1);

doubles=find(sortedboth(2:length(sortedboth),1)-sortedboth(1:length(sortedboth)-1,1)<1e-4);
d=0;
m=[];
for i=1:length(doubles)
    if (i<=d)
        continue;
    end
    d=i;
    s=[sortedboth(doubles(d),2);sortedboth(doubles(d)+1,2)];
    m=[m;doubles(d)+1];
    try
        while (doubles(d)+1==doubles(d+1))
            d=d+1;
            s=[s;sortedboth(doubles(d)+1,2)];
            m=[m;doubles(d)+1];
        end   
    catch
    end
    sortedboth(doubles(i),2)=mean(s);
    %sortedboth(doubles(i),2)=mean([sortedboth(doubles(i),2) sortedboth(doubles(i)+1,2)]);
end
sortedboth(m,:)=[];

disp(num2str(mean(lastsuccess)));
disp(num2str(mean(lastclosefail)));
disp(num2str(mean(lastfarfail)));


suite=D(find(go==0),1);
g=[];
d=0;
for i=1:length(suite);
    if (i<=d)
        g=[g;d-e+1];
        continue;
    end
    e=i;
    d=i;
    try
        while (suite(d+1)==suite(d)+1)
            d=d+1;
        end    
    catch
        
    end
    g=[g;d-e+1];
    %i=d;
end

if(isempty(g))
    return;
end    

end