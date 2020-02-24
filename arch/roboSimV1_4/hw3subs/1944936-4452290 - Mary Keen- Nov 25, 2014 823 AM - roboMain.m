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

% Version 1.4 - T.H.
% goals - Release version for ENGR1120 Fall 2014 - HW3

%% Lab 6 ENGR 1120 021
% Mary Keen Lab6

clear all
close all
clc
set(0,'DefaultFigureWindowStyle','docked')

disp('***************************************************************')
disp('RoboSim Version 1.4 - Tennessee Technological Univeristy - 2014')
disp('***************************************************************')

map_opt=input(' 1) Would you like to use a harcoded map?  \n 2) Or, Would you like to build a new map?  \n 3) Or, Would you like use a map from a file? \n Enter your choice. (1/2/3) ');

if map_opt==1 %use a hardcoded map 
    arena_size=100;    
    arena=[0,arena_size,arena_size,0,0
       0,0  ,arena_size,arena_size,0];

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
    [obsx,obsy,arena_size]=mapBuilder();
    
elseif map_opt==3 %load a map from a text file
    myFile=input('Enter the name of the map file to load. ','s');
    myID=fopen(myFile,'r');
    arena_size = fscanf(myID,'%f',1);
    arena=[0,arena_size,arena_size,0,0
       0,0  ,arena_size,arena_size,0];
    scanning = 1;
    idx = 1;
    while scanning
        tempx = fscanf(myID,'%f',4);
        tempy = fscanf(myID,'%f',4);
        if feof(myID)
            scanning = 0;
        else
            obsx(idx,1:4) = tempx;
            obsy(idx,1:4) = tempy;
        end
        idx = idx + 1;
    end

    fclose(myID)
end

% setup the arena map
arena=[0,arena_size,arena_size,0,0
       0,0  ,arena_size,arena_size,0];

sim_speed=.01; % controls simulation display speed
axis([-5,arena_size+5,-5,arena_size+5])
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
disp('Your robot is trying to escape!')
while (~escaped && ~crashed)
    ctr=ctr+1;
    
    %get sensor scan
    [sen_dist,sen_angle] = getSensor(obsx,obsy,s(ctr,:));
% *********** Navigation strategy *****************
%    program robot behaviors in this section    
    
    if ~avoiding;
        %Enter your default behavior here, (not avoiding) 
        gas=10;
        steer=0;
        
        %Enter as many reactive behaviors here as you want.
        if sen_dist(4)<thresh % if danger is in front
            gas=-10;          % reverse
            steer=0;          % dont steer 
            avoiding=5 ;      % for five seconds (iterations)   
        end
        
        if sen_dist(2)<thresh
            gas=5;
            steer=-1;
            avoiding=5 ;        
        end                 
        
        if sen_dist(3)<thresh
            gas=2;
            steer=-1;
            avoiding=5 ;        
        end
        
         if sen_dist(5)<thresh
            gas=2;
            steer=1;
            avoiding=5 ;        
         end       
        
         if sen_dist(6)<thresh
            gas=2;
            steer=1;
            avoiding=5 ;        
         end   
         
         if sen_dist(7)<5
            gas=2;
            steer=0.3;
            avoiding=5 ;        
         end 
         
         if sen_dist(1)<5
            gas=2;
            steer=-0.3;
            avoiding=5 ;        
         end 
         
         
         if (sen_dist(4)<thresh) && (sen_dist(3)<thresh) && (sen_dist(5)<thresh) && ((sen_dist(3))>(sen_dist(5)))
             gas = -10;
             steer = 2.5;
             avoiding = 5;
             
         elseif (sen_dist(4)<thresh) && (sen_dist(3)<thresh) && (sen_dist(5)<thresh) && ((sen_dist(3))<(sen_dist(5)))
             gas = -10;
             steer = -2.5;
             avoiding = 5;
         end
         
         if (sen_dist(1)<thresh) && (sen_dist(2)<thresh) && (sen_dist(3)<thresh) && (sen_dist(4)<thresh) && (sen_dist(5)<thresh) && (sen_dist(6)<thresh) && (sen_dist(7)<thresh)
             gas = -30;
             steer = 4;
             avoiding = 5;
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
    if s(ctr,1)>arena_size || s(ctr,1)<0
        escaped=1;
    end
    if s(ctr,2)>arena_size || s(ctr,2)<0
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
    
    if escaped
        msg=sprintf('Congratulations, your robot has escaped the arena in %f seconds!!!',toc);
        title(msg)
        fprintf(msg)
    elseif crashed
        msg=sprintf('Opps, your robot crashed and has been destroyed in %f seconds!!!',toc);
        title(msg)
        fprintf(msg)
    end
        
% *********** end Plot course, robot path **********************
end % end while   
