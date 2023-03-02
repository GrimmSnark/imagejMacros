// Get open image name
imName = getTitle();

// remove .tif from end
imNameSh = substring(imName, 0, lengthOf(imName)-4);

// pixel widths etc
wPix = getWidth();
wPix_2 = Math.round(wPix/2);

// cropping
makeRectangle(wPix_2 - 256, wPix_2 - 256, 512, 512);
waitForUser("Move rectangle and press OK to continue and crop area");
getSelectionBounds(xRect, yRect, wRect, hRect);
rename(imNameSh + "X_" + xRect + "_Y_"+ yRect+ ".tif");
run("Crop");

// search for labels image
imDir = getInfo("image.directory");

fileFlag = File.exists(imDir+imNameSh+"-labelMasks.tif");

if (fileFlag == 1)
{
	open(imDir+imNameSh+"-labelMasks.tif");
	rename(imNameSh + "X_" + xRect + "_Y_"+ yRect+ "-labelMasks.tif");

	makeRectangle(xRect, yRect, wRect, hRect);
	run("Crop");
}
