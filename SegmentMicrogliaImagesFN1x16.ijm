
// Change to the filepath for your own classifer (REMEMBER double slashes)
segFilePath = "C:\\Data\\mouse\\microglia\\18-01-2023\\cleaned\\LabKitClass.classifier"

// choose file etc
path = File.openDialog("Select an Image to Process");
folder =File.getDirectory(path);
imName = File.getName(path);

// remove .tif from end
imNameSh = substring(imName, 0, lengthOf(imName)-4);

// open
open(path);

// run segmentation
run("Segment Image With Labkit", "segmenter_file=" + segFilePath+ " use_gpu=false");

//run("Segment Image With Labkit", "segmenter_file=C:\\Data\\mouse\\microglia\\18-01-2023\\cleaned\\LabKitClass.classifier use_gpu=false");
run("8-bit");
run("16-bit");
run("8-bit");
run("16-bit");
run("Make Binary", "method=Default background=Dark calculate black create");

run("Analyze Particles...", "size=50-Infinity add stack show=Masks in_situ");

run("16-bit");

rename(imNameSh+"-labelMasks");
close("\\Others");

roiManager("Delete");
close("ROI Manager");

saveAs("tif", folder+ "\\" + imNameSh+ "-labelMasks.tif");

close("*");
