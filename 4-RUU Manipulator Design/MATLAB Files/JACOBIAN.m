%% JACOBIAN MATRIX AND INVERSE CONDITION NUMBER
% Computes the jacobian matrix and the inverse condition number.

function [J1, J2, invKappa1, invKappa2] = JACOBIAN(P, phi, R, r, B);
Xp = P(1);
Yp = P(2);
Zp = P(3);
B1 = [B(:,1) B(:,2)];
B2 = [B(:,3) B(:,4)];
B3 = [B(:,5) B(:,6)];
B4 = [B(:,7) B(:,8)];
%% 4 points C
phi = phi * pi() / 180; %Input phi to radians
C1 = [Xp - r*cos(phi); Yp - r*sin(phi); Zp];
C2 = [Xp + r*sin(phi); Yp - r*cos(phi); Zp];
C3 = [Xp + r*cos(phi); Yp + r*sin(phi); Zp];
C4 = [Xp - r*sin(phi); Yp + r*cos(phi); Zp];

%% 4 points A
A1 = [-R*cosd(45); -R*sind(45); 0];
A2 = [R*cosd(45); -R*sind(45); 0];
A3 = [R*cosd(45); R*sind(45); 0];
A4 = [-R*cosd(45); R*sind(45); 0];


%% From points Ci to P
rC1 = P-C1;
rC2 = P-C2;
rC3 = P-C3;
rC4 = P-C4;

%% Unitary vectors from points Bi to Ci. Direction: fi. 
% For each Bi we have two possible points, so 2 possible directions for
% each fi

f11 = [C1(1)-B1(1,1) ; C1(2)-B1(2,1) ; C1(3)-B1(3,1)];
f11 = f11 ./ norm(f11);
f12 = [C1(1)-B1(1,2) ; C1(2)-B1(2,2) ; C1(3)-B1(3,2)];
f12 = f12 ./ norm(f12);

f21 = [C2(1)-B2(1,1) ; C2(2)-B2(2,1) ; C2(3)-B2(3,1)];
f21 = f21 ./ norm(f21);
f22 = [C2(1)-B2(1,2) ; C2(2)-B2(2,2) ; C2(3)-B2(3,2)];
f22 = f22 ./ norm(f22);

f31 = [C3(1)-B3(1,1) ; C3(2)-B3(2,1) ; C3(3)-B3(3,1)];
f31 = f31 ./ norm(f31);
f32 = [C3(1)-B3(1,2) ; C3(2)-B3(2,2) ; C3(3)-B3(3,2)];
f32 = f32 ./ norm(f32);

f41 = [C4(1)-B4(1,1) ; C4(2)-B4(2,1) ; C4(3)-B4(3,1)];
f41 = f41 ./ norm(f41);
f42 = [C4(1)-B4(1,2) ; C4(2)-B4(2,2) ; C4(3)-B4(3,2)];
f42 = f42 ./ norm(f42);


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
% TWO POSSIBLE SOLUTIONS AS WE HAVE 2 POSSIBLE POINTS FOR Bi
% Matrix A taking direction f for the first points
AJac1 = [cross(rC1,f11)' f11'; 
     cross(rC2,f21)' f21'; 
     cross(rC3,f31)' f31'; 
     cross(rC4,f41)' f41'; 
     i' Zeros';
     j' Zeros'];
 
% Matrix A taking direction f for the seconds points
AJac2 = [cross(rC1,f12)' f12'; 
     cross(rC2,f22)' f22'; 
     cross(rC3,f32)' f32'; 
     cross(rC4,f42)' f42'; 
     i' Zeros';
     j' Zeros'];

% There are more possible combinations, but the moment we check this ones.
 %% Inverse Jacobian Matrix

 BJac1 = [dot(cross(A1C1,f11)',k), 0, 0, 0;
     0, dot(cross(A2C2,f21)',k), 0, 0;
     0, 0, dot(cross(A3C3,f31)',k), 0;
     0, 0, 0, dot(cross(A4C4,f41)',k);
     0, 0, 0, 0;
     0, 0, 0, 0];
 BJac2 = [dot(cross(A1C1,f12)',k), 0, 0, 0;
     0, dot(cross(A2C2,f22)',k), 0, 0;
     0, 0, dot(cross(A3C3,f32)',k), 0;
     0, 0, 0, dot(cross(A4C4,f42)',k);
     0, 0, 0, 0;
     0, 0, 0, 0];
 
if det(AJac1) == 0 || det(BJac1'*BJac1)==0
   Kappa1 = 10^6;
else    
   J1 = inv(AJac1)*BJac1;
   if any(isnan(J1(:)))
      Kappa1 = 10^6; 
   else
   Kappa1 = cond(J1);
   end
end
if det(AJac2) == 0 || det(BJac2'*BJac1)==0
   Kappa2 = 10^6;
else    
   J2 = inv(AJac2)*BJac2;
   if any(isnan(J2(:)))
      Kappa2 = 10^6; 
   else
      Kappa2 = cond(J2);
   end
end
   invKappa1 = 1/Kappa1;
   invKappa2 = 1/Kappa2;
   
 
%% Condition Number
   
    disp(newline);
    Text = ['The value of Kappa for the considered 2 combinations is: ', num2str(Kappa1), ' and ', num2str(Kappa2), '.' ];
    disp(Text);
    Text1 = ['The inverse of Kappa for the considered 2 combinations is: ', num2str(invKappa1), ' and ', num2str(invKappa2), '.' ];

    disp(Text1);
    disp(newline);

 
end
 
