# Author: Nathan Duckett
# This script assumes it is running as Admin User.

if ($args.length != 2) {
    Write-Output "Invalid arguments provided - Expects install_gitlab_ci.ps1 <ci_url> <ci_token>"
    exit 1
}

$URL=$args[0]
$TOKEN=$args[1]

mkdir C:\Gitlab-Runner
cd C:\Gitlab-Runner
# Download and install Gitlab runner
wget https://gitlab-runner-downloads.s3.amazonaws.com/latest/binaries/gitlab-runner-windows-amd64.exe # TODO: Verify this is working as expected WGET doesn't seem to work
mv gitlab-runner-windows-amd64.exe gitlab-runner.exe
.\gitlab-runner.exe install
.\gitlab-runner.exe start

#TODO: Register the runner with CLI parameters
.\gitlab-runner register \
  --non-interactive \
  --url "$URL" \
  --registration-token "$TOKEN" \
  --executor "shell" \
  --description "[Anton-Windows] Gitlab shell runner to execute on server" \
  --tag-list "windows,shell" \
  --run-untagged="true" \
  --locked="true" \
  --access-level="not_protected"
