function Set-UuidPart($uuid, $start, $end) {
    $uuidPart = ""
    for ($i = $start; $i -lt $end; $i++) {
        $uuidPart += $uuid[$i]
    }
    return "0x" + $uuidPart
}

$uuid = (new-guid).ToString()

$TA_UUID = @"
    { /* [[generated-uuid]] */                          \
        [[generated-uuid-part-1]], [[generated-uuid-part-2]], [[generated-uuid-part-3]],    \
        {                                               \
            [[generated-uuid-part-4-a]], [[generated-uuid-part-4-b]], [[generated-uuid-part-5-a]], [[generated-uuid-part-5-b]], [[generated-uuid-part-5-c]], [[generated-uuid-part-5-d]], [[generated-uuid-part-5-e]], [[generated-uuid-part-5-f]] \
        }                                               \
    }
"@

$TA_UUID = $TA_UUID.Replace("[[generated-uuid]]", $uuid)
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-1]]", (Set-UuidPart -uuid $uuid -start 0 -end 8))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-2]]", (Set-UuidPart -uuid $uuid -start 9 -end 13))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-3]]", (Set-UuidPart -uuid $uuid -start 14 -end  18))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-4-a]]", (Set-UuidPart -uuid $uuid -start 19 -end  21))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-4-b]]", (Set-UuidPart -uuid $uuid -start 21 -end  23))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-5-a]]", (Set-UuidPart -uuid $uuid -start 24 -end  26))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-5-b]]", (Set-UuidPart -uuid $uuid -start 26 -end  28))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-5-c]]", (Set-UuidPart -uuid $uuid -start 28 -end  30))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-5-d]]", (Set-UuidPart -uuid $uuid -start 30 -end  32))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-5-e]]", (Set-UuidPart -uuid $uuid -start 32 -end  34))
$TA_UUID = $TA_UUID.Replace("[[generated-uuid-part-5-f]]", (Set-UuidPart -uuid $uuid -start 34 -end  36))

Write-Host $TA_UUID
$TA_UUID | Set-Clipboard
