#copyright: Ryan Hoffman https://gist.github.com/tekmaven/041a205276bf4d26e8f9#file-install-mongodb-on-appveyor-ps1

#Make sure 7za is installed
choco install 7zip.commandline

# Create mongodb and data directory
md $env:temp\mongo\data

# Go to mongodb dir
Push-Location $env:temp\mongo

# Download zipped mongodb binaries to mongodbdir
Invoke-WebRequest https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-2.6.5.zip -OutFile mongodb.zip

# Extract mongodb zip
cmd /c 7za e mongodb.zip

# Install mongodb as a windows service
cmd /c $env:temp\mongo\mongod.exe --logpath=$env:temp\mongo\log --dbpath=$env:temp\mongo\data\ --smallfiles --install

# Sleep as a hack to fix an issue where the service sometimes does not finish installing quickly enough
Start-Sleep -Seconds 5

# Start mongodb service
net start mongodb

# add this dir to path
Clear-Host
$AddedLocation ="$env:temp\mongo\"
$Reg = "Registry::HKLM\System\CurrentControlSet\Control\Session Manager\Environment"
$OldPath = (Get-ItemProperty -Path "$Reg" -Name PATH).Path
$NewPath = $OldPath + ';' + $AddedLocation
Set-ItemProperty -Path "$Reg" -Name PATH -Value $NewPath
# Return to last location, to run the build
Pop-Location

Write-Host
Write-Host "monogdb installation complete"
