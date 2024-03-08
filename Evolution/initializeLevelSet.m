function phi = initializeLevelSet(imageSize, shape, params)
% Inizializza la funzione di insieme di livello per forme circolari o ellittiche
% imageSize: dimensione dell'immagine [altezza, larghezza]
% shape: 'circle' per circolare o 'ellipse' per ellittica
% params: struttura contenente i parametri (centro, raggio, semi-assi)
    switch shape
        case 'circle'
            [x, y] = meshgrid(1:imageSize(2), 1:imageSize(1));
            phi = sqrt((x - params.centerX).^2 + (y - params.centerY).^2) - params.radius;
        case 'ellipse'
            [x, y] = meshgrid(1:imageSize(2), 1:imageSize(1));
            phi = ((x - params.centerX).^2 / params.a^2) + ((y - params.centerY).^2 / params.b^2) - 1;
        otherwise
            error('Forma non riconosciuta.');
    end
end


