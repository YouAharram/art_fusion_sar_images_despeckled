function calculate_psnr_from_folders(folder1, folder2)
    % Controlla se le cartelle esistono
    if ~isfolder(folder1) || ~isfolder(folder2)
        error('Una o entrambe le cartelle non esistono.');
    end

    % Ottiene la lista dei file immagine nella prima cartella
    imageFiles1 = dir(fullfile(folder1, '*.*'));
    imageFiles1 = imageFiles1(~[imageFiles1.isdir]);  % rimuove cartelle

    % Inizializza variabili
    psnr_values = [];
    image_names = {};

    fprintf('Calcolo PSNR tra immagini corrispondenti:\n\n');
    
    for i = 1:length(imageFiles1)
        name = imageFiles1(i).name;

        % Costruisce i percorsi completi ai file
        file1 = fullfile(folder1, name);
        file2 = fullfile(folder2, name);

        % Verifica se l'immagine corrispondente esiste nella seconda cartella
        if exist(file2, 'file')
            img1 = imread(file1);
            img2 = imread(file2);

            % Controlla che le immagini siano della stessa dimensione
            if ~isequal(size(img1), size(img2))
                fprintf('❌ Immagini diverse in dimensioni: %s\n', name);
                continue;
            end

            % Converte in double
            img1 = double(img1) / 255.0;
            img2 = double(img2) / 255.0;

            % Calcola PSNR
            psnr_value = ssim(img1, img2);

            fprintf('✅ %s: PSNR = %.2f dB\n', name, psnr_value);

            % Salva valore e nome
            psnr_values(end+1) = psnr_value; %#ok<AGROW>
            image_names{end+1} = name; %#ok<AGROW>
        else
            fprintf('⚠️ Immagine mancante nella seconda cartella: %s\n', name);
        end
    end

    % Analizza risultati
    if ~isempty(psnr_values)
        [max_psnr, idx_max] = max(psnr_values);
        [min_psnr, idx_min] = min(psnr_values);
        avg_psnr = mean(psnr_values);

        fprintf('\n📊 Risultati finali:\n');
        fprintf('🔺 PSNR massimo: %.2f dB (%s)\n', max_psnr, image_names{idx_max});
        fprintf('🔻 PSNR minimo: %.2f dB (%s)\n', min_psnr, image_names{idx_min});
        fprintf('📈 PSNR medio : %.2f dB su %d immagini\n', avg_psnr, numel(psnr_values));
    else
        fprintf('\n❗ Nessuna immagine valida trovata per il confronto.\n');
    end
end
