function [B, boSolution] = IGM(P, phi, R, r, L1, L2)
%% IMPORTANT: This function does everything taking the VALUES given to the design variables
% In other words, it takes exactly the value of l1, l2, R and r
% So, this algorithm it is not useful for the computation of the Jacobian,
% which should be in terms of these design variables, since then we have to
% compute the condition number in terms of the design variables l1, l2, R,
% and r. 
% SO, THIS ALGORITHM IS JUST TO CHECK THAT THE INVERSE GEOMETRIC MODEL
% WORKS IN OUR MANIPULATOR WITH SPECIFIC VALUES FOR DESIGN PARAMETERS.


%This function realices the Inverse Geometric Model of a 4-RUU manipulator
%See the figure attached to this file in the report. 
%Coordinates of points A and C are known. Only B is unknown. 
%With the intersection of 1 circle and 1 sphere, we can calculate the angle alpha
%   1) Center: A....Radius: l1
%   2) Center: C....Radius: l2
%Actuacted joints q1, q2, q3 and q4 can be computed with the angle alpha

%% Start here 
boSolution = true; %boSolution will give us if exits solution
phi = phi * pi() / 180; %Input phi to radians
Xp = P(1);
Yp = P(2);
Zp = P(3);

%% 4 points C
C1 = [Xp - r*cos(phi); Yp - r*sin(phi); Zp];
C2 = [Xp + r*sin(phi); Yp - r*cos(phi); Zp];
C3 = [Xp + r*cos(phi); Yp + r*sin(phi); Zp];
C4 = [Xp - r*sin(phi); Yp + r*cos(phi); Zp];

%% 4 points A
A1 = [-R*cosd(45); -R*sind(45); 0];
A2 = [R*cosd(45); -R*sind(45); 0];
A3 = [R*cosd(45); R*sind(45); 0];
A4 = [-R*cosd(45); R*sind(45); 0];
%% Distance A1C1 can not be greather than l1+l2
% If this happen, the point P is not reachable
A1C1 = C1 - A1;
distA1C1 = norm(A1C1);
A2C2 = C2 - A2;
distA2C2 = norm(A2C2);
A3C3 = C3 - A3;
distA3C3 = norm(A3C3);
A4C4 = C4 - A4;
distA4C4 = norm(A4C4);

if distA1C1>L1+L2 || distA2C2>L1+L2 || distA3C3>L1+L2 || distA4C4>L1+L2 
    boSolution  = false;
    disp('Not possible to reach this point.');
end
%% Intersection of 2 circles
% The sphere has been projected to a circle of radius n
n = sqrt(L2^2-Zp^2); %n can not be less than 0.
if Zp>L2 
    boSolution  = false;
    disp('Not possible to reach this point.');
end
if boSolution == true
    [XB1,YB1] = circcirc(A1(1),A1(2),L1,C1(1),C1(2),n);
    [XB2,YB2] = circcirc(A2(1),A2(2),L1,C2(1),C2(2),n);
    [XB3,YB3] = circcirc(A3(1),A3(2),L1,C3(1),C3(2),n);
    [XB4,YB4] = circcirc(A4(1),A4(2),L1,C4(1),C4(2),n);


    %% Coordinates of points Bi
    % In the intersecion 2 different point are found for each Bi. 
    % We will work with both of them
    B1 = vertcat(XB1, YB1, [0 0]);
    B2 = vertcat(XB2, YB2, [0 0]);
    B3 = vertcat(XB3, YB3, [0 0]);
    B4 = vertcat(XB4, YB4, [0 0]);
    B = horzcat(B1, B2, B3, B4);
end 


%% If P is reachable, display the values for the actuated joints
if boSolution == true
    
    theta11 = asin((B1(2,1)-A1(2))/L1);
    theta11 = theta11 / pi() * 180;
    theta12 = asin((B1(2,2)-A1(2))/L1);
    theta12 = theta12 / pi() * 180;
    
    Text1 = ['The actuated revolute angle for joint 1 is: ', num2str(theta11), ' or ', num2str(theta12), '.' ];
    disp(Text1);
    disp(newline);
    
    theta21 = asin((B2(2,1)-A2(2))/L1);
    theta21 = theta21 / pi() * 180;
    theta22 = asin((B2(2,2)-A2(2))/L1);
    theta22 = theta22 / pi() * 180;

    Text2 = ['The actuated revolute angle for joint 2 is: ', num2str(theta21), ' or ', num2str(theta22), '.' ];
    disp(Text2);
    disp(newline);
    
    theta31 = asin((B3(2,1)-A3(2))/L1);
    theta31 = theta31 / pi() * 180;
    theta32 = asin((B3(2,2)-A3(2))/L1);
    theta32 = theta32 / pi() * 180;

    Text3 = ['The actuated revolute angle for joint 3 is: ', num2str(theta31), ' or ', num2str(theta32), '.' ];
    disp(Text3);
    disp(newline);
    
    theta41 = asin((B4(2,1)-A4(2))/L1);
    theta41 = theta41 / pi() * 180;
    theta42 = asin((B4(2,2)-A4(2))/L1);
    theta42 = theta42 / pi() * 180;
    
    Text4 = ['The actuated revolute angle for joint 4 is: ', num2str(theta41), ' or ', num2str(theta42), '.' ];
    disp(Text4);
else

   B=[];
    
end




% %% A DIFFERENT APPROACH FOR THE INVERSE GEOMETRIC MODEL
% %WORKING PURELY GEOMETRICALLY WITH THE TRIANGLE TO GET THETA DIRECTLY
% %
% 
% %% Intersection sphere and circle
% %The sphere has been transformed to a another circle with the corresponding
% %radius, which is given by:
% n = sqrt(l2^2-Zp^2);
% if Zp > l2 || Zp < 0
%     boSolution  = false;
%     disp('Not possible to reach this point.');
% end
% 
% distA1C1 = norm(C1-A1);
% alpha1 = acos ((l1^2+(distA1C1)^2-n^2)/(2*l1*distA1C1));
% 
% distA2C2 = sqrt((C2(1)-A2(1))^2+(C2(2)-A2(2))^2+(C2(3)-A2(3))^2);
% alpha2 = acos ((l1^2+(distA2C2)^2-n^2)/(2*l1*distA2C2));
% 
% distA3C3 = sqrt((C3(1)-A3(1))^2+(C3(2)-A3(2))^2+(C3(3)-A3(3))^2);
% alpha3 = acos ((l1^2+(distA3C3)^2-n^2)/(2*l1*distA3C3));
% 
% 
% distA4C4 = sqrt((C4(1)-A4(1))^2+(C4(2)-A4(2))^2+(C4(3)-A4(3))^2);
% alpha4 = acosd ((l1^2+(distA4C4)^2-n^2)/(2*l1*distA4C4));
% 
% 
% if distA1C1 > l1+l2 || distA2C2 > l1+l2 || distA3C3 > l1+l2 || distA4C4 > l1+l2
%     boSolution  = false;
%     disp('Not possible to reach this point.');
% end
% %% Computing theta1, theta2, theta3 and theta4
% 
% gamma1 = atand((C1(2)-A1(2))/(C1(1)-A1(1)));
% theta1 = alpha1 + gamma1;
% B1 = [A1(1)+l1*cosd(theta1); A1(2)+l1*sind(theta1); A1(3)];
% 
% gamma2 = atand((C2(2)-A2(2))/(C2(1)-A2(1)));
% theta2 = alpha2 + gamma2;
% B2 = [A2(1)+l1*cosd(theta2); A2(2)+l1*sind(theta2); A2(3)];
% 
% 
% gamma3 =  atand((C3(2)-A3(2))/(C3(1)-A3(1)));
% theta3 = alpha3 + gamma3;
% B3 = [A3(1)-l1*cosd(theta3); A3(2)-l1*sind(theta3); A3(3)];
% 
% gamma4 =  atand((C4(2)-A4(2))/(C4(1)-A4(1)));
% theta4 = alpha4 + gamma4;
% B4 = [A4(1)-l1*cosd(theta4); A4(2)-l1*sind(theta4); A4(3)];
% 
%     if boSolution == true 
%         disp('The actuated revolute angle for joint 1 is: ');
%         disp(theta1);
%        
%         disp('The actuated revolute angle for joint 2 is: ');
%         disp(theta2);
%         
%         disp('The actuated revolute angle for joint 3 is: ');
%         disp(theta3); 
%         
%         disp('The actuated revolute angle for joint 4 is: ');
%         disp(theta4); 
% 
%     end
% end
% 
% end
