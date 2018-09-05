[CmdletBinding()]
param()

$goldMirror = "\\TFSShares\NuGet DEV Repository\BTO\Gold";
$goldSource = "\\TFSShares\NuGet\Production";

$regex = "^(.*?)\.((?:\.?[0-9]+){2,}(?:[-a-zA-Z0-9]+)?)\.nupkg$";

Get-ChildItem -Path $goldSource -Filter "*.nupkg" | 
    ForEach-Object {
       
        if($_.Name -match $regex)
        {
            $basePackagePath = Join-Path -Path $goldMirror -ChildPath $Matches[1];
            if(Test-Path -Path $basePackagePath -PathType Container)
            {
                if(!($Matches[2].Contains("-")))
                {
                    $v = [Version]::Parse($Matches[2]);
                    $packageVersion = $v.ToString();
                    
                    if($v.Build -eq -1)
                    {
                        $packageVersion = [Version]::new($v.Major, $v.Minor, 0).ToString();
                    }
                    
                    $packageVersionPath = Join-Path -Path $basePackagePath -ChildPath $packageVersion;
                    if(Test-Path -Path $packageVersionPath -PathType Container)
                    {
                        Write-Verbose ("Existing version found: {0}" -f $_.Name);
                    }
                    else 
                    {
                        if($packageVersionPath.EndsWith(".0"))
                        {
                            $nonZeroBuildorPatch = $packageVersionPath.Remove($packageVersionPath.Length - 2);
                            if(Test-Path -Path $nonZeroBuildorPatch -PathType Container)
                            {
                                Write-Verbose ("Existing version found: {0}" -f $_.Name);
                            }
                            else 
                            {
                                Write-Verbose ("New version: {0}" -f $_.Name);
                                Write-Output ("Copying new version: {0}" -f $_.Name);
                                Copy-Item -Path $_.FullName -Destination $goldMirror -Force;
                            }
                        }
                        else 
                        {
                            Write-Verbose ("New version: {0}" -f $_.Name);
                            Write-Output ("Copying new version: {0}" -f $_.Name);
                            Copy-Item -Path $_.FullName -Destination $goldMirror -Force;
                        }
                    }
                }
                else 
                {
                    Write-Warning ("Unstable package: {0}" -f $_.Name);
                }
            }
            else 
            {
                Write-Verbose ("New package found: {0}" -f $_.Name);
                Write-Output ("Copying new package: {0}" -f $_.Name);
                Copy-Item -Path $_.FullName -Destination $goldMirror -Force;
            }
        }
        else 
        {
            Write-Warning ("Invalid package: {0}" -f $_.Name);
        }
    };




