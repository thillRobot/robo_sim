function [robot,pose,vel] = getRobot(F,w,pose,vel)
%UNTITLED2 Summary of this function goes here
   
    dt=.1;  % time step
    width=3; %robot dimensions
    height=5;
    mass=25; %(kg) 
    vLim=11;  %(m/s) - approx 25 mph
    v_dotLim=9.8; %(m/s^2) - 1 g  
    v_dot=F/mass; %newtons second law
    
    %saturation limits (acceleration)
    
    if v_dot>v_dotLim;
        v_dot=v_dotLim;
    elseif v_dot<-v_dotLim;
        v_dot=-v_dotLim;
    end
    
    %integrate acceleration to velocity
    vel=vel+v_dot*dt;

    %saturation limits (velocity)
    
    if vel>vLim;
        vel=vLim;
    elseif vel<-vLim;
        vel=-vLim;
    end
    
    %integrate rotational vel into theta
    pose(3)=pose(3)+w*dt;
    
    %calc x,y components at robot theta
    vX=vel*cos(pose(3));
    vY=vel*sin(pose(3));  
    
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

