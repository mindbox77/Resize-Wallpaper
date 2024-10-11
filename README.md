# Resize-Wallpaper
This script simplifies the task of generating multiple resized versions of an image, which is particularly useful for web developers, graphic designers, and content creators who need images in various resolutions.

The script begins by loading the necessary assemblies for GUI components and image processing.

Defining the Resize-Image Function:

function Resize-Image { ... }
A custom function that handles the resizing and cropping of the image to fit the target dimensions.

Parameters:

[System.Drawing.Image]$image: The source image to be resized.
[int]$targetWidth, [int]$targetHeight: The desired dimensions.

Process:

Calculates the aspect ratios of the source image and target dimensions.
Determines whether to crop the sides or the top and bottom to maintain aspect ratio.
Performs cropping and resizing using high-quality bicubic interpolation.

Prompting for Input Image Selection:

$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
Opens a file dialog for the user to select the input image.
Filters for common image file types (JPEG, PNG, BMP, GIF).

Prompting for Output Folder Selection:

$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
Allows the user to select the destination folder where resized images will be saved.

Defining the List of Resolutions:

$resolutions = @(
    @{Width=1920; Height=1080},
    @{Width=1280; Height=720},
    @{Width=800; Height=600}
    # Add more resolutions as needed
)
An array containing the target resolutions.
Users can modify this list to include any additional resolutions required.

Processing Each Resolution:

foreach ($res in $resolutions) { ... }
Iterates over each resolution.
Calls the Resize-Image function to resize the image.
Constructs an output filename that includes the resolution (e.g., image_1920x1080.jpg).
Saves the resized image to the selected output folder.

Cleanup:

$InputImage.Dispose()
Releases resources used by the image objects to free up memory.
