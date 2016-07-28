disp('Welcome to Numerical Analysis Tool :NAT');
try 
    %branching statement to choose which tool
ToolMode=Utilities.ChooseToolMode;

 switch str2double(ToolMode)
     
    case 1
%work as interpolation tool
     disp('Welcome to Interpolation Tool');
     InterpolationMethodsHelper.TriggerInterpolationTool
     disp('Thanks for using Interpolation Tool');

    case 2
%work as differentiation tool
     disp('Welcome to Differentiation Tool');      
     Differentiation_Integration_MethodsHelper.TriggerDifferentiationTool
     disp('Thanks for using Differentiation Tool');  

    case 3
%work as ingetegration tool
     disp('Welcome to Ingetegration Tool');      
     Differentiation_Integration_MethodsHelper.TriggerIntegrationTool
     disp('Thanks for using Ingetegration Tool');   

    case 4
%work as ODE tool
     disp('Welcome to ODE Tool');      
     DifferentialEquationMethodsHelper.TriggerODETool
     disp('Thanks for using ODE Tool');
        
    case 5 
  %work as PDE tool
     disp('Welcome to PDE Tool');      
     DifferentialEquationMethodsHelper.TriggerPDETool
     disp('Thanks for using PDE Tool');    
        
   otherwise
     %the user quits
     disp('Thanks for using'); 
 end;
 
catch e
    
     disp('Thanks for using'); 
end
