function testBH(minVal,maxVal,numLines)

radius = 1;
hold off;
circle(0,0,radius);
hold on;
xlim([-4 4]);
ylim([-4 4]);
pbaspect([1 1 1])
eventHorizon = 1.5;
circle(0,0,eventHorizon);

for yPos = linspace(minVal,maxVal,numLines)
   xPos= 4;
   xDir = -0.1;
   yDir = 0;
   steps = 0;
   notDone = 1;
   plot(xPos,yPos,'.', 'MarkerSize', 10)
   while (notDone == 1)    
       if(steps <= 25)
           xDir = xDir - 1 / xPos * .005;
           yDir = yDir - 1 / (yPos) * .003;
       end
       if(steps > 25)
           xDir = xDir - 1 / xPos * .002;
           yDir = yDir * 1.1;
       end
       xPos = xPos + xDir; 
       yPos = yPos + yDir;
       plot(xPos,yPos,'.', 'MarkerSize', 10)
       if (xPos ^2 + yPos ^2 < radius ^2)
           notDone = 0;
       end
       if(xPos >4 || xPos <-4 || yPos >4 || yPos <-4) 
           notDone = 0;
       end
       steps = steps + 1;
   end    
end
