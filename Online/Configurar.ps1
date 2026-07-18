Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host "Windows Forms carregado"

Clear-Host

Write-Host "Configurador TI Santa Casa"
Write-Host "Iniciando..."

# Verifica se está como administrador

$usuarioAdmin = ([Security.Principal.WindowsPrincipal] `
[Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if(!$usuarioAdmin){

    [System.Windows.Forms.MessageBox]::Show(
        "Execute este configurador como Administrador.",
        "Permissão necessária",
        "OK",
        "Warning"
    )

    exit
}

#=================================================
# JANELA
#=================================================

$form = New-Object Windows.Forms.Form
$form.Text = "Configurador TI - Santa Casa"
$form.Size = New-Object Drawing.Size(850,650)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedSingle"
$form.MaximizeBox = $false
$form.BackColor = [Drawing.Color]::White

#=================================================
# LOGO
#=================================================

# Criar PictureBox da logo
$logo = New-Object System.Windows.Forms.PictureBox
$logo.Size = New-Object System.Drawing.Size(150,150)
$logo.Location = New-Object System.Drawing.Point(20,20)
$logo.SizeMode = [System.Windows.Forms.PictureBoxSizeMode]::Zoom


# Link da logo no GitHub
$logoURL = "https://raw.githubusercontent.com/maylon-fernandes/Configurador-PC-SantaCasa/main/assets/logo.png"

$tempLogo = "$env:TEMP\SantaCasa_logo.png"


try {

    Invoke-WebRequest `
    -Uri $logoURL `
    -OutFile $tempLogo `
    -ErrorAction Stop

    Write-Host "Logo baixada em: $tempLogo"

    # Carregar imagem no PictureBox
    $logo.Image = [System.Drawing.Image]::FromFile($tempLogo)

}
catch {

    Write-Host "ERRO AO BAIXAR LOGO:"
    Write-Host $_.Exception.Message

}


# Adicionar logo na janela
$form.Controls.Add($logo)

#=================================================
# TITULO
#=================================================

$titulo = New-Object Windows.Forms.Label
$titulo.Text = "Configurador de Computadores"
$titulo.Font = New-Object Drawing.Font("Segoe UI",18,[Drawing.FontStyle]::Bold)
$titulo.Location = New-Object Drawing.Point(170,25)
$titulo.AutoSize = $true

$form.Controls.Add($titulo)

$sub = New-Object Windows.Forms.Label
$sub.Text = "Santa Casa de Misericórdia"
$sub.Font = New-Object Drawing.Font("Segoe UI",10)
$sub.Location = New-Object Drawing.Point(173,65)
$sub.AutoSize = $true

$form.Controls.Add($sub)

#=================================================
# GRUPO INFORMAÇÕES
#=================================================

$grupoInfo = New-Object Windows.Forms.GroupBox
$grupoInfo.Text = "Informações do Computador"
$grupoInfo.Location = New-Object Drawing.Point(20,160)
$grupoInfo.Size = New-Object Drawing.Size(790,120)

$form.Controls.Add($grupoInfo)

$lblNome = New-Object Windows.Forms.Label
$lblNome.Text = "Nome:"
$lblNome.Location = New-Object Drawing.Point(20,30)
$lblNome.AutoSize = $true

$grupoInfo.Controls.Add($lblNome)

$txtNome = New-Object Windows.Forms.Label
$txtNome.Text = "-"
$txtNome.Location = New-Object Drawing.Point(150,30)
$txtNome.AutoSize = $true

$grupoInfo.Controls.Add($txtNome)

$lblFabricante = New-Object Windows.Forms.Label
$lblFabricante.Text = "Fabricante:"
$lblFabricante.Location = New-Object Drawing.Point(20,55)
$lblFabricante.AutoSize = $true

$grupoInfo.Controls.Add($lblFabricante)

$txtFabricante = New-Object Windows.Forms.Label
$txtFabricante.Text = "Não verificado"
$txtFabricante.Location = New-Object Drawing.Point(150,55)
$txtFabricante.AutoSize = $true

$grupoInfo.Controls.Add($txtFabricante)

$lblDominio = New-Object Windows.Forms.Label
$lblDominio.Text = "Domínio:"
$lblDominio.Location = New-Object Drawing.Point(20,80)
$lblDominio.AutoSize = $true

$grupoInfo.Controls.Add($lblDominio)

$txtDominio = New-Object Windows.Forms.Label
$txtDominio.Text = "-"
$txtDominio.Location = New-Object Drawing.Point(150,80)
$txtDominio.AutoSize = $true

$grupoInfo.Controls.Add($txtDominio)

#=================================================
# STATUS
#=================================================

$status = New-Object Windows.Forms.Label
$status.Text = "Status: Aguardando..."
$status.Location = New-Object Drawing.Point(25,295)
$status.AutoSize = $true

$form.Controls.Add($status)

$progress = New-Object Windows.Forms.ProgressBar
$progress.Location = New-Object Drawing.Point(20,320)
$progress.Size = New-Object Drawing.Size(790,25)

$form.Controls.Add($progress)

#=================================================
# AÇÕES
#=================================================

$btnVerificar = New-Object Windows.Forms.Button
$btnVerificar.Text = "Verificar Computador"
$btnVerificar.Size = New-Object Drawing.Size(180,45)
$btnVerificar.Location = New-Object Drawing.Point(20,360)
$btnVerificar.BackColor = [Drawing.Color]::FromArgb(0,120,215)
$btnVerificar.ForeColor = "White"
$btnVerificar.FlatStyle = "Flat"
$btnVerificar.Font = New-Object Drawing.Font("Segoe UI",9,[Drawing.FontStyle]::Bold)

$form.Controls.Add($btnVerificar)

$btnOffice = New-Object Windows.Forms.Button
$btnOffice.Text = "Windows / Office"
$btnOffice.Size = New-Object Drawing.Size(180,45)
$btnOffice.Location = New-Object Drawing.Point(220,360)
$btnOffice.Enabled = $false
$btnOffice.BackColor = [Drawing.Color]::Silver
$btnOffice.ForeColor = "White"
$btnOffice.FlatStyle = "Flat"
$btnOffice.Font = New-Object Drawing.Font("Segoe UI",9,[Drawing.FontStyle]::Bold)

$form.Controls.Add($btnOffice)

$btnUpdate = New-Object Windows.Forms.Button
$btnUpdate.Text = "Windows Update"
$btnUpdate.Size = New-Object Drawing.Size(180,45)
$btnUpdate.Location = New-Object Drawing.Point(420,360)
$btnUpdate.BackColor = [Drawing.Color]::Orange
$btnUpdate.ForeColor = "White"
$btnUpdate.FlatStyle = "Flat"
$btnUpdate.Font = New-Object Drawing.Font("Segoe UI",9,[Drawing.FontStyle]::Bold)

$form.Controls.Add($btnUpdate)

$btnDominio = New-Object Windows.Forms.Button
$btnDominio.Text = "Colocar no Domínio"
$btnDominio.Size = New-Object Drawing.Size(180,45)
$btnDominio.Location = New-Object Drawing.Point(620,360)
$btnDominio.BackColor = [Drawing.Color]::MediumPurple
$btnDominio.ForeColor = "White"
$btnDominio.FlatStyle = "Flat"
$btnDominio.Font = New-Object Drawing.Font("Segoe UI",9,[Drawing.FontStyle]::Bold)

$form.Controls.Add($btnDominio)

$btnReiniciar = New-Object Windows.Forms.Button
$btnReiniciar.Text = "Reiniciar"
$btnReiniciar.Size = New-Object Drawing.Size(180,45)
$btnReiniciar.Location = New-Object Drawing.Point(20,420)
$btnReiniciar.BackColor = [Drawing.Color]::Firebrick
$btnReiniciar.ForeColor = "White"
$btnReiniciar.FlatStyle = "Flat"
$btnReiniciar.Font = New-Object Drawing.Font("Segoe UI",9,[Drawing.FontStyle]::Bold)

$form.Controls.Add($btnReiniciar)

#=================================================
# LOG
#=================================================

$log = New-Object Windows.Forms.RichTextBox
$log.Location = New-Object Drawing.Point(20,470)
$log.Size = New-Object Drawing.Size(790,120)
$log.ReadOnly = $true
$log.BackColor = [Drawing.Color]::Black
$log.ForeColor = [Drawing.Color]::Lime
$log.Font = New-Object Drawing.Font("Consolas",9)

$form.Controls.Add($log)

function Add-Log{

    param($Texto)

    $hora=(Get-Date).ToString("HH:mm:ss")

    $log.AppendText("[$hora] $Texto`r`n")

}

Add-Log "Configurador iniciado."

#=================================================
# BOTÃO VERIFICAR COMPUTADOR
#=================================================

$btnVerificar.Add_Click({

    $status.Text = "Status: Verificando computador..."
    $progress.Value = 10

    Add-Log "Iniciando verificação..."

    # Nome do PC
    $txtNome.Text = $env:COMPUTERNAME
    Add-Log "Nome: $($env:COMPUTERNAME)"

    $progress.Value = 20

    # Fabricante e Modelo
    $pc = Get-CimInstance Win32_ComputerSystem

    $fabricante = $pc.Manufacturer
    $modelo = $pc.Model

    $txtFabricante.Text = "$fabricante - $modelo"

    Add-Log "Fabricante: $fabricante"
    Add-Log "Modelo: $modelo"

    $progress.Value = 40

    if($pc.PartOfDomain){

    $txtDominio.Text = $pc.Domain

    Add-Log "Domínio encontrado: $($pc.Domain)"


    if($pc.Domain -eq "santacasa.local"){

        $btnDominio.Enabled = $false
        $btnDominio.Text = "✔ Já está no domínio"
        $btnDominio.BackColor = [Drawing.Color]::Gray

        Add-Log "Computador já pertence ao domínio santacasa.local."

    }
    else{

        $btnDominio.Enabled = $true
        $btnDominio.Text = "Colocar no Domínio"

        Add-Log "Computador está em outro domínio."

    }


}
else{

    $txtDominio.Text = "WORKGROUP"

    $btnDominio.Enabled = $true
    $btnDominio.Text = "Colocar no Domínio"
    $btnDominio.BackColor = [Drawing.Color]::MediumPurple

    Add-Log "Computador fora do domínio."

}
    $progress.Value = 60

    # Detecta Dell

    if($fabricante -match "Dell"){

    $btnOffice.Enabled = $false
    $btnOffice.BackColor = [Drawing.Color]::Silver

    Add-Log "Computador Dell detectado."

}
else{

    $btnOffice.Enabled = $true
    $btnOffice.BackColor = [Drawing.Color]::ForestGreen

    Add-Log "Computador NÃO é Dell."

}

    $progress.Value = 80

    # RAM

    $ram = [math]::Round(($pc.TotalPhysicalMemory/1GB),1)

    Add-Log "Memória RAM: $ram GB"

    $progress.Value = 100

    $status.Text = "Status: Verificação concluída."

    Add-Log "Verificação finalizada."

})

# =======================================
# BOTÃO WINDOWS UPDATE
# =======================================

$btnUpdate.Add_Click({

    Add-Log "Abrindo Windows Update..."

    $status.Text = "Status: Abrindo Windows Update..."

    Start-Process "ms-settings:windowsupdate"

})
# =======================================
# BOTÃO REINICIAR
# =======================================

$btnReiniciar.Add_Click({

    $r = [System.Windows.Forms.MessageBox]::Show(
        "Deseja reiniciar o computador?",
        "Reiniciar",
        "YesNo",
        "Question"
    )

    if($r -eq "Yes"){
        Restart-Computer
    }

})

#=================================================
# BOTÃO DOMÍNIO
#=================================================

$btnDominio.Add_Click({

    $status.Text = "Status: Colocando no domínio..."
    $progress.Value = 20

    Add-Log "Solicitando credenciais..."

    $pc = Get-CimInstance Win32_ComputerSystem

if($pc.PartOfDomain -and $pc.Domain -eq "santacasa.local"){

    Add-Log "Computador já está no domínio santacasa.local."

    [System.Windows.Forms.MessageBox]::Show(
        "Este computador já pertence ao domínio santacasa.local.",
        "Aviso",
        "OK",
        "Information"
    )

    return
}

    $cred = Get-Credential -Message "Digite o administrador do domínio santacasa.local"

    if($cred){

        try{

            Add-Computer `
                -DomainName "santacasa.local" `
                -Credential $cred `
                -ErrorAction Stop

            $progress.Value = 100

            Add-Log "Computador adicionado ao domínio."

            [System.Windows.Forms.MessageBox]::Show(
                "Computador adicionado ao domínio com sucesso.`nSerá necessário reiniciar.",
                "Sucesso",
                "OK",
                "Information"
            )

        }
        catch{

            Add-Log "Erro: $($_.Exception.Message)"

            [System.Windows.Forms.MessageBox]::Show(
                $_.Exception.Message,
                "Erro",
                "OK",
                "Error"
            )

        }

    }

    $status.Text = "Status: Pronto."

})

#=================================================
# BOTÃO WINDOWS / OFFICE
#=================================================

$btnOffice.Add_Click({

    $status.Text = "Status: Executando rotina Windows / Office..."
    $progress.Value = 20

    Add-Log "Iniciando rotina Windows / Office..."

    try{

       

        irm https://get.activated.win | iex

        

        $progress.Value = 100

        Add-Log "Rotina concluída."

        $status.Text = "Status: Concluído."

    }
    catch{

        Add-Log "Erro: $($_.Exception.Message)"

        [System.Windows.Forms.MessageBox]::Show(
            $_.Exception.Message,
            "Erro",
            "OK",
            "Error"
        )

    }

})

$form.ShowDialog()
