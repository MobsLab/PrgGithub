




if length(ExtSess.(Mouse_names{mouse}))==4

FirstAfterCondSess.(Mouse_names{mouse}){1} = ExtSess.(Mouse_names{mouse}){1};
FirstAfterCondSess.(Mouse_names{mouse}){2} = ExtSess.(Mouse_names{mouse}){3};

elseif length(ExtSess.(Mouse_names{mouse}))==6

FirstAfterCondSess.(Mouse_names{mouse}){1} = ExtSess.(Mouse_names{mouse}){1};
FirstAfterCondSess.(Mouse_names{mouse}){2} = ExtSess.(Mouse_names{mouse}){4};

elseif length(ExtSess.(Mouse_names{mouse}))==8

FirstAfterCondSess.(Mouse_names{mouse}){1} = ExtSess.(Mouse_names{mouse}){1};
FirstAfterCondSess.(Mouse_names{mouse}){2} = ExtSess.(Mouse_names{mouse}){5};

end









