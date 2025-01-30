function STIMRIP=RateEventRip(tsa,ripEvt)

% nbRip nbRIPstim nbStim nbSTIMrip


 nbSTIMrip=0;
 nbRIPstim=0;
for i=1:length(Start(ripEvt))

a=length(Range(Restrict(tsa,subset(ripEvt,i))));
if a>=1
    nbRIPstim=nbRIPstim+1;
    nbSTIMrip=nbSTIMrip+a;
end

end
 
nbRip=length(Start(ripEvt));
nbStim=length(Range(tsa));


STIMRIP=[nbRip nbRIPstim floor(nbRIPstim/nbRip*100*100)/100 nbStim nbSTIMrip floor(nbSTIMrip/nbStim*100*100)/100];