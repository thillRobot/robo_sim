%mapbuilder for roboSim V1.3
%save maps as text file using ginput;
%currently maps are square (v1_3)
function [xs,ys,myHeight,myWidth] = map_builder()

    map_file=input('What would you like to name the new map? ','s');
    map_file=strcat('..\maps\',map_file);
    map_file=strcat(map_file,'.txt');
    myID=fopen(map_file,'w');

    myWidth=input('Choose the Arena Width. ');
    myHeight=input('Choose the Arena Height. ');
    
    fprintf(myID,'%i %i 0 0 0 0 0 0 \n',myHeight,myWidth)
    
    arena=[0,myWidth,myWidth,0,0
       0,0  ,myHeight,myHeight,0];
   
    figure(1);
    plot(arena(1,:),arena(2,:),'b-'); hold on
    axis([-5 myWidth+5 -5 myHeight+5]);
    axis equal
    disp('Place your objects on the figure. Each object must have 4 vertices.')
    adding=1;
    ctr=0;
    while adding
        ctr=ctr+1;
        
        [xs(ctr,:),ys(ctr,:)]=ginput(4);
        fprintf(myID,'%f %f %f %f ',xs(ctr,1),xs(ctr,2),xs(ctr,3),xs(ctr,4));
        fprintf(myID,'%f %f %f %f ',ys(ctr,1),ys(ctr,2),ys(ctr,3),ys(ctr,4));
        fill(xs(ctr,:),ys(ctr,:),'g')
        axis([-5 myWidth+5 -5 myHeight+5]);
        axis equal
        % dont put a newline at the end of the last line
        adding=input('Would you like to add another object? (1/0) ');
        if adding
            fprintf(myID,'\n');
        end
        
    end

    fclose(myID)


