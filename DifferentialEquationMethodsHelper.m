classdef DifferentialEquationMethodsHelper
methods(Static)
    
%start the ODE tool
function TriggerODETool
     
              while 1
                    disp('Please choose the method');
                    disp('1:[IVP for ODE]');
                    disp('2:[BVP for ODE]');
                    disp('quit:[Exit or stop the script]');

                    Mode = input('            Let''s pick: ','s');

                    if(strcmp(Mode,'quit'))

                        return;
                    end ;

                    disp('-------------------------------------');
                    if ~(strcmpi( Mode , '1' )||strcmpi( Mode , '2' ))
                        disp('Error!,please pick a proper choice')
                    else
                        break;
                    end;
              end
            
            switch str2double(Mode)
             case 1 %IVP tool
              
              disp('This''s going to calculate the solution of ODE at certain points');   
              disp('the initial condition [xo,yo]');
              disp('n is the number of periods producing the nodes');
              disp('such that f(x)=dy/dx ');
              disp('-----------------------');
      
           fs='';   %default
           
            %reading the function itself and analysing it
            while true
              try
                fs = input('Please Enter The Function \ndy/dx= ','s');
                if(strcmp(fs,'quit'))
                    return; %quit the program
                end ;
                
                %analysis of the input
                F  = sym(fs);
                Vars=symvar(F);
                
                if length(Vars) >2 %handling errors
                        disp('Function of two varibles is only accepted');
                        if(strfind(char(F), 'e'))
                        disp('Hint: use exp(x) instead of e^x ');
                        end ;
                         continue; 

                        else 
                          VariablesCounter=0;

                               for i=1:length(Vars)


                                  if strcmp(char(Vars(i)),'x')
                                      VariablesCounter=VariablesCounter+1;

                                  else if strcmp(char(Vars(i)),'y')
                                         VariablesCounter=VariablesCounter+1;
                                      end;
                                  end;

                               end;

                          if(VariablesCounter~=length(Vars))
                             disp('Please use the variables x and y');  

                             continue; 
                          end

                end;
                
             catch e %handling errors
                disp('Please enter the function properly');
                disp('Hint: use 2*x instead of 2x');
                disp('-------------------------------------');  
                 continue; 
              end; 

               break;
            end;
            
            n=Utilities.Accept_n('n');
           
               while true
                try
                     x = input('inital condition x0=');
                             if( isempty(x))
                                continue;
                             end;
                             break; 
                catch e
                       disp('Please enter x0 properly');  
                end
               end;
               
       
                while true
                    try
                    y = input('inital condition y0=');
                         if( isempty(y))
                            continue;
                         end;
                         break; 
                    catch e
                           disp('Please enter y0 properly');  
                    end
                end;
    
                while true
                try
                    xend = input('the desired approximate y \n at x=');
                     if( isempty(xend))
                        continue;
                     end;
                     break; 
                catch e
                    disp('Please enter x properly');  
                end
                end;
            h=(xend-x)/n;
            %create the arrays to avoid resizing
            X=zeros(1,n);
            Y=zeros(1,n);

            %fill them
            Y(1)=y;
            for i=0:n
            X(i+1)=i*h+x;
            end;
    
    
                while 1
                disp('Please Choose the method');
                disp('1:[RK4]');
                    if n >= 4
                    disp('2:[Adams-Bashforth 4 step with RK4 at the begining]');
                    end;
                disp('quit:[Exit or stop the script]');

                ModeIVP = input('            Let''s pick: ','s');
                
                    if(strcmp(ModeIVP,'quit'))
                    return;
                    end ;

                disp('-------------------------------------');
                    if ~(strcmpi( ModeIVP , '1' )||strcmpi( ModeIVP , '2' ))
                    disp('Error!,please pick a proper choice')
                    else
                    break;
                    end;
                end;
     
                switch str2double(ModeIVP)
                    case 1
                    %use RK4
                            for i=1:n
                            Y(i+1)=DifferentialEquationMethodsHelper.RK4_evaluation(X(i),Y(i),fs,h);
                            end

                    case 2  
                    %use adams bashforth 4step
                        if n >= 4

                                for i=1:3
                                Y(i+1)=DifferentialEquationMethodsHelper.RK4_evaluation(X(i),Y(i),fs,h);
                                end

                                for i=4:n
                                Y(i+1)=DifferentialEquationMethodsHelper.AB4S_evaluation(X(1,i-3:i),Y(1,i-3:i),fs,h);
                                end

                        else
                        disp('Error!,please pick a proper choice');
                        end;

                end  

                    case 2 %BVP outer swtich 
                        disp('This''s going to calculate the solution of BVP ODE at certain points');   
                        disp('on the form     y''''+p(x)y''+q(x)y=r(x)');
                        disp('the boundaries y(a)=y0  y(b)=yn');
                        disp('n is the number of periods producing the nodes');
                        disp('-----------------------'); 

                          p=Utilities.TakeAnInputFucntion('p(x)');
                        if(strcmp(p,'quit')) 
                        return;
                        end 
                          q=Utilities.TakeAnInputFucntion('q(x)');
                        if(strcmp(q,'quit'))
                        return;
                        end
                          r=Utilities.TakeAnInputFucntion('r(x)');
                        if(strcmp(r,'quit'))
                        return;
                        end ;
                          n=Utilities.Accept_n('n');
                    

                        y0=0;
                        yn=0;    
                        
                        %gathering the inputs
                        while true
                            try
                            a = input('enter the lower boundary a= ');
                                if( isempty(a))
                                continue;
                                end;
                            break; 
                            catch e
                             disp('Please enter a properly');  
                            end
                        end
                        
                        while true
                        try
                        b = input('denter the upper boundary b= ');
                            if( isempty(b))
                            continue;
                            end
                        break; 
                        catch e
                          disp('Please enter b properly');  
                        end
                        end


                        while true
                        try
                        y0 = input(sprintf('enter f(%0.5f)=y0= ',a));
                            if( isempty(y0))
                            continue;
                            end
                        break; 
                        catch e
                          disp('Please enter y0 properly');  
                        end
                        end


                    while true
                        try
                        yn =  input(sprintf('enter f(%0.5f)=yn= ',b));

                            if( isempty(yn))
                            continue;
                            end;
                            break; 
                        catch e
                          disp('Please enter yn properly');  
                        end
                    end
                    
                    %calculations of the BVP
                        h=(b-a)/n;   
                        A=zeros(n-2);
                        C=zeros(n-1,1);  
                        X=zeros(1,n-1);

                    try
                        
                            for i=1:n-1
                                  X(i)=a+(i)*h;
                            end

                            for i=1:n-2
                                A(i,i)=-2+(h^2)*subs(q,'x',X(i));%bi
                                A(i,i+1)=1+(h/2)*subs(p,'x',X(i));%ci
                                A(i+1,i)=1-(h/2)*subs(p,'x',X(i+1));%ai
                                C(i)=(h^2)*subs(r,'x',X(i));%di
                            end
                        
                            fs='the BVP';

                            A(n-1,n-1)=-2+(h^2)*subs(q,'x',X(n-1));
                            C(1)=C(1)-y0*( 1-(h/2)*subs(p,'x',X(1))) ;  %d1-a1*yo   
                            C(n-1)=(h^2)*subs(r,'x',X(n-1))-yn*(1+(h/2)*subs(p,'x',X(n-1))); %dn-1-an-1*yn  

                    catch e
                            disp('Logical error');
                            return;
                    end;
                    %the solution
                        Y=A\C;
            end;
                 fprintf('      the numerical solution for %s            \n',fs);
                 %display the result
                 Utilities.Construct_X_Y_table(X,Y,'x',' y  ',numel(X))       
end

%single runge kutta evaluation repeated n of times
function R=RK4_evaluation(x,y,fs,h)
         
            k1= DifferentialEquationMethodsHelper.sub( fs,x, y);
            k2=DifferentialEquationMethodsHelper.sub( fs,x+h/2, y+(h/2)*k1);
k3=DifferentialEquationMethodsHelper.sub(fs, x+h/2, y+(h/2)*k2);
k4=DifferentialEquationMethodsHelper.sub( fs,x+h, y+h*k3);

          R=y+(h/6)*(k1+k4+2*(k2+k3));    
end

%single adams bashforth evaluation repeated n of times
function R=AB4S_evaluation(X,Y,fs,h)
         fi=DifferentialEquationMethodsHelper.sub( fs,X(4),Y(4));%evaluate Fi
         fi_1=DifferentialEquationMethodsHelper.sub( fs,X(3), Y(3));%evaluate Fi-1 one step before
         fi_2=DifferentialEquationMethodsHelper.sub( fs,X(2), Y(2));%evaluate Fi-2 2 steps before
         fi_3=DifferentialEquationMethodsHelper.sub( fs,X(1), Y(1));%evaluate Fi-3 3 steps before
            
          R=Y(4)+(h/24)*(55*fi-59*fi_1+37*fi_2-9*fi_3);
end

%substitution subroutine   
function F=sub(fs,x,y)  
         F=subs(fs,'x',x);
         F=subs(F,'y',y);  
end
        
%starting PDE TOOL
function TriggerPDETool
   
         disp('This''s going to calculate the solution of heat PDE using Crank-Nicolson');   
         disp('on the form     Ut(x,t)=O*Uxx(x,t) O is a constant');
         disp('the boundaries U(a,t)=U0  U(b,t)=Un');
         disp('n is the number of periods on x');
         disp('p is the number of periods on t'); 
         disp('-----------------------');        
            O =0;
            ax=0;
            bx =0;
            at=0;
            bt =0;
            
              %Crank-Nicolson is independant of boundary conditions
              %  y0=0; 
              %  yn=0;
        n=Utilities.Accept_n('n');
        p=Utilities.Accept_n('p');
    
    while true
       try
        O = input('enter the constant O= ');

            if( isempty(O))
                continue;
            end;

       break; 
            catch e
                   disp('Please enter O properly');  
       end
       
    end
   
   
     
     
    while true
        try
        ax = input('enter the x lower boundary a= ');
            if( isempty(ax))
                continue;
            end;
       break; 
        catch e
               disp('Please enter a properly');  
        end
     end

     
     while true
    try
        bx = input('enter the x upper boundary b= ');
        if( isempty(bx))
        continue;
        end
        break; 
    catch e
           disp('Please enter b properly');  
    end
    
     end

    while true
        try
            at = input('enter the t lower boundary a= ');
            if( isempty(at))
                continue;
            end;
            break; 
        catch e
               disp('Please enter a properly');  
        end
    end

     
     while true
        try
             bt = input('enter the t upper boundary b= ');
            if( isempty(bt))
            continue;
            end
            break; 
        catch e
               disp('Please enter b properly');  
        end
     end
     
         while true
        try
            y0 = input(sprintf('enter U(%0.5f,t)=U0= ',ax));
            if( isempty(y0))
            continue;
            end
       break; 
        catch e
               disp('Please enter U0 properly');  
        end
         end

     
     while true
    try
        yn =input(sprintf('enter U(%0.5f,t)=Un= ',bx));
        if( isempty(yn))
        continue;
        end;
        break; 
    catch e
        disp('Please enter Un properly');  
    end
     end
 
        h=(bx-ax)/n ;
        k=(bt-at)/p ;
         u=O*(k/h^2);
        f=Utilities.TakeAnInputFucntion(sprintf(' U(x,%0.5f)',at)  );

        Y=zeros(n-1,p+1);  %avoid resizing
        X=zeros(1,n-1);

        A=zeros(n-2);
        B=zeros(n-2);


            for i=1:n-2
                X(i)=ax+i*h;
                 Y(i,1)=subs(f,'x',X(i)) ;

                 A(i,i)=1+u;%diagonal
                 A(i,i+1)=-u/2;%above
                 A(i+1,i)=-u/2;%below

                  B(i,i)=1-u;%diagonal
                 B(i,i+1)=+u/2;%above
                 B(i+1,i)=+u/2;%below
            end
            
            %the last element
            A(n-1,n-1)=1+u;%diagonal
            B(n-1,n-1)=1-u;%diagonal
            X(n-1)=ax+(n-1)*h;
            Y(n-1,1)=subs(f,'x',X(n-1));
    
   
  
            for i=2:p+1
            Y(:,i)=A\(B * Y(:,i-1));
            end 
  
  
            fprintf('the numerical solution for Ut(x,t)=%0.3f*Uxx(x,t)\n',O);
            %display the results in a formatted table with a simple
            %algorithm for a varying-width table

            fprintf('+'); 
            for i=0:p+1
                fprintf   ('---------------+');
            end
            fprintf('\n');
            fprintf('|       x       |');

            for i=0:p
             fprintf(' U(x,%0.6f) |',at+i*k);
            end
            fprintf('\n'); 


            fprintf('+'); 
            for i=0:p+1
          	 fprintf   ('---------------+');
            end
            fprintf('\n'); 


            fprintf('|   %9.6f   ',X(1));
            for i=0:p
             fprintf('|   %9.6f   ',Y(1,i+1));
            end
            fprintf('|\n');


            for j = 2:n-1    
                fprintf('|   %9.6f   ',X(j));
                for i=0:p
                    fprintf('|   %9.6f   ',Y(j,i+1));
                end
                fprintf('|\n');
            end;

            fprintf('+'); 
            for i=0:p+1
                fprintf   ('---------------+');
            end
            fprintf('\n'); 
end

end %end methods
end %end classdef