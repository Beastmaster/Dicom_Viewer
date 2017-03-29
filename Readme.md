- Author: QIN Shuo
- Date: 2016/7
- Organization: RRR


# Description:
Matlab version of dicom series viewer


# File Structure

## Top level
	Dicom_Viewer: GUI funciton of this application

## Middle levle:
- Load_Dicom_Series: load a series of dicom by specifying a folder
- region_growing3d: Modified 3d region growing algorithm

## Bottom level:
- sort_tag2: function to sort a series of dicom files by tag
- Search_Dicom_Path: Search path recursivly to find all dicom files.
- seg_preprocess: Data preprocess for sub image
- reslice_data: Reslice view of data


## Others:
	test_script: useless, for testing only


## Notes:
	Load overlay: a .mat format file. Generated from segmentation









