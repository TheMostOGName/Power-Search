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


# Filter out empty lines
$Response = $Response | Where-Object { $_ -ne "" }

# Initialize an array to store the links
$LinkVariables = @()

# Loop through the $Response variable to assign links to callable variables
for ($i = 1; $i -le $Response.Count; $i++) {
    # Create a variable name for the link (e.g., $Link1, $Link2, ...)
    $variableName = "Link$i"
    
    # Set the variable with the link content
    Set-Variable -Name $variableName -Value $Response[$i - 1] -Scope Script
    
    # Add the variable name to the array
    $LinkVariables += $variableName
}

# Output the results with line numbers
for ($i = 0; $i -lt $Response.Count; $i++) {
    $lineNumber = $i + 1
    Write-Host "$lineNumber. $($Response[$i])"
}

$Yn = Read-Host -Prompt "Open a result in browser? (Y/n)"

if ($Yn -eq "Y") {
    $LinkNum = Read-Host -Prompt "Enter link number"
    if ([int]$LinkNum -ge 1 -and [int]$LinkNum -le $Response.Count) {
        $SelectedLink = $Response[$LinkNum - 1]
        Write-Host "Opening link ${LinkNum}: $SelectedLink"
        Start-Process $SelectedLink
    } else {
        Write-Host "Invalid link number. Please enter a valid link number."
    }
}
else {
    exit
}

# Output the list of variable names (optional)
# Write-Host "Variable Names: $($LinkVariables -join ', ')"
 
#Output the results and delete the file
# $Response


#Pause the script if there were no args, this sometimes means the script was opened in the file explorer and will automatically close the window 
#once finished. 
## if (1 -eq $NoArgs) {
##    cmd /c pause
## }