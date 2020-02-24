%mapbuilder for roboSim V1.3
%save maps as text file using ginput;
%currently maps are square (v1_3)
function [xs,ys,mySize] = mapBuilder()

    myFile=input('what would you like to name your map file? ','s');
    myID=fopen(myFile,'w');

    mySize=input('Choose the Arena Size. ');

    fprintf(myID,'%i\n',mySize);
    
    arena=[0,mySize,mySize,0,0
       0,0  ,mySize,mySize,0];
    figure(1);
    plot(arena(1,:),arena(2,:),'b-'); hold on
    axis([-5 mySize+5 -5 mySize+5]);
    
    disp('Place your objects on the figure. Each object must have 4 vertices.')
    adding=1;
    ctr=0;
    while adding
        ctr=ctr+1;
        
        [xs(ctr,:),ys(ctr,:)]=ginput(4);
        fprintf(myID,'%f %f %f %f ',xs(ctr,1),xs(ctr,2),xs(ctr,3),xs(ctr,4));
        fprintf(myID,'%f %f %f %f ',ys(ctr,1),ys(ctr,2),ys(ctr,3),ys(ctr,4));
        fill(xs(ctr,:),ys(ctr,:),'g')
        axis([-5 mySize+5 -5 mySize+5]);
        % dont put a newline at the end of the last line
        adding=input('Would you like to add another object? (1/0) ');
        if adding
            fprintf(myID,'\n');
        end
        
    end

    fclose(myID)


