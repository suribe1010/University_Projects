clear all
clc
%% OPTIMIZATION OF THE DESIGN VARIABLES
% Using the function fmincon, we have to defined some variables.
% Design Variables x=[R r L1 L2]
%% Objective Function
fun = @(x)x(1)+x(2)+x(3)+x(4);

%% Initial values
x0 = [400, 280, 310, 420];

%% We don't have linear equalities or inequalities. They are defined empty 
A = [];
b = [];
Aeq = [];
beq = [];

%% Lower and upper bounds
lb = [260, 140, 170, 280];
ub = [400, 280, 310, 420];

%% We call the non-linear function (works with the condition number Kappa)
nonlcon = @unitdisk;

%% We set some options for the fmincon
options = optimoptions('fmincon','Display','iter','Algorithm','sqp');

%% Using fmincon. Output: x vector with final results.
x = fmincon(fun,x0,A,b,Aeq,beq,lb,ub,nonlcon, options)

% Not working well as it is giving the lower bounds. Something is not well
% defined as it is converging to an infeasible point.