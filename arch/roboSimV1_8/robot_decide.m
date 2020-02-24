function [speed,turn]=robot_decide(sensor,velo)
        
   speed=5;
   turn=0; 
   
   if sensor(4)<8 % if danger is in front
        speed=-5;
        turn=0;
        disp('front')
   
   end
    if sensor(6)<8 % if danger is in front
        speed=-5;
        turn=6;
        disp('front')
   
   end
    
    
        
        
end