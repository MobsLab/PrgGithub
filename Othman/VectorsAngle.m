function [VectorsAngle]=VectorsAngle(Ux,Uy,Vx,Vy)

VectorsAngle = atan2d(Ux.*Vy-Uy.*Vx,Ux.*Vx+Uy.*Vy);
end
