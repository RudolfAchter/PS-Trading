# Get-MarketValue
Holt den aktuellen Wert einer Aktie


[[_TOC_]]

## Description


Holt den aktuellen Wert einer Aktie





## Parameter

### -Symbol


<table><tr><td>description</td><td>
Symbol (ID) der Aktie



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

### -Throttle


<table><tr><td>description</td><td>
60/5 - 5 Calls pro Minute
500 Calls pro Tag



</td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>2
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
An example
     
```
## Related Links

 * https://www.alphavantage.co/documentation/#latestprice

## Something Funny

![ruthe/1377.jpg](../../../doc/resource/comics/ruthe/1377.jpg)

---
## PlainText Hilfe

```

NAME
    Get-MarketValue
    
ÜBERSICHT
    Holt den aktuellen Wert einer Aktie
    
    
SYNTAX
    Get-MarketValue [-Symbol] <Object> [[-Throttle] <Object>] [<CommonParameters>]
    
    
BESCHREIBUNG
    Holt den aktuellen Wert einer Aktie
    

PARAMETER
    -Symbol <Object>
        Symbol (ID) der Aktie
        
        Erforderlich?                true
        Position?                    1
        Standardwert                 
        Pipelineeingaben akzeptieren?true (ByValue)
        Platzhalterzeichen akzeptieren?false
        
    -Throttle <Object>
        60/5 - 5 Calls pro Minute
        500 Calls pro Tag
        
        Erforderlich?                false
        Position?                    2
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
    
    
        In der Freien Version gehen nur 5 API Calls pro Minute
        500 pro Tag
        
        das ist einer in 172,8 Sekunden
        Also machen wir nur einen Call in 3 Minuten
        bzw Eine Abfrage pro 5 Minuten ist in Ordnung
    
    -------------------------- BEISPIEL 1 --------------------------
    
    PS C:\>An example
    
    
    
    
    
    
    
VERWANDTE LINKS
    https://www.alphavantage.co/documentation/#latestprice



```

