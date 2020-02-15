%% RECONSTRUCCIÓN Y GENERACIÓN DE TRAYECTORIA

load( 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorX_Vuelta/CoorX_L_Vuelta.mat');
load( 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorX_Vuelta/CoorX_R_Vuelta.mat');
load('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/DistanciaZ/DistanciaZ.mat');
load('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Calibración/stereoParams.mat');
load('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorY_Vuelta/CoorY_L_Vuelta.mat');

%% ¿¿ Metodos númericos ---> sacamos el polinomio de newton y lo representamos en 3 coordenadas ?? 
% Me da que nada, ya que tengo 3 coordendas x, y, z.. el polinomio tendría
% que ser z(x,y)= ... lo cual no se si es posible con Newton

%% Punto central de la imagen (Xo)
Xo=stereoParams.CameraParameters1.PrincipalPoint(1); %% LEFT = CAMERA 1
Yo=stereoParams.CameraParameters1.PrincipalPoint(2);
%% Implementamos las fórmulas para sacar Xc e Yc
f=1224; %pixel
for i=1:1:160
    Xc(1,i)=Z(1,i)*abs((CoorX_L(1,i)-Xo))/f; %ojo unidades pixels cm
    Yc(1,i)=Z(1,i)*abs((CoorY_L(1,i)-Yo))/f;
end
%% Representamos la trayectoria
% axis properties para cambiar los ejes (poner en escala cm)
% copy figure para copiarla en la memoria
% menu plots, ctrl + seleccionar variables para que te salgan los graficos adecuados
plot3(Z,Xc,Yc)
xlabel 'Z';
ylabel 'X';
zlabel 'Y';
%https://es.mathworks.com/help/matlab/ref/linespec.html

%% NOTA: LA NUMERACIÓN DE LAS FOTOS CORRESPONDEN DE LA SIGUIENTE MANERA:
    %IMAGEN 1 -- IMAGEN 15 CARPETA