# MATLAP-Numerical-Analysis-Tool
A group of m files just to perform common numerical analysis problems ,such as interpolation ,numerical differentiation,ODEs ,PDEs and more

add these files to a folder and navigate to it using matlab 
run NAT.m and the other files are referenced automatically.


## Interpolation tool
1. Function (interpolates a single variable function using one of those ways)
2. Nodes of a function (control points from a function)
3. Nodes of a curve (control points from a parametric 2d curve)

- Methods for interpolation
  1. Lagrange polynomials
  2. Newton
  3. Natural cubic splines
  4. bessel
  5. Newton forward
  6. Newton backward
  7. Differentiation tool (Richardson Extrapolation)
  
![alt text](https://github.com/mohammed-elkomy/MATLAB-numerical-analysis-tool/blob/master/imgs/diff.png) 

 
## Integration tool 
Performing numerical integration using gaussian quadrature

## ODE tool
1. IVP for ODE (Initial value problem)
   1. RK4
   2. Adams-Bashforth 4 step with RK4 at the beginning
2. BVP for ODE (bounded value problem)

## PDE tool
solves heat PDE using Crank-Nicolson method
