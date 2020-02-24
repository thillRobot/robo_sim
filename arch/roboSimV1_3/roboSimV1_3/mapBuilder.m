%mapbuilder for roboSim V1.3
%save maps as text file using ginput;
clear all
close all
clc

myFile=input('what would you like to name you map file?')
myID=fopen(myFile,'w');

myLims=input('Enter the Map [xmin xmax ymin ymax]')

fprintf(myID,'%f %f %f %f\n',myLims(1),myLims(2),myLims(3),myLims(4))


figure(1);
axis(myLims);


adding=1;
ctr=0;
while adding
    ctr=ctr+1;
    
    [xs,ys]=ginput(4);
    
    fprintf(myID,'%f %f %f %f ',xs(1),xs(2),xs(3),xs(4));
    fprintf(myID,'%f %f %f %f ',ys(1),ys(2),ys(3),ys(4));
    
    adding=input('Would you like to add another object? (1/0)');
    if adding
        fprintf(myID,'\n');
    end
end


fclose(myID)


