# Thicc Auto Sorter
param(
    [string]$Source = 'E:\Upload\thethiccart'
)

# Looking for GIFs
$objGIFs = Get-ChildItem -Path $Source -Recurse | Where-Object {$_.Extension -eq ".gif"}
foreach($GIF in $objGIFs){
    $strYear = (Get-Date $GIF.LastWriteTime -Format "yyyy")
    $strMonthNum = (Get-Date $GIF.LastWriteTime -Format "MM")
    $strMonthWord = (Get-Date $GIF.LastWriteTime -Format "MMM")
    $strDest = ($Source + '\Sorted\' + $strYear + '\' +$strMonthNum + '-' + $strMonthWord + '\GIF')
    if(!(Test-Path $strDest)){
        New-Item -Path $strDest -ItemType Directory -Force
    }
    Move-Item -Path $GIF.FullName -Destination $strDest
}

# Looking for JPGs
$objJPGs = Get-ChildItem -Path $Source -Recurse | Where-Object {$_.Extension -eq ".jpg" -or $_.Extension -eq ".jpeg"}
foreach($JPG in $objJPGs){
    $strYear = (Get-Date $JPG.LastWriteTime -Format "yyyy")
    $strMonthNum = (Get-Date $JPG.LastWriteTime -Format "MM")
    $strMonthWord = (Get-Date $JPG.LastWriteTime -Format "MMM")
    $strDest = ($Source + '\Sorted\' + $strYear + '\' +$strMonthNum + '-' + $strMonthWord + '\Image')
    if(!(Test-Path $strDest)){
        New-Item -Path $strDest -ItemType Directory -Force
    }
    Move-Item -Path $JPG.FullName -Destination $strDest
}

# Looking for PNGs
$objPNGs = Get-ChildItem -Path $Source -Recurse | Where-Object {$_.Extension -eq ".png"}
foreach($PNG in $objPNGs){
    $strYear = (Get-Date $PNG.LastWriteTime -Format "yyyy")
    $strMonthNum = (Get-Date $PNG.LastWriteTime -Format "MM")
    $strMonthWord = (Get-Date $PNG.LastWriteTime -Format "MMM")
    $strDest = ($Source + '\Sorted\' + $strYear + '\' +$strMonthNum + '-' + $strMonthWord + '\Image')
    if(!(Test-Path $strDest)){
        New-Item -Path $strDest -ItemType Directory -Force
    }
    Move-Item -Path $PNG.FullName -Destination $strDest
}

# Looking for Movies
$objMOVs = Get-ChildItem -Path $Source -Recurse | Where-Object {$_.Extension -eq ".mp4" `
    -or $_.Extension -eq ".avi" `
    -or $_.Extension -eq ".mkv" `
    -or $_.Extension -eq ".mov"
}
foreach($MOV in $objMOVs){
    $strYear = (Get-Date $MOV.LastWriteTime -Format "yyyy")
    $strMonthNum = (Get-Date $MOV.LastWriteTime -Format "MM")
    $strMonthWord = (Get-Date $MOV.LastWriteTime -Format "MMM")
    $strDest = ($Source + '\Sorted\' + $strYear + '\' +$strMonthNum + '-' + $strMonthWord + '\Movie')
    if(!(Test-Path $strDest)){
        New-Item -Path $strDest -ItemType Directory -Force
    }
    Move-Item -Path $MOV.FullName -Destination $strDest
}

[timespan]$totalTime
$shell = New-Object -ComObject Shell.Application
foreach($MOV in $objMOVs){
    $folderObject = $shell.NameSpace($MOV.DirectoryName)
    $fileObject = $folderObject.ParseName($Mov.Name)
    $movLength = $folderobject.GetDetailsOf($fileObject,27)
    $totalTime += ([timespan]::Parse($movLength)).TotalSeconds
}

$objTotal = Get-ChildItem -Path ($Source +'\Sorted') -Directory
$arrSize = @()
foreach($item in $objTotal){
    $objYear = Get-ChildItem -Path $item.FullName -Directory
    foreach($month in $objYear){
        $size = (Get-ChildItem $month.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
        $tmp = [PSCustomObject]@{
            Year = $item.Name
            Folder = $month.Name
            Path = $month.FullName
            Size = $size
        }
        $arrSize += $tmp
    }
}


# Below is WIP for grouping
# However, the folder sizes are too big
foreach($item in $arrSize){
    $itemSizeGB = "{0:N2} GB" -f ($item.Size / 1GB)
    if($item.Size -gt 10200547328){
        Write-Host ('Folder: ' + $item.Path + ' is too big ' + $itemSizeGB)
        $subFolders = Get-ChildItem $item.Path -Recurse -Directory
        foreach($folder in $subFolders){
            $size = (Get-ChildItem $folder.FullName -Recurse | Measure-Object -Property Length -Sum).Sum
            $sizeGB = "{0:N2} GB" -f ($size / 1GB)
            Write-Host ('Folder ' + $folder.Name + ' size: ' + $sizeGB)
        }
    }else{
        Write-Host ('Folder: ' + $item.Path + ' is ' + $itemSizeGB)
    }
}

$SumSize = 0
$i = 0
$htZips = @{}
$group = @()
foreach($item in $arrSize){
    if(($SumSize += $item.Size) -gt 10200547328){
        $group | Add-Member -MemberType NoteProperty -Name "Total" -Value $SumSize
        $htZips[$i] += $group
        $i++
    }else{
        $SumSize += $item.Size
        $groupLine = New-Object psobject -Property @{
            Group = $i
            Folder = $item.Folder
            Size = $item.Size
        }
        $group += $groupLine
    }
}

$htGroup = @{}
foreach($item in $arrSize){
    $htGroup.Add("Name", $item.Path)
    $htGroup.Add("")
    if($SumSize -gt 10200547328){
        Group-Object
    }
}

$SumSizeGB = "{0:N2} GB" -f ($SumSize / 1GB)