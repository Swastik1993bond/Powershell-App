Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$Image =  [system.drawing.image]::FromFile("G:\Powershell-App\bot.jpg")
$form = New-Object System.Windows.Forms.Form
$form.Text = 'TOTAL - PC Manager'
$form.Size = New-Object System.Drawing.Size(500,500)
$form.StartPosition = 'CenterScreen'
$form.Font = "Arial"
$form.BackgroundImage = $Image

$Icon = New-Object system.drawing.icon ("G:\Powershell-App\bot.ico")
$form.Icon = $Icon

$Font = New-Object System.Drawing.Font("Times New Roman",12,[System.Drawing.FontStyle]::Bold)
$Fon2 = New-Object System.Drawing.Font("Arial",8,[System.Drawing.FontStyle]::Bold)


$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(180,20)
$label.Size = New-Object System.Drawing.Size(150,25)
$label.Text = 'Total - PC Manager' 
$label.ForeColor = "green"
$label.font = $Font
$form.Controls.Add($label)

$btnser = New-Object System.Windows.Forms.Button
$btnser.Location = New-Object System.Drawing.Point(50,70)
$btnser.Size = New-Object System.Drawing.Size(140,25)
$btnser.Text = 'Show Running Services'
$btnser.ForeColor = "Blue"
$btnser.Font = $Fon2
$btnser.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $btnser
$form.Controls.Add($btnser)

$btnpr = New-Object System.Windows.Forms.Button
$btnpr.Location = New-Object System.Drawing.Point(50,120)
$btnpr.Size = New-Object System.Drawing.Size(140,25)
$btnpr.Text = 'Show Running Process'
$btnpr.DialogResult = [System.Windows.Forms.DialogResult]::OK
$btnpr.ForeColor = "green"
$btnpr.Font = $Fon2
$form.AcceptButton = $btnpr
$form.Controls.Add($btnpr)


$btndisk = New-Object System.Windows.Forms.Button
$btndisk.Location = New-Object System.Drawing.Point(50,170)
$btndisk.Size = New-Object System.Drawing.Size(140,25)
$btndisk.Text = 'Show Disk Usage'
$btndisk.DialogResult = [System.Windows.Forms.DialogResult]::OK
$btndisk.Font = $Fon2
$btndisk.ForeColor = "blue"
$form.AcceptButton = $btndisk
$form.Controls.Add($btndisk)

$btnmem = New-Object System.Windows.Forms.Button
$btnmem.Location = New-Object System.Drawing.Point(50,220)
$btnmem.Size = New-Object System.Drawing.Size(140,25)
$btnmem.Text = 'Show Memory Usage'
$btnmem.DialogResult = [System.Windows.Forms.DialogResult]::OK
$btnmem.Font = $Fon2
$btnmem.backColor = "red"
$form.AcceptButton = $btnmem
$form.Controls.Add($btnmem)

$btnsysinfo = New-Object System.Windows.Forms.Button
$btnsysinfo.Location = New-Object System.Drawing.Point(50,270)
$btnsysinfo.Size = New-Object System.Drawing.Size(140,25)
$btnsysinfo.Text = 'Show Full System Info'
$btnsysinfo.DialogResult = [System.Windows.Forms.DialogResult]::OK
$btnsysinfo.Font = $Fon2
$btnsysinfo.backColor = "yellow"
$form.AcceptButton = $btnsysinfo
$form.Controls.Add($btnsysinfo)

$btnnetinfo = New-Object System.Windows.Forms.Button
$btnnetinfo.Location = New-Object System.Drawing.Point(50,320)
$btnnetinfo.Size = New-Object System.Drawing.Size(140,25)
$btnnetinfo.Text = 'Show Listening Ports'
$btnnetinfo.Font = $Fon2
$btnnetinfo.backColor = "green"
$btnnetinfo.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $btnnetinfo
$form.Controls.Add($btnnetinfo)

$btnlrgfil = New-Object System.Windows.Forms.Button
$btnlrgfil.Location = New-Object System.Drawing.Point(250,70)
$btnlrgfil.Size = New-Object System.Drawing.Size(200,25)
$btnlrgfil.Text = 'Show Files Consuming More Space'
$btnlrgfil.DialogResult = [System.Windows.Forms.DialogResult]::OK
$btnlrgfil.Font = $Fon2
$btnlrgfil.backColor = "orange"
$form.AcceptButton = $btnlrgfil
$form.Controls.Add($btnlrgfil)

$bt = New-Object System.Windows.Forms.Button
$bt.Location = New-Object System.Drawing.Point(250,120)
$bt.Size = New-Object System.Drawing.Size(200,25)
$bt.Text = 'Show Last Boot Time'
$bt.DialogResult = [System.Windows.Forms.DialogResult]::OK
$bt.Font = $Fon2
$bt.backColor = "pink"
$form.AcceptButton = $bt
$form.Controls.Add($bt)

$abt = New-Object System.Windows.Forms.Button
$abt.Location = New-Object System.Drawing.Point(150,400)
$abt.Size = New-Object System.Drawing.Size(200,25)
$abt.Text = 'About TOTAL - PC Manager'
$abt.DialogResult = [System.Windows.Forms.DialogResult]::OK
$abt.Font = $Fon2
$abt.backColor = "white"
$form.AcceptButton = $abt
$form.Controls.Add($abt)

$btnser.Add_Click({
    Get-Service | Where-Object {$_.Status -eq "running"} |  Out-GridView
})

$btnpr.Add_Click({
    get-process | sort CPU -Descending | out-gridview
})

$btndisk.Add_Click({
    get-volume | out-gridview
})

$btnmem.Add_Click({
 $CompObject =  Get-WmiObject -Class WIN32_OperatingSystem
 $Memory = ((($CompObject.TotalVisibleMemorySize - $CompObject.FreePhysicalMemory)*100)/ $CompObject.TotalVisibleMemorySize)
 echo "Total memory free(%) is $Memory" | Out-GridView
})

$btnsysinfo.Add_Click({
    function Flip-Object
{
    param
    (
        [Object]
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject
    )
    process
    {
        $InputObject | 
        ForEach-Object {
            $instance = $_
            $instance | 
            Get-Member -MemberType *Property |
            Select-Object -ExpandProperty Name |
            ForEach-Object {
                [PSCustomObject]@{
                    Name = $_
                    Value = $instance.$_
                }
            }
        } 
    }
}

Get-ComputerInfo|Flip-object| out-gridview
})

$btnnetinfo.Add_Click({
 Get-NetTCPConnection -State Listen | Out-GridView
})

$btnlrgfil.Add_Click({
    gci -r|sort -descending -property length | select -first 10 name,Directoryname,@{Name="Gigabytes";Expression={[Math]::round($_.length / 1GB, 2)}}|out-gridview
   })

$bt.Add_Click({
    Get-CimInstance -ClassName win32_operatingsystem | select csname, lastbootuptime | out-gridview
       })

$abt.Add_Click({
    echo " 
TOTAL - PC manager , a lightweight housekeeping tool for your PC, here you can do multiple operation within smaller duration

You can check System health, Nework condition, File system Healh with oneclick

Created by : Swastik Mukherjee, E-mail to: swastikmukherjee276@gmail.com "|out-gridview
   })

$result = $form.ShowDialog()