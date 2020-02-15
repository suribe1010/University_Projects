%% CARACTERIZACIÓN DE LAS IMÁGENES RECTIFICADAS 

for i=150:309
   %de 150  a 309
       
    % Empezamos por las imágenes rectificadas de la GOPR002_Left
   
     I1=imread (fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR002_L/GOPR002_L_Vuelta/Frames Rect/GOPR002_L_Rect_%d.jpg',i))); % SI PONGO i+10 ME SALEN DOS AREAS PORQUE AL FINAL ESTAS RESTANDO DOS FRAMES EN LA QUE LA DISTANCIA ES MUY GRANDE
    J1=imread (fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR002_L/GOPR002_L_Vuelta/Frames Rect/GOPR002_L_Rect_%d.jpg',1)));
    %Flujo óptico
    H = I1-J1;
    H_gray = rgb2gray(H);
    H_gray=imadjust (H_gray,[0 1], [0 1], 0.9);
    H_bw = im2bw(H_gray,0.085); %rango de binarización
    %figure;
    %imshow(H);
    % Erosionar 
     H_bw = bwmorph(H_bw,'clean');
     H_bw = bwmorph(H_bw,'close');
     H_bw = bwareaopen(H_bw, 1000);
     H_bw = imfill(H_bw,'holes');
     
    % Agrandar las superficies y eliminar pequenos ruidos
    se1=strel('disk',350); %disco. 'poniendo sphere tarda muchisimo, probablemente porque hace algo en 3D. Pero no hay cambios
                                    % con 'rectangle' lo hace bastante bien.
                                    % con('disk',45) me quita los agujeros interiores       
                                    
    H2_bw = imclose(H_bw,se1); %junta los pequeños huecos
    %figure;
    %imshow(H2_bw)
    
    %% Guardamos las imágenes en BW
    cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR002_L/GOPR002_L_Vuelta/Frames BW ' %cd tiene problemas con los espacios, por eso va entre comillas'
    nombre=['GOPR002_L_BW_',num2str(i),'.jpg'];
    imwrite(H2_bw,nombre,'jpeg');
     
end

for i=150:309
    
    
  
   %Balón Frames Right
    I1=imread (fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR003_R/GOPR003_R_Vuelta/Frames Rect/GOPR003_R_Rect_%d.jpg',i)));
    J1=imread (fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR003_R/GOPR003_R_Vuelta/Frames Rect/GOPR003_R_Rect_%d.jpg',1)));
    
    H = I1-J1;
    H_gray = rgb2gray(H);
    H_gray=imadjust (H_gray,[0 1], [0 1], 0.9);
    H_bw = im2bw(H_gray,0.085);
    %figure;
    %imshow(H);
    %% Erosionar y dilatar
     H_bw = bwmorph(H_bw,'clean');
     H_bw = bwmorph(H_bw,'close');
     H_bw = bwareaopen(H_bw, 1000);
     H_bw=imfill(H_bw,'holes');
    %% Agrandar las superficies y eliminar pequenos ruidos
    se1=strel('disk',350); %disco. 'poniendo sphere tarda muchisimo, probablemente porque haga algo en 3D. Pero no hay cambios
                                    % con 'rectangle' lo hace bastante bien.
                                    % con('disk',45) me quita los agujeros interiores       
                                    
    H2_bw = imclose(H_bw,se1);
    %figure;
    %imshow(H2_bw)
    
    %% Guardamos las imágenes en BW
   
      cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR003_R/GOPR003_R_Vuelta/Frames BW'
    nombre=['GOPR003_R_BW_',num2str(i),'.jpg'];
    imwrite(H2_bw,nombre,'jpeg');
end