% Meshal Almarri
% ENGR 1120 - Homework 3 - FAll 2014
% Tristan Hill - modified from Dr. Stephen Canfield's robo_sim_2013.m
%
% Robot Simulator - Reactive Behaviors 

% Mobile robot Simulation - roboSim
% This program provides a simulation of a mobile robot moving through an
% unknown environment
% Version 1.1 - S.C
% In this version, the robot consists of a lumped mass with no preferred direction
% no dissipative effects, sensor array is inertially fixed.  

% Version 1.2 - T.H.
% To program simple behaviors, call getScan()
% Then, to drive the robot call getRobot(), you choose the Throtle and
% Steering angle
% Try to make a smart robot that can escape the arena
% The sensor array is fixed to the robot frame

clear all
close all
clc

% setup the arena map
arena_size=100;    
arena=[0,arena_size,arena_size,0,0
       0,0  ,arena_size,arena_size,0];
       
map_flag=input('would like to build a new map? (1/0) ');
if map_flag %build a custom map
    num=input('how many objects do you want? ');
    disp('choose your objects with the mouse, each object must have 4 vertices')
    
    figure(1);hold on
    axis([-5,arena_size+5,-5,arena_size+5])
    
    for i=1:num
        [x,y]=ginput(4); % get user input from clicking on plot
        obsx(i,:)=x;
        obsy(i,:)=y;
        fill(x,y,'g')
    end 

else %use hardcoded map
    obsx=[   7.7995   95.2419   94.2281   25.5415
             17.4309    6.0253   31.1175   24.2742
             85.8641   93.4677   96.2558   91.4401
             50.6336   93.2143   93.9747   57.7304
             19.9654   46.5783   23.7673   16.4171];
    
    obsy=[  97.1199   99.3713   86.8275   91.6520
            100.9795   13.8158   59.4883   93.2602
            92.2953    1.2719   65.9211   93.9035
            65.2778   24.1082   50.8041   54.9854
            39.2251   11.2427   53.3772   45.3363];
end

sim_speed=.01;           % controls simulation display speed

figure(1);hold on
for j=1:length(obsx(:,1))
    fill(obsx(j,:),obsy(j,:),'g')
end

%initialial robot position;
disp('Where do want to start the robot? Choose location with mouse.'); %x,y,theta triplet, initial pose 
s(1,1:2)=ginput(1);

s(1,3)=input('Type the initial heading in degrees. ');
s(1,3)=s(1,3)*pi/180;

v(1)=0; %robot starts at rest

thresh=11; %safe distance from object

%Main: run continous loop, incrementing time by time step dt.
ctr=0; 
avoiding=0;
escaped=0;  % flag for are you still in the area
crashed=0;  % flag for if youve hit an object
tic;
while (~escaped && ~crashed)
    ctr=ctr+1;
    
    %get sensor scan
    [sen_dist,sen_angle] = getSensor(obsx,obsy,s(ctr,:));
% *********** Navigation strategy *****************
%    program robot behaviors in this section    
    
    if ~avoiding;
        %drive straight ahead if you havent seem an obstacle
        gas=5;
        steer=0;
        sen_flag=zeros(1,7);
        %check if any laser scans are dangerous
        for k=1:7
            if sen_dist(k)<thresh;
                sen_flag(k)=1; 
            end
        end
        %%
        % my logic here
       
        front=4;
        left=1;
        right=7;
        
       
        % move somewhere else.
         % now changing direction
         % if we move robot when too near the obstacle, its already too 
         % late so we keep checking sensors to keep it away from the
         % obstacles by calculating distance from both sides.
         
        if(sen_dist(left+2)>sen_dist(right-2))
            % we have space on the left.
            gas=gas-1; % slow down
            steer=-1;
            gas=gas+1; % speed up again
        elseif(sen_dist(left+2)<sen_dist(right-2))
            gas=gas-1;
            steer=1;
            gas=gas+1;
        end
        
                 if(sen_dist(left+1)>sen_dist(right-1))
                     gas=gas-2;
                     steer=-2;
                     gas=gas+2;
                  elseif(sen_dist(left+1)<sen_dist(right-1))
                        gas=gas-2;
                        steer=2;
                        gas=gas+2;
                 end
                 
            if(sen_dist(left)>sen_dist(right))
            gas=gas-3;
            steer=-4;
            gas=gas+3;
           elseif(sen_dist(left)<sen_dist(right))
            gas=gas-3;
            steer=4;
            gas=gas+3;
            end
            leftspace=sen_dist(left)+sen_dist(left+1)+sen_dist(left+2);
            rightspace=sen_dist(right)+sen_dist(right-1)+sen_dist(right-2);
            
            if(leftspace>rightspace)
                steer=left;
            elseif(leftspace<rightspace )
                steer=left*(-1);
            end
        
        
        
       
        
       
        
    else
        avoiding=avoiding-1; %count down while 'avoiding the object'
    end

% *********** end Navigation strategy *****************


% *********** Robot Kinematcs **********************
    [robot,s(ctr+1,:),v(ctr+1)] = getRobot(gas,steer,s(ctr,:),v(ctr));
    
    %check if the robot has crashed       
    if min(sen_dist)<2
       crashed=1;
    end
    
    %check if you have escaped
    if s(ctr,1)>100 || s(ctr,1)<0
        escaped=1;
    end
    if s(ctr,2)>100 || s(ctr,2)<0
        escaped=1;
    end
% *********** end Robot dynamics, kinematics ***************
    
% *********** Plot the Animation ********************* 
 
    hold off
    clf
    patch(robot)
    
    hold on
    for j=1:length(obsx(:,1))
        fill(obsx(j,:),obsy(j,:),'g')
    end
    axis([-5,arena_size+5,-5,arena_size+5])
     
    plot(arena(1,:),arena(2,:),'b-')
  
    showSensor(sen_dist,sen_angle,thresh,s(ctr,:))
   
    pause(sim_speed) %pause to display on screen
    
    %make a .gif
    if escaped
        msg=sprintf('Congratulations, your robot has escaped the arena in %f seconds!!!',toc);
        title(msg)
    elseif crashed
        msg=sprintf('Opps, your robot crashed and has been destroyed in %f seconds!!!',toc);
        title(msg)
    end
        
% *********** end Plot course, robot path **********************
end % end while   
