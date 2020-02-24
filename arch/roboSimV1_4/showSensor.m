function showSensor(sen_dist,sen_angle,thresh,s)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
  %calc x,y location of 7 laser scans
    for k=1:7
        senXY(1,k)=sen_dist(k)*cos(sen_angle(k))+s(1);
        senXY(2,k)=sen_dist(k)*sin(sen_angle(k))+s(2);
    end
    
    %create vectors for laser beams
    sen_flag=zeros(1,7);
    for k=1:7
        if sen_dist(k)<thresh
            sen_flag(k)=1;
        end
        beam(1,:)=[s(1) senXY(1,k)];
        beam(2,:)=[s(2) senXY(2,k)];
        if sen_flag(k)==0
            plot(beam(1,:),beam(2,:),':r');
        else
            plot(beam(1,:),beam(2,:),':k');
        end
    end
    plot(senXY(1,:),senXY(2,:),'r*')

end

