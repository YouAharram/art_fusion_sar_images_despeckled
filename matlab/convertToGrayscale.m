function convertToGrayscale(inputFolder, outputFolder)
% Converte tutte le immagini in scala di grigi e le salva nella cartella di oCoutput
%
% inputFolder: percorso della cartella con le immagini originali
% outputFolder: percorso della cartella dove salvare le immagini convertite

    if ~isfolder(outputFolder)
        mkdir(outputFolder); % crea la cartella di output se non esiste
    end

    % Supporta diverse estensioni di immagini
    extensions = {'*.png', '*.jpg', '*.jpeg', '*.bmp', '*.tif', '*.tiff'};
    imageFiles = [];

    for i = 1:length(extensions)
        imageFiles = [imageFiles; dir(fullfile(inputFolder, extensions{i}))];
    end

    for k = 1:length(imageFiles)
        filename = imageFiles(k).name;
        filepath = fullfile(inputFolder, filename);

        % Legge l'immagine
        img = imread(filepath);

        % Converte in scala di grigi se necessario
        if ndims(img) == 3
            imgGray = rgb2gray(img);
        else
            imgGray = img;
        end

        % Salva l'immagine in outputFolder
        outputPath = fullfile(outputFolder, filename);
        imwrite(imgGray, outputPath);
        k
    end
end
