![Logo_Politecnico_Milano](https://github.com/user-attachments/assets/c9c89ef7-8a4c-4080-adfa-176c0ad9523d)

# Left Ventricle Automatic Segmentation in MRI Slices
## Project Overview

This project was developed as part of the *Laboratorio di Elaborazione di Bioimmagini* (Lab of Bio Image Processing) course. The goal is to segment the endocardium of the left ventricle (LV) from 25 MRI slices, extract the contours of the LV, and calculate its area and volume for each slice. The project concludes with a plot of the LV volume over time and the visualization of the segmented LV contours overlaid on the original images.


## Methodology

The segmentation process is designed to be automatic, relying on the fact that the left ventricle is a nearly circular structure. By detecting circular shapes within a specified radius range, the method segments the LV across all slices. This process eliminates manual intervention, ensuring the LV is automatically segmented, filled, and analyzed in every frame. The calculated contours of the ventricle allow for precise area and volume estimation, providing clinically relevant metrics.

## Code Structure

#### Loading and Pre-processing:
The MRI slices are loaded into a struct and pre-processed by converting them to grayscale and applying contrast enhancement with the imadjust() function and stretchlim(). This prepares the data for more accurate segmentation.
#### Segmentation Process:
The segmentation starts by identifying the left ventricle in the first slice using the imfindcircles() function, which detects circular structures within a predefined radius range.
Once the center and radius of the LV are identified, a mask is generated, and thresholding is applied to segment the LV. The boundaries of the LV are detected for each slice using the bwboundaries() function.
A loop applies this procedure to all 25 slices, calculating the LV area in mm² and volume in ml based on spatial resolution parameters.
#### Visualization:
The LV volume over time is plotted, and the contours of the segmented LV are overlaid on the original images for visual inspection.

### Key Functions
`get_boundaries_and_area(A, x, y, radii)`: Creates a binary mask for the LV, applies thresholding, and detects boundaries of the segmented LV.

`get_area(L)`: Filters out noise and small objects, returning the accurate area of the LV and the corresponding boundaries.

## Results

The method successfully segmented the left ventricle across all 25 slices.
The total calculated LV volume was 550 ml.
The LV volume variation over time was visualized, and the contours of the ventricle were plotted on the original images for validation.

## Conclusion

This project demonstrates the use of automatic segmentation techniques for cardiac MRI analysis, leveraging circular shape detection to identify and extract the left ventricle. The methodology enables efficient area and volume computation, providing reliable metrics for further clinical analysis.
