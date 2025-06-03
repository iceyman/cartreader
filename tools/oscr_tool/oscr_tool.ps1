Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$ErrorActionPreference = "Stop"

try {
    $configPath = "Arduino IDE\portable\sketchbook\Cart_Reader\config.h"
    $applyPath = "apply_config.txt"

    if (-not (Test-Path $configPath)) {
        throw "Missing config.h at $configPath"
    }

    # Define tooltip texts
    $tooltipTexts = @{
        "Hardware" = "Select the hardware version of your OSCR."
        "ENABLE_RTC" = "If installed this will enable the Real Time Clock module which adds the current time to each dumped ROM."
        "RTC module type" = "Select the type of RTC module you have installed."
        "ENABLE_3V3FIX" = "Some Mega2560s can't run 16MHz at 3.3V. So this will down-clock the OSCR to run at 8MHz."
        "ENABLE_CLOCKGEN" = "Enable if you have the Clock Gen module installed, it is used in the 7800, C64, GPC, N64, SFM, SNES, SUPRACAN, SV modules."
        "ENABLE_CONFIG" = "Allows changing some configuration values via a config file on the SD card but not firmware options."
        "ENABLE_GLOBAL_LOG" = "This will duplicate all screen output to a txt file on the SD card."
        "ENABLE_UPDATER" = "Disable this if you don't want to use the firmware updater utility."
        "OPTION_CLOCKGEN_CALIBRATION" = "Enables the calibration utility for the Clockgen (found under Super Nintendo)."
        "OPTION_CLOCKGEN_USE_CALIBRATION" = "Uses the value found via the calibration utility to match the frequency better."
        "OPTION_N64_FASTCRC" = "Calculate the CRC32 of an N64 ROM while it is being dumped instead of afterwards."
        "OPTION_N64_SAVESUMMARY" = "Add an text file with additional info about the dumped ROM to the directory."
        "ENABLE_2600" = "The Atari 2600 is a home video game console developed and produced by Atari, Inc. Released in September 1977."
        "ENABLE_5200" = "The Atari 5200 SuperSystem or simply Atari 5200 is a home video game console introduced in 1982 by Atari, Inc."
        "ENABLE_7800" = "The Atari 7800 ProSystem, or simply the Atari 7800, is a home video game console officially released by Atari Corporation in 1986."
        "ENABLE_ARC" = "The Arcadia 2001 is a second-generation 8-bit home video game console released by Emerson Radio in May 1982."
        "ENABLE_ATARI8" = "The Atari 8-bit computers, formally launched as the Atari Home Computer System, are a series of home computers introduced by Atari, Inc., in 1979 with the Atari 400 and Atari 800."
        "ENABLE_BALLY" = "The Bally Astrocade is a video game console designed by the videogame division of Bally and initially made available in December 1977."
        "ENABLE_C64" = "The Commodore 64, also known as the C64, is an 8-bit home computer introduced in January 1982 by Commodore International."
        "ENABLE_COLV" = "ColecoVision is a second-generation home video-game console developed by Coleco and launched in North America in August 1982."
        "ENABLE_CONTROLLERTEST" = "This enables the Controller Test for N64, it allows to check the analog stick and buttons."
        "ENABLE_CPS3" = "The CP System III or CPS-3 is an arcade system board that was first used by Capcom in 1996 with the arcade game Red Earth."
        "ENABLE_FAIRCHILD" = "The Fairchild Channel F is a home video game console released by Fairchild Camera and Instrument in November 1976."
        "ENABLE_FLASH" = "This enables flashing ROM files in CPS3, Flash8/16, GB, GBA, GBM, GBS, LYNX, MD, N64, NES, PCE, SFM, SNES modules."
        "ENABLE_FLASH16" = "This enables flashing using the 16bit flashrom adapter, also needed for CPS3."
        "ENABLE_FLASH8" = "This enables the Flashrom menu which allows you to flash single rom chips using the 8-bit flashrom adapter, also needed for flashing SNES repros."
        "ENABLE_GBX" = "The Game Boy, Game Boy Color and Game Boy Advance are handheld game consoles developed by Nintendo, launched in the Japanese home market in 1989, 1998 and 2001."
        "ENABLE_GPC" = "Enables the SFC Game Processor RAM Cassette menu."
        "ENABLE_INTV" = "The Intellivision is a home video game console released by Mattel Electronics in 1979."
        "ENABLE_JAGUAR" = "The Atari Jaguar is a home video game console developed by Atari Corporation and released in North America in November 1993."
        "ENABLE_LEAP" = "The Leapster Learning Game System is an educational handheld game console made by LeapFrog Enterprises."
        "ENABLE_LJ" = "The Bandai Little Jammer is a cartridge based music entertainment system."
        "ENABLE_LJPRO" = "The Bandai Little Jammer Pro is a cartridge based music entertainment system."
        "ENABLE_LOOPY" = "The Casio Loopy is a 32-bit home video game console released in Japan in October 1995."
        "ENABLE_LYNX" = "The Atari Lynx is a fourth-generation hand-held game console released by Atari Corporation in September 1989."
        "ENABLE_MD" = "The Sega Mega Drive is a 16-bit video game console released by Sega 1988 in Japan and in 1989 in North America as the Genesis."
        "ENABLE_MSX" = "MSX is a standardized home computer architecture developed by ASCII Corporation and released by multiple manufacturers starting 1983."
        "ENABLE_N64" = "The Nintendo 64 is a home video game console released by Nintendo in Japan on June 23, 1996."
        "ENABLE_NES" = "The Nintendo Entertainment System is an 8-bit home video game console produced by Nintendo. It was first released in Japan on July 15, 1983, as the Family Computer."
        "ENABLE_NGP" = "The Neo Geo Pocket series is a line of handheld game consoles developed and manufactured by SNK between 1998 and 2001."
        "ENABLE_ODY2" = "The Magnavox Odyssey 2, also known as Philips Odyssey 2, is a home video game console of the second generation that was released in 1978."
        "ENABLE_PCE" = "The TurboGrafx-16, known in Japan as the PC Engine, is a home video game console developed by Hudson Soft, manufactured by NEC and released in Japan in 1987 and in North America in 1989."
        "ENABLE_PCW" = "The Pocket Challenge W is a handheld device released by Benesse Corporation."
        "ENABLE_POKE" = "The Pokémon Mini is a handheld game console designed and manufactured by Nintendo in collaboration with The Pokémon Company and released in North America on November 16, 2001."
        "ENABLE_PV1000" = "The Casio PV-1000 is a third-generation home video game console manufactured by Casio and released in Japan in 1983."
        "ENABLE_PYUUTA" = "The Tomy Tutor, originally sold in Japan as the Pyūta and in the UK as the Grandstand Tutor, is a home computer produced by the Japanese toymaker Tomy in 1982."
        "ENABLE_RCA" = "The RCA Studio II is a home video game console made by RCA that debuted in January 1977."
        "ENABLE_SELFTEST" = "The self test allows you to quickly check each of the cartridge slot pins for short circuits."
        "ENABLE_SFM" = "Nintendo Power was a video game distribution service for Super Famicom operated by Nintendo that ran exclusively in Japan from 1997 until February 2007."
        "ENABLE_SMS" = "The Master System is an 8-bit third-generation home video game console manufactured and developed by Sega."
        "ENABLE_SNES" = "The Super Nintendo is a 16-bit home video game console developed by Nintendo that was released in 1991 in North America."
        "ENABLE_ST" = "The SuFami Turbo is an accessory by Bandai for Nintendo's Super Famicom system and was released in 1996."
        "ENABLE_SUPRACAN" = "The Super A'can is a home video game console released exclusively in 1995 by Funtech/Dunhuang Technology and People's Republic of China by Sino Wealth Electronic Ltd."
        "ENABLE_SV" = "The Satellaview was a satellite modem peripheral produced by Nintendo for the Super Famicom in 1995."
        "ENABLE_TI99" = "The TI-99/4 and TI-99/4A are home computers released by Texas Instruments in 1979 and 1981, respectively."
        "ENABLE_TRS80" = "The TRS-80 Micro Computer System is a desktop microcomputer developed by American company Tandy Corporation and sold through their Radio Shack stores in 1977."
        "ENABLE_VBOY" = "The Virtual Boy is a 32-bit tabletop portable video game console developed and manufactured by Nintendo and released in 1995."
        "ENABLE_VECTREX" = "The Vectrex is a vector display-based home video game console that was developed by Smith Engineering and manufactured and sold by General Consumer Electronics starting October 1982."
        "ENABLE_VIC20" = "The VIC-20 is an 8-bit entry level home computer that was sold by Commodore Business Machines, it was announced in 1980."
        "ENABLE_VSELECT" = "If you have an OSCR with VSELECT automatic voltage selection you need to enable this option."
        "ENABLE_VSMILE" = "The V.Smile is a sixth-generation educational home video game console manufactured and released by VTech released in 2004."
        "ENABLE_WS" = "The WonderSwan is a handheld game console released in Japan by Bandai in March 1999."
        "ENABLE_WSV" = "The Watara Supervision, also known as the QuickShot Supervision in the UK, is a monochrome handheld game console, originating from Asia, and introduced in 1992."
        "OPTION_MD_DEFAULT_SAVE_TYPE" = "Configure how the MD core saves are formatted. 0: Output each byte once (default), 1: Duplicate each byte, 2: Same as 1 + pad with 0xFF to 64KB."
        "OPTION_LCD_BG_COLOR" = "Set the backlight color of the LCD."
        "OPTION_REVERSE_SORT" = "Enable to sort files/folders from newest to oldest in the file browser."
    }

    function Get-ConfigData {
        $configLinesAll = Get-Content $configPath -ErrorAction Stop
        $marker = "/*==== PROCESSING =================================================*/"
        $markerIndex = $null
        for ($i = 0; $i -lt $configLinesAll.Count; $i++) {
            if ($configLinesAll[$i] -like "*$marker*") {
                $markerIndex = $i
                break
            }
        }
        if ($null -ne $markerIndex) {
            $configLines = $configLinesAll[0..($markerIndex - 1)]
        } else {
            $configLines = $configLinesAll
        }

        $configDefs = @{}
        foreach ($line in $configLines) {
            if ($line -match '^(#define|//#define)\s+(\w+)\b') {
                $name = $matches[2]
                if ($name -eq "CONFIG_H_") { continue }

                # Special handling for OPTION_LCD_BG_COLOR
                if ($name -eq "OPTION_LCD_BG_COLOR") {
                    if ($line -match '#define\s+OPTION_LCD_BG_COLOR\s+(\d+),\s*(\d+),\s*(\d+)') {
                        $g = [int]$matches[1]
                        $r = [int]$matches[2]
                        $b = [int]$matches[3]
                        if ($g -eq 0 -and $r -eq 0 -and $b -eq 100) { $configDefs[$name] = "Blue" }
                        elseif ($g -eq 0 -and $r -eq 100 -and $b -eq 0) { $configDefs[$name] = "Red" }
                        elseif ($g -eq 100 -and $r -eq 0 -and $b -eq 0) { $configDefs[$name] = "Green" }
                        elseif ($g -eq 100 -and $r -eq 100 -and $b -eq 0) { $configDefs[$name] = "Yellow" }
                        elseif ($g -eq 0 -and $r -eq 100 -and $b -eq 100) { $configDefs[$name] = "Magenta" }
                        elseif ($g -eq 100 -and $r -eq 0 -and $b -eq 100) { $configDefs[$name] = "Cyan" }
                        elseif ($g -eq 100 -and $r -eq 100 -and $b -eq 100) { $configDefs[$name] = "White" }
                        elseif ($g -eq 50 -and $r -eq 100 -and $b -eq 0) { $configDefs[$name] = "Orange" }
                        else { $configDefs[$name] = "$g,$r,$b" }
                    } else {
                        $configDefs[$name] = $null
                    }
                    continue
                }
                if ($name -eq "OPTION_LCD_BG_COLOR") { continue }

                # Special handling for numeric options
                if ($name -eq "OPTION_MD_DEFAULT_SAVE_TYPE") {
                    if ($line -match '#define\s+OPTION_MD_DEFAULT_SAVE_TYPE\s+(\d+)') {
                        $configDefs[$name] = [int]$matches[1]
                    } else {
                        $configDefs[$name] = $null
                    }
                } else {
                    $enabled = $line -like "#define*"
                    $configDefs[$name] = $enabled
                }
            }
        }
        return $configDefs
    }

    $configDefs = Get-ConfigData

    $applyChanges = @{}
    if (Test-Path $applyPath) {
        $applyContent = Get-Content $applyPath -ErrorAction SilentlyContinue
        if ($applyContent) {
            foreach ($line in $applyContent) {
                $line = $line.Trim()
                if ($line -match '^(#|//)?\s*#define\s+(\w+)') {
                    $name = $matches[2]
                    if ($name -eq "CONFIG_H_") { continue }

                    # Special handling for OPTION_LCD_BG_COLOR
                    if ($name -eq "OPTION_LCD_BG_COLOR") {
                        if ($line -match '#define\s+OPTION_LCD_BG_COLOR\s+(\d+),\s*(\d+),\s*(\d+)') {
                            $g = [int]$matches[1]
                            $r = [int]$matches[2]
                            $b = [int]$matches[3]
                            if ($g -eq 0 -and $r -eq 0 -and $b -eq 100) { $applyChanges[$name] = "Blue" }
                            elseif ($g -eq 0 -and $r -eq 100 -and $b -eq 0) { $applyChanges[$name] = "Red" }
                            elseif ($g -eq 100 -and $r -eq 0 -and $b -eq 0) { $applyChanges[$name] = "Green" }
                            elseif ($g -eq 100 -and $r -eq 100 -and $b -eq 0) { $applyChanges[$name] = "Yellow" }
                            elseif ($g -eq 0 -and $r -eq 100 -and $b -eq 100) { $applyChanges[$name] = "Magenta" }
                            elseif ($g -eq 100 -and $r -eq 0 -and $b -eq 100) { $applyChanges[$name] = "Cyan" }
                            elseif ($g -eq 100 -and $r -eq 100 -and $b -eq 100) { $applyChanges[$name] = "White" }
                            elseif ($g -eq 50 -and $r -eq 100 -and $b -eq 0) { $applyChanges[$name] = "Orange" }
                            else { $applyChanges[$name] = "$g,$r,$b" }
                        } else {
                            $applyChanges[$name] = $null
                        }
                        continue
                    }
                    if ($name -eq "OPTION_LCD_BG_COLOR") { continue }

                    # Special handling for numeric options
                    if ($name -eq "OPTION_MD_DEFAULT_SAVE_TYPE") {
                        if ($line -match '#define\s+OPTION_MD_DEFAULT_SAVE_TYPE\s+(\d+)') {
                            $applyChanges[$name] = [int]$matches[1]
                        } else {
                            $applyChanges[$name] = $null
                        }
                    } else {
                        $enable = -not ($line.StartsWith("//"))
                        $applyChanges[$name] = $enable
                    }
                }
            }
        }
    }

    $hardwareKeys = @("HW1", "HW2", "HW3", "HW4", "HW5", "SERIAL_MONITOR")
    $rtcKeys = @("DS1307", "DS3231")

    $currentHardware = $hardwareKeys | Where-Object { $configDefs[$_] } | Select-Object -First 1
    if (-not $currentHardware) { $currentHardware = $hardwareKeys[0] }

    $applyHardware = $hardwareKeys | Where-Object { $applyChanges.ContainsKey($_) -and $applyChanges[$_] } | Select-Object -First 1
    if (-not $applyHardware) { $applyHardware = $currentHardware }

    $currentRTC = $rtcKeys | Where-Object { $configDefs[$_] } | Select-Object -First 1
    if (-not $currentRTC) { $currentRTC = $rtcKeys[0] }

    $applyRTC = $rtcKeys | Where-Object { $applyChanges.ContainsKey($_) -and $applyChanges[$_] } | Select-Object -First 1
    if (-not $applyRTC) { $applyRTC = $currentRTC }

    $allKeys = ($configDefs.Keys + $applyChanges.Keys) | Sort-Object -Unique

    $hardwareSet = $hardwareKeys + "ENABLE_RTC", "RTC", "ENABLE_3V3FIX", "ENABLE_CLOCKGEN", "ENABLE_VSELECT"
    $optionSet = @(
        "ENABLE_CONFIG", "ENABLE_GLOBAL_LOG", "ENABLE_UPDATER"
    ) + ($allKeys | Where-Object { $_ -like "OPTION_*" })
    $moduleSet = $allKeys | Where-Object {
        ($_ -notin $hardwareSet) -and
        ($_ -notin $optionSet) -and
        ($_ -ne "CONFIG_H_") -and
        ($_ -notin $rtcKeys) -and
        ($_ -ne "use_md_conf")
    }

    function Add-ConfigRows {
        param(
            $grid, $keys, $configDefs, $applyChanges,
            $currentHardware, $applyHardware, $currentRTC, $applyRTC, $tooltipTexts
        )
        $grid.Rows.Clear()
        foreach ($key in $keys) {
            try {
                if ($key -eq "Hardware") {
                    $future = $applyHardware
                    $rowIndex = $grid.Rows.Add($key, $future)
                    $row = $grid.Rows[$rowIndex]
                    $row.Cells[1].Items.Clear()
                    $row.Cells[1].Items.AddRange($hardwareKeys)
                    $isDifferent = $future -ne $currentHardware
                }
                elseif ($key -eq "RTC") {
                    $future = $applyRTC
                    $displayName = "RTC module type"
                    $rowIndex = $grid.Rows.Add($displayName, $future)
                    $row = $grid.Rows[$rowIndex]
                    $row.Cells[1].Items.Clear()
                    $row.Cells[1].Items.AddRange($rtcKeys)
                    $isDifferent = $future -ne $currentRTC
                }
                elseif ($key -eq "OPTION_MD_DEFAULT_SAVE_TYPE") {
                    $current = if ($configDefs.ContainsKey($key)) { $configDefs[$key] } else { $null }
                    $future = if ($applyChanges.ContainsKey($key)) { $applyChanges[$key] } else { $current }
                    $displayValue = if ($null -eq $future) { "Disabled" } else { $future.ToString() }
                    $rowIndex = $grid.Rows.Add($key, $displayValue)
                    $row = $grid.Rows[$rowIndex]
                    $row.Cells[1].Items.Clear()
                    $row.Cells[1].Items.AddRange(@("Disabled", "0", "1", "2"))
                    $isDifferent = $current -ne $future
                }
                elseif ($key -eq "OPTION_LCD_BG_COLOR") {
                    $current = if ($configDefs.ContainsKey($key)) { $configDefs[$key] } else { $null }
                    $future = if ($applyChanges.ContainsKey($key)) { $applyChanges[$key] } else { $current }
                    $displayValue = if ($null -eq $future) { "Red" } else { $future.ToString() }
                    $rowIndex = $grid.Rows.Add($key, $displayValue)
                    $row = $grid.Rows[$rowIndex]
                    $row.Cells[1].Items.Clear()
                    $row.Cells[1].Items.AddRange(@("Red", "Green", "Blue", "Yellow", "Magenta", "Cyan", "White", "Orange"))
                    $isDifferent = $current -ne $future
                }
                else {
                    $current = if ($configDefs.ContainsKey($key)) { $configDefs[$key] } else { $false }
                    $future = if ($applyChanges.ContainsKey($key)) { $applyChanges[$key] } else { $current }
                    $rowIndex = $grid.Rows.Add($key, $future.ToString())
                    $row = $grid.Rows[$rowIndex]
                    $row.Cells[1].Items.Clear()
                    $row.Cells[1].Items.AddRange(@("True", "False"))
                    $isDifferent = $current -ne $future
                }
                if ($isDifferent) {
                    $row.Cells[1].Style.ForeColor = [System.Drawing.Color]::Red
                } else {
                    $row.Cells[1].Style.ForeColor = [System.Drawing.Color]::Black
                }
            }
            catch {
                Write-Warning "Error adding row for key '$key': $_"
            }
        }
    }

    $form = New-Object Windows.Forms.Form
    $form.Text = "Open Source Cartridge Reader"
    $form.Size = New-Object Drawing.Size(760, 920)
    $form.StartPosition = "CenterScreen"
    $form.Topmost = $false
    $form.MinimumSize = New-Object Drawing.Size(760, 920)

    # Remove scrollbars from the main panel
    $panel = New-Object Windows.Forms.Panel
    $panel.AutoScroll = $false
    $panel.Dock = "Fill"
    $panel.HorizontalScroll.Enabled = $false
    $panel.HorizontalScroll.Visible = $false
    $panel.VerticalScroll.Enabled = $false
    $panel.VerticalScroll.Visible = $true

    function New-Grid {
        param($rowCount)
        $grid = New-Object Windows.Forms.DataGridView
        $headerHeight = 23
        $rowHeight = 22
        $buffer = 5
        $calculatedHeight = $headerHeight + ($rowCount * $rowHeight) + $buffer
        $gridWidth = 700
        $grid.Size = New-Object Drawing.Size($gridWidth, $calculatedHeight)
        $grid.Location = New-Object Drawing.Point(10, 0)
        $grid.Anchor = "Top, Left, Right"
        $grid.AutoSizeColumnsMode = 'None'
        $grid.AllowUserToAddRows = $false
        $grid.AllowUserToDeleteRows = $false
        $grid.AllowUserToResizeRows = $false
        $grid.EditMode = "EditOnEnter"
        $grid.SelectionMode = "CellSelect"
        $grid.RowHeadersVisible = $false
        $grid.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical

        $colDefine = New-Object Windows.Forms.DataGridViewTextBoxColumn
        $colDefine.Name = "Define"
        $colDefine.HeaderText = "Define"
        $colDefine.ReadOnly = $true
        $colDefine.Width = 454

        $colFuture = New-Object Windows.Forms.DataGridViewComboBoxColumn
        $colFuture.Name = "Will Be After Apply"
        $colFuture.HeaderText = "Value"
        $colFuture.Width = 260

        $grid.Columns.AddRange($colDefine, $colFuture)

        $grid.add_Scroll({
            param($src, $e)
            if ($e.ScrollOrientation -eq [System.Windows.Forms.ScrollOrientation]::HorizontalScroll) {
                $e.NewValue = 0
            }
        })

        $grid.add_DataError({
            param($src, $e)
            $e.ThrowException = $false
            Write-Warning "DataGrid error: $($e.Exception.Message)"
        })

        return $grid
    }

    # Function to get available COM ports
    function Get-ComPorts {
        try {
            $ports = [System.IO.Ports.SerialPort]::GetPortNames() | Sort-Object
            if ($ports.Count -eq 0) {
                return @("No COM ports found")
            }
            return $ports
        } catch {
            return @("Error detecting ports")
        }
    }

    # COM Port dropdown
    $comPortDropdown = New-Object Windows.Forms.ComboBox
    $comPortDropdown.Location = New-Object Drawing.Point(10, 12)
    $comPortDropdown.Size = New-Object Drawing.Size(80, 25)
    $comPortDropdown.DropDownStyle = "DropDownList"
    $comPortPorts = Get-ComPorts
    $comPortDropdown.Items.AddRange($comPortPorts)
    if ($comPortPorts.Count -gt 0 -and $comPortPorts[0] -ne "No COM ports found") {
        $comPortDropdown.SelectedIndex = 0
    }

    # Refresh COM Port button
    $btnRefreshCOM = New-Object Windows.Forms.Button
    $btnRefreshCOM.Text = "Refresh"
    $btnRefreshCOM.Size = New-Object Drawing.Size(80, 35)
    $btnRefreshCOM.Location = New-Object Drawing.Point(100, 10)
    $btnRefreshCOM.BackColor = [System.Drawing.Color]::LightGray
    $btnRefreshCOM.FlatStyle = "Flat"

    # Update button
    $btnUpdate = New-Object Windows.Forms.Button
    $btnUpdate.Text = "Update"
    $btnUpdate.Size = New-Object Drawing.Size(80, 35)
    $btnUpdate.Location = New-Object Drawing.Point(190, 10)
    $btnUpdate.BackColor = [System.Drawing.Color]::LightPink
    $btnUpdate.FlatStyle = "Flat"

    # Backup button
    $btnBackup = New-Object Windows.Forms.Button
    $btnBackup.Text = "Backup"
    $btnBackup.Size = New-Object Drawing.Size(80, 35)
    $btnBackup.Location = New-Object Drawing.Point(280, 10)
    $btnBackup.BackColor = [System.Drawing.Color]::LightYellow
    $btnBackup.FlatStyle = "Flat"

    # Apply button
    $btnApply = New-Object Windows.Forms.Button
    $btnApply.Text = "Apply Changes"
    $btnApply.Size = New-Object Drawing.Size(80, 35)
    $btnApply.Location = New-Object Drawing.Point(370, 10)
    $btnApply.BackColor = [System.Drawing.Color]::LightBlue
    $btnApply.FlatStyle = "Flat"

    # Arduino IDE button
    $btnArduinoIDE = New-Object Windows.Forms.Button
    $btnArduinoIDE.Text = "Arduino IDE"
    $btnArduinoIDE.Size = New-Object Drawing.Size(80, 35)
    $btnArduinoIDE.Location = New-Object Drawing.Point(460, 10)
    $btnArduinoIDE.BackColor = [System.Drawing.Color]::LightGreen
    $btnArduinoIDE.FlatStyle = "Flat"

    # Restore button
    $btnRestore = New-Object Windows.Forms.Button
    $btnRestore.Text = "Restore"
    $btnRestore.Size = New-Object Drawing.Size(80, 35)
    $btnRestore.Location = New-Object Drawing.Point(550, 10)
    $btnRestore.BackColor = [System.Drawing.Color]::LightCoral
    $btnRestore.FlatStyle = "Flat"
	
    # --- Copy to SD Button ---
    $btnCopyToSD = New-Object Windows.Forms.Button
    $btnCopyToSD.Text = "Copy to SD"
    $btnCopyToSD.Size = New-Object Drawing.Size(80, 35)
    $btnCopyToSD.Location = New-Object Drawing.Point(640, 10)
    $btnCopyToSD.BackColor = [System.Drawing.Color]::LightCyan
    $btnCopyToSD.FlatStyle = "Flat"
	
    # Create tooltips for buttons
    $tooltip = New-Object Windows.Forms.ToolTip
    $tooltip.SetToolTip($btnRefreshCOM, "Searches for available COM ports")
    $tooltip.SetToolTip($btnUpdate, "Updates the OSCR Arduino sketch")
    $tooltip.SetToolTip($btnBackup, "Saves the current firmware of the OSCR to the PC")
    $tooltip.SetToolTip($btnApply, "Writes the changes colored in red to the config.h")
    $tooltip.SetToolTip($btnArduinoIDE, "Launches the Arduino IDE so you can compile and flash the code")
    $tooltip.SetToolTip($btnRestore, "Restores the saved firmware in case something went wrong")
    $tooltip.SetToolTip($btnCopyToSD, "Copies the game databases to the SD card and hides them")

    # Status label
    $statusLabel = New-Object Windows.Forms.Label
    $statusLabel.Text = "Red text indicates changes from current config in apply_config.txt"
    $statusLabel.Location = New-Object Drawing.Point(10, 50)
    $statusLabel.Size = New-Object Drawing.Size(575, 20)
    $statusLabel.ForeColor = [System.Drawing.Color]::DarkGreen

    $labelHardware = New-Object Windows.Forms.Label
    $labelHardware.Text = "Hardware Config"
    $labelHardware.Location = New-Object Drawing.Point(10, 75)
    $labelHardware.Size = New-Object Drawing.Size(700, 20)
    $labelHardware.Font = New-Object Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Bold)

    $hardwareDisplayKeys = @("Hardware", "ENABLE_RTC", "RTC", "ENABLE_3V3FIX", "ENABLE_CLOCKGEN", "ENABLE_VSELECT")
    $gridHardware = New-Grid -rowCount $hardwareDisplayKeys.Count
    $gridHardware.Location = New-Object Drawing.Point(10, 100)

    # Add tooltip functionality to hardware grid
    $gridHardware.add_CellMouseEnter({
        param($src, $e)
        if ($e.RowIndex -ge 0 -and $e.ColumnIndex -eq 0) {
            $key = $src.Rows[$e.RowIndex].Cells[0].Value
            if ($tooltipTexts.ContainsKey($key)) {
                $src.ShowCellToolTips = $true
                $src.Rows[$e.RowIndex].Cells[0].ToolTipText = $tooltipTexts[$key]
            }
        }
    })

    $labelOption = New-Object Windows.Forms.Label
    $labelOption.Text = "Options Config"
    $labelOption.Location = New-Object Drawing.Point(10, ($gridHardware.Location.Y + $gridHardware.Height + 15))
    $labelOption.Size = New-Object Drawing.Size(700, 20)
    $labelOption.Font = New-Object Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Bold)

    $gridOption = New-Grid -rowCount $optionSet.Count
    $gridOption.Location = New-Object Drawing.Point(10, ($labelOption.Location.Y + 25))

    # Add tooltip functionality to option grid
    $gridOption.add_CellMouseEnter({
        param($src, $e)
        if ($e.RowIndex -ge 0 -and $e.ColumnIndex -eq 0) {
            $key = $src.Rows[$e.RowIndex].Cells[0].Value
            if ($tooltipTexts.ContainsKey($key)) {
                $src.ShowCellToolTips = $true
                $src.Rows[$e.RowIndex].Cells[0].ToolTipText = $tooltipTexts[$key]
            }
        }
    })

    $labelModule = New-Object Windows.Forms.Label
    $labelModule.Text = "Module Config"
    $labelModule.Location = New-Object Drawing.Point(10, ($gridOption.Location.Y + $gridOption.Height + 15))
    $labelModule.Size = New-Object Drawing.Size(700, 20)
    $labelModule.Font = New-Object Drawing.Font("Microsoft Sans Serif", 10, [System.Drawing.FontStyle]::Bold)

    # --- Only the module grid should scroll ---
    # Set a fixed height for the module grid and enable vertical scrolling
    $gridModuleVisibleRows = 12
    $gridModule = New-Grid -rowCount $gridModuleVisibleRows
    $gridModule.Location = New-Object Drawing.Point(10, ($labelModule.Location.Y + 25))
    $gridModule.Height = 23 + ($gridModuleVisibleRows * 22) + 5
    $gridModule.ScrollBars = [System.Windows.Forms.ScrollBars]::Vertical
    $gridModule.Anchor = "Top, Left, Right"

    # Add tooltip functionality to module grid
    $gridModule.add_CellMouseEnter({
        param($src, $e)
        if ($e.RowIndex -ge 0 -and $e.ColumnIndex -eq 0) {
            $key = $src.Rows[$e.RowIndex].Cells[0].Value
            if ($tooltipTexts.ContainsKey($key)) {
                $src.ShowCellToolTips = $true
                $src.Rows[$e.RowIndex].Cells[0].ToolTipText = $tooltipTexts[$key]
            }
        }
    })

    # Add configuration rows
    Add-ConfigRows -grid $gridHardware -keys $hardwareDisplayKeys -configDefs $configDefs -applyChanges $applyChanges -currentHardware $currentHardware -applyHardware $applyHardware -currentRTC $currentRTC -applyRTC $applyRTC -tooltipTexts $tooltipTexts
    Add-ConfigRows -grid $gridOption -keys $optionSet -configDefs $configDefs -applyChanges $applyChanges -currentHardware $currentHardware -applyHardware $applyHardware -currentRTC $currentRTC -applyRTC $applyRTC -tooltipTexts $tooltipTexts
    Add-ConfigRows -grid $gridModule -keys $moduleSet -configDefs $configDefs -applyChanges $applyChanges -currentHardware $currentHardware -applyHardware $applyHardware -currentRTC $currentRTC -applyRTC $applyRTC -tooltipTexts $tooltipTexts

    # Backup button click handler
    $btnBackup.Add_Click({
        try {
            $selectedPort = $comPortDropdown.SelectedItem
            if (-not $selectedPort -or $selectedPort -eq "No COM ports found" -or $selectedPort -eq "Error detecting ports") {
                [System.Windows.Forms.MessageBox]::Show("Please select a valid COM port first.", "No COM Port Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
                return
            }

            # Define paths
            $avrdudeExe = ".\Arduino IDE\hardware\tools\avr\bin\avrdude.exe"
            $avrdudeConf = ".\Arduino IDE\hardware\tools\avr\etc\avrdude.conf"
            $backupFile = "backup.hex"

            # Build arguments array
            $avrdudeArgs = @(
                "-C", "`"$avrdudeConf`""
                "-c", "wiring"
                "-P", $selectedPort
                "-b", "115200"
                "-p", "m2560"
                "-U", "flash:r:$backupFile"
            )

            $statusLabel.Text = "Creating backup... Please wait."
            $statusLabel.ForeColor = [System.Drawing.Color]::Orange
            $statusLabel.Refresh()

            # Run avrdude directly in PowerShell
            $process = Start-Process -FilePath $avrdudeExe -ArgumentList $avrdudeArgs -Wait -PassThru -NoNewWindow

            if ($process.ExitCode -eq 0) {
                $statusLabel.Text = "Backup created successfully as backup.hex"
                $statusLabel.ForeColor = [System.Drawing.Color]::Green
            } else {
                $statusLabel.Text = "Backup failed. Check COM port and connection."
                $statusLabel.ForeColor = [System.Drawing.Color]::Red
            }
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error creating backup:`n$($_.Exception.Message)", "Backup Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            $statusLabel.Text = "Backup failed with error."
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
        }
    })

	$btnArduinoIDE.Add_Click({
		try {
			$prefsPath = "Arduino IDE\portable\preferences.txt"
			$selectedPort = $comPortDropdown.SelectedItem
			if (-not $selectedPort -or $selectedPort -eq "No COM ports found" -or $selectedPort -eq "Error detecting ports") {
				[System.Windows.Forms.MessageBox]::Show("Please select a valid COM port first.", "No COM Port Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
				return
			}

            # --- Build last.sketch0.path dynamically ---
            $scriptDir = $null
            if ($PSScriptRoot) {
                $scriptDir = $PSScriptRoot
            } elseif ($MyInvocation.MyCommand.Path) {
                $scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
            } else {
                $scriptDir = Get-Location
            }
            $sketchRelPath = "Arduino IDE\portable\sketchbook\Cart_Reader\Cart_Reader.ino"
            $sketchFullPath = [System.IO.Path]::Combine($scriptDir, $sketchRelPath)
            $sketchFullPath = [System.IO.Path]::GetFullPath($sketchFullPath)
            $targetSketch = "last.sketch0.path=$sketchFullPath"
            $targetSketchCount = "last.sketch.count=1"

            if (-not (Test-Path $prefsPath)) {
                Write-Host "preferences.txt file not found. Creating new file..." -ForegroundColor Yellow
                $parentDir = Split-Path $prefsPath -Parent
                if (-not (Test-Path $parentDir)) {
                    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
                    Write-Host "Created directory: $parentDir" -ForegroundColor Green
                }
                $newFileContent = @(
                    "board=mega",
                    "custom_cpu=mega_atmega2560",
                    "serial.port=$selectedPort",
                    $targetSketch,
                    $targetSketchCount
                )
                try {
                    [System.IO.File]::WriteAllLines($prefsPath, $newFileContent, [System.Text.UTF8Encoding]::new($false))
                    Write-Host "Created new preferences.txt with required settings:" -ForegroundColor Green
                    Write-Host "  board=mega" -ForegroundColor White
                    Write-Host "  custom_cpu=mega_atmega2560" -ForegroundColor White
                    Write-Host "  serial.port=$selectedPort" -ForegroundColor White
                    Write-Host "  $targetSketch" -ForegroundColor White
                    Write-Host "  $targetSketchCount" -ForegroundColor White
                }
                catch {
                    Write-Host "Error creating file: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            else {
                $content = Get-Content $prefsPath
                Write-Host "Checking Arduino IDE preferences..." -ForegroundColor Green

                $targetBoard = "board=mega"
                $targetCpu = "custom_cpu=mega_atmega2560"
                $targetPort = "serial.port=$selectedPort"
                $targetSketch = "last.sketch0.path=$sketchFullPath"
                $targetSketchCount = "last.sketch.count=1"

                $boardFound = $false
                $cpuFound = $false
                $portFound = $false
                $sketchFound = $false
                $sketchCountFound = $false
                $boardCorrect = $false
                $cpuCorrect = $false
                $portCorrect = $false
                $sketchCorrect = $false
                $sketchCountCorrect = $false
                $modified = $false

                foreach ($line in $content) {
                    if ($line -match "^board=") {
                        $boardFound = $true
                        if ($line -eq $targetBoard) { $boardCorrect = $true }
                    }
                    elseif ($line -match "^custom_cpu=") {
                        $cpuFound = $true
                        if ($line -eq $targetCpu) { $cpuCorrect = $true }
                    }
                    elseif ($line -match "^serial\.port=") {
                        $portFound = $true
                        if ($line -eq $targetPort) { $portCorrect = $true }
                    }
                    elseif ($line -match "^last\.sketch0\.path=") {
                        $sketchFound = $true
                        if ($line -eq $targetSketch) { $sketchCorrect = $true }
                    }
                    elseif ($line -match "^last\.sketch\.count=") {
                        $sketchCountFound = $true
                        if ($line -eq $targetSketchCount) { $sketchCountCorrect = $true }
                    }
                }

                $newContent = @()
                foreach ($line in $content) {
                    if ($line -match "^board=" -and -not $boardCorrect) {
                        $newContent += $targetBoard
                        $modified = $true
                    }
                    elseif ($line -match "^custom_cpu=" -and -not $cpuCorrect) {
                        $newContent += $targetCpu
                        $modified = $true
                    }
                    elseif ($line -match "^serial\.port=") {
                        if (-not $portCorrect) {
                            $newContent += $targetPort
                            $modified = $true
                        } else {
                            $newContent += $line
                        }
                    }
                    elseif ($line -match "^last\.sketch0\.path=") {
                        if (-not $sketchCorrect) {
                            $newContent += $targetSketch
                            $modified = $true
                        } else {
                            $newContent += $line
                        }
                    }
                    elseif ($line -match "^last\.sketch\.count=") {
                        if (-not $sketchCountCorrect) {
                            $newContent += $targetSketchCount
                            $modified = $true
                        } else {
                            $newContent += $line
                        }
                    }
                    else {
                        $newContent += $line
                    }
                }
                if (-not $boardFound) {
                    $newContent += $targetBoard
                    $modified = $true
                }
                if (-not $cpuFound) {
                    $newContent += $targetCpu
                    $modified = $true
                }
                if (-not $portFound) {
                    $newContent += $targetPort
                    $modified = $true
                }
                if (-not $sketchFound) {
                    $newContent += $targetSketch
                    $modified = $true
                }
                if (-not $sketchCountFound) {
                    $newContent += $targetSketchCount
                    $modified = $true
                }

                if ($modified) {
                    try {
                        [System.IO.File]::WriteAllLines($prefsPath, $newContent, [System.Text.UTF8Encoding]::new($false))
                        Write-Host "`nChanges saved successfully!" -ForegroundColor Green
                        Write-Host "Updated preferences:" -ForegroundColor Green
                        Write-Host "  $targetBoard" -ForegroundColor White
                        Write-Host "  $targetCpu" -ForegroundColor White
                        Write-Host "  $targetPort" -ForegroundColor White
                        Write-Host "  $targetSketch" -ForegroundColor White
                        Write-Host "  $targetSketchCount" -ForegroundColor White
                    }
                    catch {
                        Write-Host "`nError writing to file: $($_.Exception.Message)" -ForegroundColor Red
                    }
                } else {
                    Write-Host "`nNo changes needed - all settings are correct!" -ForegroundColor Green
                }
            }

			Start-Sleep -Milliseconds 500
			Write-Host "Launching Arduino IDE..." -ForegroundColor Green

			if (Test-Path ".\Arduino IDE\arduino.exe") {
				Start-Process -FilePath ".\Arduino IDE\arduino.exe"
				$statusLabel.Text = "Arduino IDE launched (preferences checked)"
				$statusLabel.ForeColor = [System.Drawing.Color]::Green
			} else {
				[System.Windows.Forms.MessageBox]::Show("Arduino IDE not found at .\Arduino IDE\arduino.exe", "Arduino IDE Not Found", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
			}
		} catch {
			[System.Windows.Forms.MessageBox]::Show("Error launching Arduino IDE:`n$($_.Exception.Message)", "Launch Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
		}
	})

    # Refresh COM Port button click handler
    $btnRefreshCOM.Add_Click({
        try {
            $comPortDropdown.Items.Clear()
            $comPortPorts = Get-ComPorts
            $comPortDropdown.Items.AddRange($comPortPorts)
            if ($comPortPorts.Count -gt 0 -and $comPortPorts -notcontains "No COM ports found") {
				$statusLabel.ForeColor = [System.Drawing.Color]::Green
				$comPortDropdown.SelectedIndex = 0
				$statusLabel.Text = "COM ports refreshed"
            }
			else {
				$statusLabel.ForeColor = [System.Drawing.Color]::Red	
				$comPortDropdown.SelectedIndex = 0
				$statusLabel.Text = "COM ports refreshed"
				# Ask user if they want to install CH341 drivers
				$result = [System.Windows.Forms.MessageBox]::Show("No COM ports found. Would you like to install CH341 drivers?", "Install Drivers", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
				if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
					try {
						Start-Process -FilePath ".\CH341 Drivers\SETUP.EXE" -Verb RunAs
					} catch {
						[System.Windows.Forms.MessageBox]::Show("Error launching driver installer:`n$($_.Exception.Message)", "Driver Install Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
					}
				}
			}         
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error refreshing COM ports:`n$($_.Exception.Message)", "Refresh Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    # Update button click handler
    $btnUpdate.Add_Click({
        try {
            $statusLabel.Text = "Updating OSCR... Please wait."
            $statusLabel.ForeColor = [System.Drawing.Color]::Orange
            $statusLabel.Refresh()

            Write-Host "Delete old version"
            if (Test-Path "Arduino IDE\portable\sketchbook\Cart_Reader") { Remove-Item "Arduino IDE\portable\sketchbook\Cart_Reader" -Recurse -Force }
            if (Test-Path "SD Card") { Remove-Item "SD Card" -Recurse -Force }
            if (Test-Path "master") { Remove-Item "master" -Recurse -Force }
            if (Test-Path "master.zip") { Remove-Item "master.zip" -Force }
            if (Test-Path "LICENSE.txt") { Remove-Item "LICENSE.txt" -Force }

            Write-Host "Downloading latest OSCR version from github.com/sanni/cartreader"
            Invoke-WebRequest "https://github.com/sanni/cartreader/archive/refs/heads/master.zip" -OutFile "master.zip"

            # Extracting
            Add-Type -AssemblyName System.IO.Compression.FileSystem
            [System.IO.Compression.ZipFile]::ExtractToDirectory("master.zip", "master")

            # Moving to sub-folders
            Move-Item "master\cartreader-master\Cart_Reader" "Arduino IDE\portable\sketchbook\Cart_Reader"
            Move-Item "master\cartreader-master\sd" .
            Move-Item "master\cartreader-master\LICENSE" "LICENSE.txt"
            Rename-Item "sd" "SD Card"

            # Clean-up
            $readme1 = "SD Card\README.md"
            $readme2 = "Arduino IDE\portable\sketchbook\Cart_Reader\README.md"
            $licenseCopy = "Arduino IDE\portable\sketchbook\Cart_Reader\LICENSE.txt"
            if (Test-Path $readme1) { Remove-Item $readme1 -Force }
            if (Test-Path $readme2) { Remove-Item $readme2 -Force }
            if (Test-Path $licenseCopy) { Remove-Item $licenseCopy -Force }
            if (Test-Path "master") { Remove-Item "master" -Recurse -Force }
            if (Test-Path "master.zip") { Remove-Item "master.zip" -Force }

            # Reload config data after update
            $script:configDefs = Get-ConfigData
            $script:applyChanges = @{}
            if (Test-Path $applyPath) {
                $applyContent = Get-Content $applyPath -ErrorAction SilentlyContinue
                if ($applyContent) {
                    foreach ($line in $applyContent) {
                        $line = $line.Trim()
                        if ($line -match '^(#|//)?\s*#define\s+(\w+)') {
                            $name = $matches[2]
                            if ($name -eq "CONFIG_H_") { continue }
                            if ($name -eq "OPTION_LCD_BG_COLOR") {
                                if ($line -match '#define\s+OPTION_LCD_BG_COLOR\s+(\d+),\s*(\d+),\s*(\d+)') {
                                    $g = [int]$matches[1]; $r = [int]$matches[2]; $b = [int]$matches[3]
                                    if ($g -eq 0 -and $r -eq 0 -and $b -eq 100) { $script:applyChanges[$name] = "Blue" }
                                    elseif ($g -eq 0 -and $r -eq 100 -and $b -eq 0) { $script:applyChanges[$name] = "Red" }
                                    elseif ($g -eq 100 -and $r -eq 0 -and $b -eq 0) { $script:applyChanges[$name] = "Green" }
                                    elseif ($g -eq 100 -and $r -eq 100 -and $b -eq 0) { $script:applyChanges[$name] = "Yellow" }
                                    elseif ($g -eq 0 -and $r -eq 100 -and $b -eq 100) { $script:applyChanges[$name] = "Magenta" }
                                    elseif ($g -eq 100 -and $r -eq 0 -and $b -eq 100) { $script:applyChanges[$name] = "Cyan" }
                                    elseif ($g -eq 100 -and $r -eq 100 -and $b -eq 100) { $script:applyChanges[$name] = "White" }
                                    elseif ($g -eq 50 -and $r -eq 100 -and $b -eq 0) { $script:applyChanges[$name] = "Orange" }
                                    else { $script:applyChanges[$name] = "$g,$r,$b" }
                                } else { $script:applyChanges[$name] = $null }
                            } elseif ($name -eq "OPTION_MD_DEFAULT_SAVE_TYPE") {
                                if ($line -match '#define\s+OPTION_MD_DEFAULT_SAVE_TYPE\s+(\d+)') {
                                    $script:applyChanges[$name] = [int]$matches[1]
                                } else { $script:applyChanges[$name] = $null }
                            } else {
                                $enable = -not ($line.StartsWith("//"))
                                $script:applyChanges[$name] = $enable
                            }
                        }
                    }
                }
            }

            # Refresh hardware and RTC selections
            $script:currentHardware = $hardwareKeys | Where-Object { $script:configDefs[$_] } | Select-Object -First 1
            if (-not $script:currentHardware) { $script:currentHardware = $hardwareKeys[0] }
            $script:applyHardware = $hardwareKeys | Where-Object { $script:applyChanges.ContainsKey($_) -and $script:applyChanges[$_] } | Select-Object -First 1
            if (-not $script:applyHardware) { $script:applyHardware = $script:currentHardware }
            $script:currentRTC = $rtcKeys | Where-Object { $script:configDefs[$_] } | Select-Object -First 1
            if (-not $script:currentRTC) { $script:currentRTC = $rtcKeys[0] }
            $script:applyRTC = $rtcKeys | Where-Object { $script:applyChanges.ContainsKey($_) -and $script:applyChanges[$_] } | Select-Object -First 1
            if (-not $script:applyRTC) { $script:applyRTC = $script:currentRTC }

            # Refresh all grids
            Add-ConfigRows -grid $gridHardware -keys $hardwareDisplayKeys -configDefs $script:configDefs -applyChanges $script:applyChanges -currentHardware $script:currentHardware -applyHardware $script:applyHardware -currentRTC $script:currentRTC -applyRTC $script:applyRTC -tooltipTexts $tooltipTexts
            Add-ConfigRows -grid $gridOption -keys $optionSet -configDefs $script:configDefs -applyChanges $script:applyChanges -currentHardware $script:currentHardware -applyHardware $script:applyHardware -currentRTC $script:currentRTC -applyRTC $script:applyRTC -tooltipTexts $tooltipTexts
            Add-ConfigRows -grid $gridModule -keys $moduleSet -configDefs $script:configDefs -applyChanges $script:applyChanges -currentHardware $script:currentHardware -applyHardware $script:applyHardware -currentRTC $script:currentRTC -applyRTC $script:applyRTC -tooltipTexts $tooltipTexts

            $statusLabel.Text = "OSCR updated successfully and config reloaded"
            $statusLabel.ForeColor = [System.Drawing.Color]::Green
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error updating OSCR:`n$($_.Exception.Message)", "Update Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            $statusLabel.Text = "Update failed with error."
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
        }
    })

    # Restore button click handler
    $btnRestore.Add_Click({
        try {
            if (-not (Test-Path "backup.hex")) {
                [System.Windows.Forms.MessageBox]::Show("backup.hex file not found. Please create a backup first.", "Backup File Not Found", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
                return
            }
            $selectedPort = $comPortDropdown.SelectedItem
            if (-not $selectedPort -or $selectedPort -eq "No COM ports found" -or $selectedPort -eq "Error detecting ports") {
                [System.Windows.Forms.MessageBox]::Show("Please select a valid COM port first.", "No COM Port Selected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
                return
            }
            $result = [System.Windows.Forms.MessageBox]::Show("This will restore the firmware from backup.hex. Are you sure?", "Confirm Restore", [System.Windows.Forms.MessageBoxButtons]::YesNo, [System.Windows.Forms.MessageBoxIcon]::Question)
            if ($result -ne [System.Windows.Forms.DialogResult]::Yes) {
                return
            }

            # Define avrdude executable and config paths
            $avrdudeExe = ".\Arduino IDE\hardware\tools\avr\bin\avrdude.exe"
            $avrdudeConf = ".\Arduino IDE\hardware\tools\avr\etc\avrdude.conf"

            # Build arguments array for Start-Process
            $avrdudeArgs = @(
                "-C", "`"$avrdudeConf`""
                "-D"
                "-c", "wiring"
                "-P", $selectedPort
                "-b", "115200"
                "-p", "m2560"
                "-U", "flash:w:backup.hex"
            )

            $statusLabel.Text = "Restoring firmware... Please wait."
            $statusLabel.ForeColor = [System.Drawing.Color]::Orange
            $statusLabel.Refresh()

            # Run avrdude directly in PowerShell
            $process = Start-Process -FilePath $avrdudeExe -ArgumentList $avrdudeArgs -Wait -PassThru -NoNewWindow

            if ($process.ExitCode -eq 0) {
                $statusLabel.Text = "Firmware restored successfully"
                $statusLabel.ForeColor = [System.Drawing.Color]::Green
            } else {
                $statusLabel.Text = "Restore failed. Check COM port and connection."
                $statusLabel.ForeColor = [System.Drawing.Color]::Red
            }
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error restoring firmware:`n$($_.Exception.Message)", "Restore Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            $statusLabel.Text = "Restore failed with error."
            $statusLabel.ForeColor = [System.Drawing.Color]::Red
        }
    })

    # Apply button click handler
    $btnApply.Add_Click({
        try {
            $newConfigDefs = @{}

            # Handle hardware selection
            if ($gridHardware.Rows.Count -gt 0) {
                $selectedHw = $gridHardware.Rows[0].Cells[1].Value
                if ($selectedHw) {
                    foreach ($hwKey in $hardwareKeys) {
                        $newConfigDefs[$hwKey] = ($hwKey -eq $selectedHw)
                    }
                }
            }

            # Handle other hardware settings
            if ($gridHardware.Rows.Count -gt 1) {
                $enableRtcValue = $gridHardware.Rows[1].Cells[1].Value
                if ($enableRtcValue -ne $null) {
                    $newConfigDefs["ENABLE_RTC"] = ($enableRtcValue -eq "True")
                }
            }

            if ($gridHardware.Rows.Count -gt 2) {
                $selectedRtc = $gridHardware.Rows[2].Cells[1].Value
                if ($selectedRtc) {
                    foreach ($rtcKey in $rtcKeys) {
                        $newConfigDefs[$rtcKey] = ($rtcKey -eq $selectedRtc)
                    }
                }
            }

            if ($gridHardware.Rows.Count -gt 3) {
                $enable3v3Value = $gridHardware.Rows[3].Cells[1].Value
                if ($enable3v3Value -ne $null) {
                    $newConfigDefs["ENABLE_3V3FIX"] = ($enable3v3Value -eq "True")
                }
            }

            if ($gridHardware.Rows.Count -gt 4) {
                $enableClockgenValue = $gridHardware.Rows[4].Cells[1].Value
                if ($enableClockgenValue -ne $null) {
                    $newConfigDefs["ENABLE_CLOCKGEN"] = ($enableClockgenValue -eq "True")
                }
            }

            if ($gridHardware.Rows.Count -gt 5) {
                $enableVselectValue = $gridHardware.Rows[5].Cells[1].Value
                if ($enableVselectValue -ne $null) {
                    $newConfigDefs["ENABLE_VSELECT"] = ($enableVselectValue -eq "True")
                }
            }

            # Handle option settings
            for ($i = 0; $i -lt $gridOption.Rows.Count; $i++) {
                $key = $gridOption.Rows[$i].Cells[0].Value
                $val = $gridOption.Rows[$i].Cells[1].Value
                if ($key -and $val -ne $null) {
                    if ($key -eq "OPTION_MD_DEFAULT_SAVE_TYPE") {
                        if ($val -eq "Disabled") {
                            $newConfigDefs[$key] = $null
                        } else {
                            $newConfigDefs[$key] = [int]$val
                        }
                    } elseif ($key -eq "OPTION_LCD_BG_COLOR") {
                        $newConfigDefs[$key] = $val
                    } else {
                        $newConfigDefs[$key] = ($val -eq "True")
                    }
                }
            }

            # Handle module settings
            for ($i = 0; $i -lt $gridModule.Rows.Count; $i++) {
                $key = $gridModule.Rows[$i].Cells[0].Value
                $val = $gridModule.Rows[$i].Cells[1].Value
                if ($key -and $val -ne $null) {
                    $newConfigDefs[$key] = ($val -eq "True")
                }
            }

            # Check if there are changes from the original apply_config.txt
            $hasChanges = $false
            foreach ($key in $newConfigDefs.Keys) {
                $guiValue = $newConfigDefs[$key]
                $originalApplyValue = if ($applyChanges.ContainsKey($key)) { $applyChanges[$key] } else { $null }
                if ($originalApplyValue -eq $null -or $guiValue -ne $originalApplyValue) {
                    $hasChanges = $true
                    break
                }
            }
            if (-not $hasChanges) {
                foreach ($key in $applyChanges.Keys) {
                    if (-not $newConfigDefs.ContainsKey($key)) {
                        $hasChanges = $true
                        break
                    }
                }
            }

            # Always update config.h first
            try {
                $originalLines = Get-Content $configPath -ErrorAction Stop
                $newLines = @()
                foreach ($line in $originalLines) {
                    if ($line -match '^(#define|//#define)\s+(\w+)\b') {
                        $defineName = $matches[2]
                        if ($defineName -eq "CONFIG_H_") {
                            $newLines += $line
                            continue
                        }
                        if ($newConfigDefs.ContainsKey($defineName)) {
                            if ($defineName -eq "OPTION_MD_DEFAULT_SAVE_TYPE") {
                                $value = $newConfigDefs[$defineName]
                                $newLine = if ($value -eq $null) { "//#define $defineName 0" } else { "#define $defineName $value" }
                                $newLines += $newLine
                            } elseif ($defineName -eq "OPTION_LCD_BG_COLOR") {
                                $value = $newConfigDefs[$defineName]
                                # Map color name to RGB string if needed, otherwise use as-is if already RGB
                                if ($null -eq $value) {
                                    $rgb = "100, 0, 0" # fallback to Green if null
                                } elseif ($value -match '^\d+\s*,\s*\d+\s*,\s*\d+$') {
                                    $rgb = $value
                                } else {
                                    switch ($value) {
                                        "Red"     { $rgb = "0, 100, 0" }
                                        "Green"   { $rgb = "100, 0, 0" }
                                        "Blue"    { $rgb = "0, 0, 100" }
                                        "Yellow"  { $rgb = "100, 100, 0" }
                                        "Magenta" { $rgb = "0, 100, 100" }
                                        "Cyan"    { $rgb = "100, 0, 100" }
                                        "White"   { $rgb = "100, 100, 100" }
                                        "Orange"  { $rgb = "50, 100, 0" }
                                        default   { $rgb = "100, 0, 0" } # fallback to Green if unknown
                                    }
                                }
                                $newLine = "#define $defineName $rgb"
                                $newLines += $newLine
                            } else {
                                $shouldEnable = $newConfigDefs[$defineName]
                                $newLine = if ($shouldEnable) { "#define $defineName" } else { "//#define $defineName" }
                                $newLines += $newLine
                            }
                        } else {
                            $newLines += $line
                        }
                    } else {
                        $newLines += $line
                    }
                }
                [System.IO.File]::WriteAllLines($configPath, $newLines, [System.Text.UTF8Encoding]::new($false))
                $statusLabel.Text = "Config.h updated successfully"
                $statusLabel.ForeColor = [System.Drawing.Color]::Green
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Error updating config.h:`n$($_.Exception.Message)", "Config Update Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                return
            }

            # Handle apply_config.txt based on whether changes were made
            if ($hasChanges) {
                $result = [System.Windows.Forms.MessageBox]::Show(
                    "You made changes to the configuration settings.`n`nDo you want to save these changes to apply_config.txt?",
                    "Save Configuration Changes?",
                    [System.Windows.Forms.MessageBoxButtons]::YesNo,
                    [System.Windows.Forms.MessageBoxIcon]::Question
                )
                if ($result -eq [System.Windows.Forms.DialogResult]::Yes) {
                    $linesToWrite = @()
                    foreach ($key in ($newConfigDefs.Keys | Sort-Object)) {
                        $val = $newConfigDefs[$key]
                        if ($key -eq "OPTION_MD_DEFAULT_SAVE_TYPE") {
                            $line = if ($val -eq $null) { "//#define $key 0" } else { "#define $key $val" }
                            $linesToWrite += $line
                        } elseif ($key -eq "OPTION_LCD_BG_COLOR") {
                            # Map color name to RGB string if needed, otherwise use as-is if already RGB
                            if ($null -eq $val) {
                                $rgb = "100, 0, 0"
                            } elseif ($val -match '^\d+\s*,\s*\d+\s*,\s*\d+$') {
                                $rgb = $val
                            } else {
                                switch ($val) {
                                    "Red"     { $rgb = "0, 100, 0" }
                                    "Green"   { $rgb = "100, 0, 0" }
                                    "Blue"    { $rgb = "0, 0, 100" }
                                    "Yellow"  { $rgb = "100, 100, 0" }
                                    "Magenta" { $rgb = "0, 100, 100" }
                                    "Cyan"    { $rgb = "100, 0, 100" }
                                    "White"   { $rgb = "100, 100, 100" }
                                    "Orange"  { $rgb = "50, 100, 0" }
                                    default   { $rgb = "100, 0, 0" }
                                }
                            }
                            $line = "#define $key $rgb"
                            $linesToWrite += $line
                        } else {
                            $line = if ($val) { "#define $key" } else { "//#define $key" }
                            $linesToWrite += $line
                        }
                    }
                    if ($linesToWrite.Count -gt 0) {
                        [System.IO.File]::WriteAllLines($applyPath, $linesToWrite, [System.Text.UTF8Encoding]::new($false))
                    }
                }
            }

            # Reload config data and refresh display to remove red text
            $script:configDefs = Get-ConfigData
            $script:applyChanges = @{}  # Clear apply changes since config is now up to date
            $script:currentHardware = $hardwareKeys | Where-Object { $script:configDefs[$_] } | Select-Object -First 1
            if (-not $script:currentHardware) { $script:currentHardware = $hardwareKeys[0] }
            $script:currentRTC = $rtcKeys | Where-Object { $script:configDefs[$_] } | Select-Object -First 1
            if (-not $script:currentRTC) { $script:currentRTC = $rtcKeys[0] }
            Add-ConfigRows -grid $gridHardware -keys $hardwareDisplayKeys -configDefs $script:configDefs -applyChanges $script:applyChanges -currentHardware $script:currentHardware -applyHardware $script:currentHardware -currentRTC $script:currentRTC -applyRTC $script:currentRTC -tooltipTexts $tooltipTexts
            Add-ConfigRows -grid $gridOption -keys $optionSet -configDefs $script:configDefs -applyChanges $script:applyChanges -currentHardware $script:currentHardware -applyHardware $script:currentHardware -currentRTC $script:currentRTC -applyRTC $script:currentRTC -tooltipTexts $tooltipTexts
            Add-ConfigRows -grid $gridModule -keys $moduleSet -configDefs $script:configDefs -applyChanges $script:applyChanges -currentHardware $script:currentHardware -applyHardware $script:currentHardware -currentRTC $script:currentRTC -applyRTC $script:currentRTC -tooltipTexts $tooltipTexts
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Error applying changes:`n$($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    # Copy to SD button click handler
    $btnCopyToSD.Add_Click({
        try {
            # Get current script directory more defensively
            $scriptDir = $null
            if ($PSScriptRoot) {
                $scriptDir = $PSScriptRoot
            } elseif ($MyInvocation.MyCommand.Path) {
                $scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
            } else {
                $scriptDir = Get-Location
            }

            # Ask user to select SD card root
            $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
            $folderBrowser.Description = "Select the root of your SD card"
            $folderBrowser.ShowNewFolderButton = $false
            $folderBrowser.RootFolder = [System.Environment+SpecialFolder]::MyComputer

            $dialogResult = $folderBrowser.ShowDialog()

            if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK) {
                $sdPath = $folderBrowser.SelectedPath

                # Validate SD path
                if (-not $sdPath -or $sdPath.Trim() -eq "") {
                    [System.Windows.Forms.MessageBox]::Show("No SD card path selected.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                    return
                }

                # Build source path
                $sourcePath = $null
                if ($scriptDir) {
                    $sourcePath = [System.IO.Path]::Combine($scriptDir, "SD Card")
                }

                if (-not $sourcePath -or $sourcePath.Trim() -eq "") {
                    [System.Windows.Forms.MessageBox]::Show("Could not determine source path.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                    return
                }

                # Check if source folder exists
                if (-not (Test-Path -Path $sourcePath -PathType Container)) {
                    [System.Windows.Forms.MessageBox]::Show("The folder 'SD Card' was not found at: $sourcePath", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                    return
                }

                # Get all items recursively, excluding config.txt
                $allItems = @()

                try {
                    $allItems = Get-ChildItem -Path $sourcePath -Recurse -Force -ErrorAction Stop | Where-Object {
                        $_.Name.ToLower() -ne "config.txt"
                    }
                } catch {
                    [System.Windows.Forms.MessageBox]::Show("Failed to scan source directory: $($_.Exception.Message)", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                    return
                }

                if (-not $allItems -or $allItems.Count -eq 0) {
                    [System.Windows.Forms.MessageBox]::Show("No files found to copy.", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
                    return
                }

                $fileItems = $allItems | Where-Object { -not $_.PSIsContainer }
                $totalFiles = if ($fileItems) { $fileItems.Count } else { 0 }
                $currentFile = 0

                # Process each item
                foreach ($item in $allItems) {
                    try {
                        if (-not $item -or -not $item.FullName) {
                            Write-Host "Skipping invalid item" -ForegroundColor Yellow
                            continue
                        }

                        # Calculate relative path using .NET methods for better reliability
                        $itemFullPath = $item.FullName
                        $sourceFullPath = (Get-Item $sourcePath).FullName

                        if (-not $itemFullPath.StartsWith($sourceFullPath)) {
                            Write-Host "Skipping item outside source path: $itemFullPath" -ForegroundColor Yellow
                            continue
                        }

                        $relativePath = $itemFullPath.Substring($sourceFullPath.Length).TrimStart([System.IO.Path]::DirectorySeparatorChar)

                        if (-not $relativePath -or $relativePath.Trim() -eq "") {
                            Write-Host "Skipping item with empty relative path" -ForegroundColor Yellow
                            continue
                        }

                        $targetPath = [System.IO.Path]::Combine($sdPath, $relativePath)

                        if ($item.PSIsContainer) {
                            # Create directory
                            if (-not (Test-Path -Path $targetPath -PathType Container)) {
                                New-Item -ItemType Directory -Path $targetPath -Force -ErrorAction Stop | Out-Null
                                Write-Host "Created directory: $relativePath" -ForegroundColor Blue
                            }
                        } else {
                            # Copy file
                            $targetDir = [System.IO.Path]::GetDirectoryName($targetPath)

                            if ($targetDir -and -not (Test-Path -Path $targetDir -PathType Container)) {
                                New-Item -ItemType Directory -Path $targetDir -Force -ErrorAction Stop | Out-Null
                            }

                            Copy-Item -Path $itemFullPath -Destination $targetPath -Force -ErrorAction Stop

                            # Set file as hidden
                            if (Test-Path -Path $targetPath -PathType Leaf) {
                                try {
                                    $file = Get-Item -Path $targetPath -Force -ErrorAction SilentlyContinue
                                    if ($file) {
                                        $file.Attributes = $file.Attributes -bor [System.IO.FileAttributes]::Hidden
                                    }
                                } catch {
                                    Write-Host "Warning: Could not hide file $relativePath" -ForegroundColor Yellow
                                }
                            }

                            $currentFile++
                            if ($totalFiles -gt 0) {
                                Write-Progress -Activity "Copying to SD Card" -Status "File $currentFile of $totalFiles" -PercentComplete (($currentFile / $totalFiles) * 100)
                            }
                            Write-Host "Copied and hid: $relativePath"
                        }
                    } catch {
                        Write-Host "Failed to process item: $($item.Name) - $($_.Exception.Message)" -ForegroundColor Red
                    }
                }

                Write-Progress -Activity "Copying to SD Card" -Completed
                Write-Host "Copy operation completed successfully!" 
            } else {
                Write-Host "User cancelled SD card selection" -ForegroundColor Yellow
            }
        } catch {
            $errorMessage = "Copy operation failed: $($_.Exception.Message)"
            Write-Host $errorMessage -ForegroundColor Red
            Write-Host "Stack trace: $($_.ScriptStackTrace)" -ForegroundColor Red
            [System.Windows.Forms.MessageBox]::Show($errorMessage, "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })

    # Enable vertical scrolling for the panel content
    $panel.AutoScroll = $false
    $panel.HorizontalScroll.Enabled = $false
    $panel.HorizontalScroll.Visible = $false

    $panel.Controls.AddRange(@(
        $comPortDropdown, $btnRefreshCOM, $btnUpdate, $btnBackup, $btnApply, $btnArduinoIDE, $btnRestore, $btnCopyToSD, $statusLabel,
        $labelHardware, $gridHardware,
        $labelOption, $gridOption,
        $labelModule, $gridModule
    ))

    $form.Controls.Add($panel)

    # Set focus to first grid
    $form.Add_Shown({
        $gridHardware.Focus()
    })

    [void] $form.ShowDialog()

} catch {
    $errorMsg = "Script Error: $($_.Exception.Message)`n`nLine: $($_.InvocationInfo.ScriptLineNumber)"
    Write-Error $errorMsg

    # Show error dialog if Windows Forms is available
    if ([System.Windows.Forms.MessageBox]) {
        [System.Windows.Forms.MessageBox]::Show($errorMsg, "Script Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
}