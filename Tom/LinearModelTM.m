classdef LinearModelTM
    %LINEARMODELTM is a class with essentials properties of GeneralizedLinearModel  
    %Goal is to recreate a class of linear model without using fitglm 
    
    properties
        Variables table
        Fitted table
        Coefficients table
        Rsquared table
        VariableNames 
    end
    
    methods
        function obj = LinearModelTM(oVariables, FittedResponse, CoefficientsEstimate, RsquaredOrdinary)
            %LINEARMODELTM Construct an instance of this class
            %   classic construction with all properties
            obj.Variables = oVariables;
            obj.Fitted.Response = FittedResponse;
            obj.Coefficients.Estimate = CoefficientsEstimate;
            obj.Rsquared.Ordinary = RsquaredOrdinary;
            obj.VariableNames = oVariables.Properties.VariableNames';
        end
        
    end
end

