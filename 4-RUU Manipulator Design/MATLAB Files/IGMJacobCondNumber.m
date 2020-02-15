clear all;
clc;
%% IMPORTANT: This script does everything in the GENERIC FORM
% In other words, it takes the design variables: l1, l2, R and r. This
% means that it could take any value for l1, l2, R and r.
% At the end, it is not used during the project. This code was written with
% the belief that it was going to be useful for the optimization problem,
% as we thought that the Jacobian needed to be in a generic form, so that
% afterwards the condition number could be calculated in the generic form,
% and get the constraints inequalities of the function fmincon.

%% Starts here
syms X Y l1 l2 r R

Xp = 0;
Yp = 0;
Zp = 12;
phi = 0;
boSolution = true;

% This variables could also be introduced without their values, but since
% the computation with these variables is so difficult, we will try to make
% it as easier as possible.

%% 4 points Ci for i=1:4
C1 = [Xp - r*cos(phi); Yp - r*sin(phi); Zp];
C2 = [Xp + r*sin(phi); Yp - r*cos(phi); Zp];
C3 = [Xp + r*cos(phi); Yp + r*sin(phi); Zp];
C4 = [Xp - r*sin(phi); Yp + r*cos(phi); Zp];

%% 4 points Ai for i=1:4
A1 = [-R*cosd(45); -R*sind(45); 0];
A2 = [R*cosd(45); -R*sind(45); 0];
A3 = [R*cosd(45); R*sind(45); 0];
A4 = [-R*cosd(45); R*sind(45); 0];

%% 4 intersections of 2 circles for finding Bi
% The sphere has been projected to a circle of radius n
n = sqrt(l2^2-Zp^2);


% B1
circle1 = (X-C1(1))^2+(Y-C1(2))^2 == n^2;
circle2 = (X-A1(1))^2+(Y-A1(2))^2 == l1^2;
intersection1 = solve([circle1,circle2],[X,Y]);
XB1 = intersection1.X(1); % we take only the first solution
YB1 = intersection1.Y(1); %first solution
B1 = [XB1; YB1; 0]; %B1 is the first point found
theta1 = asin((B1(2)-A1(2))/l1); %theta1 in terms of l1, l2, R and r
% Xp = 0;
% Yp = 0;
% Zp = 11;
% phi = 0;
% R = 12;
% r = 6;
% l1 = 6.5;
% l2 = 12;
% subs(theta1)

% B2
circle1 = (X-C2(1))^2+(Y-C2(2))^2 == n^2;
circle2 = (X-A2(1))^2+(Y-A2(2))^2 == l1^2;
intersection2 = solve([circle1,circle2],[X,Y]);
XB2 = intersection2.X(1);
YB2 = intersection2.Y(1);
B2 = [XB2; YB2; 0];

% B3
circle1 = (X-C3(1))^2+(Y-C3(2))^2 == n^2;
circle2 = (X-A3(1))^2+(Y-A3(2))^2 == l1^2;
intersection3 = solve([circle1,circle2],[X,Y]);
XB3 = intersection3.X(1);
YB3 = intersection3.Y(1);
B3 = [XB3; YB3; 0];

% B4
circle1 = (X-C4(1))^2+(Y-C4(2))^2 == n^2;
circle2 = (X-A4(1))^2+(Y-A4(2))^2 == l1^2;
intersection4 = solve([circle1,circle2],[X,Y]);
XB4 = intersection4.X(1);
YB4 = intersection4.Y(1);
B4 = [XB4; YB4; 0];

%% PROBLEMS: the expressions are huge.
% The expressions are so huge that almost all times MATLAB is not even able 
% to display them. 
% CONCLUSION: WHEN COMPUTING THE CONDITION NUMBER, it takes a long time.

%% From points Ci to P
rC1 = [Xp-C1(1) ; Yp-C1(2) ; Zp-C1(3)];
rC2 = [Xp-C2(1) ; Yp-C2(2) ; Zp-C2(3)];
rC3 = [Xp-C3(1) ; Yp-C3(2) ; Zp-C3(3)];
rC4 = [Xp-C4(1) ; Yp-C4(2) ; Zp-C4(3)];


%% Unitary vectors from points Bi to Ci. Direction: fi. 
f1 = [C1(1)-B1(1) ; C1(2)-B1(2) ; C1(3)-B1(3)];
f1 = f1 ./ norm(f1);
f2 = [C2(1)-B2(1) ; C2(2)-B2(2) ; C2(3)-B2(3)];
f2 = f2 ./ norm(f2);
f3 = [C3(1)-B3(1) ; C3(2)-B3(2) ; C3(3)-B3(3)];
f3 = f3 ./ norm(f3);
f4 = [C4(1)-B4(1) ; C4(2)-B4(2) ; C4(3)-B4(3)];
f4 = f4 ./ norm(f4);

%% From Ai to Ci
 A1C1 = C1-A1;
 A2C2 = C2-A2;
 A3C3 = C3-A3;
 A4C4 = C4-A4;
 
%% Other directions
i = [1; 0; 0];
j = [0; 1; 0];
k = [0; 0; 1];
Zeros = [0;0;0];

%% Direct Jacobian Matrix
A = [cross(rC1,f1)' f1'; 
     cross(rC2,f2)' f2'; 
     cross(rC3,f3)' f3'; 
     cross(rC4,f4)' f4'; 
     i' Zeros';
     i' Zeros']; 
 
 %% Inverse Jacobian Matrix

 B = [dot(cross(A1C1,f1)',k), 0, 0, 0;
     0, dot(cross(A2C2,f2)',k), 0, 0;
     0, 0, dot(cross(A3C3,f3)',k), 0;
     0, 0, 0, dot(cross(A3C3,f3)',k);
     0, 0, 0, 0;
     0, 0, 0, 0];
 %% Jacobian Matrix 
 J = inv(A)*B; 
 % There are NO ERRORS, BUT is not able to display the solutions, as they
 % are so huge.

 %% Condition Number
 % Kappa = cond(J); 
 
 % ERROR 
 % Error using symengine
 % Out of memory.