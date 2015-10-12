#Alex Curley
#Run through every distribution group, and each member in each distribution group
#If the current member does not exist in the MemberOf hash table, add it, along with the type (mail contact, etc), and primary SMTP address
#Append the current distribution group to the current user

$MemberOf = @{}

foreach ($group in Get-DistributionGroup) {
    Write-Warning('{0}' -f $group.Name)

    foreach ($member in Get-DistributionGroupMember $group.Name) 
    {
        if (-not $MemberOf.ContainsKey($member.Name)) 
        {
            $MemberOf.Add($member.Name, @($member.RecipientTypeDetails, $member.PrimarySmtpAddress, @()))
        }

        $MemberOf[$member.Name][2] += $group.Name
    }
}

Write-Output (('DisplayName','RecipientTypeDetails','Email','Groups') -join "`t")

foreach ($disp_name in $MemberOf.Keys) 
{
    ($disp_name, $MemberOf[$disp_name][0], $MemberOf[$disp_name][1], ($MemberOf[$disp_name][2] -join ';')) -join "`t"
}