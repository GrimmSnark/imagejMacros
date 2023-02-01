// Get open image name
imName = getTitle();

// remove .tif from end
imNameSh = substring(imName, 0, lengthOf(imName)-4);

run("Z Project...", "projection=[Max Intensity] all");
run("Smooth", "stack");
run("Sharpen", "stack");
run("Subtract Background...", "rolling=50 stack");
run("StackReg", "transformation=[Affine]");
//run("Brightness/Contrast...");
run("Enhance Contrast", "saturated=0.35");
run("8-bit");


// rename stack appropriately at the end
rename(imNameSh + "_MaxInt.tif");