classdef InterpolationMethodsHelper
methods(Static) 
  
%evaluate the dependent varible value for functions 
function EvaluateOnInterpolantRange_functions(Interpolant,X,DV,Mode)
n=length(X);
while(1)
    disp('------------------------');
    fprintf('would you like to evaluate the value of the interpolant at certain value of %s?\nenter the value of %s or type ''quit'' to exit\n',DV,DV);
    text=input('your input is ','s');

    if(strcmp(text,'quit'))
       return;
    end ;

    parsingResult=str2double(text);

    if isnan(parsingResult) %accepting the input
        disp('------------------------');
        disp('please enter it properly');

        continue;
    elseif  parsingResult >max(X)|| parsingResult <min(X)
        disp('------------------------');
        fprintf('out of range [%5.5f,%5.5f]\n',min(X),max(X));

          continue;
    end   ; 

    %substituting step
    if length(Interpolant) >1; %piecewise interpolant
        for i=1:n %X is sorted
            if X(i)<parsingResult && X(i+1)>parsingResult
                fprintf('f(%s)= %5.8f\n',DV,subs(Interpolant(i),DV,parsingResult));
                break;
            end;     
        end
    else %not piecewise
       fprintf('f(%s)= %5.8f\n',DV,subs(Interpolant,DV,parsingResult));    
    end
switch str2double(Mode) 
    case 5 %forward
          if(mod(n,2)) %odd
        if(X(n/2-.5) <parsingResult)
            disp('------------------------');
            disp('Warning:Newton forward difference causes lager error for this node');
           
        end
    else %even
        if((X(n/2)+X(n/2+1)/2)<parsingResult)
            disp('------------------------');
            disp('Warning:Newton forward difference causes lager error for this node');
           
        end
          end
      
    case 6 %backward
      if(mod(n,2)) %odd
        if(X(n/2-.5) >parsingResult)
            disp('------------------------');
            disp('Warning:Newton backward difference causes lager error for this node');
          
        end
    else %even
        if((X(n/2)+X(n/2+1)/2)>parsingResult)
            disp('------------------------');
            disp('Warning:Newton backward difference causes lager error for this node');
            
        end
      end;
end;
 
    
    
end

end

%evaluate the dependent varible value for curves 
function EvaluateOnInterpolantRange_curves(InterpolantX,InterpolantY,X,DV)
  while(1)
    disp('------------------------');
    fprintf('would you like to evaluate the value of the interpolant at certain value of x?\nenter the value of x or type ''quit'' to exit\n');
    text=input('your input is ','s');

    if(strcmp(text,'quit'))
       return;
    end ;

    parsingResult=str2double(text);

    if isnan(parsingResult) %accepting the input
        disp('------------------------');
        disp('please enter it properly');

        continue;
    elseif  parsingResult >max(X)|| parsingResult <min(X)
        disp('------------------------');
        fprintf('out of range [%5.5f,%5.5f]\n',min(X),max(X));

          continue;
    end   ; 

    %substituting step
    if length(InterpolantX) >1; %piecewise interpolant
        for i=1:length(X) %X is sorted
            if X(i)<parsingResult && X(i+1)>parsingResult

                Eqn=strcat(char(InterpolantX(i)),strcat('=',num2str(parsingResult)));
                Tsolution=solve(Eqn,'t');
                Tsolution=double(Tsolution) ;
                Tsolution=Tsolution(and( and(Tsolution>=0 ,Tsolution<=1),imag(Tsolution)==0)); %filtering the solutions
                text='f(%s)=%5.8f';
                for j=2:length(Tsolution)
                text =strcat(text,' or %5.8f');
                end 
                text=strcat(text,'\n');
                fprintf(text,DV,double(subs(InterpolantY(i),DV,Tsolution)));  

                break;
            end;     
        end
    else %not piecewise
          Eqn=strcat(char(InterpolantX),strcat('=',num2str(parsingResult)));
          Tsolution=solve(Eqn,'t');
          try
          Tsolution=double(Tsolution) ;
          Tsolution=Tsolution(and( and(Tsolution>=0 ,Tsolution<=1),imag(Tsolution)==0)); %filtering the solution
          catch e
          end;
          
          if isempty(Tsolution)
              disp('out of range of the interpolant') %for bezier curves
              continue;
          end
          
          text='f(%s)=%5.8f';
          for i=2:length(Tsolution)
          text =strcat(text,' or %5.8f');
          end 
          text=strcat(text,'\n');
          fprintf(text,DV,double(subs(InterpolantY,DV,Tsolution)));  

    end
  end  
end

 %the interfrace for bezier curves
function BezierCurvesInterpolation

      while 1
        disp('Please Choose an action:');
        disp('1:[To enter your points]');
        disp('2:[To enter random points]');
        disp('quit:[Exit or stop the script]'); 

        Mode = input('            Let''s pick: ','s');
        %Mode is string ....use string compare
        if(strcmp(Mode,'quit'))
           return;
        
        %branching
        elseif(strcmpi(Mode,'1')) 
            disp('Hint:order of nodes has to be taken into account in bezier curves');
            while(1)
                try
                IN=input('Please Enter the nodes in the form of an array as [X0 Y0; X1 Y1; X2 Y2;  ... ] or -1 to exit:\n');
                
                if(IN==-1)
                    return;
                end ;
                
                    dim=size(IN);
                        if (length(dim)==2)&&dim(2)==2
                            InterpolationMethodsHelper.BezierCurvesWithFinitePoints(IN)
                            break;
                        else 
                            disp('enter the nodes properly'); 
                            disp('------------------------'); 
                        end
                        
                catch e
                        disp('enter the nodes properly'); 
                        disp('------------------------'); 
                end
            end
         elseif(strcmpi(Mode,'2'))
                    disp('Hint:You choose the number of points and the program should pick random values for them');
                   
                        while true
                            try
                                n = input('Please Enter the number of points:');

                                if( isempty(n))
                                continue;
                                end;

                                if n <= 0
                                disp('Please enter a positive number');
                                continue;    
                                end;
                                
                                if ~(~isempty(n)  && isnumeric(n)&& isreal(n)&& isfinite(n) && (n == fix(n)) && (n > 0))
                                    disp('Please enter the it properly') ;  
                                    continue;    
                                end;
                                
                                InterpolationMethodsHelper.BezierCurvesWithRandomPoints(n)
                                break;

                            catch e %handling errors  
                            disp('Please enter the number of points properly') ;  
                            end
                        end
        else
             disp('Error!,please pick a proper choice') 
             disp('-------------------------------------');
             continue;
        end ;
                         break; 
      end;
        
end;

%the user gives the points
function BezierCurvesWithFinitePoints( Points )
    % This function draw the bezier curve for control points Points
    % Points is an array of points with size of (number of points,2)
    % Example:
    % bezierpoints([1 1; 2 3; 3 4; 4 0;])
    px=Points(:,1);
    py=Points(:,2);
    n=length(px)-1;
    syms t;
    %syms P;
    %B=0;
    X=0;
    Y=0;
    for i=0:n
        %B=B+nchoosek(n,i)*t.^i.*(1-t).^(n-i)*P^(i+1);
        X=X+nchoosek(n,i)*t.^i.*(1-t).^(n-i)*px(i+1);
        Y=Y+nchoosek(n,i)*t.^i.*(1-t).^(n-i)*py(i+1);
    end
    X=expand(X)
    Y=expand(Y)
    t=0:0.001:1;
    x=subs(X,t);
    y=subs(Y,t);
    %PLOTTING.......
    figure('Name','Interpolation Tool'); 
    plot(px,py,'-.c.','LineWidth',2,'MarkerSize',12,'MarkerEdgeColor','b')
    hold on
    plot(x,y,'r','LineWidth',1.25)
    %title('Bezier Curve','LineWidth',2)
    xlabel('X')
    ylabel('Y')
    legend('Control Points','Bezier Curve','Location','northoutside','Orientation','horizental')
    xlim([min(px)-1,max(px)+1])
    ylim([min(py)-1,max(py)+1])
    set(gca,'FontSize',12)
    InterpolationMethodsHelper.EvaluateOnInterpolantRange_curves(X,Y,px,'t');
end

%random points as the user give their number
function BezierCurvesWithRandomPoints( m )
    % This function draw the bezier curve for m number of points
    % Example:
    % bezierrandpoints(5)
    Points=randi(10,m,2);
    
    px=Points(:,1);
    py=Points(:,2);
    Utilities.Construct_X_Y_table(px,py,'x',' y  ',m) ;
    n=length(px)-1;
    syms t;
    %syms P;
    %B=0;
    X=0;
    Y=0;
    for i=0:n
        %B=B+nchoosek(n,i)*t.^i.*(1-t).^(n-i)*P^(i+1);
        X=X+nchoosek(n,i)*t.^i.*(1-t).^(n-i)*px(i+1);
        Y=Y+nchoosek(n,i)*t.^i.*(1-t).^(n-i)*py(i+1);
    end
    X=expand(X)
    Y=expand(Y)

    t=0:0.001:1;
    x=subs(X,t);
    y=subs(Y,t);
    %PLOTTING.......
    figure('Name','Interpolation Tool'); 
    plot(px,py,'-.c.','LineWidth',2,'MarkerSize',12,'MarkerEdgeColor','b')
    hold on
    plot(x,y,'r','LineWidth',1.25)
    %title('Bezier Curve','LineWidth',2)
    xlabel('X')
    ylabel('Y')
    legend('Control Points','Bezier Curve','Location','northoutside','Orientation','horizental')
    xlim([min(px)-1,max(px)+1])
    ylim([min(py)-1,max(py)+1])
    set(gca,'FontSize',12)
    InterpolationMethodsHelper.EvaluateOnInterpolantRange_curves(X,Y,px,'t');
end

%input the nodes in the a specified manner known at runtime
function [X Y Mode]= setupNodesForInterpolation(IsCurve)
    while true

    [X Y]=Utilities.read_nodes_X_Y(IsCurve); %read the nodes
    try
            if(X==0 && Y==0 )
            Mode=0;
            return;
            end;
    catch e
    end;

            if(numel(X) == numel(Y))

                    if IsCurve
                    EquallySpaced=false; 
                    else
                    %this calls a function to pick the method of interpolation
                    EquallySpaced=InterpolationMethodsHelper.isEquallySpaced(X);
                    end;
            Mode=InterpolationMethodsHelper.ChooseInterpolateMode(EquallySpaced);

                    if(Mode==0)
                    return;
                    end;

            n=numel(X);
            Utilities.Construct_X_Y_table(X,Y,'x',' y  ',n) ;

            break;
            else
            disp('X & Y array mismatch (different sizes)');
            disp('Please try again');
            disp('hint: duplicates are excluded');
            disp ('----------------------------------------');

            continue;
            end;
    end  
end

%finds if the function is equally spaced or not to permit using forward and backward newton methods
function EquallySpaced=isEquallySpaced(X)
            X=sort(X);
            EquallySpaced=true;
            if(length(X)>=2)
                delta=X(2)-X(1);
                
                for i=2:length(X)-1
                    
                    if(  (abs(X(i+1)-X(i) - delta)) > 10^-2)  
                        EquallySpaced=false;
                        return;
                    end
                end
                
            end
end

        
function   TriggerInterpolationTool
Mode=Utilities.ChooseInputMode_FUNCTION_OR_POINTS;



    %for a function mode 1
    if strcmpi( Mode , '1' )
        
        [DV F X] =Utilities.read_dependentVariable_Function_NodesOFX;
        %the user wants to quit
        if(DV==0 && F==0 && X==0)
        return;
        end;
        %equally spaced chek
        EquallySpaced=InterpolationMethodsHelper.isEquallySpaced(X) ;

        %this calls a function to pick the method of interpolation
        Mode=InterpolationMethodsHelper.ChooseInterpolateMode(EquallySpaced);

        if(Mode==0)
        return;
        end;

        %Substitute in F(DV) with X vector
        Y=  Utilities.Substitute_in_a_function(F,DV,X);
        
        %sorting the arrays to find the interval of each peicewise function      
       [SortedX, SortIndex] = sort(X);
        SortedY = Y(SortIndex);

 
            %DO THE HARD WORK FIND THE INTERPOLANT
            Interpolant=InterpolationMethodsHelper.interpolate(Mode,SortedX,SortedY,DV,0);
            LEN=length(Interpolant);
            figure('Name','Interpolation Tool'); 
            try 
                if(min(X)==max(X))
                ez=ezplot(F,[min(X),max(X)]);
                set(ez,'LineWidth',2,'color',[1 0 0]);
                else

                plot(X,Y,'-mo','MarkerFaceColor',[.49 1 .63],'color',[1 0 0],'LineWidth',2);
                end;
            hold on
            
            catch e
                
                 plot(X,ones(size(X)) *  subs(F, DV, X(1)),'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
            end;
    hold on

        if( LEN>1) %plotting  piecewise cubic
                disp('The parametric interpolants for the given set of data');         
                for i=1:LEN
                        fprintf('f(%s) = %s     %12.4f <= %s <=%12.4f      \n',DV,char(Interpolant(i)),X(i),DV,X(i+1));

                    try
                        hold on
                        ezplot(Interpolant(i),[X(i),X(i+1)]);
                        axis([min(X) max(X) min(Y) max(Y)])
                        catch e

                    plot(X,ones(size(X)) *  subs(Interpolant(i), DV, X(1)),'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
                    end;
                end;
                 Text='Piecewise function printed in command window';

        else
                disp('The interpolant for the given set of data');
                fprintf('f(%s) = %s\n',DV,char(Interpolant));
                %plot the result of the 2 opposing functions
                try
                     ezplot(Interpolant,[min(X),max(X)]);
                catch e
                     plot(X,ones(size(X)) *  subs(Interpolant, DV, X(1)),'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
                end;
                Text=char(Interpolant);
        end
        legend('Exact Function','Interpolant')
        title(sprintf('The interpolant \n%s',Text));
        xlabel(sprintf('%s',DV));
        ylabel(sprintf('f(%s)',DV));
        InterpolationMethodsHelper. EvaluateOnInterpolantRange_functions(Interpolant,X,DV,Mode);
        return;

    elseif strcmpi( Mode , '2' ) %the user wants the node
        DV='x';
        [X Y Mode] =  InterpolationMethodsHelper. setupNodesForInterpolation(false);
        
         if(Mode==0)
             return;
         end;
        
        %sorting the arrays to find the interval of each peicewise function      
       [SortedX, SortIndex] = sort(X);
        SortedY = Y(SortIndex);
        
        Interpolant=InterpolationMethodsHelper.interpolate(Mode,SortedX,SortedY,DV,0);
        LEN=length(Interpolant);

        if( LEN>1) %plotting  piecewise cubic
           
                
            figure('Name','Interpolation Tool');
            plot(X,Y,'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
            hold on
            disp('The piecewise interpolants for the given set of data');       
            for i=1:LEN
            fprintf('f(%s) = %s     %12.4f <= %s <=%12.4f      \n',DV,char(Interpolant(i)),X(i),DV,X(i+1));
                try
                    hold on
                    ezplot(Interpolant(i),[X(i),X(i+1)]);
                    axis([min(X) max(X) min(Y) max(Y)])
                catch e
                    plot(X,ones(size(X)) *  subs(Interpolant(i), DV, X(1)),'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
                end

            end
            Text='Piecewise function printed in command window';
        else
            disp('The interpolant for the given set of data');
            fprintf('f(%s) = %s\n',DV,char(Interpolant));
            figure('Name','Interpolation Tool');
                try
                    plot(SortedX,SortedY,'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
                    hold on
                    ezplot(Interpolant,[min(X),max(X)]);
                catch e
                    plot(X,ones(size(X)) *  subs(Interpolant, DV, X(1)),'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
                end;
            Text=char(Interpolant);
        end

    legend('Input nodes','Interpolant')
    title(sprintf('The interpolant \n%s',Text));
    xlabel(sprintf('%s',DV));
    ylabel(sprintf('f(%s)',DV));
    InterpolationMethodsHelper. EvaluateOnInterpolantRange_functions(Interpolant,X,DV,Mode);
    
    elseif strcmpi( Mode , '3' )

        while 1
            disp('Please choose an action');
            disp('1:[Bezier Curves]');
            disp('2:[Parametric interpolation]');
            disp('quit:[Exit or stop the script]');
            CMode = input('            Let''s pick: ','s');

            if(strcmp(CMode,'quit'))
                 return;
            end ;

            disp('-------------------------------------');
            if ~(strcmpi( CMode , '1' )||strcmpi( CMode , '2' ))
                disp('Error!,please pick a proper choice')
            else
            break;
            end;

        end

        if strcmpi( CMode , '1' )  %starting bezier
            InterpolationMethodsHelper.BezierCurvesInterpolation;
        else
            disp('Hint:order of nodes has to be taken in parametric curves ')    
            DV='t';
            [X Y Mode] =  InterpolationMethodsHelper. setupNodesForInterpolation(true);
            
            if(Mode==0)
             return;
            end;
            
            
            if(length(X) ~=1)
            n=length(X);
            h=1/(n-1);

            T=zeros(1,n);

            for i=1:n
            T(i)=(i-1)*h;
            end

            [InterpolantX acc]=InterpolationMethodsHelper.interpolate(Mode,T,X,DV,0);
            InterpolantY=InterpolationMethodsHelper.interpolate(Mode,T,Y,DV,acc);
            else
              InterpolantX=X(1);
                InterpolantY=Y(1);
            end;
            LEN=length(InterpolantX);
            disp('The parametric interpolants for the given set of data');

                if( LEN>1) %plotting  piecewise cubic
                figure('Name','Interpolation Tool');
                %ploting Nodes 
                plot(X,Y,'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
                hold on

                    for i=1:LEN
                    fprintf('X(%s) = %s     %12.4f <= %s <=%12.4f      \n',DV,char(InterpolantX(i)),T(i),DV,T(i+1));
                    fprintf('Y(%s) = %s     %12.4f <= %s <=%12.4f      \n',DV,char(InterpolantY(i)),T(i),DV,T(i+1));
                    fprintf('-------------------------------------------\n');
                        try
                        hold on

                        ezplot(InterpolantX(i),InterpolantY(i),[T(i),T(i+1)]);
                        axis([min(X) max(X) min(Y) max(Y)])

                        catch e
                        end
                    end

                Text='are 2 parametric piecewise functions printed in the command window';
                else
                fprintf('X(%s) = %s\n',DV,char(InterpolantX));
                fprintf('Y(%s) = %s\n',DV,char(InterpolantY));

                figure('Name','Interpolation Tool');
                    try
                        plot(X,Y,'-mo','MarkerFaceColor',[.49 1 .63],'LineWidth',1.5,'color',[1 0 0]);
                        hold on
                        ezplot(InterpolantX,InterpolantY,[0,1]);
                        catch e
                    end;
                Text='are 2 parametric functions printed in the command window';
                end

            legend('Input nodes','Interpolant')
            title(sprintf('The interpolants \n%s',Text));
            xlabel(sprintf('%s','x'));
            ylabel(sprintf('f(%s)','x'));
            
            InterpolationMethodsHelper.EvaluateOnInterpolantRange_curves(InterpolantX,InterpolantY,X,DV);
         end
    end
end
%prompts the user to input the method of interpolation
function  Mode =ChooseInterpolateMode(EquallySpaced)
    while 1
        disp('Please Choose an action');
        disp('1:[Lagrange polynomials]');
        disp('2:[Newton]');
        disp('3:[Natural cubic splines]');

        if EquallySpaced
            disp('4:[bessel]');
            disp('5:[Newton forward]');
            disp('6:[Newton backward]');
        end

        disp('quit:[Exit or stop the script]');
        Mode = input('            Let''s pick: ','s');
        
        if(strcmp(Mode,'quit'))
             Mode=0;
             return;
        end ;
        
        
        if ~(strcmpi( Mode , '1' )||strcmpi( Mode , '2' )||strcmpi( Mode , '3' )||EquallySpaced&&(strcmpi( Mode , '5' )||strcmpi( Mode , '6' )||strcmpi( Mode , '4' )))
             disp('Error!,please pick a proper choice')
        else
             break;
        end;
    end
end

%branching for interpolation methods    
function [result acc]= interpolate(Mode,X,Y,DV,acc)

switch str2double(Mode)
    case 1
        result =  InterpolationMethodsHelper.lagrange( X,Y,DV );
    case 2
        result =  InterpolationMethodsHelper.newton( X,Y,DV );
    case 3
        result =  InterpolationMethodsHelper.cubic_spline( X,Y,DV );
    case 4
        result =  InterpolationMethodsHelper.bessel( X,Y,DV );
    case 5
        result =  InterpolationMethodsHelper.newton_forward( X,Y,DV );
    case 6
        result =  InterpolationMethodsHelper.newton_backward( X,Y,DV );
end;


    if acc==0
        acc =input('please choose the maximum number of significant decimal digits ');
        while ~(~isempty(acc)  && isnumeric(acc)&& isreal(acc)&& isfinite(acc) && (acc == fix(acc)) && (acc > 0))
            try
        acc =input('please choose the maximum number of significant decimal digits ');
            catch e 
            end
        end
    end   
    
    digits(acc);
    result=vpa(result);

    
end

%lagrange interpolation
function  Func  = lagrange( X,Y ,DV)

    n=numel(X);
    syms x;
    L=sym(ones(1,n)); %array of lagrange coefficient L's
    for i = 1:n %calculate  Li lagrange coefficient

        for j = 1:n
            %calulate each piece of Li (x-x0)/(xi-x0)
            %then muliply them in each iteration to find each Li
            if( X(j)~= X(i))
                L(i) =simplify(L(i)*((x-X(j))/(X(j)-X(i))));
            end ;
        end;

    end;

Func=sym('0');%defualt starting value 

for i = 1:n   %find the function summation of Li*Y(i)
    Func =Func+L(i)*Y(i);
end;

Func=expand(x*0+Func) ;
Func=strrep(char(Func), 'x', DV);
Func=sym(Func);
Func=InterpolationMethodsHelper.Check(Func,X,Y,DV);

end

%checking the results against matlab bugs
function result=Check(Func,X,Y,DV)
     result=Func;
    for i=1:length(X)
         if Y(i) ~=0 && subs(Func, DV, X(i)) == -1*Y(i)
            result=-1*Func;
            break;
         end
    end
end
        
%general newton interpolation        
function     Func  = newton( X,Y,DV )

    n=numel(X); %avoid resizing
    DD=cell(n,1);%initializng the divided difference table
    DD{1}=ones(1,n-1);
    DD{1}=Y;

    for i=1:n
        for j=1:n-i
            DD{i+1}(j)=(DD{i}(j+1)- DD{i}(j))/(X(j+i)-X(j));
        end;
    end

    syms x;
    Func=sym(Y(1));

    Roots=sym(x-X(1));
    for i = 2:n

        Func =Func+(DD{i}(1))*Roots;
        Roots=Roots*(x-X(i));

    end;

    %finlizing
    Func=expand(x*0+Func) ;
    Func=strrep(char(Func), 'x', DV);
    Func=sym(Func);
    Func=InterpolationMethodsHelper.Check(Func,X,Y,DV);
end

        
        
%piecewise natural cubic spline interpolation
function   Func  = cubic_spline( X,Y,DV )
    %initializing
        n=length(X)-1;
        H=zeros(1,n);
        R=zeros(n-1,1); 
        B=zeros(n,1); 
        D=zeros(n,1); 
        A=zeros(n-1);

    for i=1:n
        H(i) =X(i+1)-X(i); 
    end


    for i=1:n-2
        R(i)=3*(((Y(i+2)-Y(i+1))/H(i+1))-((Y(i+1)-Y(i))/H(i)));
        A(i,i)=2*(H(i)+H(i+1));%diagonal
        A(i,i+1)=H(i+1);%above
        A(i+1,i)=H(i+1);%below
    end

    try
        A(n-1,n-1)=2*(H(n-1)+H(n));%diagonal
        R(n-1)=3*((Y(n+1)-Y(n))/H(n)-(Y(n)-Y(n-1))/H(n-1));
        % A(n-2,n-2)=654654;%diagonal
    catch e
    end
    
    %solving the linear system
    C=A\R;
    C=[0;C;0];

    for i=1:n
        B(i)=(1/H(i))*(Y(i+1)-Y(i))-(H(i)/3)*(C(i+1)+2*C(i));
        D(i)=(C(i+1)-C(i))/(3*H(i));
    end
    
    %initialining these output functions
    Func=sym(zeros(1,n));
    syms x;
C
    %finilizing
    for i=1:n 
        Func(i)=   expand(Y(i)+B(i)*(x-X(i))+C(i)*(x-X(i))^2+D(i)*(x-X(i))^3)    ;
        Func(i)=strrep(char(Func(i)), 'x', DV);
        Func(i)=sym(Func(i)); 
    end
    
end
        
       
function     Func  = bessel( X,Y,DV )
   if numel(X)==1
        Func= sym(Y(1));
         return;
    end
    
    %initizling
    n=numel(X);
    FD=cell(n,1);
    FD{1}=ones(1,n-1);
    FD{1}=Y;

    %constructing forward difference table
    for i=1:n
        for j=1:n-i
          FD{i+1}(j)=(FD{i}(j+1)- FD{i}(j));
        end;        
    end


     syms x;
     syms P;
    
    Func=sym(0);%initializing
    Roots=sym(1);
    try
    for i = 1:n
           x0=ceil(length(FD{i})/2);
      
         if(mod(i, 2)) %odd     
            Func =Func+(( FD{i}(x0)) + FD{i}(x0+1))/2*(Roots/factorial(i-1));
            Roots=Roots*(P-.5);
        else %even 
            Func =Func+(FD{i}(x0)*(Roots/factorial(i-1)));
            Roots=(Roots*(P-i+2)*(P+i-3))/(P-.5); 
        end;
      
    
    end;
    catch e
        e
    end;
    disp('the interpolant in terms of P');
    %display in 7 digits
    digits(7);
    disp(vpa(expand(x*0+Func)));
    Func=subs(Func, (x-X(ceil(n/2)))/(X(2)-X(1)) );
    
    Func=expand(x*0+Func) ;
    Func=strrep(char(Func), 'x', DV);
    Func=sym(Func);
    Func=InterpolationMethodsHelper.Check(Func,X,Y,DV);
end

%newton using forward difference interpolation       
function     Func  = newton_forward ( X,Y,DV )

    if numel(X)==1
        Func= sym(Y(1));
         return;
    end
    
    %initizling
    n=numel(X);
    FD=cell(n,1);
    FD{1}=ones(1,n-1);
    FD{1}=Y;

    %constructing forward difference table
    for i=1:n
        for j=1:n-i
          FD{i+1}(j)=(FD{i}(j+1)- FD{i}(j));
        end;        
    end

    syms x;
    syms S;

    Func=sym(Y(1));%initializing

    Roots=sym(S);
    for i = 2:n
         Func =Func+(FD{i}(1))*(Roots/factorial(i-1));
         Roots=Roots*(S-i+1);
    end;
    disp('the interpolant in terms of s');
    %display in 7 digits
    digits(7);
    disp(vpa(expand(x*0+Func)));
    
    Func=subs(Func, (x-X(1))/(X(2)-X(1)) );
    Func=expand(x*0+Func) ;
    Func=strrep(char(Func), 'x', DV);
    Func=sym(Func);
    Func=InterpolationMethodsHelper.Check(Func,X,Y,DV);
end

        
function     Func  = newton_backward( X,Y,DV )
     if numel(X)==1
        Func= sym(Y(1));
         return;
     end
    n=numel(X);
    FD=cell(n,1);
    FD{1}=ones(1,n-1);
    FD{1}=Y;

    for i=1:n
        for j=1:n-i
            FD{i+1}(j)=(FD{i}(j+1)- FD{i}(j));
        end;
    end
    
    syms x;
    syms S;
    
    Func=sym(Y(n));%initialing
    
    Roots=sym(S);
    for i = 2:n
        Func =Func+(FD{i}(n-i+1))*(Roots/factorial(i-1));
        Roots=Roots*(S+i-1);
    end;

    disp('the interpolant in terms of s');
    digits(7);
     disp(vpa(expand(x*0+Func)));
    
    Func=subs(Func, (x-X(n))/(X(2)-X(1)) );
    %finalizing
    Func=expand(x*0+Func) ;
    Func=strrep(char(Func), 'x', DV);
    Func=sym(Func);
    Func=InterpolationMethodsHelper.Check(Func,X,Y,DV);

        end  
    end %end methods
end %end class definitions