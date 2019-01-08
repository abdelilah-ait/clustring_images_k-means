clc

 fold='2Classes';
 lst=dir(fold);
 nT=size(lst);

k0=1;




 %%%%%%%%% training == extraire les features %%%%%%%%%%
n=length(lst); 
features_img=zeros(50);
 for i=3:n
     IDB = imread(strcat(fold,'/',lst(i).name));
     features_img(k0,:)=getFeatures(IDB, 50);
     k0=k0+1;
 end
 
%  MAXIM=max(features_img');
%  MININ=min(features_img');
%  for p=1:n-2
%      features_img(p,:)=(features_img(p,:)-MININ(p))/(MAXIM(p)-MININ(p));
%  end
 
[cidx2,cmeans2] = kmeans(features_img,2,'dist','cityblock');
% GMModel = fitgmdist(features_img);
Prediction={};
for i=1:(length(lst)-2)
    Prediction{1,i}=lst(i+2).name;
    Prediction{2,i}=cidx2(i);
end
T = cell2table(Prediction,'VariableNames',{' image_id', 'classe'});
writetable(T,'AIT_LAHCEN_Abdelilah.csv');

 

















 
 
 