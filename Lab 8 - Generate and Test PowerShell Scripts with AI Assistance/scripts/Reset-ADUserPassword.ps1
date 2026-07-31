<#
.SYNOPSIS
    Resets a single Active Directory user's password to a temporary value
    and forces a password change at the user's next logon.

.DESCRIPTION
    This script accepts a SamAccountName (username), verifies the user
    exists in Active Directory, resets their password to a specified
    temporary value, and sets the "user must change password at next
    logon" flag. It includes error handling for a user-not-found scenario
    and other common failure cases.

.PARAMETER Username
    The SamAccountName of the AD user whose password should be reset.

.PARAMETER TempPassword
    The temporary password to assign. Defaults to a randomly generated
    value if not supplied, which is printed to the console so it can be
    communicated securely to the user.

.EXAMPLE
    .\Reset-ADUserPassword.ps1 -Username "jdoe"

.EXAMPLE
    .\Reset-ADUserPassword.ps1 -Username "jdoe" -TempPassword "P@ssw0rd!2026"

.NOTES
    Requires the ActiveDirectory PowerShell module (RSAT) and permissions
    to reset passwords in the target OU. Run from a machine with the AD
    module installed, as an account with appropriate delegated rights.
#>

[CmdletBinding()]
param(
    # The username (SamAccountName) of the AD account to reset.
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateNotNullOrEmpty()]
    [string]$Username,

    # Optional temporary password. If omitted, one is generated automatically.
    [Parameter(Mandatory = $false)]
    [string]$TempPassword
)

# ---------------------------------------------------------------------------
# SECTION 1: Import required module
# ---------------------------------------------------------------------------
# The ActiveDirectory module provides the Get-ADUser / Set-ADAccountPassword
# cmdlets. If it isn't available (e.g., RSAT not installed), stop early with
# a clear message rather than letting the script fail with a cryptic error.
try {
    Import-Module ActiveDirectory -ErrorAction Stop
}
catch {
    Write-Error "The ActiveDirectory module is not available on this machine. Install RSAT / AD PowerShell tools and try again."
    exit 1
}

# ---------------------------------------------------------------------------
# SECTION 2: Generate a temporary password if one wasn't provided
# ---------------------------------------------------------------------------
# A simple randomized temporary password generator. Adjust length/complexity
# rules to match your domain's password policy.
if (-not $TempPassword) {
    Add-Type -AssemblyName System.Web
    # Generates a 12-character password with at least a few non-alphanumeric chars.
    $TempPassword = [System.Web.Security.Membership]::GeneratePassword(12, 3)
}

# ---------------------------------------------------------------------------
# SECTION 3: Verify the user exists in Active Directory
# ---------------------------------------------------------------------------
# Attempt to look up the user first. This lets us give a clean, specific
# "user not found" error instead of letting the reset cmdlet fail blindly.
try {
    $adUser = Get-ADUser -Identity $Username -ErrorAction Stop
}
catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException] {
    # This specific exception type is thrown when the identity doesn't exist.
    Write-Error "No Active Directory user found with username '$Username'. Please check the username and try again."
    exit 2
}
catch {
    # Catch-all for other lookup failures (e.g., connectivity, permissions).
    Write-Error "An unexpected error occurred while looking up user '$Username': $($_.Exception.Message)"
    exit 3
}

# ---------------------------------------------------------------------------
# SECTION 4: Reset the password and force change at next logon
# ---------------------------------------------------------------------------
try {
    # Convert the plain-text temp password to a SecureString, as required
    # by Set-ADAccountPassword.
    $securePassword = ConvertTo-SecureString -String $TempPassword -AsPlainText -Force

    # Reset the password on the located user object.
    Set-ADAccountPassword -Identity $adUser -NewPassword $securePassword -Reset -ErrorAction Stop

    # Force the user to change their password the next time they log in.
    Set-ADUser -Identity $adUser -ChangePasswordAtLogon $true -ErrorAction Stop

    # Optional: if the account was previously disabled or locked due to
    # password issues, you may also want to unlock it. Uncomment if needed:
    # Unlock-ADAccount -Identity $adUser

    Write-Host "Password for user '$Username' has been reset successfully." -ForegroundColor Green
    Write-Host "Temporary password: $TempPassword" -ForegroundColor Yellow
    Write-Host "The user will be required to change this password at next logon." -ForegroundColor Green
}
catch {
    # Catches issues such as the new password not meeting complexity/length
    # policy, insufficient permissions, or connectivity problems.
    Write-Error "Failed to reset password for user '$Username': $($_.Exception.Message)"
    exit 4
}
