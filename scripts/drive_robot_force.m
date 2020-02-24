function [robot,pose,vel] = drive_robot_force(F,T,pose,vel)
%UNTITLED2 Summary of this function goes here
   
    dt=.1;  % time step
    
    %robot parameters
    size_x=1.50;   %(m)
    size_y=2;   %(m)     
    mass=25;    %(kg)
    
    %mass moment of inertia of a disk
    inertia=mass*((size_x)^2+(size_y)^2)/12; 
    
    %newtons second law
    accel(1)=F/mass; %translation
    accel(2)=T/inertia; %rotation
    
    %saturation limits (lin. acceleration)
    accelLim=[10,.5]; %(m/s^2) - 1 g 
    if accel(1)>accelLim(1);
        accel(1)=accelLim(1);
    elseif accel(1)<-accelLim(1);
        accel(1)=-accelLim(1);
    end
    
    %saturation limits (ang. acceleration)
    velLim=[11 1];  %(m/s) - approx 25 mph
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
    robot.vertices=[-size_x/2,0
                    size_x/2,0
                    0,size_y];
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

