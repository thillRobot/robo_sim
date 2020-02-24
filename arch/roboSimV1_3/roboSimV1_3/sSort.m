
%% selection sort

clear all
close all
clc

myArray=[5,6,7,3,4,2,6,7,8,9];

for i=1:10
    myMax=0;
    for j=i:10
        
        if myArray(j)>myMax
            myMax=myArray(j);
            k=j;
        end
       
    end
        tmp=myArray(i);
        myArray(i)=myArray(k);
        myArray(k)=tmp;
end


