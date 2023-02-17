# Random PS stuff
# File list sort
$objFiles = Get-Content "E:\Upload\gallery-dl\kemonoparty\patreon\CheckerToo\filelist.txt"

foreach($file in $objFiles){
    try{
        Add-Content -Value ($file.substring(0,$file.IndexOf('_'))) -Path "E:\Upload\gallery-dl\kemonoparty\patreon\CheckerToo\files.txt"
    }catch{
        Add-Content -Value $file -Path "E:\Upload\gallery-dl\kemonoparty\patreon\CheckerToo\files.txt"
    }
}