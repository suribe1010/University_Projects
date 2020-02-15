%% DETECCIÓN DEL OBJETO Y OBTENCIÓN DEL CENTROIDE


inicio=150;
final=309;
index=final-inicio;

elem=zeros(1,index);
%props(100,index) = struct( 'Area', [], 'Centroide', [], 'BoundingBox',[]);
CoorX_R=zeros(1,index);
CoorY_R=zeros(1,index);

CoorX_L=zeros(1,index);
CoorY_L=zeros(1,index);

%contador = 1;
for ii=inicio:final
   
   %Insertamos la imagen en BW!!!!
   %Left images
   A=imread(fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR002_L/GOPR002_L_Vuelta/Frames BW/GOPR002_L_BW_%d.jpg',ii)));
  
   
   %Area=bwarea(A);
   %figure;
   %imshow(A);
   iii=ii-(inicio-1); %número de frame
  
   %A = wiener2(A,[5 5]); %quita el ruido. Tambíen me elimina los pixeles
   %A = filter2(fspecial('average',3),A)/255; %filtro creado. Me elimina los elementos que no me son de interés.
      
   [Object num]=bwlabeln(A,8); %me detecta 38 elementos cuando solo tiene que detectar 1. Cuando entramos en area, todos los elementos tienen un area entre 1-10. 
                                %Pero otro elemento tiene otro area mucho
                                %mas grande: nuestro objeto de interés.
   
   if num==0
    
       
       CoorX_L(1,iii)=0;
       CoorY_L(1,iii)=0;
        continue %sale del ciclo y pasa al siguiente iii
   end
   
   %% Me pone los 0 (no movimiento) al final de la matriz CoorX.
   % Problema: el movimiento empieza en distintos frames en las imágenes de la derecha (frame 10) e izquierda(frame 12). Por tanto, utilizando
   % este metodo voy a tener la primera coordenada relacionada del frame 10 y 12, algo incorrecto.
     %if num==0
      %   contador=contador+1; %contador de frames sin movimiento
       % continue %sale del ciclo y pasa al siguiente iii
    % end
   %%
   data=regionprops(Object);
   idx = find([data.Area] > 200); %posición del elemento con área mayor a 1000. 
                                   %Siempre vamos a tener un único elemento x1=1
                                    
   [x1 x2]= size(idx); %tenemos un único elemento
   elem(1,iii)=x1; 
   
   props(1,iii).Centroide = data(idx,1).Centroid; %coordenadas X del centroide
  % props(1,iii).Centroide = data(idx,2).Centroid; %coordenadas Y del centroide
   
   %% Me pone los 0 (no movimiento) al final de la matriz CoorX.
   %CoorX(1,iii-contador+1)=props(1,iii).Centroide(1,1);
   %la primera foto que detecta con movimiento, pone la coorX en el primer elemento 
  
   %%
 
   CoorX_L(1,iii)=props(1,iii).Centroide(1,1);
   CoorY_L(1,iii)=props(1,iii).Centroide(1,2);
end

for ii=inicio:final
   
   %Insertamos la imagen en BW!!!!
   
   %Right images
   A=imread(fullfile(sprintf('C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/GOPR003_R/GOPR003_R_Vuelta/Frames BW/GOPR003_R_BW_%d.jpg',ii)));
   
   %Area=bwarea(A);
   %figure;
   %imshow(A);
   iii=ii-(inicio-1); %número de frame
  
   %A = wiener2(A,[5 5]); %quita el ruido. Tambíen me elimina los pixeles
   %A = filter2(fspecial('average',3),A)/255; %filtro creado. Me elimina los elementos que no me son de interés.
      
   [Object num]=bwlabeln(A,8); %me detecta 38 elementos cuando solo tiene que detectar 1. Cuando entramos en area, todos los elementos tienen un area entre 1-20. Pero otro elemento tiene otro area. entre
   
   if num==0
       CoorX_R(1,iii)=0;
       CoorY_R(1,iii)=0;     
       continue %sale del ciclo y pasa al siguiente iii
   end
   
   %% Me pone los 0 (no movimiento) al final de la matriz CoorX.
   % Problema: el movimiento empieza en distintos frames en las imágenes de la derecha (frame 10) e izquierda(frame 12). Por tanto, utilizando
   % este metodo voy a tener la primera coordenada relacionada del frame 10 y 12, algo incorrecto.
     %if num==0
      %   contador=contador+1; %contador de frames sin movimiento
       % continue %sale del ciclo y pasa al siguiente iii
    % end
   %%
   data=regionprops(Object);
   idx = find([data.Area] > 1000); %posición del elemento con área mayor a 1000. 
                                   %Siempre vamos a tener un único elemento x1=1
                                    
   [x1 x2]= size(idx); %tenemos un único elemento en el caso del balón
   elem(1,iii)=x1; 
   
   props(1,iii).Centroide = data(idx,1).Centroid; %coordenadas X del centroide
  % props(1,iii).Centroide = data(idx,2).Centroid; %coordenadas Y del centroide
   
   %% Me pone los 0 (no movimiento) al final de la matriz CoorX.
   %CoorX(1,iii-contador+1)=props(1,iii).Centroide(1,1);
   %la primera foto que detecta con movimiento, pone la coorX en el primer elemento 
  
   %%
   CoorX_R(1,iii)=props(1,iii).Centroide(1,1);
   CoorY_R(1,iii)=props(1,iii).Centroide(1,2);
  
   end
   
cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorX_Vuelta'
  nombre=['CoorX_L_Vuelta.mat'];
   save(nombre,'CoorX_L');
cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorX_Vuelta'
 nombre=['CoorX_R_Vuelta.mat'];
  save(nombre,'CoorX_R');

 cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorY_Vuelta'
  nombre=['CoorY_L_Vuelta.mat'];
    save(nombre,'CoorY_L');
 cd 'C:/Users/sergi/Desktop/SERGIO URIBE/TFG/Scripts MATLAB/Script TFG coordenadas del objeto/Inteto 6 Rectificado/Scripts TFG/CoorY_Vuelta'
  nombre=['CoorY_R_Vuelta.mat'];
    save(nombre,'CoorY_R');