clear all;
clc;
%% Points P of the Trajectory
%PointA = [123.903; -1.341; 210.57];
%PointB = [123.903; -1.341; 187.409];
%PointC = [160.81; -5.627; 189.4];
%PointD = [162.486; 0.953; 211.673];

Xp = 123.903
Yp = -1.341;
Zp = 187.4;
P=[Xp; Yp; Zp];
phi = 0;

%% Design Variables
R = 260;
r = 140;
L1 = 170;
L2 = 280;

%% IGM
% THIS ALGORITHM IS JUST TO CHECK THAT THE INVERSE GEOMETRIC MODEL
% WORKS IN OUR MANIPULATOR WITH SPECIFIC VALUES FOR DESIGN PARAMETERS.
[B, boSolution] = IGM(P, phi, R, r, L1, L2);

%% JACOBIAN AND CONDITION NUMBER for specific values of l1, l2, R and r
% We are considering 2 possible solutions for points Bi, so we obtain 2
% possible solution for the inverse of Kappa
if boSolution == true
[J1, J2, invKappa1, invKapp2] = JACOBIAN(P, phi, R, r, B);
end

 
