function hsvColor_Histogram = hsvHistogramFeatures(img)
% img: image à quantifier dans un espace couleur hsv en 8x2x2 cases identiques
% sortie: vecteur 1x32 indiquant les entités extraites de l'histogramme dans l'espace hsv
% L'Histogramme dans l'espace de couleur HSV est obtenu utilisant une
% quantification par niveau:
% 8 pour H(hue), 2 pour S(saturation), et 2 pour V(Value).
% Le vecteur descripteur de taille 1x32 est calculé et normalisé
[rows, cols, ~] = size(img);
% convertir l'image RGB en HSV.
img = rgb2hsv(img);
% Extraire les 3 composantes (espaces) h, s v
h = img(:, :, 1);
s = img(:, :, 2);
v = img(:, :, 3);
% Chaque composante h,s,v sera quantifiée équitablement en 8x2x2
% le nombre de niveau de quantification est: 
numberOfLevelsForH = 8; % 8 niveau pour h
numberOfLevelsForS = 2; % 2 niveau pour s
numberOfLevelsForV = 2; % 2 niveau pour v
% Il est possible de faire la quantification par seuillage. Les seuils sont
% extraits pour chaque composante comme suit:
% X seuils ==> X+1 niveaux
% thresholdForH = multithresh(h, numberOfLevelsForH-1);
% thresholdForS = multithresh(s, numberOfLevelsForS -1);
% thresholdForV = multithresh(v, numberOfLevelsForV -1);

% Quantification
% seg_h = imquantize(h, thresholdForH); % appliquer les seuils pour obtenir une image segmentée...
% seg_s = imquantize(s, thresholdForS); % appliquer les seuils pour obtenir une image segmentée...
% seg_v = imquantize(v, thresholdForV); % appliquer les seuils pour obtenir une image segmentée...

% Trouver le maximum.
maxValueForH = max(h(:));
maxValueForS = max(s(:));
maxValueForV = max(v(:));

% Initialiser l'histogramme à des zéro de dimension 8x2x2
hsvColor_Histogram = zeros(8, 2, 2);
% Quantification de chaque composante en nombre niveaux étlablis
quantizedValueForH=ceil((numberOfLevelsForH .* h)./maxValueForH);
quantizedValueForS= ceil((numberOfLevelsForS .* s)./maxValueForS);
quantizedValueForV= ceil((numberOfLevelsForV .* v)./maxValueForV);

% Créer un vecteur d'indexes
index = zeros(rows*cols, 3);
index(:, 1) = reshape(quantizedValueForH',1,[]);
index(:, 2) = reshape(quantizedValueForS',1,[]);
index(:, 3) = reshape(quantizedValueForV',1,[]);
% Remplir l'histogramme pour chaque composante h,s,v
% (ex. si h=7,s=2,v=1 Alors incrémenter de 1 la matrice d'histogramme à la position 7,2,1)
for row = 1:size(index, 1)
 if (index(row, 1) == 0 || index(row, 2) == 0 || index(row, 3) == 0)
 continue;
 end
 hsvColor_Histogram(index(row, 1), index(row, 2), index(row, 3)) = ...
 hsvColor_Histogram(index(row, 1), index(row, 2), index(row, 3)) + 1;
end
% normaliser l'histogramme à la somme
hsvColor_Histogram = hsvColor_Histogram(:)';
hsvColor_Histogram = hsvColor_Histogram/sum(hsvColor_Histogram);
end