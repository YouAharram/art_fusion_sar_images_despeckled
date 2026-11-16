function other_format_to_mat(input_dir, output_dir)

% Creazione cartella di output se non esiste
if ~isfolder(output_dir)
    mkdir(output_dir);
end

% Ricerca immagini
files_png  = dir(fullfile(input_dir, '*.png'));
files_tif  = dir(fullfile(input_dir, '*.tif'));
files_tiff = dir(fullfile(input_dir, '*.tiff'));

files = [files_png; files_tif; files_tiff];

for k = 1:length(files)

    img_name = files(k).name
    
    % Lettura immagine
    img = imread(fullfile(input_dir, img_name));

    % Generazione nome file MAT
    [~, name, ~] = fileparts(img_name);

    img_output_dir = fullfile(output_dir, [name '.mat']);

    % Salvataggio
    save(img_output_dir, 'img');
    fprintf('Convertita immagine %d/%d: %s\n', ...
        k, length(files), img_name);

end

end

