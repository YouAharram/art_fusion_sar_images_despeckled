function [J, W, mu, sigma2] = kuanFilterSAR(I, winSize, ENL)
%KUANFILTERSAR  Despeckling SAR con filtro di Kuan, stima LMMSE.
%
%   J = kuanFilterSAR(I, winSize, ENL)
%   [J, W, mu, sigma2] = kuanFilterSAR(I, winSize, ENL)
%
%   Input:
%       I        - Immagine SAR in intensità lineare, non in dB.
%       winSize  - Dimensione finestra locale, es. 3, 5, 7 oppure [7 7].
%                  Deve essere dispari.
%       ENL      - Equivalent Number of Looks. Per rumore speckle:
%                  varianza rumore moltiplicativo = 1 / ENL.
%
%   Output:
%       J        - Immagine filtrata, in double.
%       W        - Peso LMMSE locale del filtro di Kuan.
%       mu       - Media locale.
%       sigma2   - Varianza locale osservata.
%
%   Modello:
%       I = X * N
%       E[N] = 1
%       Var[N] = 1 / ENL
%
%   Stima LMMSE:
%       J = mu + W * (I - mu)
%
%   con:
%       W = (sigma2 - sigma_n2 * mu^2) / ((1 + sigma_n2) * sigma2)
%
%   dove:
%       sigma_n2 = 1 / ENL
%
%   Il peso W viene limitato all'intervallo [0, 1].
%
%   Nota:
%       Se l'immagine è in dB, convertirla prima in scala lineare:
%           Ilin = 10.^(IdB / 10);
%           Jlin = kuanFilterSAR(Ilin, 7, ENL);
%           JdB  = 10 * log10(max(Jlin, realmin));

    if nargin < 2 || isempty(winSize)
        winSize = 7;
    end

    if nargin < 3 || isempty(ENL)
        ENL = 1;
    end

    if isscalar(winSize)
        winSize = [winSize winSize];
    end

    if numel(winSize) ~= 2
        error('winSize deve essere uno scalare oppure un vettore [righe colonne].');
    end

    if any(winSize < 1) || any(mod(winSize, 2) == 0)
        error('winSize deve contenere valori positivi e dispari, ad esempio 3, 5, 7 o [7 7].');
    end

    if ENL <= 0
        error('ENL deve essere positivo.');
    end

    I = double(I);

    % Gestione di NaN e Inf: vengono ignorati nelle statistiche locali.
    validMask = isfinite(I);
    Iwork = I;
    Iwork(~validMask) = 0;

    kernel = ones(winSize);

    % Padding replicato implementato senza toolbox esterni.
    padR = (winSize(1) - 1) / 2;
    padC = (winSize(2) - 1) / 2;

    Ipad  = replicatePad2D(Iwork, padR, padC);
    Mpad  = replicatePad2D(double(validMask), padR, padC);

    localSum   = conv2(Ipad, kernel, 'valid');
    localCount = conv2(Mpad, kernel, 'valid');

    mu = localSum ./ max(localCount, 1);

    I2pad = replicatePad2D(Iwork.^2, padR, padC);
    localSum2 = conv2(I2pad, kernel, 'valid');

    sigma2 = localSum2 ./ max(localCount, 1) - mu.^2;
    sigma2 = max(sigma2, 0);

    % Varianza del rumore moltiplicativo speckle.
    sigma_n2 = 1 / ENL;

    % Peso LMMSE del filtro di Kuan.
    W = (sigma2 - sigma_n2 .* mu.^2) ./ ((1 + sigma_n2) .* sigma2);

    % Stabilizzazione numerica.
    W(~isfinite(W)) = 0;
    W = min(max(W, 0), 1);

    % Stima filtrata.
    J = mu + W .* (I - mu);

    % Ripristina NaN dove l'immagine originale non era valida.
    J(~validMask) = NaN;
    W(~validMask) = NaN;
    mu(~validMask) = NaN;
    sigma2(~validMask) = NaN;
end


function Apad = replicatePad2D(A, padR, padC)
%REPLICATEPAD2D  Padding replicato per matrici 2D, senza Image Processing Toolbox.

    [nr, nc] = size(A);

    rIdx = [ones(1, padR), 1:nr, nr * ones(1, padR)];
    cIdx = [ones(1, padC), 1:nc, nc * ones(1, padC)];

    Apad = A(rIdx, cIdx);
end
