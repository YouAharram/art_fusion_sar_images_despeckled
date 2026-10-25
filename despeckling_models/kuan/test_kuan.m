% 1. Carica l'immagine (assicurati che sia l'immagine di intensità, non di ampiezza)
%load '../../Immagini/cascine_1L.mat'
%X = cascine_1L;
load '../../Immagini/airport.mat'
X = airport.^2;

% 2. Definisci i parametri
winSize = 7;  % Finestra 5x5
ENL = 4;          % Numero di look

% 3. Applica il filtro
Xf = kuanFilterSAR(X, winSize, ENL);

% 4. Visualizza i risultati
figure, imshow(sqrt(X)/255), title('Immagine SAR Originale');
figure, imshow(sqrt(Xf)/255), title('Filtrata con filtro di Kuan');

