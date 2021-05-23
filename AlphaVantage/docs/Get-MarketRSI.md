# Get-MarketRSI
Liefert RSI einer Aktie
- https://en.wikipedia.org/wiki/Relative_strength_index


[[_TOC_]]

## Description


Liefert RSI einer Aktie

Standard Markt:
RSI Ã¼ber 70 -> Verkaufen Signal
RSI unter 30 -> Kaufen Signal

AufwÃ¤rts (Bull) Trend
RSI Ã¼ber 80 -> Verkaufen Signal
RSI unter 40 -> Kaufen Signal

AbwÃ¤rts (Bear) Trend
RSI Ã¼ber 60 -> Verkaufen Signal
RSI unter 20 -> Kaufen Signal

natÃ¼rlich selbst noch abwÃ¤gen





## Parameter

### -Symbol


<table><tr><td>description</td><td>
Symbol (Kurzname der Aktie)



</td></tr>
<tr><td>required</td><td>true
</td></tr>
<tr><td>position</td><td>1
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>true (ByValue)
</td></tr>
<tr><td>defaultValue</td><td>
</td></tr>
</table>

### -Interval


<table><tr><td>description</td><td>
Messintervalle (Funktioniert gut mit daily bei Aktien)



</td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>2
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>daily
</td></tr>
</table>

### -TimePeriod


<table><tr><td>description</td><td>
Zeitraum der Analysiert wird. Nach "Wilder" sind 14
Tage mit einem "daily" Interval ein Typischer Wert



</td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>3
</td></tr>
<tr><td>type</td><td>Int32
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>14
</td></tr>
</table>

### -SeriesType


<table><tr><td>description</td><td>
Mit welchem Wert aus der API Rechnen
"close","open","high","low"



</td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>4
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>open
</td></tr>
</table>

### -Graph


<table><tr><td>description</td><td></td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>named
</td></tr>
<tr><td>type</td><td>SwitchParameter
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>False
</td></tr>
</table>

### -GraphPoints


<table><tr><td>description</td><td></td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>5
</td></tr>
<tr><td>type</td><td>Int32
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>100
</td></tr>
</table>

### -YAxisStep


<table><tr><td>description</td><td></td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>6
</td></tr>
<tr><td>type</td><td>Int32
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>5
</td></tr>
</table>

### -MarketTrend


<table><tr><td>description</td><td></td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>7
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>Default
</td></tr>
</table>

### -RsiHigh


<table><tr><td>description</td><td></td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>8
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>
</td></tr>
</table>

### -RsiLow


<table><tr><td>description</td><td></td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>9
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>
</td></tr>
</table>

### -Throttle


<table><tr><td>description</td><td>
Die AlphaVantage API ist in der "Free" Version eingeschrÃ¤nkt auf
Ein Call pro 12 Sekunden    # 60/5 - 5 Calls pro Minute fÃ¼r Kurze Angelegenheiten
Ein Call pro 180 Sekunden   # 500 Calls pro Tag -> wenn du eine
                            # Query Ã¼ber den ganzen Tag brauchst



</td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>10
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>$Global:AlphaVantage.ApiDefaultThrottle
</td></tr>
</table>

## Beispiele

### Beispiel 1
```powershell
Get-MarketRSI HDD.DE -TimePeriod 14
     
```
### Beispiel 2
```powershell
Get-MarketRSI -Symbol BYND
     
```
### Beispiel 3
```powershell
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
# â”Œ Relative Strength Index (RSI) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
# â”‚                                                                              â”‚
# â”‚   74â”¤                                                           â–ˆ         â–  â”‚
# â”‚   72â”¤                                                       â–ˆâ–ˆ â–â–         â–  â”‚
# â”‚   70â”¤                                                      â–ˆ â–â–ˆâ–â–         â–  â”‚
# â”‚   68â”¤                                                     â–   â–â– â–ˆ        â–  â”‚
# â”‚   66â”¤                                                     â–   â–â– â–â–ˆ       â–  â”‚
# â”‚   64â”¤                                                   â–ˆ â–    â–ˆ  â–       â–  â”‚
# â”‚   62â”¤                                                  â–â– â–ˆ       â–       â–  â”‚
# â”‚   60â”¤                                                  â–ˆâ–â–        â–   â–ˆâ–ˆ  â–  â”‚
# â”‚   58â”¤                                              â–ˆâ–ˆâ–ˆâ–ˆ  â–ˆ         â–ˆ â– â–  â–  â”‚
# â”‚R  56â”¤         â–ˆ  â–ˆ                                â–ˆ                â– â–ˆ  â–ˆ â–  â”‚
# â”‚S  54â”¤        â–ˆâ– â–â–â–ˆ                 â–ˆ            â–ˆ                 â–â–   â–â–ˆâ–  â”‚
# â”‚I  52â”¤       â– â– â– â–                â–â–           â–ˆ                   â–ˆ    â–â–ˆ  â”‚
# â”‚   50â”¤ â–ˆ  â–ˆ  â–  â–ˆâ–ˆ  â–ˆ â–ˆ             â–â–   â–ˆ      â–                          â–  â”‚
# â”‚   48â”¤â–â–â–ˆâ–ˆâ–  â–      â–â–â–â–ˆâ–ˆ           â–ˆâ–  â–ˆâ–      â–                          â–  â”‚
# â”‚   46â”¤â–   â–  â–ˆ       â–ˆ  â–          â–ˆ  â–ˆâ–ˆ â–      â–                          â–  â”‚
# â”‚   44â”¤â–    â–ˆâ–ˆ           â–    â–ˆâ–ˆ â–ˆ â–       â–ˆ â–ˆ   â–                          â–  â”‚
# â”‚   42â”¤â–                  â–ˆâ–ˆ â– â–â–â– â–ˆ       â–â–ˆâ–â–ˆ  â–ˆ                          â–  â”‚
# â”‚   40â”¤â–                   â–â–ˆâ–  â–ˆ â–ˆ           â– â–ˆ                           â–  â”‚
# â”‚   38â”¤â–ˆ                    â–â–                â–â–                            â–  â”‚
# â”‚   36â”¤                      â–ˆ                â–â–                            â–  â”‚
# â”‚   34â”¤                                        â–ˆ                            â–  â”‚
# â”‚     â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬  â”‚
# â”‚              10        20        30        40        50        60        70  â”‚
# â”‚                                daily (Time ago)                              â”‚
# â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜     
```
## Related Links

 * https://en.wikipedia.org/wiki/Relative_strength_index

## Something Funny

![ruthe/1349.jpg](../../../doc/resource/comics/ruthe/1349.jpg)

---
## PlainText Hilfe

```

NAME
    Get-MarketRSI
    
ÜBERSICHT
    Liefert RSI einer Aktie
    - https://en.wikipedia.org/wiki/Relative_strength_index
    
    
SYNTAX
    Get-MarketRSI [-Symbol] <Object> [[-Interval] <Object>] [[-TimePeriod] <Int32>] [[-SeriesType] <Object>] [-Graph] [[-GraphPoints] <Int32>] [[-YAxisStep] <Int32>] [[-MarketTrend] <Object>] [[-RsiHigh] 
    <Object>] [[-RsiLow] <Object>] [[-Throttle] <Object>] [<CommonParameters>]
    
    
BESCHREIBUNG
    Liefert RSI einer Aktie
    
    Standard Markt:
    RSI Ã¼ber 70 -> Verkaufen Signal
    RSI unter 30 -> Kaufen Signal
    
    AufwÃ¤rts (Bull) Trend
    RSI Ã¼ber 80 -> Verkaufen Signal
    RSI unter 40 -> Kaufen Signal
    
    AbwÃ¤rts (Bear) Trend
    RSI Ã¼ber 60 -> Verkaufen Signal
    RSI unter 20 -> Kaufen Signal
    
    natÃ¼rlich selbst noch abwÃ¤gen
    

PARAMETER
    -Symbol <Object>
        Symbol (Kurzname der Aktie)
        
        Erforderlich?                true
        Position?                    1
        Standardwert                 
        Pipelineeingaben akzeptieren?true (ByValue)
        Platzhalterzeichen akzeptieren?false
        
    -Interval <Object>
        Messintervalle (Funktioniert gut mit daily bei Aktien)
        
        Erforderlich?                false
        Position?                    2
        Standardwert                 daily
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -TimePeriod <Int32>
        Zeitraum der Analysiert wird. Nach "Wilder" sind 14
        Tage mit einem "daily" Interval ein Typischer Wert
        
        Erforderlich?                false
        Position?                    3
        Standardwert                 14
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -SeriesType <Object>
        Mit welchem Wert aus der API Rechnen
        "close","open","high","low"
        
        Erforderlich?                false
        Position?                    4
        Standardwert                 open
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -Graph [<SwitchParameter>]
        
        Erforderlich?                false
        Position?                    named
        Standardwert                 False
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -GraphPoints <Int32>
        
        Erforderlich?                false
        Position?                    5
        Standardwert                 100
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -YAxisStep <Int32>
        
        Erforderlich?                false
        Position?                    6
        Standardwert                 5
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -MarketTrend <Object>
        
        Erforderlich?                false
        Position?                    7
        Standardwert                 Default
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -RsiHigh <Object>
        
        Erforderlich?                false
        Position?                    8
        Standardwert                 
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -RsiLow <Object>
        
        Erforderlich?                false
        Position?                    9
        Standardwert                 
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -Throttle <Object>
        Die AlphaVantage API ist in der "Free" Version eingeschrÃ¤nkt auf
        Ein Call pro 12 Sekunden    # 60/5 - 5 Calls pro Minute fÃ¼r Kurze Angelegenheiten
        Ein Call pro 180 Sekunden   # 500 Calls pro Tag -> wenn du eine
                                    # Query Ã¼ber den ganzen Tag brauchst
        
        Erforderlich?                false
        Position?                    10
        Standardwert                 $Global:AlphaVantage.ApiDefaultThrottle
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    <CommonParameters>
        Dieses Cmdlet unterstützt folgende allgemeine Parameter: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable und OutVariable. Weitere Informationen finden Sie unter 
        "about_CommonParameters" (https:/go.microsoft.com/fwlink/?LinkID=113216). 
    
EINGABEN
    
AUSGABEN
    
HINWEISE
    
    
        General notes
    
    -------------------------- BEISPIEL 1 --------------------------
    
    PS C:\>Get-MarketRSI HDD.DE -TimePeriod 14
    
    
    
    
    
    
    -------------------------- BEISPIEL 2 --------------------------
    
    PS C:\>Get-MarketRSI -Symbol BYND
    
    
    
    
    
    
    -------------------------- BEISPIEL 3 --------------------------
    
    PS C:\>Get-MarketRSI -Symbol LHA.DE -Graph -GraphPoints 70 -YAxisStep 2 -MarketTrend Bear
    
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
    # â”Œ Relative Strength Index (RSI) â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
    # â”‚                                                                              â”‚
    # â”‚   74â”¤                                                           â–ˆ         â–  â”‚
    # â”‚   72â”¤                                                       â–ˆâ–ˆ â–â–         â–  â”‚
    # â”‚   70â”¤                                                      â–ˆ â–â–ˆâ–â–         â–  â”‚
    # â”‚   68â”¤                                                     â–   â–â– â–ˆ        â–  â”‚
    # â”‚   66â”¤                                                     â–   â–â– â–â–ˆ       â–  â”‚
    # â”‚   64â”¤                                                   â–ˆ â–    â–ˆ  â–       â–  â”‚
    # â”‚   62â”¤                                                  â–â– â–ˆ       â–       â–  â”‚
    # â”‚   60â”¤                                                  â–ˆâ–â–        â–   â–ˆâ–ˆ  â–  â”‚
    # â”‚   58â”¤                                              â–ˆâ–ˆâ–ˆâ–ˆ  â–ˆ         â–ˆ â– â–  â–  â”‚
    # â”‚R  56â”¤         â–ˆ  â–ˆ                                â–ˆ                â– â–ˆ  â–ˆ â–  â”‚
    # â”‚S  54â”¤        â–ˆâ– â–â–â–ˆ                 â–ˆ            â–ˆ                 â–â–   â–â–ˆâ–  â”‚
    # â”‚I  52â”¤       â– â– â– â–                â–â–           â–ˆ                   â–ˆ    â–â–ˆ  â”‚
    # â”‚   50â”¤ â–ˆ  â–ˆ  â–  â–ˆâ–ˆ  â–ˆ â–ˆ             â–â–   â–ˆ      â–                          â–  â”‚
    # â”‚   48â”¤â–â–â–ˆâ–ˆâ–  â–      â–â–â–â–ˆâ–ˆ           â–ˆâ–  â–ˆâ–      â–                          â–  â”‚
    # â”‚   46â”¤â–   â–  â–ˆ       â–ˆ  â–          â–ˆ  â–ˆâ–ˆ â–      â–                          â–  â”‚
    # â”‚   44â”¤â–    â–ˆâ–ˆ           â–    â–ˆâ–ˆ â–ˆ â–       â–ˆ â–ˆ   â–                          â–  â”‚
    # â”‚   42â”¤â–                  â–ˆâ–ˆ â– â–â–â– â–ˆ       â–â–ˆâ–â–ˆ  â–ˆ                          â–  â”‚
    # â”‚   40â”¤â–                   â–â–ˆâ–  â–ˆ â–ˆ           â– â–ˆ                           â–  â”‚
    # â”‚   38â”¤â–ˆ                    â–â–                â–â–                            â–  â”‚
    # â”‚   36â”¤                      â–ˆ                â–â–                            â–  â”‚
    # â”‚   34â”¤                                        â–ˆ                            â–  â”‚
    # â”‚     â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”
    €â”€â”€â”€â”€â”€â”¬  â”‚
    # â”‚              10        20        30        40        50        60        70  â”‚
    # â”‚                                daily (Time ago)                              â”‚
    # â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â
    ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
    
    
    
    
    
VERWANDTE LINKS
    https://en.wikipedia.org/wiki/Relative_strength_index



```

