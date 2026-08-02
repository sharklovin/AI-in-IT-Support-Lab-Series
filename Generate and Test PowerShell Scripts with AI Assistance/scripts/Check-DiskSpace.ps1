<#
.SYNOPSIS
    Reads a list of computer names from a text file and reports free disk
    space on the C: drive of each, with colour-coded console output.

.DESCRIPTION
    This script reads one computer name per line from an input text file,
    queries each machine's C: drive free space via CIM/WMI, and prints a
    colour-coded line to the console:
        Red    - free space below 10 GB
        Yellow - free space below 20 GB (but >= 10 GB)
        Green  - free space at or above 20 GB
    Unreachable or errored computers are reported separately in gray/red
    so they're not confused with a real low-disk-space reading.

.PARAMETER ComputerListPath
    Path to a text file containing one computer name per line.

.EXAMPLE
    .\Check-DiskSpace.ps1 -ComputerListPath .\computers.txt

.NOTES
    Requires network access and permissions (WMI/CIM, typically via WinRM
    or DCOM) to query each remote computer. Run as an account with rights
    to query CIM on the target machines.
#>

[CmdletBinding()]
param(
    # Path to the text file listing computer names, one per line.
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$ComputerListPath
)

# ---------------------------------------------------------------------------
# SECTION 1: Define thresholds (in GB)
# ---------------------------------------------------------------------------
# Centralized here so they're easy to tweak without hunting through the script.
$RedThresholdGB    = 10
$YellowThresholdGB = 20

# ---------------------------------------------------------------------------
# SECTION 2: Validate and read the computer list file
# ---------------------------------------------------------------------------
if (-not (Test-Path -Path $ComputerListPath -PathType Leaf)) {
    Write-Error "Computer list file not found: $ComputerListPath"
    exit 1
}

# Read lines, trim whitespace, and drop any blank lines so accidental empty
# rows in the file don't get queried as computer names.
$computerNames = Get-Content -Path $ComputerListPath |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne '' }

if (-not $computerNames -or $computerNames.Count -eq 0) {
    Write-Warning "No computer names found in '$ComputerListPath'. Nothing to check."
    exit 0
}

Write-Host "Checking C: drive free space on $($computerNames.Count) computer(s)...`n" -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# SECTION 3: Query each computer and print colour-coded results
# ---------------------------------------------------------------------------
foreach ($computer in $computerNames) {

    try {
        # Query the C: drive via CIM (preferred over the older Get-WmiObject).
        # -ErrorAction Stop ensures unreachable/failed queries land in catch.
        $disk = Get-CimInstance -ClassName Win32_LogicalDisk `
            -ComputerName $computer `
            -Filter "DeviceID='C:'" `
            -ErrorAction Stop

        if (-not $disk) {
            # Machine responded but has no C: drive (unusual, but possible).
            Write-Host ("{0,-20} No C: drive found" -f $computer) -ForegroundColor DarkGray
            continue
        }

        # FreeSpace is returned in bytes; convert to GB for readability
        # and threshold comparisons.
        $freeGB = [math]::Round($disk.FreeSpace / 1GB, 2)
        $totalGB = [math]::Round($disk.Size / 1GB, 2)

        # Pick the colour based on the configured thresholds.
        if ($freeGB -lt $RedThresholdGB) {
            $color = 'Red'
        }
        elseif ($freeGB -lt $YellowThresholdGB) {
            $color = 'Yellow'
        }
        else {
            $color = 'Green'
        }

        Write-Host ("{0,-20} {1,8} GB free  /  {2} GB total" -f $computer, $freeGB, $totalGB) -ForegroundColor $color
    }
    catch {
        # Covers unreachable computers, access denied, WinRM/DCOM not
        # configured, etc. Reported distinctly so it's not mistaken for a
        # disk-space reading.
        Write-Host ("{0,-20} ERROR: {1}" -f $computer, $_.Exception.Message) -ForegroundColor DarkRed
    }
}

Write-Host "`nDone." -ForegroundColor Cyan
