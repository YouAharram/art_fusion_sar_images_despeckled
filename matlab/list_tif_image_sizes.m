function list_tif_image_sizes(folder_path)
    % Verifica che la cartella esista
    if ~isfolder(folder_path)
        error('La cartella specificata non esiste: %s', folder_path);
    end

    % Ottieni la lista dei file .tif nella cartella
    files = dir(fullfile(folder_path, '*.tif'));

    % Verifica che ci siano immagini .tif
    if isempty(files)
        fprintf('Nessuna immagine .tif trovata in %s\n', folder_path);
        return;
    end

    % Itera sui file e stampa dimensioni
    fprintf('File\t\t\tAltezza\tLarghezza\tCanali\titerazioni\n');
    fprintf('-----------------------------------------------------\n');
    for i = 1:length(files)
        file_path = fullfile(folder_path, files(i).name);
        try
            img = imread(file_path);
            dims = size(img);
            if numel(dims) == 2
                % Immagine grayscale
                height = dims(1);
                width = dims(2);
                channels = 1;
            else
                % Immagine con più canali
                height = dims(1);
                width = dims(2);
                channels = dims(3);
            end
            if height ~= 256 || weight ~= 256
                fprintf('%s\t%d\t%d\t\t%d \t\t %d\n', files(i).name, height, width, channels,i);
            end
        catch ME
            %fprintf('Errore nella lettura di %s: %s\n', files(i).name, ME.message);
        end
    end
end
