$End = $False

do{
    $WebResponse = Invoke-WebRequest "https://itch.io/games/new-and-popular/free/tag-adult"
    $arrFreeAdultGames = $WebResponse.AllElements | Where-Object {$_.Class -eq "title game_link"}

    Write-Host "********************************************************"
    Write-Host "Latest game on Itch:" $arrFreeAdultGames[0].innerText
    Write-Host ""
    if($strLatestGame -eq $arrFreeAdultGames[0].innerText){
        Write-Host "Already done." -BackgroundColor DarkRed -ForegroundColor White
        Write-Host "No new games, bitch." -BackgroundColor DarkRed -ForegroundColor White
    }else{
        Write-Host "It's new! Check F95Zone." -BackgroundColor Green -ForegroundColor Black
        Write-Host $arrFreeAdultGames[0].innerText
        Write-Host $arrFreeAdultGames[0].href
        Write-Host ""
        Write-Host 'Press any key to continue...'
        $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
    }
    Write-Host ""
    Write-Host "Sleeping for 5 minutes..."
    Write-Host ""

    Start-Sleep -Seconds 300

    $strLatestGame = $arrFreeAdultGames[0].innerText
}until($End -eq $True)