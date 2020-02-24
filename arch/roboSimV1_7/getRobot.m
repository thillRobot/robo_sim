function [robot,pose,vel] = getRobot(F,T,pose,vel)
%UNTITLED2 Summary of this function goes here
   
    dt=.1;  % time step
    width=3; %robot dimensions
    height=5;
    mass=25; %(kg) 
    radius=.2 ;  
    
    inertia=mass*radius^2; %need to add equation here
    
    accelLim=[10,.5]; %(m/s^2) - 1 g  
    
    velLim=[11 1];  %(m/s) - approx 25 mph
    
    accel(1)=F/mass; %newtons second law
    accel(2)=T/inertia; %newtons second
    
    
    %saturation limits (lin. acceleration)
    if accel(1)>accelLim(1);
        accel(1)=accelLim(1);
    elseif accel(1)<-accelLim(1);
        accel(1)=-accelLim(1);
    end
    
    %saturation limits (ang. acceleration)
    if accel(2)>accelLim(2);
        accel(2)=accelLim(2);
    elseif accel(2)<-accelLim(2);
        accel(2)=-accelLim(2);
    end
    
    %integrate lin. acceleration to lin. velocity (EULERS's integration)
    vel(1)=vel(1)+accel(1)*dt;

    %integrate ang. acceleration to ang. velocity
    vel(2)=vel(2)+accel(2)*dt;

    %saturation limits (lin. velocity)
    if vel(1)>velLim(1);
        vel(1)=velLim(1);
    elseif vel(1)<-velLim(1);
        vel(1)=-velLim(1);
    end
    
    %saturation limits (ang. velocity)
    if vel(2)>velLim(2);
        vel(2)=velLim(2);
    elseif vel(2)<-velLim(2);
        vel(2)=-velLim(2);
    end
    
    %integrate rotational vel into theta
    pose(3)=pose(3)+vel(2)*dt;
    
    %calc x,y components at robot theta
    vX=vel(1)*cos(pose(3));
    vY=vel(1)*sin(pose(3));  
    
    %integrate velocity to position
    pose(1)=pose(1)+vX*dt;
    pose(2)=pose(2)+vY*dt;
    
    %build the patch 
    robot.vertices=[-width/2,0
                    width/2,0
                    0,height];
    robot.faces=[1,2,3];
    
    %rotate the patch
    R=[cos(pose(3)-pi/2) -sin(pose(3)-pi/2)
       sin(pose(3)-pi/2) cos(pose(3)-pi/2)];
    robot.vertices=R*robot.vertices';
    robot.vertices=robot.vertices';
    
    %translate the patch
    for g=1:length(robot.faces)
        robot.vertices(g,1)=robot.vertices(g,1)+pose(1);
        robot.vertices(g,2)=robot.vertices(g,2)+pose(2);
    end
    
end
