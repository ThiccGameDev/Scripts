# Ultimate File Uploader for F95
# Created by ThiccLover/ThiccStudios
# Any issues, DM me: ThiccLover#7045

param(
    [Parameter(Mandatory=$True)][string]$File,
    [bool]$A = $true,
    [bool]$G = $true,
    [bool]$M = $true,
    [bool]$P = $true,
    [bool]$T = $false
)

Clear-Host

# Sets filename (do not edit)
$arrFileSplit = $File.Split("\")
$int = $arrFileSplit.Count - 1
$strFileName = $arrFileSplit[$int]
$strFileName = $strFileName -replace (' ', '-')

## Variables (EDIT BEFORE USING)
# Upload Links Text File
$strLogLocation = 'E:\Upload\' # Change to preferred text location

Write-Host ('UPLOADING: ' + $strFileName)

New-Variable -Name 'strInfo' -Value ('Starting Uploader')
$strTemp = ((Get-Variable -Name strInfo -ValueOnly)+"`r`nUploading "+$strFileName)
Set-Variable -Name strInfo -Value $strTemp

New-Variable -Name 'strLinks' -Value ("`r`nDownload links:")

New-Variable -Name 'strBBCode' -Value ("`r`nDownload links (BBCODE):")
$strTemp = ((Get-Variable -Name strBBCode -ValueOnly)+"`r`n[SIZE=6]")
Set-Variable -Name strBBCode -Value $strTemp

$strMaxTries = 'The maximum number of retries has been reached, moving on to next upload.'

$dateFull = (Get-Date -Format 'ddMMyyyy')
$timeFull = (Get-Date -Format 'HHmm')

# Mixdrop API (See https://mixdrp.to/api/)
$MixEmail = 'thiccstudios@outlook.com' # Mixdrop email
$MixAPI = 'GaBgXvYlaqWOenyfwDA2' # Mixdrop AP

## MAIN SCRIPT
$strLog = ($strLogLocation + 'Uploader-' + $dateFull + '-' + $timeFull + '-' + $strFileName + '.txt')
$null = New-Item $strLog

# UPLOAD: Anonfiles
Write-Host ''
$strSection = 'ANONFILES'
if($A){
    Write-Host ('== ' + $strSection + ' ==')
    # Check if ANONFILES is up
    $strAnonUri = 'https://api.anonfiles.com/upload'
    try{
        Write-Host ('Checking if ' + $strSection + ' is up...')
        $null = Invoke-WebRequest -Uri 'https://api.anonfiles.com'
        Write-Host ('Success! Response received from ' + $strSection + ', continuing to upload') -BackgroundColor Green -ForegroundColor Black
        $boolAFUp = $true
    }catch{
        Write-Host ($strSection + ' is down, skipping') -BackgroundColor DarkRed -ForegroundColor White
        $boolAFUp = $false
    }

    if($boolAFUp){
        Write-Host ('Uploading to ' + $strSection)
        $boolAFDone = $false
        $i = 0
        while(($boolAFDone -eq $false) -and ($i -lt 4)){
            try{
                $i++
                $objAnonUpload = curl.exe -F "file=@$File" $strAnonUri
                $objAnonUpload = ConvertFrom-Json -InputObject $objAnonUpload
                $strAnonURL = $objAnonUpload.data.file.url.short
                $boolAFDone = $true
            }catch{
                # Record error and retry
                $strAFFail = ('Failed to upload to ' + $strSection + '.' + "`n" + '  Error: ' + $_.Exception.Message)
                Write-Host $strAFFail -BackgroundColor DarkRed -ForegroundColor White
                $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strAFFail)
                Set-Variable -Name strInfo -Value $strTemp
                Write-Host ('Retrying '+ $strSection + ' upload...')
            }
        }

        if($i -eq 4){
            Write-Host $strMaxTries -BackgroundColor DarkRed -ForegroundColor White
            $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strMaxTries)
            Set-Variable -Name strInfo -Value $strTemp
        }else{
            $strTemp = ((Get-Variable strBBCode -ValueOnly)+"[URL=`'" + $strAnonURL + "`']ANONFILES[/URL] - ")
            Set-Variable -Name strBBCode -Value $strTemp

            $strTemp = ((Get-Variable strLinks -ValueOnly)+"`r`n"+$strAnonURL)
            Set-Variable -Name strLinks -Value $strTemp
            Write-Host ($strSection + ' complete') -BackgroundColor Green -ForegroundColor Black
        }
    }
}else{
    Write-Host ($strSection + ' set to false, skipping upload')
}

# UPLOAD: GOFILE
Write-Host ''
$strSection = 'GOFILE'
if($G){
    Write-Host ('== ' + $strSection + ' ==')
    # Check if GOFILE is up
    try{
        Write-Host ('Checking if ' + $strSection + ' is up...')
        $null = Invoke-WebRequest -Uri 'https://api.gofile.io/'
        Write-Host ('Success! Response received from ' + $strSection + ', continuing to upload') -BackgroundColor Green -ForegroundColor Black
        $boolGFUp = $true
    }catch{
        Write-Host ($strSection + ' is down, skipping') -BackgroundColor DarkRed -ForegroundColor White
        $boolGFUp = $false
    }

    if($boolGFUp){
        $null = $objBestServer = curl.exe https://api.gofile.io/getServer

        $objBestServer = ConvertFrom-Json -InputObject $objBestServer
        $strGofServer = $objBestServer.data.server
        $strGofUri = ('https://'+$strGofServer+'.gofile.io/uploadFile')
        
        Write-Host ('Uploading to ' + $strSection)
        $boolGFDone = $false
        $i = 0
        while(($boolGFDone -eq $false) -and ($i -lt 4)){
            try{
                $i++
                $objGofUpload = curl.exe -F "file=@$File" $strGofUri
                $objGofUpload = ConvertFrom-Json -InputObject $objGofUpload
                $strGofURL = $objGofUpload.data.downloadPage
                $boolGFDone = $true
            }catch{
                # Record error and retry
                $strGFFail = ('Failed to upload to ' + $strSection + '.' + "`n" + '  Error: ' + $_.Exception.Message)
                Write-Host $strGFFail -BackgroundColor DarkRed -ForegroundColor White
                $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strGFFail)
                Set-Variable -Name strInfo -Value $strTemp
                Write-Host ('Retrying '+ $strSection + ' upload...')
            }
        }

        if($i -eq 4){
            Write-Host $strMaxTries -BackgroundColor DarkRed -ForegroundColor White
            $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strMaxTries)
            Set-Variable -Name strInfo -Value $strTemp
        }else{
            $strTemp = ((Get-Variable strBBCode -ValueOnly)+"[URL=`'" + $strGofURL + "`']GOFILE[/URL] - ")
            Set-Variable -Name strBBCode -Value $strTemp
            Write-Host ($strSection + ' complete') -BackgroundColor Green -ForegroundColor Black
        }
    }
}else{
    Write-Host ($strSection + ' set to false, skipping upload')
}

# UPLOAD: MIXDROP
Write-Host ''
$strSection = 'MIXDROP'
if($M){
    Write-Host ('== ' + $strSection + ' ==')
    # Check if MIXDROP is up
    $strMixUri = 'https://ul.mixdrop.co/api'
    try{
        Write-Host ('Checking if ' + $strSection + ' is up...')
        $null = Invoke-WebRequest -Uri $strMixUri
        Write-Host ('Success! Response received from ' + $strSection + ', continuing to upload') -BackgroundColor Green -ForegroundColor Black
        $boolMDUp = $true
    }catch{
        Write-Host ($strSection + ' is down, skipping') -BackgroundColor DarkRed -ForegroundColor White
        $boolMDUp = $false
    }

    if($boolMDUp){
        if($null -eq $MixEmail -or $null -eq $MixAPI){
            Write-Host ""
            Write-Host ($strSection + ' requires email and API key to use REST upload, skipping') -BackgroundColor DarkRed
        }else{
            Write-Host ('Uploading to ' + $strSection)
            $boolMDDone = $false
            $i = 0
            while(($boolMDDone -eq $false) -and ($i -lt 4)){
                try{
                    $i++
                    $objMixUpload = curl.exe -X POST -F "email=$MixEmail" -F "key=$MixAPI" -F "file=@$File" $strMixUri
                    $objMixUpload = ConvertFrom-Json -InputObject $objMixUpload
                    $strMixURL = ('https://mixdrp.to/f/' + $objMixUpload.result.fileref)
                    $boolMDDone = $true
                }catch{
                    # Record error and retry
                    $strMDFail = ('Failed to upload to ' + $strSection + '.' + "`n" + '  Error: ' + $_.Exception.Message)
                    Write-Host $strMDFail -BackgroundColor DarkRed -ForegroundColor White
                    $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strMDFail)
                    Set-Variable -Name strInfo -Value $strTemp
                    Write-Host ('Retrying '+ $strSection + ' upload...')
                }
            }

            if($i -eq 4){
                Write-Host $strMaxTries -BackgroundColor DarkRed -ForegroundColor White
                $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strMaxTries)
                Set-Variable -Name strInfo -Value $strTemp
            }else{
                $strTemp = ((Get-Variable strBBCode -ValueOnly)+"[URL=`'" + $strMixURL + "`']MIXDROP[/URL] - ")
                Set-Variable -Name strBBCode -Value $strTemp
                Write-Host ($strSection + ' complete') -BackgroundColor Green -ForegroundColor Black
            }
        }
    }
}else{
    Write-Host ($strSection + ' set to false, skipping upload')
}

# UPLOAD: PIXELDRAIN
Write-Host ''
$strSection = 'PIXELDRAIN'
if($P){
    Write-Host ('== ' + $strSection + ' ==')
    # Check if PIXELDRAIN is up
    try{
        Write-Host ('Checking if ' + $strSection + ' is up...')
        $null = Invoke-WebRequest -Uri 'https://pixeldrain.com/api/'
        Write-Host ('Success! Response received from ' + $strSection + ', continuing to upload') -BackgroundColor Green -ForegroundColor Black
        $boolPDUp = $true
    }catch{
        Write-Host ($strSection + ' is down, skipping') -BackgroundColor DarkRed -ForegroundColor White
        $boolPDUp = $false
    }

    if($boolPDUp){
        Write-Host ('Uploading to ' + $strSection)
        $strPixUri = ("https://pixeldrain.com/api/file/" + $strFileName)

        $boolPDDone = $false
        $i = 0
        while(($boolPDDone -eq $false) -and ($i -lt 4)){
            try{
                $i++
                $objPixUpload = curl.exe -X PUT -F "name=$strFileName" -F "file=@$File" $strPixUri
                $objPixUpload = ConvertFrom-Json -InputObject $objPixUpload
                $strPixURL = 'https://pixeldrain.com/u/' + $objPixUpload.id
                $boolPDDone = $true
            }catch{
                # Record error and retry
                $strPDFail = ('Failed to upload to ' + $strSection + '.' + "`n" + '  Error: ' + $_.Exception.Message)
                Write-Host $strPDFail -BackgroundColor DarkRed -ForegroundColor White
                $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strPDFail)
                Set-Variable -Name strInfo -Value $strTemp
                Write-Host ('Retrying '+ $strSection + ' upload...')
            }
        }

        if($i -eq 4){
            Write-Host $strMaxTries -BackgroundColor DarkRed -ForegroundColor White
            $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strMaxTries)
            Set-Variable -Name strInfo -Value $strTemp
        }else{
            $strTemp = ((Get-Variable strBBCode -ValueOnly)+"[URL=`'" + $strPixURL + "`']PIXELDRAIN[/URL] - ")
            Set-Variable -Name strBBCode -Value $strTemp
            Write-Host ($strSection + ' complete') -BackgroundColor Green -ForegroundColor Black
        }
    }
}else{
    Write-Host ($strSection + ' set to false, skipping upload')
}

# UPLOAD: TRANSFER.SH
Write-Host ''
$strSection = 'TRANSFER.SH'
if($T){
    Write-Host ('== ' + $strSection + ' ==')
    # Check if TRANSFER.SH is up
    try{
        Write-Host ('Checking if ' + $strSection + ' is up...')
        $null = Invoke-WebRequest -Uri 'https://transfer.sh'
        Write-Host ('Success! Response received from ' + $strSection + ', continuing to upload') -BackgroundColor Green -ForegroundColor Black
        $boolTSHUp = $true
    }catch{
        Write-Host ($strSection + ' is down, skipping') -BackgroundColor DarkRed -ForegroundColor White
        $boolTSHUp = $false
    }

    if($boolTSHUp){
        Write-Host ('Uploading to ' + $strSection)
        $strTSHUri = ('https://transfer.sh/' + $strFileName)

        $boolTSHDone = $false
        $i = 0
        while(($boolTSHDone -eq $false) -and ($i -lt 4)){
            try{
                $i++
                $objTSHUpload = curl.exe --upload-file $File $strTSHUri
                $boolTSHDone = $true
            }catch{
                # Record error and retry
                $strTSHFail = ('Failed to upload to ' + $strSection + '.' + "`n" + '  Error: ' + $_.Exception.Message)
                Write-Host $strTSHFail -BackgroundColor DarkRed -ForegroundColor White
                $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strTSHFail)
                Set-Variable -Name strInfo -Value $strTemp
                Write-Host ('Retrying '+ $strSection + ' upload...')
            }
        }

        if($i -eq 4){
            Write-Host $strMaxTries -BackgroundColor DarkRed -ForegroundColor White
            $strTemp = ((Get-Variable strInfo -ValueOnly)+"`r`n"+$strMaxTries)
            Set-Variable -Name strInfo -Value $strTemp
        }else{
            $strTemp = ((Get-Variable strBBCode -ValueOnly)+"[URL=`'" + $objTSHUpload + "`']TRANSFER.SH[/URL] - ")
            Set-Variable -Name strBBCode -Value $strTemp
            Write-Host ($strSection + ' complete') -BackgroundColor Green -ForegroundColor Black
        }
    }
}else{
    Write-Host ($strSection + ' set to false, skipping upload')
}

# Remove trailing '-'
$strTemp = (Get-Variable strBBCode -ValueOnly) -replace ".{3}$"
Set-Variable -Name strBBCode -Value $strTemp

# Add [/SIZE] to end
$strTemp = ((Get-Variable strBBCode -ValueOnly)+"[/SIZE]")
Set-Variable -Name strBBCode -Value $strTemp

Add-Content $strLog -Value $strInfo
Add-Content $strLog -Value $strBBCode

# Opens notepad and log
$null = Start-Process notepad.exe $strLog