function [mean_errhabgood,mean_errtestPregood,mean_errcondgood,mean_errtestPostgood,mean_errhabbad,mean_errtestPrebad,mean_errcondbad,mean_errtestPostbad] = errorByEpoch(hab,testPre,cond,testPost,LinearPredTsd,LinearTrueTsd,EpochOK,BadEpoch)

    val=LinearPredTsd;
    trueval=LinearTrueTsd;
    valgood=Restrict(val,EpochOK);
    truevalgood=Restrict(trueval, EpochOK);

%     val=LinearPredTsd;
%     trueval=LinearTrueTsd;
%     valgood=Restrict(val,GoodEpoch);
%     truevalgood=Restrict(trueval, GoodEpoch);
    
    valbad=Restrict(val,BadEpoch);
    truevalbad=Restrict(trueval, BadEpoch);

    errhabgood=abs(Data(Restrict(valgood, hab))-Data(Restrict(truevalgood, hab)));
    mean_errhabgood=mean(errhabgood);
    errtestPregood=abs(Data(Restrict(valgood, testPre))-Data(Restrict(truevalgood, testPre)));
    mean_errtestPregood=mean(errtestPregood);
    errcondgood=abs(Data(Restrict(valgood, cond))-Data(Restrict(truevalgood, cond)));
    mean_errcondgood=mean(errcondgood);
    errtestPostgood=abs(Data(Restrict(valgood, testPost))-Data(Restrict(truevalgood, testPost)));
    mean_errtestPostgood=mean(errtestPostgood);

    errhabbad=abs(Data(Restrict(valbad, hab))-Data(Restrict(truevalbad, hab)));
    mean_errhabbad=mean(errhabbad);
    errtestPrebad=abs(Data(Restrict(valbad, testPre))-Data(Restrict(truevalbad, testPre)));
    mean_errtestPrebad=mean(errtestPrebad);
    errcondbad=abs(Data(Restrict(valbad, cond))-Data(Restrict(truevalbad, cond)));
    mean_errcondbad=mean(errcondbad);
    errtestPostbad=abs(Data(Restrict(valbad, testPost))-Data(Restrict(truevalbad, testPost)));
    mean_errtestPostbad=mean(errtestPostbad);
 
    %Erreur standard
    carr_errhabgood=(Data(Restrict(valgood, hab))-Data(Restrict(truevalgood, hab))).^2;
    Scarr_errhabgood = sum(carr_errhabgood)/(length(carr_errhabgood)-1);
    stand_errhabgood = (Scarr_errhabgood/length(carr_errhabgood))^(1/2);
    carr_errtestPregood=(Data(Restrict(valgood, testPre))-Data(Restrict(truevalgood, testPre))).^2;
    Scarr_errtestPregood=sum(carr_errtestPregood)/(length(carr_errtestPregood)-1);
    stand_errtestPregood=(Scarr_errtestPregood/length(carr_errtestPregood))^(1/2);
    carr_errcondgood=(Data(Restrict(valgood, cond))-Data(Restrict(truevalgood, cond))).^2;
    Scarr_errcondgood=sum(carr_errcondgood)/(length(carr_errcondgood)-1);
    stand_errcondgood=(Scarr_errcondgood/length(carr_errcondgood))^(1/2);
    carr_errtestPostgood=(Data(Restrict(valgood, testPost))-Data(Restrict(truevalgood, testPost))).^2;
    Scarr_errtestPostgood=sum(carr_errtestPostgood)/(length(carr_errtestPostgood)-1);
    stand_errtestPostgood=(Scarr_errtestPostgood/length(carr_errtestPostgood))^(1/2);

    carr_errhabbad=(Data(Restrict(valbad, hab))-Data(Restrict(truevalbad, hab))).^2;
    Scarr_errhabbad=sum(carr_errhabbad)/(length(carr_errhabbad)-1);
    stand_errhabbad=(Scarr_errhabbad/length(carr_errhabbad))^(1/2);
    carr_errtestPrebad=(Data(Restrict(valbad, testPre))-Data(Restrict(truevalbad, testPre))).^2;
    Scarr_errtestPrebad=sum(carr_errtestPrebad)/(length(carr_errtestPrebad)-1);
    stand_errtestPrebad=(Scarr_errtestPrebad/length(carr_errtestPrebad))^(1/2);
    carr_errcondbad=(Data(Restrict(valbad, cond))-Data(Restrict(truevalbad, cond))).^2;
    Scarr_errcondbad=sum(carr_errcondbad)/(length(carr_errcondbad)-1);
    stand_errcondbad=(Scarr_errcondbad/length(carr_errcondbad))^(1/2);
    carr_errtestPostbad=(Data(Restrict(valbad, testPost))-Data(Restrict(truevalbad, testPost))).^2;
    Scarr_errtestPostbad=sum(carr_errtestPostbad)/(length(carr_errtestPostbad)-1);
    stand_errtestPostbad=(Scarr_errtestPostbad/length(carr_errtestPostbad))^(1/2);

end

% figure,
% hold on,
% PlotErrorBar4(errhabgood,errtestPregood,errcondgood,errtestPostgood,1,0), ylim([0,0.4]);
% PlotErrorBar4(errhabbad,errtestPrebad,errcondbad,errtestPostbad,1,0), ylim([0,0.4])
% ;
% ylim([0,0.4])
