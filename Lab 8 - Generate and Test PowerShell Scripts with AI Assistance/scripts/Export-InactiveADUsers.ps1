<#
.SYNOPSIS
    Exports all Active Directory user accounts that have not logged in
    within the last 90 days to a CSV file (inactive-users.csv).

.DESCRIPTION
    This script queries Active Directory for enabled user accounts, checks
    each account's last logon timestamp, and exports those that have not
    logged on within the configured threshold (default 90 days) to a CSV
    file. The export includes username, last logon date, department, and
    manager (resolved to a display name rather than a raw distinguished
    name). A summary line count is printed at the end.

.PARAMETER DaysInactive
    Number of days of inactivity to consider a user "inactive". Defaults to 90.

.PARAMETER OutputPath
    Path to the output CSV file. Defaults to ".\inactive-users.csv".

.PARAMETER IncludeDisabled
    If specified, disabled accounts are included in the results. By default
    only enabled accounts are checked, since disabled accounts are expected
    to be inactive.

.EXAMPLE
    .\Export-InactiveADUsers.ps1

.EXAMPLE
    .\Export-InactiveADUsers.ps1 -DaysInactive 60 -OutputPath "C:\Reports\inactive-users.csv"

.NOTES
    Requires the ActiveDirectory PowerShell module (RSAT) and read access
    to the relevant AD attributes. Uses the replicated "LastLogonTimestamp"
    attribute rather than "LastLogon" because LastLogonTimestamp is
    replicated between domain controllers and gives a reasonably accurate
    (though not perfectly real-time) picture domain-wide. It can lag actual
    logon time by up to ~9-14 days by default AD replication settings, so
    treat the 90-day threshold as approximate, not exact to the day.
#>

[CmdletBinding()]
param(
    # Number of days since last logon to consider an account inactive.
    [Parameter(Mandatory = $false)]
    [int]$DaysInactive = 90,

    # Where to write the CSV output.
    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".\inactive-users.csv",

    # Whether to include already-disabled accounts in the results.
    [Parameter(Mandatory = $false)]
    [switch]$IncludeDisabled
)

# ---------------------------------------------------------------------------
# SECTION 1: Import required module
# ---------------------------------------------------------------------------
try {
    Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
    Write-Error "The ActiveDirectory module is not available on this machine. Install RSAT / AD PowerShell tools and try again."
    exit 1
}

# ---------------------------------------------------------------------------
# SECTION 2: Calculate the cutoff date for "inactive"
# ---------------------------------------------------------------------------
# Any account whose last logon is before this date (or has never logged on)
# will be treated as inactive.
$cutoffDate = (Get-Date).AddDays(-$DaysInactive)
Write-Host "Finding users who have not logged on since $($cutoffDate.ToString('yyyy-MM-dd')) (threshold: $DaysInactive days)..." -ForegroundColor Cyan

# ---------------------------------------------------------------------------
# SECTION 3: Query Active Directory for user accounts
# ---------------------------------------------------------------------------
# Pull the attributes we need in one query rather than per-user lookups.
# LastLogonTimestamp is stored as an AD "FileTime" integer and must be
# converted; it can also be $null for accounts that have never logged on.
try {
    $ldapFilter = if ($IncludeDisabled) { "(objectClass=user)" } else { "(&(objectClass=user)(!(userAccountControl:1.2.840.113556.1.4.803:=2)))" }

    $adUsers = Get-ADUser -LDAPFilter $ldapFilter `
        -Properties SamAccountName, DisplayName, LastLogonTimestamp, Department, Manager, Enabled `
        -ErrorAction Stop
}
catch {
    Write-Error "Failed to query Active Directory for users: $($_.Exception.Message)"
    exit 2
}

if (-not $adUsers -or $adUsers.Count -eq 0) {
    Write-Warning "No users were returned from Active Directory. Nothing to export."
    exit 0
}

# ---------------------------------------------------------------------------
# SECTION 4: Filter for inactive users and build export objects
# ---------------------------------------------------------------------------
$inactiveUsers = foreach ($user in $adUsers) {

    # Convert LastLogonTimestamp (FileTime) to a readable DateTime.
    # A $null or 0 value means the account has never logged on.
    if ($user.LastLogonTimestamp) {
        $lastLogonDate = [DateTime]::FromFileTime($user.LastLogonTimestamp)
    }
    else {
        $lastLogonDate = $null
    }

    # A user is "inactive" if they've never logged on, or their last logon
    # is older than the cutoff date.
    $isInactive = (-not $lastLogonDate) -or ($lastLogonDate -lt $cutoffDate)

    if ($isInactive) {

        # Resolve the Manager distinguished name to a friendly display name.
        # Wrapped in try/catch since a stale or broken Manager DN reference
        # shouldn't halt the whole export.
        $managerName = $null
        if ($user.Manager) {
            try {
                $managerName = (Get-ADUser -Identity $user.Manager -Properties DisplayName -ErrorAction Stop).DisplayName
            }
            catch {
                $managerName = "(unable to resolve manager)"
            }
        }

        # Emit a custom object representing one CSV row.
        [PSCustomObject]@{
            Username      = $user.SamAccountName
            DisplayName   = $user.DisplayName
            LastLogonDate = if ($lastLogonDate) { $lastLogonDate.ToString('yyyy-MM-dd HH:mm:ss') } else { 'Never logged on' }
            Department    = $user.Department
            Manager       = $managerName
            Enabled       = $user.Enabled
        }
    }
}

# ---------------------------------------------------------------------------
# SECTION 5: Export results to CSV
# ---------------------------------------------------------------------------
try {
    if ($inactiveUsers) {
        $inactiveUsers | Sort-Object Username | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8 -ErrorAction Stop
    }
    else {
        # Still create an (empty, header-only) CSV so downstream processes
        # relying on the file's existence don't break.
        [PSCustomObject]@{
            Username      = $null
            DisplayName   = $null
            LastLogonDate = $null
            Department    = $null
            Manager       = $null
            Enabled       = $null
        } | Select-Object * | Where-Object { $false } | Export-Csv -Path $OutputPath -NoTypeInformation -Encoding UTF8 -ErrorAction Stop
    }
}
catch {
    Write-Error "Failed to write CSV file at '$OutputPath': $($_.Exception.Message)"
    exit 3
}

# ---------------------------------------------------------------------------
# SECTION 6: Report summary line count
# ---------------------------------------------------------------------------
$count = if ($inactiveUsers) { ($inactiveUsers | Measure-Object).Count } else { 0 }

Write-Host "Export complete: $OutputPath" -ForegroundColor Green
Write-Host "Total inactive users exported: $count" -ForegroundColor Green
