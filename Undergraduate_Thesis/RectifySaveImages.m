close all

%% METER LAS IMÁGENES Y RECTIFICARLAS
% Necesito las imágenes de la cámara izquierda y derecha en el mismo
% instante.

load ( 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Calibración/stereoParams.mat');

inicio = 1;
final = 1;

for i=inicio:final
    %Ordenador ormazabal
    %I1=imread (fullfile(sprintf('E:/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Intento 2/GOPR002_Left/GOPR002_L_Balón/Frames/GOPR002_L_%d.jpg',i)));
    %I2=imread (fullfile(sprintf('E:/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Intento 2/GOPR003_Right/GOPR003_R_Balón/Frames/GOPR003_R_%d.jpg',i)));
   
    %Portátil
    I1=imread (fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR002_L/GOPR002_L_Vuelta/Frames/GOPR002_L_%d.jpg',i)));
    I2=imread (fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR003_R/GOPR003_R_Vuelta/Frames/GOPR003_R_%d.jpg',i)));
    [J1,J2]= rectifyStereoImages (I1,I2,stereoParams); %rectificamos las imágenes
    
    %% GUARDAR LAS IMÁGENES RECTIFICADAS
    
    %Cambiamos el directorio para la GOPR002 Left
    cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR002_L/GOPR002_L_Vuelta/Frames Rect' %cd tiene problemas con los espacios, por eso va entre comillas'
    nombre=['GOPR002_L_Rect_',num2str(i),'.jpg'];
    imwrite(J1,nombre,'jpeg');
    
    %Cambiamos el directorio para la GOPR003 Right
    cd 'C:/Users/sergi/Desktop/SERGIO URIBE\TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR003_R/GOPR003_R_Vuelta/Frames Rect' %cd tiene problemas con los espacios, por eso va entre comillas'
    nombre=['GOPR003_R_Rect_',num2str(i),'.jpg'];
    imwrite(J2,nombre,'jpeg');
    
    %Otra forma de guardar las imágenes    
    %imwrite(J1, fullfile(sprintf('E:/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Intento 1/GOPR002_left/Persiana abierta/Frames Rectificados Video/GOPR002_Left_Rect_%d.jpg',i)),'jpeg');
    
    
end