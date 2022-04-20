function Hardware {
         "Info of Hardware" 
       get-wmiobject -class win32_computersystem 
        
}

function OperatingSystem {
         " Description of  OperatingSystem "
         get-wmiobject -class win32_operatingsystem | select-Object Name, Version
}

function Processor {
         " Description of Processor"
         get-wmiObject -class win32_processor | select-object Description,Maxclockspeed,Currentclockspeed,L2CacheSize,L3CacheSize
}

function PhysicalMemory {
         " Description of PhysicalMemory"
         Get-WmiObject -class win32_physicalmemory |
foreach {
 new-object -TypeName psobject -Property @{
 "Description" = $_.description
 "Size(MB)" = $_.capacity/1mb
 Bank = $_.banklabel
 Slot = $_.devicelocator
 }
 $totalcapacity += $_.capacity/1mb
} |
ft -auto  "Description","Size(MB)", Bank, Slot
"Total RAM: ${totalcapacity}MB " 
}

Function Diskinfo {
  " Description of Diskinfo"
$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{
                                                               Model=$disk.Model
                                                               Drive=$logicaldisk.deviceid 
                                                               Size=$logicaldisk.Size
                                                               Freespace=$logicaldisk.FreeSpace
                                                               Usedspace=$logicaldisk.Size-$logicaldisk.Freespace
                                                               }  | Format-Table -auto  Model, Drive, Size, Freespace, Usedspace
                                                               
           } 
           
      } 
  }  
 

} 

Function Network {
"Description of Network"
          Get-WmiObject -Class Win32_NetworkAdapterConfiguration | where-object ipenabled| select-object Description,Index,IPAddress,DNSDomain,IPSubnet,DNSServerSearchOrder |ft
}

Function Video {
" Description of Video"
         Get-WmiObject -Class Win32_VideoController | Select-Object Description, CurrentHorizontalResolution, CurrentVerticalResolution | fl
}
         
Hardware 
OperatingSystem
Processor
PhysicalMemory
Diskinfo
Network
Video  