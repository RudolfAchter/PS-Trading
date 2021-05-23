# Search-Market
Sucht nach einer Aktie


[[_TOC_]]

## Description


Sucht nach einer Aktie. Kann nach WÃ¤hrung gefiltert werden





## Parameter

### -Search


<table><tr><td>description</td><td>
Suchbegriff oder Symbol. gesuchte Aktie muss mit dem
Suchbegriff BEGINNEN

"Lufthansa" findet NICHT "Deutsche Lufthansa AG"

Aber z.B. "Deutsche Luft" findet "Deutsche Lufthansa AG"



</td></tr>
<tr><td>required</td><td>true
</td></tr>
<tr><td>position</td><td>1
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>
</td></tr>
</table>

### -Currency


<table><tr><td>description</td><td>
Kurzbezeichung der WÃ¤hrung (z.B. EUR | USD)



</td></tr>
<tr><td>required</td><td>false
</td></tr>
<tr><td>position</td><td>2
</td></tr>
<tr><td>type</td><td>Object
</td></tr>
<tr><td>pipelineInput</td><td>false
</td></tr>
<tr><td>defaultValue</td><td>
</td></tr>
</table>

## Beispiele

### Beispiel 1
```powershell
Search-Market -Search "Deutsche Luft"
     
```
### Beispiel 2
```powershell
Search-Market -Search "Deutsche Luft" -Currency USD
     
```
## Related Links

 * https://www.alphavantage.co/documentation/#symbolsearch

## Something Funny

![ruthe/1141.jpg](../../../doc/resource/comics/ruthe/1141.jpg)

---
## PlainText Hilfe

```

NAME
    Search-Market
    
ÜBERSICHT
    Sucht nach einer Aktie
    
    
SYNTAX
    Search-Market [-Search] <Object> [[-Currency] <Object>] [<CommonParameters>]
    
    
BESCHREIBUNG
    Sucht nach einer Aktie. Kann nach WÃ¤hrung gefiltert werden
    

PARAMETER
    -Search <Object>
        Suchbegriff oder Symbol. gesuchte Aktie muss mit dem
        Suchbegriff BEGINNEN
        
        "Lufthansa" findet NICHT "Deutsche Lufthansa AG"
        
        Aber z.B. "Deutsche Luft" findet "Deutsche Lufthansa AG"
        
        Erforderlich?                true
        Position?                    1
        Standardwert                 
        Pipelineeingaben akzeptieren?false
        Platzhalterzeichen akzeptieren?false
        
    -Currency <Object>
        Kurzbezeichung der WÃ¤hrung (z.B. EUR | USD)
        
        Erforderlich?                false
        Position?                    2
        Standardwert                 
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
    
    PS C:\>Search-Market -Search "Deutsche Luft"
    
    
    
    
    
    
    -------------------------- BEISPIEL 2 --------------------------
    
    PS C:\>Search-Market -Search "Deutsche Luft" -Currency USD
    
    
    
    
    
    
    
VERWANDTE LINKS
    https://www.alphavantage.co/documentation/#symbolsearch



```

