$snapins  = Get-PSSnapin Citrix.Broker.Admin.* -ea 0

if ($snapins -eq $null)
{
   Get-PSSnapin -Registered "Citrix.Broker.Admin.*" | Add-PSSnapin
}

Get-BrokerCatalog | foreach-object {

    $Catalog= $_
	if($Catalog)
	{
		$output = $Catalog | Get-Member -MemberType Properties | foreach-object {
			$Key = $_.Name
			$Value = $Catalog.$Key -join ";" 
			'{0}="{1}"' -f $Key,$Value
		}
		
		Write-Host ("{0:MM/dd/yyyy HH:mm:ss} GMT - {1}" -f ((get-date).ToUniversalTime()),( $output -join " " ))
	}
} 