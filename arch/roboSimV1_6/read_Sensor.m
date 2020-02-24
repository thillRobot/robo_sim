function [sen_dist,sen_angle] = read_sensor(obsx,obsy,pose)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

    sen_angle=[90,60,30,0,-30,-60,-90]*(pi/180)+pose(3); %senor directions
    max_range=20;           % max range for sensor
    sen_offset=0;         % offset for sensor data
    idx1=[1,2,3,4];
    idx2=[2,3,4,1];   
    for l=1:length(sen_angle)   %loop over all sensors
        sen_dirx=cos(sen_angle(l)); sen_diry=sin(sen_angle(l)); % dir. of current sensor
        t_current=max_range;    %initial sensor distance (t) to max range
        for j=1:length(obsx(:,1))  % loop over all obstacles
            for k=1:4              % loop over all sides
                p1x=obsx(j,idx1(k)); p1y=obsy(j,idx1(k));
                p2x=obsx(j,idx2(k)); p2y=obsy(j,idx2(k));
                v1x=p2x-p1x;v1y=p2y-p1y;
                sx=pose(1); sy=pose(2);
                A=[sen_dirx, -v1x; sen_diry, -v1y];
                b=[p1x-sx; p1y-sy];
                if abs(det(A))>=1e-8    %check for intersecting lines
                    ts=inv(A)*b;
                else
                    ts=[100,100];
                end
                if (ts(2)>=0 && ts(2)<=1 && ts(1)>=0 && ts(1)<t_current)
                    t_current=ts(1); %update current sensor distance
                end
            end % end side k
        end % end obstacle j
        sen_dist(l)=t_current-sen_offset;   % assign sensor distance l (subtract offset)
    end %end sensor angle l

end

