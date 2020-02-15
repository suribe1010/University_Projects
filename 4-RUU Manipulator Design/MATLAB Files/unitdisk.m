function [c,ceq] = unitdisk(x)
%% Points of the trajectory
PointA = [123.903; -1.341; 210.57];
PointB = [123.903; -1.341; 187.409];
PointC = [160.81; -5627; 189.4];
PointD = [162.486; 0.953; 211.673];
Points = [PointA, PointB, PointC, PointD];

%% We go through all those points to compute the condition number in each point.
for i=1:4
    P = Points(:,i);
    [B, boSolution] = IGM(P, 0, x(1), x(2), x(3), x(4));
    if boSolution == true
        [J1, J2, invKappa1, invKappa2] = JACOBIAN(P, 0, x(1), x(2), B);
        C(i) = invKappa1;
        text= 'Values of C: ', num2str(C(i));
        disp(text);
    end

end
%% Inequeality contraint
c = 0.1 - C;

%% Equality contraint empty, we do not have.
ceq = [];