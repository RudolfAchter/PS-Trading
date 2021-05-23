$global:thisModuleName = "AlphaVantage"

<#
    AlphaVantage macht nur Aktien. Scheinbar aber kein Crypo.
    - https://www.alphavantage.co/documentation/
    
    Aber Für Krypto hab ich die messari.io Api gefunden
    - https://messari.io/api/docs
#>

if ($null -ne $env:HOME) {
    #Linux
    #Unter Linux sind die Default Pfade anders 
    #TODO (ich glaube auch in Powershell Core 7?) muss ich mir anschauen
    $Global:PowershellConfigDir = ($env:HOME + "/.local/share/powershell/config")
}
elseif ($null -ne $env:USERPROFILE) {
    #Windows
    #ProgramData Override Wenn ich eine Globale Konfig in ProgramData gesetzt habe
    #TODO evtl noch umbauen. Erst Default Global Config, dann darf der User "Override" machen.
    #Dann braucht der User aber auch ein Cmdlet mit dem er das steuern kann
    if (Test-Path ($env:ProgramData + "\WindowsPowerShell\Config\" + $global:thisModuleName + ".config.ps1")) {
        #Wenn die ProgramData Config existiert dann zählt die einfach für ALLE
        $Global:PowershellConfigDir = ($env:ProgramData + "\WindowsPowerShell\Config")
    }
    else {
        #Ansonsten die User spezifische Konfig nehmen
        $Global:PowershellConfigDir = ($env:USERPROFILE + "\Documents\WindowsPowerShell\Config")
    }
}


If (-not (Test-Path $Global:PowershellConfigDir)) {
    mkdir $Global:PowershellConfigDir
}

#Konfig File schreiben
If (-not (Test-Path ($Global:PowershellConfigDir + "\" + $global:thisModuleName + ".config.ps1"))) {
    Set-Content -Path ($Global:PowershellConfigDir + "\" + $global:thisModuleName + ".config.ps1") -Value (@'
$Global:AlphaVantage=@{
    ApiKey="YourApiKey"
    ApiDefaultThrottle=12
    StartChartsUrl="https://www.etoro.com/app/procharts?instruments="
}
'@)


}
#Wenn Konfig File bereits existiert, Konfig File holen
else {
    . ($Global:PowershellConfigDir + "\" + $global:thisModuleName + ".config.ps1")
}



$Global:AlphaVantageAutoCompleters = @{
    Symbol={
        param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

        $results = @()

        #Wir suchen Online nur wenn wir mehr als 3 Zeichen haben
        if ($wordToComplete.length -ge 3) {
            $results = Search-Market -Search $wordToComplete
            $results | ForEach-Object {
                $result = $_
                ('"' + $result.Symbol + '" <#' + $result.Name + " // " + $result.Region +" // " + $result.Currency +'#>')
            }

        }
        else {
            "<# Please Enter minimum 3 Chars #>"
        }
    }
}


function _Check-ApiResult {

    param(
        $result
    )

    #Auf Fehler prüfen
    if($null -eq $result){
        Write-Error("Kein Ergebnis für '" + $s_symbol + "'")
        return $false
    }

    #Eine Note bekomme ich vom Anbieter wenn ich z.B. die API Calls überschritten habe
    if($null -ne $result.'Error Message'){
        Write-Error($result.'Error Message')
        return $false
    }

    #Eine Note bekomme ich vom Anbieter wenn ich z.B. die API Calls überschritten habe
    if($null -ne $result.Note){
        Write-Error($result.Note)
        return $false
    }

    return $true

}


Class TradeSymbol{
    $Symbol
    $Name
    $Type
    $Region
    $MarketOpen
    $MarketClose
    $TimeZone
    $Currency
    $MatchScore
}

function Search-Market {
<#
.SYNOPSIS
Sucht nach einer Aktie

.DESCRIPTION
Sucht nach einer Aktie. Kann nach Währung gefiltert werden

.PARAMETER Search
Suchbegriff oder Symbol. gesuchte Aktie muss mit dem
Suchbegriff BEGINNEN

"Lufthansa" findet NICHT "Deutsche Lufthansa AG"

Aber z.B. "Deutsche Luft" findet "Deutsche Lufthansa AG"


.PARAMETER Currency
Kurzbezeichung der Währung (z.B. EUR | USD) 

.EXAMPLE
Search-Market -Search "Deutsche Luft"

.EXAMPLE
Search-Market -Search "Deutsche Luft" -Currency USD

.NOTES
General notes

.LINK
https://www.alphavantage.co/documentation/#symbolsearch
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        $Search,
        $Currency
    )
    
    #$data=Invoke-RestMethod -Uri ("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=5min&apikey=" + $ApiKey)
    $s_search=[System.Web.HttpUtility]::UrlEncode($Search) 
    $data=Invoke-RestMethod -Uri ("https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=" + $s_search + "&apikey=" + $Global:AlphaVantage.ApiKey)
    $data.bestMatches | ForEach-Object {
        $obj=[TradeSymbol]@{
            Symbol      = $_."1. symbol"
            Name        = $_."2. name"
            Type        = $_."3. type"
            Region      = $_."4. region"
            MarketOpen  = $_."5. marketOpen"
            MarketClose = $_."6. marketClose"
            TimeZone    = $_."7. timezone"
            Currency    = $_."8. currency"
            MatchScore  = $_."9. matchScore"
        }

        #Ausgabe evtl nach Währung gefiltert
        if($null -ne $Currency){
            $obj | Where-Object {$_.Currency -eq $Currency}
        }
        else{
            $obj
        }
    }


    #$MatchScore
}


Class TradeSymbolValue{
    #$Object
    $Symbol
    [float]$Open
    [float]$High
    [float]$Low
    [float]$Price
    [bigint]$Volume
    $LatestTradingDay
    [float]$PreviousClose
    [float]$Change
    [float]$ChangePercent
}

function Get-MarketValue {
<#
.SYNOPSIS
Holt den aktuellen Wert einer Aktie

.DESCRIPTION
Holt den aktuellen Wert einer Aktie

.PARAMETER Symbol
Symbol (ID) der Aktie

.EXAMPLE
An example

.NOTES
In der Freien Version gehen nur 5 API Calls pro Minute
500 pro Tag

das ist einer in 172,8 Sekunden
Also machen wir nur einen Call in 3 Minuten
bzw Eine Abfrage pro 5 Minuten ist in Ordnung

.LINK
https://www.alphavantage.co/documentation/#latestprice
#>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $Symbol,
        
        [ValidateSet(
            0,
            12, # 60/5 - 5 Calls pro Minute
            180 # 500 Calls pro Tag
        )]
        $Throttle=$Global:AlphaVantage.ApiDefaultThrottle
    )
    
    begin {
        $a_symbols=@()
    }
    
    process {
        $Symbol | ForEach-Object {
            $o_symbol=$_
            if($o_symbol.GetType().Name -ne "String"){
                $s_symbol=$o_symbol.Symbol
            }
            else{
                $s_symbol=$o_symbol
            }
            $a_symbols+=$s_symbol
        }
    }
    
    end {
        $i=1
        $a_symbols | ForEach-Object {
            $s_symbol=$_
            
            <#
            $result=Invoke-RestMethod -Uri ("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=" + $s_symbol + "&interval=" + $Interval + "&apikey=" + $Global:AlphaVantage.ApiKey)
            $result."Time Series (1min)"
            #>
            #https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo
            $result=Invoke-RestMethod -Uri ("https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=" + $s_symbol + "&apikey=" + $Global:AlphaVantage.ApiKey)

            if( -not (_Check-ApiResult -result $result)){
                return
            }
            #Spezifischer Check für MarketValue
            if($result.'Global Quote'.'01. symbol' -ne $s_symbol){
                Write-Error("'" + $s_symbol + "' nicht gefunden")
                return $false
            }
            #Wenn ich durch alle Checks durch bin



            $result."Global Quote" | ForEach-Object {
                [TradeSymbolValue]@{
                    Symbol              = $_."01. symbol"
                    Open                = $_."02. open"
                    High                = $_."03. high"
                    Low                 = $_."04. low"
                    Price               = $_."05. price"
                    Volume              = $_."06. volume"
                    LatestTradingDay    = $_."07. latest trading day"
                    PreviousClose       = $_."08. previous close"
                    Change              = $_."09. change"
                    ChangePercent       = $_."10. change percent" -replace '%',''
                } 
            }

            #Wenn wir durch die Gratis-Api gebremst werden
            if($Throttle -gt 0){
                Write-Progress -Activity "Getting Data" -Status ("Throttled to one call per $Throttle seconds - Call $i of " + $a_symbols.Count) `
                    -PercentComplete ($i / $a_symbols.Count * 100) -SecondsRemaining (($a_symbols.Count - ($i - 1)) * $Throttle)

                Start-Sleep -Seconds $Throttle
            }

            $i++ 
        }
    }
}


function Start-ProCharts {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $Symbol
    )
    
    begin {
        $a_symbols=@()
    }
    
    process {
        $Symbol | ForEach-Object {
            #Wir brauchen symbol als String
            $o_symbol=$_
            if($o_symbol.GetType().Name -ne "String"){
                $s_symbol=$o_symbol.Symbol
            }
            else{
                $s_symbol=$o_symbol
            }

            $a_symbols+=$s_symbol

        }
    }
    
    end {
            $url_param=[System.Web.HttpUtility]::UrlEncode(($a_symbols -join ","))
            $url="https://www.etoro.com/app/procharts?instruments="+ $url_param
            Write-Host($url)
            #https://www.etoro.com/app/procharts?instruments=LHA.DE,BLDP,OTLY,1810.HK,MRNA,XLM
            Start-Process -FilePath $url
    }
}


Class MarketAnalyzeEntry {
    $Symbol
    $Indicator
    $LastRefreshed
    $Interval
    $TimePeriod
    $SeriesType
    $TimeZone
    $LastRsi
    $MarketTrend
    $Signal
    $RsiSeries
}


function Get-MarketRSI {
<#
.SYNOPSIS
Liefert RSI einer Aktie
- https://en.wikipedia.org/wiki/Relative_strength_index

.DESCRIPTION
Liefert RSI einer Aktie

Standard Markt:
RSI über 70 -> Verkaufen Signal
RSI unter 30 -> Kaufen Signal

Aufwärts (Bull) Trend
RSI über 80 -> Verkaufen Signal
RSI unter 40 -> Kaufen Signal

Abwärts (Bear) Trend
RSI über 60 -> Verkaufen Signal
RSI unter 20 -> Kaufen Signal

natürlich selbst noch abwägen

.PARAMETER Symbol
Symbol (Kurzname der Aktie)

.PARAMETER Interval
Messintervalle (Funktioniert gut mit daily bei Aktien)

.PARAMETER TimePeriod
Zeitraum der Analysiert wird. Nach "Wilder" sind 14
Tage mit einem "daily" Interval ein Typischer Wert

.PARAMETER SeriesType
Mit welchem Wert aus der API Rechnen
"close","open","high","low"

.PARAMETER Throttle
Die AlphaVantage API ist in der "Free" Version eingeschränkt auf
Ein Call pro 12 Sekunden    # 60/5 - 5 Calls pro Minute für Kurze Angelegenheiten
Ein Call pro 180 Sekunden   # 500 Calls pro Tag -> wenn du eine
                            # Query über den ganzen Tag brauchst

.EXAMPLE
Get-MarketRSI HDD.DE -TimePeriod 14

.EXAMPLE
Get-MarketRSI -Symbol BYND

.EXAMPLE
Get-MarketRSI -Symbol LHA.DE -Graph -GraphPoints 70 -YAxisStep 2 -MarketTrend Bear

# Symbol        : LHA.DE
# Indicator     : Relative Strength Index (RSI)
# LastRefreshed : 2021-05-21
# Interval      : daily
# TimePeriod    : 14
# SeriesType    : open
# TimeZone      : US/Eastern Time
# LastRsi       : 38.1439
# MarketTrend   : Bear
# Signal        : Hold
# RsiSeries     : {38.1439, 49.4518, 48.4379, 47.4594...}
# 
# ┌ Relative Strength Index (RSI) ───────────────────────────────────────────────┐
# │                                                                              │
# │   74┤                                                           █         ▐  │
# │   72┤                                                       ██ ▐▐         ▐  │
# │   70┤                                                      █ ▐█▐▐         ▐  │
# │   68┤                                                     ▐   ▐▐ █        ▐  │
# │   66┤                                                     ▐   ▐▐ ▐█       ▐  │
# │   64┤                                                   █ ▐    █  ▐       ▐  │
# │   62┤                                                  ▐▐ █       ▐       ▐  │
# │   60┤                                                  █▐▐        ▐   ██  ▐  │
# │   58┤                                              ████  █         █ ▐ ▐  ▐  │
# │R  56┤         █  █                                █                ▐ █  █ ▐  │
# │S  54┤        █▐ ▐▐█                 █            █                 ▐▐   ▐█▐  │
# │I  52┤       ▐ ▐ ▐ ▐                ▐▐           █                   █    ▐█  │
# │   50┤ █  █  ▐  ██  █ █             ▐▐   █      ▐                          ▐  │
# │   48┤▐▐██▐  ▐      ▐▐▐██           █▐  █▐      ▐                          ▐  │
# │   46┤▐   ▐  █       █  ▐          █  ██ ▐      ▐                          ▐  │
# │   44┤▐    ██           ▐    ██ █ ▐       █ █   ▐                          ▐  │
# │   42┤▐                  ██ ▐ ▐▐▐ █       ▐█▐█  █                          ▐  │
# │   40┤▐                   ▐█▐  █ █           ▐ █                           ▐  │
# │   38┤█                    ▐▐                ▐▐                            ▐  │
# │   36┤                      █                ▐▐                            ▐  │
# │   34┤                                        █                            ▐  │
# │     └─────────┬─────────┬─────────┬─────────┬─────────┬─────────┬─────────┬  │
# │              10        20        30        40        50        60        70  │
# │                                daily (Time ago)                              │
# └──────────────────────────────────────────────────────────────────────────────┘

.LINK
https://en.wikipedia.org/wiki/Relative_strength_index

.NOTES
General notes
#>
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline=$true,Mandatory=$true)]
        $Symbol,
        
        [ValidateSet("1min","5min","15min","30min","60min","daily","weekly","monthly")]
        $Interval="daily",
        
        
        [int]$TimePeriod=14,

        [ValidateSet("close","open","high","low")]
        $SeriesType="open",

        [Switch]$Graph,

        [int]$GraphPoints=100,
        
        [ValidateSet(10,5,2,1)]
        [int]$YAxisStep=5,

        [ValidateSet("Bull","Up","Bear","Down","Middle","Normal","Default")]
        $MarketTrend="Default",

        $RsiHigh,

        $RsiLow,

        [Switch]$OutString,

        [ValidateSet(
            0,
            12, # 60/5 - 5 Calls pro Minute
            180 # 500 Calls pro Tag
        )]
        $Throttle=$Global:AlphaVantage.ApiDefaultThrottle

    )
    
    begin {
        $a_symbols=@()

        #https://en.wikipedia.org/wiki/Relative_strength_index
        #https://www.investopedia.com/terms/r/rsi.asp
        if($MarketTrend -in @("Up","Bull")){
            [int]$RsiHi=80
            [int]$RsiLo=40
        }
        elseif($MarketTrend -in @("Down","Bear")){
            [int]$RsiHi=60
            [int]$RsiLo=20

        }
        else{
            [int]$RsiHi=70
            [int]$RsiLo=30
        }

        if($null -ne $RsiHigh){
            $RsiHi=$RsiHigh
        }
        if($null -ne $RsiLow){
            $RsiLo=$RsiHigh
        }

        Write-Verbose("RsiHi: " + $RsiHi + " RsiLo: " + $RsiLo)

        $GraphColorMap=@{
            $RsiLo = "Green"
            $RsiHi = "Yellow"
            200 = "Red"
        }

    }
    
    process {
        $Symbol | ForEach-Object {
            $o_symbol=$_
            if($o_symbol.GetType().Name -ne "String"){
                $s_symbol=$o_symbol.Symbol
            }
            else{
                $s_symbol=$o_symbol
            }
            $a_symbols+=$s_symbol
        }
    }
    
    end {
        $i=0
        $a_symbols | ForEach-Object {
            $s_symbol=$_
            

            #Wenn wir durch die Gratis-Api gebremst werden
            if($Throttle -gt 0 -and $i -gt 0){
                Write-Progress -Activity "Getting Data" -Status ("Throttled to one call per $Throttle seconds - Call $i of " + $a_symbols.Count) `
                    -PercentComplete ($i / $a_symbols.Count * 100) -SecondsRemaining (($a_symbols.Count - ($i - 1)) * $Throttle)

                Start-Sleep -Seconds $Throttle
            }

            <#
            $result=Invoke-RestMethod -Uri ("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=" + $s_symbol + "&interval=" + $Interval + "&apikey=" + $Global:AlphaVantage.ApiKey)
            $result."Time Series (1min)"
            #>
            #https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=IBM&apikey=demo
            $result=Invoke-RestMethod -Uri ("https://www.alphavantage.co/query?function=RSI&symbol=" + $s_symbol + 
                "&interval=$Interval&time_period=$TimePeriod&series_type=$SeriesType&apikey=" + $Global:AlphaVantage.ApiKey)

            if( -not (_Check-ApiResult -result $result)){
                return
            }
            if($result.'Meta Data'.'1: Symbol' -ne $s_symbol){
                Write-Error("'" + $s_symbol + "' nicht gefunden")
                return $false
            }
            
            #$result.'Meta Data'
            #(($result.'Technical Analysis: RSI').PSObject.Properties | Select-Object -First 1).Value.RSI
            #"2021-05-21".RSI
            $Signal=$null
            $LastRsi=(($result.'Technical Analysis: RSI').PSObject.Properties | Select-Object -First 1).Value.RSI
            if($LastRsi -ge $RsiHi){
                $Signal="Sell"
            }
            elseif($LastRsi -le $RsiLow){
                $Signal="Buy"
            }
            else{
                $Signal="Hold"
            }

            $entry=[MarketAnalyzeEntry]@{
                Symbol          = $result.'Meta Data'.'1: Symbol'
                Indicator       = $result.'Meta Data'.'2: Indicator'
                LastRefreshed   = $result.'Meta Data'.'3: Last Refreshed'
                Interval        = $result.'Meta Data'.'4: Interval'
                TimePeriod      = $result.'Meta Data'.'5: Time Period'
                SeriesType      = $result.'Meta Data'.'6: Series Type'
                TimeZone        = $result.'Meta Data'.'7: Time Zone'
                LastRsi         = $LastRsi
                MarketTrend     = $MarketTrend
                Signal          = $Signal
                RsiSeries       = $result.'Technical Analysis: RSI'.PSObject.Properties.Value.RSI
            }

            #Rückgabe des Entry
            $entry

            #Entry Textausgabe
            if($OutString){
                $out=$entry | Select-Object Symbol,LastRefreshed,Interval,TimePeriod,LastRsi,Signal | Format-List | Out-String
                Write-Host($out)
            }

            #Graph ausgeben wenn gewünscht
            if($Graph){
                [int[]]$Datapoints=[int[]]$entry.RsiSeries
                Show-Graph -Datapoints ($entry.RsiSeries | Select-Object -First $GraphPoints)`
                    -YAxisStep $YAxisStep -XAxisTitle ($Interval + " (Time ago)") -YAxisTitle "RSI" `
                    -GraphTitle $entry.Indicator -ColorMap $GraphColorMap -Type line
            }

            $i++

        }
    }
}



<#
    Man könnte noch was mit der TIME_SERIES_INTRADAY API machen
        [ValidateSet("1min","5min","15min","30min","60min")]
        $Interval="1min"
        irgendwie so
        Invoke-WebRequest -Uri ("https://www.alphavantage.co/query?function=TIME_SERIES_INTRADAY&symbol=IBM&interval=" + $Interval + "&apikey=" + $Global:AlphaVantage.ApiKey)
#>


Register-ArgumentCompleter -CommandName "Get-MarketValue" -ParameterName "Symbol" -ScriptBlock $Global:AlphaVantageAutoCompleters.Symbol
Register-ArgumentCompleter -CommandName "Get-MarketRSI" -ParameterName "Symbol" -ScriptBlock $Global:AlphaVantageAutoCompleters.Symbol

Register-ArgumentCompleter -CommandName "Start-ProCharts" -ParameterName "Symbol" -ScriptBlock $Global:AlphaVantageAutoCompleters.Symbol