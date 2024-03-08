function [noisyImage] = addSaltAndPepperNoise(image, density)
% Aggiunge rumore salt-and-pepper a un'immagine
% image: Immagine originale
% density: Densità del rumore

noisyImage = imnoise(image,'salt & pepper',density);
end
