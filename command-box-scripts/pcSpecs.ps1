# PC Specifications

$board = Get-CimInstance Win32_BaseBoard
$cpu   = Get-CimInstance Win32_Processor
$ram   = Get-CimInstance Win32_PhysicalMemory

$ramTotalGB = [math]::Round(($ram | Measure-Object Capacity -Sum).Sum / 1GB)
$ramCount   = $ram.Count
$ramPerStick = [math]::Round($ram[0].Capacity / 1GB)

$ramManufacturer = ($ram | Select-Object -First 1).Manufacturer
$ramModel        = ($ram | Select-Object -First 1).PartNumber
$ramSpeed        = ($ram | Select-Object -First 1).Speed
$ramCurrentSpeed = ($ram | Select-Object -First 1).ConfiguredClockSpeed

$cores  = $cpu.NumberOfCores
$threads = $cpu.NumberOfLogicalProcessors
$cpuName = $cpu.Name -replace ' CPU @.*',''
$baseClock = [math]::Round($cpu.MaxClockSpeed / 1000, 2)

# Detect dual-channel configuration
$ramConfiguration = if ($ramCount -ge 2) { "Dual Channel" } else { "Single Channel" }

# Motherboard has 2 RAM slots
$ramSlots = "$ramCount / 2"

Write-Host ""
Write-Host "╔══════════════════════════════════════════╗"
Write-Host "║              PC SPECIFICATIONS            ║"
Write-Host "╠══════════════════╦═══════════════════════╣"
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "Motherboard", $board.Product)
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "CPU", $cpuName)
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "CPU", "$cores Cores / $threads Threads")
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "Base Clock", "$baseClock GHz")
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "RAM", "$ramTotalGB GB ($ramCount×$ramPerStick GB)")
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "RAM Manufacturer", $ramManufacturer)
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "RAM Model", $ramModel)
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "RAM Rated Speed", "$ramSpeed MHz")
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "RAM Current Speed", "$ramCurrentSpeed MHz")
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "RAM Configuration", $ramConfiguration)
Write-Host ("║ {0,-16} ║ {1,-21} ║" -f "RAM Slots Used", $ramSlots)
Write-Host "╚══════════════════╩═══════════════════════╝"
Write-Host ""
