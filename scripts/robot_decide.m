function [speed,turn]=robot_decide(sensor,velo)
%robot_decide this function is the brain of the robot        
   speed=10;
   turn=0; 
   
   if sensor(4)<8 % if danger is in front
        speed=-5;
        turn=0;
        disp('Danger in Front!')
   
   end
   if sensor(6)<8 % if danger is on left
        speed=-5;
        turn=6;
        disp('Danger on Left!')
   
   end
   if sensor(2)<8 % if danger is on right
        speed=-5;
        turn=-6;
        disp('Danger on Right!')
   
   end
           
end