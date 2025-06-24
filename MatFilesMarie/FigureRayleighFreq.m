RE=REPTouch*10000;
SE=SEATouch*10000;
C1=COR1*10000;
C=COR*10000;
I=IC*10000;


deb=-20000;
fin=0;

Correct1=intervalSet(C1+deb,C1+fin);
Correct=intervalSet(C+deb,C+fin);
InCorrect=intervalSet(I+deb,I+fin);

Sea=intervalSet(SE+deb,SE+fin);
Rep=intervalSet(RE+deb,RE+fin);


[H1,Ph1,MT1]=RayleighFreq(lfp1,Restrict(S{2},InCorrect));

[H2,Ph2,MT2]=RayleighFreq(lfp1,Restrict(S{2},Correct1));

[H3,Ph3,MT3]=RayleighFreq(lfp1,Restrict(S{2},Correct));

[H4,Ph4,MT4]=RayleighFreq(lfp1,Restrict(S{2},Sea));

[H5,Ph5,MT5]=RayleighFreq(lfp1,Restrict(S{2},Rep));



deb=0;
fin=20000;

Correct1=intervalSet(C1+deb,C1+fin);
Correct=intervalSet(C+deb,C+fin);
InCorrect=intervalSet(I+deb,I+fin);

Sea=intervalSet(SE+deb,SE+fin);
Rep=intervalSet(RE+deb,RE+fin);


[H6,Ph6,MT6]=RayleighFreq(lfp1,Restrict(S{2},InCorrect));

[H7,Ph7,MT7]=RayleighFreq(lfp1,Restrict(S{2},Correct1));

[H8,Ph8,MT8]=RayleighFreq(lfp1,Restrict(S{2},Correct));

[H9,Ph9,MT9]=RayleighFreq(lfp1,Restrict(S{2},Sea));

[H10,Ph10,MT10]=RayleighFreq(lfp1,Restrict(S{2},Rep));
