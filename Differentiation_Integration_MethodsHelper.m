classdef Differentiation_Integration_MethodsHelper
methods(Static)
     
%start differentiation tool
function   TriggerDifferentiationTool
    disp('This''s going to calculate the first derivative of f(x) ');
    disp('using Richardson Extrapolation as the error O(h^(2*n+2))');    
    disp('h is a small change in x,n is the number of periodes');
    disp('----------------------------------------------------'); 

    %take the inputs
    fs=Utilities.TakeAnInputFucntion('f(x)');
    n=Utilities.Accept_n('n');

        while true
            try
            h = input('the spacing  h =');

            if n <= 0
            disp('Please enter a positive number for spacing');
            continue;    
            end;

            break; 
            catch e %handling errors 
            disp('Please enter h properly');  
            end
        end

        while true
        try
            x = input('differentaition point x=');
            break; 
        catch e
        disp('Please enter x properly');  
        end
        end

        disp('-------------------------------------'); 
        DII=cell(n,1); %avoid resizing
        DII{1}=ones(1,n);
        
        for i = 1:n %find the Di1
            DII{1}(i) =  Differentiation_Integration_MethodsHelper.CentralDifference (fs,(h/(2^(i-1))),x) ;  
        end 

        for i=1:n-1
            for j=1:n-i
                 DII{i+1}(j)= -(1/(4^(i)-1))*DII{i}(j)+ (4^i/(4^i-1))*DII{i}(j+1);
            end;
        end


        fprintf('the first derivative at x =%8.4f is %8.10f \n',x,DII{n}(1));

end
    
%single evaluation of the first derivative using the Central Difference method
function  result= CentralDifference (fs,h,x)
    result =(subs(fs, 'x', x+h)-subs(fs, 'x', x-h))/(2*h);
end
    
%start integration tool
function   TriggerIntegrationTool

        disp('This''s going to calculate the integral of  f(x) ');
        disp('of a real variable x on the interval [a, b]');
        disp('using gaussian quadrature rule');    
        disp('---------------------------------------');  

        fs=Utilities.TakeAnInputFucntion('f(x)');

        while true
        try
                b = input('enter the upper boundary b =');
                if( isempty(b))
                 continue;
                end;
                
            break; 

            catch e %handling errors 
            disp('Please enter b properly');  
        end;
        end;

        while true
            try
                    a = input('enter the lower boundary a =');
                    if( isempty(a))
                    continue;
                    end;
                    break; 
                catch e %handling errors 
                disp('Please enter a properly');  
            end;
        end 

        syms x;
        syms t;
        
        %calculate the integral using quadrature rule   
        if(a ~=-1 ||  b ~=1)
            
            %susbstition in the integral changing the boundaries itno -1 to 1
            xx=((b-a)*t+(a+b))/2;
        
        else 
          xx=t; 
        end
            F=sym(fs);
            F=subs(F, x, xx)*((b-a)/2);

        while 1
            %branching
            disp('Please Choose the order of gaussian quadrature rule');
            disp('1:[1-point]');
            disp('2:[2-point]');
            disp('3:[3-point]');
            disp('4:[4-point]');
            disp('5:[5-point]');
            disp('quit:[Exit or stop the script]');

            Mode = input('            Let''s pick: ','s');

            if(strcmp(Mode,'quit')) %the user quits
            return;
            end ;
            disp('-------------------------------------');
            
                    if ~(strcmpi( Mode , '1' )||strcmpi( Mode , '2' )||strcmpi( Mode , '3' )||strcmpi( Mode , '4' )||strcmpi( Mode , '5' ))
                    disp('Error!,please pick a proper choice')
                    else
                       break;
                    end;
        end;
        
        switch str2double(Mode) %branching
            case 1
            result=2*subs(F, t, 0);
            case 2
            result=subs(F, t, (1/3)^.5)+subs(F, t, -(1/3)^.5);
            case 3
            result=(8/9)*subs(F, t, 0)+(5/9)*(subs(F, t, (3/5)^.5)+subs(F, t, -(3/5)^.5));
            case 4
            result=((18+30^.5)/36)*(subs(F, t, ( 3/7-(2/7)*(6/5)^.5 )^.5)+subs(F, t, -( 3/7-(2/7)*(6/5)^.5 )^.5))+    ((18-30^.5)/36)*(subs(F, t, ( 3/7+(2/7)*(6/5)^.5 )^.5)+subs(F, t, -( 3/7+(2/7)*(6/5)^.5 )^.5));
            case 5
            result=((322+13*70^.5)/900)*(subs(F, t, (1/3)*( 5-2*(10/7)^.5 )^.5)+subs(F, t, -(1/3)*( 5-2*(10/7)^.5 )^.5 ))+    ((322-13*70^.5)/900)*(subs(F, t, (1/3)*( 5+2*(10/7)^.5 )^.5 )+subs(F, t,  -(1/3)*( 5+2*(10/7)^.5 )^.5))+(128/225)*subs(F, t, 0);
        end;

        fprintf('the integral I=%8.20f \n',result);

end;
end %end methods
end %end classdef