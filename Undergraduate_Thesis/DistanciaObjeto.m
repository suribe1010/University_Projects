%% CÁLCULO DE LA DISTANCIA DEL OBJETO A LAS CÁMARAS
%Habrá que implementar la ecuación Z=f*b/d donde
%f=distancia focal. 
%b=distancia entre cámaras
%d=disparidad. diferencia de las coordenadas en ambas imágenes 

f=1224; %pixel
b= 24.6; %cm

load( 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorX_Vuelta/CoorX_L_Vuelta.mat');
load( 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorX_Vuelta/CoorX_R_Vuelta.mat');

[i,final]=size (CoorX_R);

for i=1:1:final %% for 1=1:final
  d(i)=abs(CoorX_L(1,i)-CoorX_R(1,i)); %pixels  %%
  
  %% Resta en valor absoluto

%% Pixels?
%an (x,y) location such as (3.2,5.3) is meaningful, and is distinct from pixel (5,3).
%The intrinsic coordinates (x,y) of the center point of any pixel are identical to the column and row indices for that pixel. 
%For example, the center point of the pixel in row 5, column 3 has spatial coordinates x = 3.0, y = 5.0. 
%This correspondence simplifies many toolbox functions considerably. 
%Be aware, however, that the order of coordinate specification (3.0,5.0) is reversed in intrinsic coordinates relative to pixel indices (5,3).
%http://es.mathworks.com/help/images/image-coordinate-systems.html
%http://es.mathworks.com/help/images/get-pixel-information-in-image-viewer-app.html;jsessionid=69854c1e0d62cb0a6c587cd1cb0e
%https://es.mathworks.com/matlabcentral/fileexchange/66901-convert-white-pixels-in-a-binary-image-to-coordinates
% 0.01634 cm ---- 1 pixel  
%d=d*0.01634;

if d==0  % realmente seria si CoorX_R==0 & CoorX_L==0
   Z(i)=0;
   continue
end

Z(i)=f*b/d(i); %%en cm

end
cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/DistanciaZ'
    nombre=['DistanciaZ.mat'];
    save(nombre,'Z');