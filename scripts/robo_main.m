% ENGR 1120 - Homework 3 - Spring 2016

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

%Version 1.8 - T.H. - Release to ENGR Spring 2016 - HW3
%   to add:
%             * reactive behavior programmed by students in user defined
%             functions (DONE)
%             * robot parameters defined in a file  
%             * clear names - no camels (DONE)
%             * timer callback based animation  
%             * fix escaped and crashed issue
%             * added dampers! c ct

%Version 1.9 - T.H. - Release to ENGR Spring 2017 

% Version 2.0 - T.H. Welcome to Spring 2020 - ENGR1120-800

clear all
close all
clc
set(0,'DefaultFigureWindowStyle','docked')

fprintf('***************************************************************\n')
fprintf('RoboSim Version 2.0 - Tennessee Technological Univeristy - 2020\n')
fprintf('***************************************************************\n')

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
    [obsx,obsy,arena_height,arena_width]=map_builder();
    
elseif map_opt==3 %load a map from a .dat file
    
    map_file=input('Please enter the name of the file you wish to view. ','s');
    map_file=strcat('..\maps\',map_file);
    map_file=strcat(map_file,'.txt');
    G=load(map_file);

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
fprintf('Where do want to start the robot? Choose location with mouse: \n'); %x,y,theta triplet, initial pose 
pos(1,1:2)=ginput(1);

pos(1,3)=input('Type the initial heading in degrees: ');
pos(1,3)=pos(1,3)*pi/180;

vel(1,:)=[0,0];  %robot starts at rest [vx, w] [forward velocity , angular velocity]

thresh=11; %safe distance from object

ctr=0;      % main whilie loop counter
escaped=0;  % flag for are you still in the area
crashed=0;  % flag for if youve hit an object
tic;        % start the clock
fprintf('Your robot is trying to escape!\n')
while (~escaped && ~crashed)
    ctr=ctr+1;
    
% *********** Read Sensor Data ****************  

    [sen_dist,sen_angle] = read_sensor(obsx,obsy,pos(ctr,:));
    
% *********** Decide Navigation strategy ****************  
    
    [gas,steer] = robot_decide(sen_dist,vel(ctr,:));

% *********** Apply Robot Kinematcs and Dynamics ************
    
    [robot,pos(ctr+1,:),vel(ctr+1,:)] = drive_robot(gas,steer,pos(ctr,:),vel(ctr,:));
    
% *********** Check if the robot has crashed **************     
    if min(sen_dist)<1
       crashed=1;
    end
    
% *********** Check if you have escaped
    if pos(ctr,1)>arena_width || pos(ctr,1)<0
        escaped=1;
    end
    if pos(ctr,2)>arena_height || pos(ctr,2)<0
        escaped=1;
    end
    
% ********** display data if the run is over ****************    
    if escaped
        msg=sprintf('Congratulations, your robot has escaped the arena in %f seconds!!!\n',toc);
        fprintf(msg)
        title(msg)
    elseif crashed
        msg=sprintf('Oops, your robot crashed and has been destroyed in %f seconds!!!\n',toc);
        title(msg)
        fprintf(msg)
    end
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
  
    show_sensor(sen_dist,sen_angle,thresh,pos(ctr+1 ,:))
   
    pause(sim_speed) %pause to display on screen

end % end while   
