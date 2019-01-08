clc

 fold='C:/Program Files/MATLAB/R2018a/bin/img_mining/ClassificationReel/ISIC-2017_Training_Data';
 foldval='C:/Program Files/MATLAB/R2018a/bin/img_mining/ClassificationReell/ISIC-2017_Validation_Data';
 foldTest='C:/Program Files/MATLAB/R2018a/bin/img_mining/ClassificationReel/ISIC-2017_Test_v2_Data';

 list_Test=dir(foldTest);
 nT=size(list_Test);
 
t = readtable('ISIC-Training.csv');
v= readtable('ISIC-Validation.csv');


datavald=table2cell(v);
data = table2cell(t);
[n m] = size(t);
[nv mv] = size(v);
k0=1;
k1=1;
k2=1;
%%%%%%%%%training : les labels et les images  %%%%%%%%%%
 for i=1:n
         etat(i,1)=data(i,2);
         Nams(i,1)=(data(i,1));         
 end
etat_arr=cell2mat(etat);

%%%%%%%%%%validation : les labels et les images  %%%%%%%%%%
 for i=1:nv
         etat_val(i,1)=datavald(i,2);
         Nams_val(i,1)=(datavald(i,1));         
 end
 etat_arr_val=cell2mat(etat_val);
 
 %%%%%%%%% training == extraire les features %%%%%%%%%%
 x=256;
 y=256;
 z=3;  
 for i=1:n
     %%caster les nomes en des char
     Namescv{i,1}=char(Nams(i,1));
     IDB = imread(strcat(fold,'/',Namescv{i,1},'.jpg'));
     
     imgSeg =~im2bw(IDB);
     for ii=1:z
         for jj=1:y
             for kk=1:x  
                 if imgSeg(kk,jj)==0                     
                     imgR0(kk,jj,ii)=IDB(kk,jj,ii);
                 end
             end
         end
    end
    for ii=1:z      
        for jj=1:y   
            for kk=1:x                
                if imgSeg(kk,jj)==1
                    imgR1(kk,jj,ii)=IDB(kk,jj,ii);
                end
            end
        end
    end
     features_img1(k0,:)=getFeatures(imgR0, 43);
     features_img2(k0,:)=getFeatures(imgR1, 43);
     features_img=[features_img1,features_img2];
     k0=k0+1;
 end
 
 %%%%%%%%%% validation == extraire les features %%%%%%%%%%
 for i=1:nv
     %%caster les nomes en des char
     Namesvalcv{i,1}=char(Nams_val(i,1));
     IDBval = imread(strcat(foldval,'/',Namesvalcv{i,1},'.jpg'));
     
     imgSegval =~im2bw(IDBval);
     for ii=1:z
         for jj=1:y
             
            for kk=1:x
                
            if imgSegval(kk,jj)==0
                imgR0val(kk,jj,ii)=IDBval(kk,jj,ii);
            end
        end
    end
     end
     for ii=1:z
    for jj=1:y
        for kk=1:x
            if imgSegval(kk,jj)==1
                imgR1val(kk,jj,ii)=IDBval(kk,jj,ii);
            end
        end
    end
     end
     features_img_val1(k1,:)=getFeatures(imgR0val, 43) ;
     features_img_val2(k1,:)=getFeatures(imgR1val, 43);
     features_img_val=[features_img_val1,features_img_val2];
     k1=k1+1;
 end
 %%%%%%%%%% TEST == extraire les features %%%%%%%%%%
 for i=3:nT
    IDBTest=imread(strcat(foldTest,'/',list_Test(i).name));
    
     imgSegtst =~im2bw(IDBTest);
     for ii=1:z
         for jj=1:y
             
            for kk=1:x
                
            if imgSegtst(kk,jj)==0
                imgR0tst(kk,jj,ii)=IDBTest(kk,jj,ii);
            end
        end
    end
     end
     for ii=1:z
    for jj=1:y
        for kk=1:x
            if imgSegtst(kk,jj)==1
                imgR1tst(kk,jj,ii)=IDBTest(kk,jj,ii);
            end
        end
    end
     end
     features_img_test1(k2,:)=getFeatures(imgR0tst, 43) ;
     features_img_test2(k2,:)=getFeatures(imgR1tst, 43);
 
     features_img_test=[features_img_test1,features_img_test2];
     k2=k2+1;   
 end
 
%%%%SVM
svmStruct =fitcsvm(features_img,etat_arr,'Standardize',true,'KernelFunction','rbf','KernelScale','auto');
C = predict(svmStruct,features_img_val );
conMat=confusionmat(etat_arr_val, C);
TP=conMat(1,1);
TN=conMat(2,2);
FP=conMat(2,1);
FN=conMat(1,2);
Accuracy=(TP+ TN)/(TP+TN+FP+FN);
errRate = sum(etat_arr_val~= C)/nv; 
Accuracy_SVM=(1-errRate);

%%%%knn
knn=fitcknn(features_img,etat_arr,'NumNeighbors',5,'Standardize',1);
C = predict(knn,features_img_val );
errRate = sum(etat_arr_val~= C)/nv; 
Accuracy_knn=(1-errRate);

%%%%%%%%%La predection de TEST_V2
C1 = predict(svmStruct,features_img_test );
malade=0;
for i=1:nT-2
    if C1(i)==1
        malade=malade+1;
    end
end






%%%generer le fichier csv
% C contient les étiquettes et
% imageNames les noms des images
for i=1:length(C1)
    Prediction{1,i}=list_Test(i+2).name;
    Prediction{2,i}=C1(i);
end
T = cell2table(Prediction','VariableNames',{' image_id', 'melanoma'});
writetable(T,'ABOUSSALEH_ILYASSE.csv');







 
 
 