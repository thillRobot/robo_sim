# robo_sim
This is a simple robot simulator written in MATLAB for ENGR1120 sudents. 

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

%Version 1.9 - T.H. - Release to ENGR Spring 2017 - HW4 (maybe)

ROBO SIM V2.0 - Welcome to the 2020s

Tristan Hill - 02/24/2020 - WOOP!
