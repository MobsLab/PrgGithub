%ProblemMakeData


GLOBAL DATA

try
    DATA.session.name=DATA.session.basename;
catch
    DATA.session.basename=DATA.session.name;
end
