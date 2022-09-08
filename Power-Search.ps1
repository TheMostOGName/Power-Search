Clear-Host

#Check to see if the user already inputed a search as args, if not prompt the user for a search
if (!$args[0]) {
    $Search = Read-Host -Prompt 'Input your search'
    #Note that there are no args
    $NoArgs = 1;
} 
else {
    #Join args into a string if they exist
    $Search = [system.String]::Join(" ", $args)
}

Clear-Host
#Output the search terms
Write-Output "${Search}:"
#Set the url
$url = "https://www.google.com/search?q=" + $Search
#Curl all links from the param url
$Response = (Invoke-WebRequest -Uri $url -UseBasicParsing).Links.Href
#Take all lines that don't have "search", which are google links and unnecessary
$Response = ($Response | find /v """search""")
#Take out lines that have "/imgres?" because that's not a result
$Response = ($Response | find /v """/imgres?""")


#Text Processing, since the result comes with a bunch of extra characters that need to be removed
#$Response -replace "---------- RESPONSE.TXT","" |  Out-File response.txt
#Replaces "/url?q=" that appears at the beginning of every line for some reason
$Response = $Response -replace "\/url\?q\=",""
#Removes everything after the character & for every line to clear some of the mess that interferes with some of the links
$Response = $Response -replace '(.+?)&.+','$1'
#Removes everything after the character % for every line to clear out the rest of the mess
$Response = $Response -replace '(.+?)%.+','$1'
#Removes "/?sa=X" because that slips by
$Response = $Response -replace "\/\?sa\=X",""
#Removes "about:" because that also slips by
$Response = $Response -replace "about\:",""
#Removes the last three lines, they're always default google links that aren't searches
$Response = ($Response | Select-Object -First ($Response.count -3))

#Remove Repeated Results
$Response = ($Response | Get-Unique) 
 
#Output the results and delete the file
$Response


#Pause the script if there were no args, this sometimes means the script was opened in the file explorer and will automatically close the window 
#once finished. 
if (1 -eq $NoArgs) {
    cmd /c pause
}