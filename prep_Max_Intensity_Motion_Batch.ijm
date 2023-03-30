currDir = getDirectory("Choose Image Directory ");
	
	setBatchMode(true);
	 
	list = getFileList(currDir);
	for (i = 0; i < list.length; i++)
		
		{
			if (endsWith(list[i], ".nd2") ==1 )
			{
				
				run("Bio-Formats Importer", "open=" + currDir + "/" + list[i] + " color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT use_virtual_stack");
				runMacro("prep_Max_Intensity_Motion.ijm");
				close(list[i]);
				imTitle = getTitle();
				saveAs("tiff", currDir+imTitle);
				close("*");
				call("java.lang.System.gc");	
			}	
			
		}
			
	setBatchMode(false);
