/* This macro processes single channel z stack t series images by creating 
   Extended Depth of Focus version for each time series
   
    Dependencies: CLIJ (https://clij.github.io/clij2-docs/installationInFiji)
    			  clijx-assistant
				  clijx-assistant-extensions
 */
 
// Get open image name
imName = getTitle();

// remove .tif from end
imNameSh = substring(imName, 0, lengthOf(imName)-4);

// get image dimensions
getDimensions(width, height, channels, slices, frames);

// start the CLIJ engine for processing
//run("CLIJ2 Macro Extensions", "cl_device=[Intel(R) HD Graphics 530]");
run("CLIJ2 Macro Extensions", "cl_device=[]");

// run through all the t series slices
for (i = 0; i < frames; i++) 
{
	// index frames to 1
	fr = i +1;
	
	// get the t series substack
	selectWindow(imName);
	run("Make Substack...", "slices=1-"+slices+ " frames="+ fr);
	
	// extended depth of focus sobel projection
	image1 = imNameSh+ "-1.tif";
	Ext.CLIJ2_push(image1);
	image2 = imNameSh+ "-2.tif";
	sigma = 10.0;
	Ext.CLIJ2_extendedDepthOfFocusSobelProjection(image1, image2, sigma);
	Ext.CLIJ2_pull(image2);

	// close the t series substack
	selectWindow(image1);
	close();

	// create or concatenate stack for each slice
	if (i == 0) 
	{
 		rename("Stack");
	}
	else 
	{
		run("Concatenate...", "open image1=Stack image2="+image2 +" image3=[-- None --]");
		rename("Stack");
	}

}

// rename stack appropriately at the end
rename(imNameSh + "_EDoF.tif");
