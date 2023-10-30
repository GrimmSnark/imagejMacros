//@AutoInstall
// This tool displays, in the Results table, the
// coordinates and pixel value at the location
// you click on on. With color images, displays
// red, green and blue values.
//
// You can permanently install this tool in the ImageJ
// toolbar by saving it in the ImageJ/plugins/Tools
// folder as "Point Picker Tool.ijm", restarting
// ImageJ and selecting "Point Picker Tool" from
// the toolbar's ">>" menu.

var intensity = 1;
var brushWidth = 2;
var intensityMax = 1;
var stack = newArray(1000);
var stackSize;

	macro "Microglia Mask Tool -C037F07f2F702f" {
   	
        getCursorLoc(x, y, z, flags);

      
        if (flags == 16){
        	intensity = getValue(x,y); // samples current pixel intensity
        	
        	//row = nResults;
        	//setResult("Intensity", row, intensity);
			}
        else if (flags == 18){ // cntrl left click 
        	
        	setPixel(x, y, intensity); // flood fills with new ID
        	draw(brushWidth);
        	}
        	else if (flags == 24) {
        		floodFillInd();
        	}
		else if (flags == 17) { // shift left click
				floodFillCurrIn(); // flood fills with current intensity
		}
    }
    
    macro "Microglia Mask Tool Options" {
   		brushWidth = getNumber("Brush Radius (pixels)", brushWidth);
	}
	
    
    /// FUNCTIONS
    
	function draw(width) {
     leftClick=16;
     setupUndo(); // requires 1.32g
     getCursorLoc(x, y, z, flags);
      moveTo(x,y);
      x2=-1; y2=-1;
      while (true) {
          getCursorLoc(x, y, z, flags);
          if (flags&leftClick==0) exit();
            if (x!=x2 || y!=y2)
                //lineTo(x,y);
                xLower = x-width;
                xUpper = x+width;
                yLower = y-width;
                yUpper = y+width;
                
                for (i = xLower; i <= xUpper; i++)
                {
                	for (c = yLower; c <= yUpper; c++)
                	{
	                setPixel(i, c, intensity);
	                }
                }
                updateDisplay();
            x2=x; y2 =y;
            wait(10);
        }
   }
   
   function floodFillInd() {
      setupUndo();
      getCursorLoc(x, y, z, flags);
      
      if (intensityMax == 1){
		Stack.getStatistics(voxelCount, mean, min, intensityMax, stdDev);
      	//getMinAndMax(min, intensityMax);
      }
      
      floodFill3(x,  y, getPixel(x, y));
      intensityMax = intensityMax+1;      
  }
  
   function floodFillCurrIn() {
      setupUndo();
      getCursorLoc(x, y, z, flags);
      
      floodFillIntensity(x,  y, getPixel(x, y));     
  }
  
   
   
      // Faster, non-recursive scan-line fill. 
   // This is the algorithm used by the built in
   // floodFill() function.
   function floodFill3(x, y, color) {
      autoUpdate(false);
      stackSize = 0;
      push(x, y);
      
      while(true) {   
          coordinates = pop(); 
          if (coordinates ==-1) {
          	
          	return;
          }
          
          x = coordinates&0xffff;
          y = coordinates>>16;
          i = x;
          while (getPixel(i,y)==color && i>=0) i--;
          i++; x1=i;
          while(getPixel(i,y)==color && i<getWidth) i++;                   
          x2 = i-1;
          drawLineIndx(x1,y, x2,y); // fill scan-line
          inScanLine = false;
          for (i=x1; i<=x2; i++) { // find scan-lines above this one
              if (!inScanLine && y>0 && getPixel(i,y-1)==color)
                  {push(i, y-1); inScanLine = true;}
              else if (inScanLine && y>0 && getPixel(i,y-1)!=color)
                      inScanLine = false;
          }
          inScanLine = false;
          for (i=x1; i<=x2; i++) { // find scan-lines below this one
              if (!inScanLine && y<getHeight-1 && getPixel(i,y+1)==color)
                  {push(i, y+1); inScanLine = true;}
              else if (inScanLine && y<getHeight-1 && getPixel(i,y+1)!=color)
                      inScanLine = false;
          }
     }     
  }
  
  function floodFillIntensity(x, y, color) {
      autoUpdate(false);
      stackSize = 0;
      push(x, y);
      
      while(true) {   
          coordinates = pop(); 
          if (coordinates ==-1) {
          	
          	return;
          }
          
          x = coordinates&0xffff;
          y = coordinates>>16;
          i = x;
          while (getPixel(i,y)==color && i>=0) i--;
          i++; x1=i;
          while(getPixel(i,y)==color && i<getWidth) i++;                   
          x2 = i-1;
          drawLineIndxIntensity(x1,y, x2,y); // fill scan-line
          inScanLine = false;
          for (i=x1; i<=x2; i++) { // find scan-lines above this one
              if (!inScanLine && y>0 && getPixel(i,y-1)==color)
                  {push(i, y-1); inScanLine = true;}
              else if (inScanLine && y>0 && getPixel(i,y-1)!=color)
                      inScanLine = false;
          }
          inScanLine = false;
          for (i=x1; i<=x2; i++) { // find scan-lines below this one
              if (!inScanLine && y<getHeight-1 && getPixel(i,y+1)==color)
                  {push(i, y+1); inScanLine = true;}
              else if (inScanLine && y<getHeight-1 && getPixel(i,y+1)!=color)
                      inScanLine = false;
          }
     }     
  }

  function push(x, y) {
      stackSize++;
      stack[stackSize-1] = x + y<<16;
  }

  function pop() {
      if (stackSize==0)
          return -1;
      else {
          value = stack[stackSize-1];
          stackSize--;
          return value;
      }
  }

  function drawLineIndx(x1,y, x2,y) { 
// function description
	for (p = x1; p <= x2; p++) {
		setPixel(p, y, intensityMax+1);	
	}
  }
  
  function drawLineIndxIntensity(x1,y, x2,y) { 
// function description
	for (p = x1; p <= x2; p++) {
		setPixel(p, y, intensity);	
	}
  }
  
