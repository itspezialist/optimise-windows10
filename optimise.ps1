$mainMenu = @('RAM', 'Disk', 'Exit')
$ramMenu = @('Display RAM usage', 'Free up RAM: Only for troubleshooting, NOT TO FREE UP RAM FOR OPTIMIZATION!!!', 'Adjust Virtual Memory', 'Go back to Main Menu')
$diskMenu = @('Display disk usage', 'Defragment disk', 'Optimize Disk', 'Adjust Virtual Memory', 'Disable Unnecessary Services', 'TRIM: SSD can perform the garbage collection process more efficiently', 'Compression', 'Disk Cleanup','Go back to Main Menu')

do {
    Write-Host "Main Menu:`n"
    for ($i=0; $i -lt $mainMenu.Count; $i++) {
        Write-Host ($i+1).ToString() + ") " + $mainMenu[$i]
    }

    $choice = Read-Host "`nEnter a choice"
    Write-Host ""

    switch ($choice) {
        1 { # RAM
            do {
                Write-Host "RAM:`n"
                for ($i=0; $i -lt $ramMenu.Count; $i++) {
                    Write-Host ($i+1).ToString() + ") " + $ramMenu[$i]
                }

                $choice2 = Read-Host "`nEnter a choice"
                Write-Host ""

                switch ($choice2) {
                    1 { # Display RAM usage
                        #Get-Process | Measure-Object WS -Sum | Select-Object @{Name="Memory Used (MB)"; Expression={ "{0:N2}" -f ($_.Sum / 1MB) }}
						Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, WorkingSet
						#Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, @{Name="Memory Used (MB)"; Expression={"{0:N2}" -f ($_.WorkingSet/1MB)}} | Format-Table -AutoSize

                    }
                    2 { # Free up RAM
						schtasks.exe /End /TN "\Microsoft\Windows\MemoryDiagnostic\ProcessMemoryDiagnosticEvents"
						Write-Output "Pending idle tasks cleared successfully."
						
						#Write-Output "Clearing Standby-List..."
						#& "E:\scripts\optimiseSystem\clrearram.bat"
						#Write-Output "Standby-List cleared."
                    }
					3 { # Adjust Virtual Memory
                        & SystemPropertiesAdvanced.exe
                    }
                    3 { # Go back to Main Menu
                        break
                    }
                    Default {
                        Write-Host "Invalid choice"
                    }
                }
            } while ($choice2 -ne 3)
        }
        2 { # Disk
            do {
                Write-Host "Disk:`n"
                for ($i=0; $i -lt $diskMenu.Count; $i++) {
                    Write-Host ($i+1).ToString() + ") " + $diskMenu[$i]
                }

                $choice2 = Read-Host "`nEnter a choice"
                Write-Host ""

                switch ($choice2) {
                    1 { # Display disk usage, (Used space  |   Free space)#
						Get-PSDrive | Where-Object {$_.Free -ne $null} | Select-Object Name, Used, Free, @{Name="Capacity(GB)";Expression={"{0:N2}" -f ($_.Used + $_.Free) / 1GB}}, @{Name="FreeSpace(GB)";Expression={"{0:N2}" -f $_.Free / 1GB}}, @{Name="UsedSpace(GB)";Expression={"{0:N2}" -f $_.Used / 1GB}} | Format-Table -AutoSize
                        #Get-PSDrive | Where-Object { $_.Provider -eq "FileSystem" } | Select-Object Name, Used, Free, @{Name="Capacity"; Expression={ "{0:N2}" -f ($_.Used + $_.Free) }}
                    }
                    2 { # Defragment disk
                        Defrag.exe C: -v
                    }
                    3 { # Optimize Disk (HAVE DISABLED IT DUE TO DRIVE NOT COMPATIBLE)#
                        #Optimize-Volume -DriveLetter C  -SlabConsolidate -Verbose
						dfrgui
                    }
                    4 { # Adjust Virtual Memory #page file size = (RAM size * 1.5) - existing page file size#
                        sysdm.cpl
                    }
                    5 { # Disable Unnecessary Services
                        services.msc
                    }
                    6 { # TRIM 
						Optimize-Volume -DriveLetter C -Verbose
                    }
                    7 { # Compression
                        Compact.exe /CompactOS:always
                    }
					8 { #Disk Cleanup
                        cleanmgr
                    }
                    9 { # Go back to Main Menu
                        break
                    }
                    Default {
                        Write-Host "Invalid choice"
                    }
                }
            } while ($choice2 -ne 9)
        }
        3 { # Exit
            break
        }
        Default {
            Write-Host "Invalid choice"
        }
    }
} while ($choice -ne 3)
