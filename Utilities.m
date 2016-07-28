classdef Utilities %defining a class to hold static helper methods
    
methods(Static)   
%prints a formated table of X&Y as well as their properities
function Construct_X_Y_table(X,Y,DV,FDV,n) 

disp   ('+---------------------+---------------------+');
fprintf('|         %s           |         %s        |\n',DV,FDV);
disp   ('+---------------------+---------------------+');
fprintf('|   %12.7f      |   %12.7f      |\n',X(1),Y(1));
for i = 2:n
    fprintf('|   %12.7f      |   %12.7f      |\n',X(i),Y(i));
end;
disp   ('+---------------------+---------------------+');

end
      
%prompts the user to input n number of periods 
function n=Accept_n(text)
          while true
                        try
                     n = input(sprintf('Please Enter the the number of periods  %s =',text));

                        if( isempty(n))
                            continue;
                        end;

                         if n <= 0
                               disp('Please enter a positive number of periods');
                           continue;    
                         end;
                       

                    if ~(~isempty(n)  && isnumeric(n)&& isreal(n)&& isfinite(n) && (n == fix(n)) && (n > 0))
                        fprintf('Please enter the %s properly',text) ;  
                        continue;    
                    end;

                     break; 
                catch e %handling errors  
                    fprintf('Please enter the %s properly',text) ;  
                       end
          end
end
        
        
%prompts the user to input a function as a string
function fs= TakeAnInputFucntion(text)
          
                                        %reading the function itself and analysing it
                           fs='';            
                    while true
                      try 

                        fs = input( sprintf('Please Enter The Function \n%s = ',text),'s');
                          if( isempty(fs))
                            continue;
                          end;
                         
                           if(strcmp(fs,'quit'))
                                return;
                           end ;
                        
                       F  = sym(fs);
                       Vars=symvar(F);
                       var=  char(Vars(1));
                               %handling errors
                               if length(Vars) ~=1  
                                disp('Function of one varible is only accepted 2D');
                                if(strfind(char(F), 'e'))
                                disp('Hint: use exp(x) instead of e^x ');
                                end ;
                                 continue; 

                                elseif   ~strcmp(var,'x')
                                  fprintf('Wrong depenednt varible %s instead of x ',var);
                                  continue; 
                               end;
                               
                     catch e %handling errors
                         
                          if ~isempty(str2double(fs))
                              break;
                          end

                            disp('Please enter the function properly');
                            disp('Hint: use 2*x instead of 2x\n');
                            disp('-------------------------------------');  
                             continue; 
                             
                      end
                       break;
                    end
            
end
    
%prompts the user to choose the tool
function  Mode =ChooseToolMode
                    while 1
                        
                        disp('Please Choose an action');
                        disp('1:[Interpolation tool]');
                        disp('2:[Differentiation tool]');
                        disp('3:[Integration tool]');
                        disp('4:[ODE tool]');
                        disp('5:[PDE tool]');
                        disp('quit:[Exit or stop the script]');
                        Mode = input('            Let''s pick: ','s');

                            if(strcmp(Mode,'quit'))
                               Mode=0;
                                return;
                            end ;

                        disp('-------------------------------------');
                            if ~(strcmpi( Mode , '1' )||strcmpi( Mode , '2' )||strcmpi( Mode , '3' )||strcmpi( Mode , '4' )||strcmpi( Mode , '5' ))
                                disp('Error!,please pick a proper choice')
                            else
                                break;
                            end;
                    end
end
        
%choose the mode function or nodes 
function  Mode =ChooseInputMode_FUNCTION_OR_POINTS      
                 
                while 1
                    disp('Please Choose your Input mode (Function or Nodes)');
                    disp('1:[Function]');
                    disp('2:[Nodes of a function]');
                    disp('3:[Nodes of a curve]');
                    disp('quit:[Exit or stop the script]');
                    Mode = input('            Let''s pick: ','s');

                     if(strcmp(Mode,'quit'))
                       Mode=0;
                        return;
                    end ;

                    disp('-------------------------------------');
                    if ~(strcmpi( Mode , '1' )||strcmpi( Mode , '2' )||strcmpi( Mode , '3' ))
                        disp('Error!,please pick a proper choice')
                    else
                        break;
                    end;
                end;
end  
         
%prompts the user to input the dependent varibles,the function and the nodes
function  [DV F X] =read_dependentVariable_Function_NodesOFX    
            
                %read the dependent varible 
                while true
                    DV = input('Please Enter the dependent variable for instance  ..  x\n            Let the dependent variable be :','s');

                         if(strcmp(DV,'quit'))
                            DV=0;
                            F=0;
                            X=0;
                            return;
                         end ;

                         if( isempty(DV))
                            continue;
                         end;

                          try 
                           if ~((uint8(DV)<= 90 && uint8(DV)>= 65) ||  (uint8(DV)>= 97 && uint8(DV)<= 122))
                           disp('please give a proper variable...only English characters accepted');
                           disp('-------------------------------------');
                            continue; 
                           end;
                          catch e %handling errors
                            disp('please give a proper variable...only English characters accepted');
                           disp('-------------------------------------');
                            continue; 
                          end;
                  break;
                end;

            %reading the function itself and analysing it
            while true
              try  
                fs = input(sprintf('Please Enter The Function \nf(%s)= ',DV),'s');

                 if( isempty(fs))%handling errors
                    continue;
                 end;

                if(strcmp(fs,'quit'))%the user quits
                    DV=0;
                    F=0;
                    X=0;
                    return;
                end ;
                
                    F  = sym(fs);
                    disp('-------------------------------------');  
                    Vars=symvar(F);
                    var=  char(Vars(1));
               
                        if length(Vars) ~=1  
                        disp('Function of one varible is only accepted 2D');

                        if(strfind(char(F), 'e'))
                        fprintf('Hint: use exp(%s) instead of e^%s ',DV,DV);
                        end ;
                         continue; 
                         
                        elseif   ~strcmp(var,DV)
                          fprintf('Wrong depenednt varible %s instead of %s ',var,DV);
                          continue; 
                        end;

             catch e %handling errors 
                 
                disp('Please enter the function properly');
                fprintf('Hint: use 2*%s instead of 2%s',DV,DV);
                disp('-------------------------------------');  
                 continue; 
              end; 
               break;
            end;


            %reading the nodes of the funciton
            while true    
            try
               X = input(sprintf('Please Enter the points in the form of an array as [%s0 %s1 %s2 ... ] Or -1 to exit\n',DV,DV,DV));
                  if( isempty(X))
                    continue;
                  end

               if(X==-1)
                   DV=0;
                    F=0;
                    X=0;
                    return;
               end ;
                
                dim=size(X);
                if (length(dim)==2)&&dim(1)==1
                else 
                     disp('enter the nodes properly'); 
                     disp('------------------------'); 
                     continue; 
                end
                
            catch e %handling errors
                disp('Please give the input properly');
                disp('-------------------------------------');
               continue; 
            end;
            [~, I]=unique(X,'first');
             X=X(sort(I)) ;
             break;
            end;
            
end  

%substitue in a funtion with and array of dependent variable X 
function Y =Substitute_in_a_function(F,DV,X)
            disp('-------------------------------------');
            
            n = numel(X);
            Y = X;
            
            %substitute in the function
            for i = 1:n
                Y(i) =subs(F, DV, X(i));
            end;
            
            %Display the result in formatted table
            fprintf('the exact function is f(%s) = %s\n',DV,char(F));
            Utilities.Construct_X_Y_table(X,Y,DV,sprintf('f(%s)',DV),n) ;
    
end 
         
    
%read the nodes of X & Y separately
function [X Y]=read_nodes_X_Y(IsCurve)
        while true
            
            try
               X = input('Please Enter the nodes of x axes in the form of an array as [X0 X1 X2 ... ] Or -1 to exit\n');
                  if( isempty(X))
                    continue;
                 end;
                if(X==-1)
                    Y=0;
                    X=0;
                    return;
                end ;
                
                dim=size(X);
                if (length(dim)==2)&&dim(1)==1
                else 
                     disp('enter the nodes properly'); 
                     disp('------------------------'); 
                     continue; 
                end

            catch e %handling errors
                disp('Please give the input properly');
                disp('-------------------------------------');

               continue
            end;
                if(~IsCurve)
                
               [~, I]=unique(X,'first');
                X=X(sort(I)) ;

                
                end
                 break;
        end

            while true
                
            try
               Y = input('Please Enter the nodes of y axes in the form of an array as [Y0 Y1 Y2 ... ] Or -1 to exit\n');
               if( isempty(Y))
                    continue;
               end;
               if(Y==-1)
                    Y=0;
                    X=0;
                    return;
               end ;
               
                dim=size(Y);
                if (length(dim)==2)&&dim(1)==1
                else 
                     disp('enter the nodes properly'); 
                     disp('------------------------'); 
                     continue; 
                end
                
           catch e %handling errors
                disp('Please give the input properly');
                disp('-------------------------------------');
               continue; 
           end;
           
                 break;
           end;
end

end %end methods
end %end class definitions