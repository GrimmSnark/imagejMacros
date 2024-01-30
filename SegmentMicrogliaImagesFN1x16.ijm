
// Change to the filepath for your own classifer (REMEMBER double slashes)
//segFilePath = "C:\\Data\\mouse\\microglia\\18-01-2023\\cleaned\\LabKitClass.classifier"

// choose file etc
path = File.openDialog("Select an Image to Process");
folder =File.getDirectory(path);
imName = File.getName(path);

// remove .tif from end
imNameSh = substring(imName, 0, lengthOf(imName)-4);

// open
open(path);

// get classifier path
segFilePath = File.openDialog("Select an Pixel Classifier File");

// copy to local temp folder
tempDir = getDirectory("temp");
File.copy(segFilePath, tempDir + "\\tempClass.classifier");

// run segmentation
run("Segment Image With Labkit", "segmenter_file=" + tempDir + "\\tempClass.classifier" + " use_gpu=false");

//run("Segment Image With Labkit", "segmenter_file=C:\\Data\\mouse\\microglia\\18-01-2023\\cleaned\\LabKitClass.classifier use_gpu=false");
run("8-bit");
run("16-bit");
run("8-bit");
run("16-bit");
run("Make Binary", "method=Default background=Dark calculate black create");

run("Analyze Particles...", "size=5-Infinity add stack show=Masks in_situ");

run("Invert", "stack");
run("16-bit");

rename(imNameSh+"-labelMasks");
close("\\Others");

roiManager("Delete");
close("ROI Manager");

saveAs("tif", folder+ "\\" + imNameSh+ "-labelMasks.tif");

close("*");
