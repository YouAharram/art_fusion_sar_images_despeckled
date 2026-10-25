function J = Gamma_MAP(I, win_size, L)
    % GAMMA_MAP_FILTER Applica il filtro Gamma-MAP per il despeckling SAR
    %
    % Input:
    %   I        - Immagine SAR in input (formato intensità)
    %   win_size - Dimensione della finestra mobile (es. 3, 5, 7)
    %   L        - Numero Equivalente di Look (ENL)
    %
    % Output:
    %   J        - Immagine SAR filtrata

    % Assicuriamoci che l'immagine sia in formato double per la precisione
    I = double(I);
    
    % Calcolo dei coefficienti di rumore
    % Cu: Coefficiente di variazione del rumore speckle
    Cu = 1 / sqrt(L);
    Cu2 = Cu^2;
    
    % Cmax: Soglia massima (solitamente sqrt(2) * Cu)
    Cmax = sqrt(2) * Cu;
    
    % Creazione del kernel per la media locale
    h = ones(win_size, win_size) / (win_size^2);
    
    % Calcolo della media locale e della varianza locale
    % Usiamo 'symmetric' per gestire i bordi dell'immagine
    local_mean = imfilter(I, h, 'symmetric');
    local_mean_sq = imfilter(I.^2, h, 'symmetric');
    local_var = local_mean_sq - local_mean.^2;
    
    % Evita problemi di divisione per zero nelle zone nere
    local_mean(local_mean == 0) = eps;
    
    % Calcolo del coefficiente di variazione locale (Ci)
    Ci = sqrt(max(local_var, 0)) ./ local_mean;
    Ci2 = Ci.^2;
    
    % Inizializzazione dell'immagine filtrata
    J = zeros(size(I));
    
    % --- Creazione delle maschere per le 3 zone spaziali ---
    % 1. Regione Omogenea (Ci <= Cu)
    mask_homo = (Ci <= Cu);
    
    % 2. Target puntiforme / Scatterer forti (Ci >= Cmax)
    mask_point = (Ci >= Cmax);
    
    % 3. Regione testurizzata (Cu < Ci < Cmax)
    mask_texture = (Ci > Cu) & (Ci < Cmax);
    
    % --- Applicazione dei filtri in base alla regione ---
    
    % 1. Zona Omogenea: restituisce la media locale (Filtro Mean)
    J(mask_homo) = local_mean(mask_homo);
    
    % 2. Target puntiforme: mantiene l'informazione originale
    J(mask_point) = I(mask_point);
    
    % 3. Zona Testurizzata: Applicazione della formula Gamma-MAP
    % Estraiamo i valori solo per la maschera interessata
    mu = local_mean(mask_texture);
    pixel_val = I(mask_texture);
    ci2_val = Ci2(mask_texture);
    
    % Parametro alpha della distribuzione a priori (Gamma)
    alpha = (1 + Cu2) ./ (ci2_val - Cu2);
    
    % Risoluzione dell'equazione quadratica del MAP (Lopes et al. 1990)
    term1 = (alpha - L - 1) .* mu;
    term2 = sqrt(term1.^2 + 4 .* alpha .* L .* pixel_val .* mu);
    
    % Calcolo del pixel stimato
    J(mask_texture) = (term1 + term2) ./ (2 .* alpha);
    
    % Se necessario, puoi riconvertire l'immagine nel formato originale (es. uint8, uint16)
    % a seconda del tipo di dato che stai trattando.
end
