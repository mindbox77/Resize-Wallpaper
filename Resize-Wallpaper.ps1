# Load required assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to resize and crop the image to fill the target dimensions
function Resize-Image {
    param(
        [System.Drawing.Image]$image,
        [int]$targetWidth,
        [int]$targetHeight
    )

    $sourceWidth = $image.Width
    $sourceHeight = $image.Height

    $targetAspectRatio = $targetWidth / $targetHeight
    $sourceAspectRatio = $sourceWidth / $sourceHeight

    if ($sourceAspectRatio -gt $targetAspectRatio) {
        # Crop sides
        $cropHeight = $sourceHeight
        $cropWidth = [int]($cropHeight * $targetAspectRatio)
        $cropX = [int](($sourceWidth - $cropWidth) / 2)
        $cropY = 0
    } else {
        # Crop top and bottom
        $cropWidth = $sourceWidth
        $cropHeight = [int]($cropWidth / $targetAspectRatio)
        $cropX = 0
        $cropY = [int](($sourceHeight - $cropHeight) / 2)
    }

    $cropRect = New-Object System.Drawing.Rectangle($cropX, $cropY, $cropWidth, $cropHeight)
    $cropImage = New-Object System.Drawing.Bitmap($cropWidth, $cropHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($cropImage)
    $graphics.DrawImage($image, 0, 0, $cropRect, [System.Drawing.GraphicsUnit]::Pixel)
    $graphics.Dispose()

    # Resize the cropped image
    $resizedImage = New-Object System.Drawing.Bitmap($targetWidth, $targetHeight)
    $graphics = [System.Drawing.Graphics]::FromImage($resizedImage)
    $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $graphics.DrawImage($cropImage, 0, 0, $targetWidth, $targetHeight)
    $graphics.Dispose()
    $cropImage.Dispose()

    return $resizedImage
}

# Prompt user to select the input image
$OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
$OpenFileDialog.Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files|*.*"
$OpenFileDialog.Title = "Select an image file"

if ($OpenFileDialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Host "No image selected. Exiting."
    exit
}

$InputImagePath = $OpenFileDialog.FileName

# Prompt user to select the output folder
$FolderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
$FolderBrowserDialog.Description = "Select an output folder"

if ($FolderBrowserDialog.ShowDialog() -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Host "No output folder selected. Exiting."
    exit
}

$OutputFolder = $FolderBrowserDialog.SelectedPath

# Define the list of resolutions
$resolutions = @(
    @{Width=1920; Height=1080},
    @{Width=1280; Height=720},
    @{Width=800; Height=600}
    # Add more resolutions as needed
)

# Load the input image
$InputImage = [System.Drawing.Image]::FromFile($InputImagePath)

# Process each resolution
foreach ($res in $resolutions) {
    $width = $res.Width
    $height = $res.Height
    $resizedImage = Resize-Image -image $InputImage -targetWidth $width -targetHeight $height

    # Generate the output filename
    $inputFileName = [System.IO.Path]::GetFileNameWithoutExtension($InputImagePath)
    $inputExtension = [System.IO.Path]::GetExtension($InputImagePath)
    $outputFileName = "{0}_{1}x{2}{3}" -f $inputFileName, $width, $height, $inputExtension
    $outputPath = [System.IO.Path]::Combine($OutputFolder, $outputFileName)

    # Save the resized image
    $resizedImage.Save($outputPath)
    $resizedImage.Dispose()
}

# Clean up
$InputImage.Dispose()
