% ENGR 1120 - Homework 3 - FAll 2014
%
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

% Version 1.3 - T.H.
% goals - (1) improved readability/understandability for students 
%         (2) reduce long arguments lists if possible (no structs)
%         (3) tune/decide on dynamics params for competition
%         (4) add map from file option (working!)
%         (5) save map to file from ginput (working!)

% Version 1.4 - T.H. - stripped version 1.3 for ENGR1120 hw3

% Version 1.5 - T.H. - Demo 11/14/2014

% Version 1.6 - T.H. - Release to ENGR1120 Spring 2015 - HW3
    %- changed to maps as .dat files
    
% Version 1.7 - T.H. - Release to ME4140 Fall 2015

clear all
close all
clc
set(0,'DefaultFigureWindowStyle','docked')

disp('***************************************************************')
disp('RoboSim Version 1.6 - Tennessee Technological Univeristy - 2014')
disp('***************************************************************')

map_opt=input(' 1) Would you like to use a harcoded map?  \n 2) Or, Would you like to build a new map?  \n 3) Or, Would you like use a map from a file? \n Enter your choice. (1/2/3) ');

if map_opt==1 %use a hardcoded map 
    arena_size=100;    
    arena=[0,arena_size,arena_size,0,0
       0,0  ,arena_size,arena_size,0];
    arena_width=arena_size;
    arena_height=arena_size;
    
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

elseif map_opt==2 %build and save a custom map
    [obsx,obsy,arena_height,arena_width]=mapBuilder();
    
elseif map_opt==3 %load a map from a .dat file
    
    new_map=input('Please enter the name of the file you wish to view. ','s');
    G=load(new_map);
    arena_width=G(1,2);
    arena_height=G(1,1);
    obsx=G(:,1:4);
    obsy=G(:,5:8);

end

% setup the arena map
arena=[0,arena_width,arena_width,0,0
       0,0,arena_height,arena_height,0];

sim_speed=.01; % controls simulation display speed
axis([-arena_width*.05,arena_width+arena_width*.05,-arena_height*.05,arena_height+arena_height*.05])
axis equal

figure(1);hold on
for j=1:length(obsx(:,1))
    fill(obsx(j,:),obsy(j,:),'g')
end

%initialial robot position;
disp('Where do want to start the robot? Choose location with mouse.'); %x,y,theta triplet, initial pose 
s(1,1:2)=ginput(1);

s(1,3)=input('Type the initial heading in degrees. ');
s(1,3)=s(1,3)*pi/180;

v(1,:)=[0,0];  %robot starts at rest [vx, w] [forward velocity , angular velocity]

thresh=11; %safe distance from object

%Main: run continous loop, incrementing time by time step dt.
ctr=0; 
avoiding=0;
escaped=0;  % flag for are you still in the area
crashed=0;  % flag for if youve hit an object
tic;
disp('Your robot is trying to escape!')
while (~escaped && ~crashed)
    ctr=ctr+1;
    
    %get sensor scan
    [sen_dist,sen_angle] = getSensor(obsx,obsy,s(ctr,:));
% *********** Navigation strategy *****************
%    program robot behaviors in this section    
    
    if ~avoiding;
        %drive straight ahead if you havent seen an obstacle
        gas=5;
        steer=0;

        %check if any laser scans are dangerous
        
        if sen_dist(4)<10 % if danger is in front
            gas=-15;
            steer=0;
            avoiding=5 ;  %time you will avoid
        end
      
        if sen_dist(6)<10 % if danger is in front
            gas=5;
            steer=.05;
            avoiding=2 ;  %time you will avoid
            disp('left')
        end
        if sen_dist(2)<10 % if danger is in front
            gas=5;
            steer=-.05;
            avoiding=2;  %time you will avoid
            disp('right')
        end
        
        
    else
        avoiding=avoiding-1; %count down while 'avoiding the object'
    end

% *********** end Navigation strategy *****************


% *********** Robot Kinematcs **********************
    [robot,s(ctr+1,:),v(ctr+1,:)] = getRobot(gas,steer,s(ctr,:),v(ctr,:));
    
    %check if the robot has crashed       
    if min(sen_dist)<2
       crashed=1;
    end
    
    %check if you have escaped
    if s(ctr,1)>arena_width || s(ctr,1)<0
        escaped=1;
    end
    if s(ctr,2)>arena_height || s(ctr,2)<0
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
    axis([-arena_width*.05,arena_width+arena_width*.05,-arena_height*.05,arena_height+arena_height*.05])
    axis equal 
    plot(arena(1,:),arena(2,:),'b-')
  
    showSensor(sen_dist,sen_angle,thresh,s(ctr,:))
   
    pause(sim_speed) %pause to display on screen
    
    %make a .gif
    if escaped
        msg=sprintf('Congratulations, your robot has escaped the arena in %f seconds!!!',toc);
        fprintf(msg)
        title(msg)
    elseif crashed
        msg=sprintf('Oops, your robot crashed and has been destroyed in %f seconds!!!',toc);
        title(msg)
        fprintf(msg)
    end
        
% *********** end Plot course, robot path **********************
end % end while   
