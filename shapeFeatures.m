function shapeFeat= shapeFeatures(img)
% Basée sur les 7 momens de Hu
% Télécharger le code invmoments de
% https://ba-network.blogspot.com/2017/06/hus-seven-moments-invariant-matlabcode.html
shapeFeat = invmoments(rgb2gray(img)); % 7 moments invariants de Hu=_'
shapeFeat=shapeFeat/mean(shapeFeat);
end