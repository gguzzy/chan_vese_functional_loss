function [noisyImage] = addGaussianNoise(image, mean, variance)
    noisyImage = imnoise(image,'gaussian',mean,variance);
    % Aggiunge rumore gaussiano a un'immagine
    % image: Immagine originale
    % mean: Media del rumore gaussiano
    % variance: Varianza del rumore gaussiano
end
