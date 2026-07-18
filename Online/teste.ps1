Add-Type -AssemblyName System.Windows.Forms

$form = New-Object Windows.Forms.Form
$form.Text = "Teste Santa Casa"
$form.Size = New-Object Drawing.Size(400,300)

$form.ShowDialog()
