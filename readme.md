# MATLAP-Numerical-Analysis-Tool
A group of m files just to perform common numerical analysis problems ,such as interpolation ,numerical differentiation,ODEs ,PDEs and more

add these files to a folder and navigate to it using matlab 
run NAT.m and the other files are referenced automatically.


## Interpolation tool
1. Function (interpolates a single variable function using one of those ways)
2. Nodes of a function (control points from a function)
3. Nodes of a curve (control points from a parametric 2d curve) ![interpolation example](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/interp%201.png) 
4. 
![interpolation example](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/interp%202.png) 

- Methods for interpolation
  1. Lagrange polynomials
  2. Newton ![interpolation newton](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/newton%20interpolation.png) 
  3. Natural cubic splines
  4. bessel
  5. Newton forward
  6. Newton backward
  
## Differentiation tool (Richardson Extrapolation)
![Differentiation tool](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/diff.png) 






## Integration tool 
Performing numerical integration using gaussian quadrature
![lIntegration tool](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/integ.png) 

## ODE tool
1. IVP for ODE (Initial value problem)
   1. RK4 ![ode](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/ode.png) 
   2. Adams-Bashforth 4 step with RK4 at the beginning
2. BVP for ODE (bounded value problem)


## PDE tool
solves heat PDE using Crank-Nicolson method
![pde](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/pde.png) 
