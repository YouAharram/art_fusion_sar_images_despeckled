function noisy(inputFolder, outputFolder, L)
% Applica rumore speckle a tutte le immagini PNG in inputFolder
% e salva il risultato in scala di grigi in outputFolder.
%
% inputFolder: percorso della cartella contenente le immagini originali
% outputFolder: percorso della cartella dove salvare le immagini modificate
% L: parametro della distribuzione Gamma per il rumore speckle

    if ~isfolder(outputFolder)
        mkdir(outputFolder); % crea la cartella di output se non esiste
    end

    imageFiles = dir(fullfile(inputFolder, '*.png')); % modifica estensione se necessario
    for k = 1:length(imageFiles)
        filename = imageFiles(k).name;
        filepath = fullfile(inputFolder, filename);

        % Leggi immagine e converti in scala di grigi se necessario
        img = imread(filepath);
        if ndims(img) == 3
            img = rgb2gray(img); % converti in scala di grigi
        end
        
        imOriginal = im2double(img); % converti in double precision
        [m, n] = size(imOriginal);  % ora questa size è corretta
        imIntensity = imOriginal.^2;
        
        % Genera rumore speckle con distribuzione Gamma
        U = gamrnd(L, 1/L, [m, n]); 
        imSpeckle = imIntensity .* U;
        imSpeckle = sqrt(imSpeckle) * sqrt(4/pi);
        % Normalizza e salva immagine
        outputPath = fullfile(outputFolder, filename);
        imwrite(imSpeckle, outputPath);
        k
    end
end
