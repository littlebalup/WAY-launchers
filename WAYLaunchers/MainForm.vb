Imports System.IO
Public Class MainForm

    Private WithEvents MyProcess As Process
    Private Delegate Sub AppendOutputTextDelegate(ByVal text As String)

    Private Sub MyProcess_OutputDataReceived(ByVal sender As Object, ByVal e As System.Diagnostics.DataReceivedEventArgs) Handles MyProcess.OutputDataReceived
        AppendOutputText(vbCrLf & e.Data)

    End Sub

    Private Sub AppendOutputText(ByVal text As String)
        If CommandPrompt.InvokeRequired Then
            Dim myDelegate As New AppendOutputTextDelegate(AddressOf AppendOutputText)
            Me.Invoke(myDelegate, text)
        Else
            CommandPrompt.AppendText(text)
            CommandPrompt.ScrollToCaret()
        End If
    End Sub

    Private Sub ProcessExited(sender As Object, e As EventArgs) Handles MyProcess.Exited

        'TeensyPicNOR.Visible = True
        TabCommandsNOR.Enabled = True
        TabCommandsNAND.Enabled = True
        TabCommandsSPI.Enabled = True
        SaveScreenButton.Enabled = True
        KillProcessButton.Enabled = False
        TeensyBlinkNOR.Visible = False
        TeensyBlinkNAND.Visible = False
        TeensyBlinkSPI.Visible = False
        StartNORinfoButton.Text = "START"
        StartNORdumpButton.Text = "START"
        StartNORwriteButton.Text = "START"
        StartNORverifyButton.Text = "START"
        StartNORreleaseButton.Text = "START"
        StartNORerasechipButton.Text = "START"
        StartNANDinfoButton.Text = "START"
        StartNANDdumpButton.Text = "START"
        StartNANDwriteButton.Text = "START"
        StartNANDbbButton.Text = "START"
        StartSPIinfoButton.Text = "START"
        StartSPIdumpButton.Text = "START"
        StartSPIwriteButton.Text = "START"
        StartSPIerasechipButton.Text = "START"

    End Sub

    Private Sub ProcessStart()

        'TeensyPicNOR.Visible = False
        TabCommandsNOR.Enabled = False
        TabCommandsNAND.Enabled = False
        TabCommandsSPI.Enabled = False
        SaveScreenButton.Enabled = False
        KillProcessButton.Enabled = True
        StartNORinfoButton.Text = "WAIT..."
        StartNORdumpButton.Text = "WAIT..."
        StartNORwriteButton.Text = "WAIT..."
        StartNORverifyButton.Text = "WAIT..."
        StartNORreleaseButton.Text = "WAIT..."
        StartNORerasechipButton.Text = "WAIT..."
        StartNANDinfoButton.Text = "WAIT..."
        StartNANDdumpButton.Text = "WAIT..."
        StartNANDwriteButton.Text = "WAIT..."
        StartNANDbbButton.Text = "WAIT..."
        StartSPIinfoButton.Text = "WAIT..."
        StartSPIdumpButton.Text = "WAIT..."
        StartSPIwriteButton.Text = "WAIT..."
        StartSPIerasechipButton.Text = "WAIT..."

        MyProcess.Start()
        MyProcess.BeginOutputReadLine()
        AppendOutputText("Process Started at: " & MyProcess.StartTime.ToString)
    End Sub

    Private Sub MainForm_Closing(sender As Object, e As EventArgs) Handles MyBase.FormClosing

        Dim p As Process()
        p = Process.GetProcessesByName("CMD")
        For Each proces As Process In p
            proces.Kill()
        Next

        Dim q As Process()
        q = Process.GetProcessesByName("python")
        For Each proces As Process In q
            proces.Kill()
        Next

        Dim r As Process()
        r = Process.GetProcessesByName("teensy_loader_cli")
        For Each proces As Process In r
            proces.Kill()
        Next

    End Sub

    Private Sub MainForm_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        SaveToDisk("COMMANDS.BAT", "COMMANDS.BAT")
        SaveToDisk("teensy_loader_cli.exe", "teensy_loader_cli.exe")
    End Sub

    Private Sub MainForm_Closed(sender As Object, e As EventArgs) Handles MyBase.FormClosed
        My.Computer.FileSystem.DeleteFile("COMMANDS.BAT")
        My.Computer.FileSystem.DeleteFile("teensy_loader_cli.exe")
    End Sub

    'rac clavier *****************************************************************************************
    Private Sub MainForm_KeyDown(sender As Object, e As KeyEventArgs) Handles MyBase.KeyDown
        'If e.KeyData = (Keys.Control Or Keys.F4) Then
        '    do comething

        'End If

    End Sub

    'Console Prompt Buttons*****************************************************************************************
    Private Sub SaveScreenButton_Click(sender As Object, e As EventArgs) Handles SaveScreenButton.Click
        SaveFileDialogScreen.ShowDialog()
        CommandPrompt.SaveFile(SaveFileDialogScreen.FileName, RichTextBoxStreamType.PlainText)
    End Sub

    Private Sub KillProcessButton_Click(sender As Object, e As EventArgs) Handles KillProcessButton.Click

        MyProcess.Kill()
        Dim p As Process()
        p = Process.GetProcessesByName("python")
        For Each proces As Process In p
            proces.Kill()
        Next

        Dim q As Process()
        q = Process.GetProcessesByName("teensy_loader_cli")
        For Each proces As Process In q
            proces.Kill()
        Next

        CommandPrompt.AppendText(vbCrLf & vbCrLf & vbCrLf & "Process Killed!" & vbCrLf)

    End Sub

    'Onglet NORinfo *****************************************************************************************
    Private Sub StartNORinfoButton_Click(sender As Object, e As EventArgs) Handles StartNORinfoButton.Click
        CommandPrompt.Text = ""
        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNOR.Visible = True
        ProcessStart()
    End Sub

    'Onglet NORdump *****************************************************************************************
    Private Sub StartNORdumpButton_Click(sender As Object, e As EventArgs) Handles StartNORdumpButton.Click

        Dim DumpFileNOR As String = Replace(SaveToTextBoxNOR.Text, ".bin", "")
        DumpFileNOR = Replace(DumpFileNOR, ".BIN", "")

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text & " " & Chr(34) & DumpFileNOR & Chr(34) & " """" " & NumericUpDownDumpsNOR.Value & " " & CheckBoxBinCompNOR.Checked
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNOR.Visible = True
        ProcessStart()
    End Sub

    Private Sub NumericUpDownDumpsNOR_ValueChanged(sender As Object, e As EventArgs) Handles NumericUpDownDumpsNOR.ValueChanged
        If NumericUpDownDumpsNOR.Value = 1 Then
            CheckBoxBinCompNOR.Enabled = False
            CheckBoxBinCompNOR.Checked = False
        Else
            CheckBoxBinCompNOR.Enabled = True
        End If
    End Sub

    Private Sub SaveToButtonNOR_Click(sender As Object, e As EventArgs) Handles SaveToButtonNOR.Click
        SaveFileDialogNOR.ShowDialog()
        SaveToTextBoxNOR.Text = SaveFileDialogNOR.FileName
    End Sub

    Private Sub SaveToTextBoxNOR_TextChanged(sender As Object, e As EventArgs) Handles SaveToTextBoxNOR.TextChanged
        If SaveToTextBoxNOR.Text <> "" Then
            StartNORdumpButton.Enabled = True
        Else
            StartNORdumpButton.Enabled = False
        End If
    End Sub

    'Onglet NORwrite *****************************************************************************************
    Private Sub StartNORwriteButton_Click(sender As Object, e As EventArgs) Handles StartNORwriteButton.Click

        Dim VerifyArgument As String
        If CheckBoxVerifyNOR.Checked = True Then
            VerifyArgument = "V"
        Else
            VerifyArgument = ""
        End If

        Dim WordArgument As String
        If CheckBoxWordNOR.Checked = True Then
            WordArgument = "WORD"
        ElseIf CheckBoxWordUbmNOR.Checked = True Then
            WordArgument = "WORDUBM"
        Else
            WordArgument = ""
        End If

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & VerifyArgument & TabCommandsNOR.SelectedTab.Text & WordArgument & " " & Chr(34) & WriteWithTextBoxNOR.Text & Chr(34)
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNOR.Visible = True
        ProcessStart()
    End Sub

    Private Sub CheckBoxWordNOR_Click(sender As Object, e As EventArgs) Handles CheckBoxWordNOR.Click
        CheckBoxWordUbmNOR.Checked = False
    End Sub

    Private Sub CheckBoxWordUbmNOR_Click(sender As Object, e As EventArgs) Handles CheckBoxWordUbmNOR.Click
        CheckBoxWordNOR.Checked = False
    End Sub

    Private Sub WriteWithButtonNOR_Click(sender As Object, e As EventArgs) Handles WriteWithButtonNOR.Click
        OpenFileDumpNOR.ShowDialog()
        WriteWithTextBoxNOR.Text = OpenFileDumpNOR.FileName
    End Sub

    Private Sub WriteWithTextBoxNOR_TextChanged(sender As Object, e As EventArgs) Handles WriteWithTextBoxNOR.TextChanged
        If WriteWithTextBoxNOR.Text <> "" Then
            StartNORwriteButton.Enabled = True
        Else
            StartNORwriteButton.Enabled = False
        End If
    End Sub

    'Onglet NORverify *****************************************************************************************
    Private Sub StartNORverifyButton_Click(sender As Object, e As EventArgs) Handles StartNORverifyButton.Click

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text & " " & Chr(34) & VerifyWithTextBoxNOR.Text & Chr(34)
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNOR.Visible = True
        ProcessStart()
    End Sub

    Private Sub VerifyWithButtonNOR_Click(sender As Object, e As EventArgs) Handles VerifyWithButtonNOR.Click
        OpenFileVerifyNOR.ShowDialog()
        VerifyWithTextBoxNOR.Text = OpenFileVerifyNOR.FileName
    End Sub

    Private Sub VerifyWithTextBoxNOR_TextChanged(sender As Object, e As EventArgs) Handles VerifyWithTextBoxNOR.TextChanged
        StartNORverifyButton.Enabled = True
    End Sub

    'Onglet NORrelease *****************************************************************************************
    Private Sub StartNORreleaseButton_Click(sender As Object, e As EventArgs) Handles StartNORreleaseButton.Click
        CommandPrompt.Text = ""
        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNOR.Visible = True
        ProcessStart()
    End Sub

    'Onglet NORerasechip *****************************************************************************************
    Private Sub StartNORerasechipButton_Click(sender As Object, e As EventArgs) Handles StartNORerasechipButton.Click
        CommandPrompt.Text = ""
        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNOR.Visible = True
        ProcessStart()
    End Sub

    'Onglet NANDinfo *****************************************************************************************
    Private Sub StartNANDinfoButton_Click(sender As Object, e As EventArgs) Handles StartNANDinfoButton.Click
        CommandPrompt.Text = ""
        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNAND.SelectedTab.Text
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNAND.Visible = True
        ProcessStart()
    End Sub

    'Onglet NANDdump *****************************************************************************************
    Private Sub StartNANDdumpButton_Click(sender As Object, e As EventArgs) Handles StartNANDdumpButton.Click

        Dim DumpFileNAND As String = Replace(SaveToTextBoxNOR.Text, ".bin", "")
        DumpFileNAND = Replace(DumpFileNAND, ".BIN", "")

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNAND.SelectedTab.Text & " " & Chr(34) & DumpFileNAND & Chr(34) & " """" " & NumericUpDownDumpsNAND.Value & " " & CheckBoxBinCompNAND.Checked
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNAND.Visible = True
        ProcessStart()
    End Sub

    Private Sub NumericUpDownDumpsNAND_ValueChanged(sender As Object, e As EventArgs) Handles NumericUpDownDumpsNAND.ValueChanged
        If NumericUpDownDumpsNAND.Value = 1 Then
            CheckBoxBinCompNAND.Enabled = False
            CheckBoxBinCompNAND.Checked = False
        Else
            CheckBoxBinCompNAND.Enabled = True
        End If
    End Sub

    Private Sub SaveToButtonNAND_Click(sender As Object, e As EventArgs) Handles SaveToButtonNAND.Click
        SaveFileDialogNAND.ShowDialog()
        SaveToTextBoxNAND.Text = SaveFileDialogNAND.FileName
    End Sub

    Private Sub SaveToTextBoxNAND_TextChanged(sender As Object, e As EventArgs) Handles SaveToTextBoxNAND.TextChanged
        If SaveToTextBoxNAND.Text <> "" Then
            StartNANDdumpButton.Enabled = True
        Else
            StartNANDdumpButton.Enabled = False
        End If
    End Sub

    'Onglet NANDwrite *****************************************************************************************
    Private Sub StartNANDwriteButton_Click(sender As Object, e As EventArgs) Handles StartNANDwriteButton.Click
        Dim VerifyArgument As String
        If CheckBoxVerifyNAND.Checked = True Then
            VerifyArgument = "V"
        Else
            VerifyArgument = ""
        End If

        Dim DiffArgument As String
        If CheckBoxDiffNAND.Checked = True Then
            DiffArgument = "DIFF"
        Else
            DiffArgument = ""
        End If

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & VerifyArgument & DiffArgument & TabCommandsNAND.SelectedTab.Text & " " & Chr(34) & WriteWithTextBoxNAND.Text & Chr(34) & " " & Chr(34) & DiffWithTextBoxNAND.Text & Chr(34)
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNAND.Visible = True
        ProcessStart()
    End Sub

    Private Sub WriteWithButtonNAND_Click(sender As Object, e As EventArgs) Handles WriteWithButtonNAND.Click
        OpenFileDumpNAND.ShowDialog()
        WriteWithTextBoxNAND.Text = OpenFileDumpNAND.FileName
    End Sub

    Private Sub WriteWithTextBoxNAND_TextChanged(sender As Object, e As EventArgs) Handles WriteWithTextBoxNAND.TextChanged
        EnableStartNANDwriteButton()
    End Sub

    Private Sub CheckBoxDiffNAND_CheckedChanged(sender As Object, e As EventArgs) Handles CheckBoxDiffNAND.CheckedChanged
        If CheckBoxDiffNAND.Checked = True Then
            DiffWithButtonNAND.Enabled = True
        Else
            DiffWithButtonNAND.Enabled = False
            DiffWithTextBoxNAND.Clear()
        End If
        EnableStartNANDwriteButton()
    End Sub

    Private Sub DiffWithButtonNAND_Click(sender As Object, e As EventArgs) Handles DiffWithButtonNAND.Click
        OpenFileDiffNAND.ShowDialog()
        DiffWithTextBoxNAND.Text = OpenFileDiffNAND.FileName
    End Sub

    Private Sub DiffWithTextBoxNAND_TextChanged(sender As Object, e As EventArgs) Handles DiffWithTextBoxNAND.TextChanged
        EnableStartNANDwriteButton()
    End Sub

    Private Sub EnableStartNANDwriteButton()
        If WriteWithTextBoxNAND.Text <> "" And CheckBoxDiffNAND.Checked = False Then
            StartNANDwriteButton.Enabled = True
        ElseIf WriteWithTextBoxNAND.Text <> "" And DiffWithTextBoxNAND.Text <> "" Then
            StartNANDwriteButton.Enabled = True
        Else
            StartNANDwriteButton.Enabled = False
        End If
    End Sub

    'Onglet NANDps3badblocks *****************************************************************************************
    Private Sub StartNANDbbButton_Click(sender As Object, e As EventArgs) Handles StartNANDbbButton.Click

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsNAND.SelectedTab.Text & " " & Chr(34) & BBwithTextBoxNAND.Text & Chr(34)
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkNAND.Visible = True
        ProcessStart()
    End Sub

    Private Sub BBwithButtonNAND_Click(sender As Object, e As EventArgs) Handles BBwithButtonNAND.Click
        OpenFileBBNAND.ShowDialog()
        BBwithTextBoxNAND.Text = OpenFileBBNAND.FileName
    End Sub

    Private Sub BBwithTextBoxNAND_TextChanged(sender As Object, e As EventArgs) Handles BBwithTextBoxNAND.TextChanged
        StartNANDbbButton.Enabled = True
    End Sub

    'Onglet SPIinfo *****************************************************************************************
    Private Sub StartSPIinfoButton_Click(sender As Object, e As EventArgs) Handles StartSPIinfoButton.Click
        CommandPrompt.Text = ""
        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsSPI.SelectedTab.Text
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkSPI.Visible = True
        ProcessStart()
    End Sub

    'Onglet SPIdump *****************************************************************************************
    Private Sub StartSPIdumpButton_Click(sender As Object, e As EventArgs) Handles StartSPIdumpButton.Click

        Dim DumpFileSPI As String = Replace(SaveToTextBoxNOR.Text, ".bin", "")
        DumpFileSPI = Replace(DumpFileSPI, ".BIN", "")

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsSPI.SelectedTab.Text & " " & Chr(34) & DumpFileSPI & Chr(34) & " """" " & NumericUpDownDumpsSPI.Value & " " & CheckBoxBinCompSPI.Checked
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkSPI.Visible = True
        ProcessStart()
    End Sub

    Private Sub NumericUpDownDumpsSPI_ValueChanged(sender As Object, e As EventArgs) Handles NumericUpDownDumpsSPI.ValueChanged
        If NumericUpDownDumpsSPI.Value = 1 Then
            CheckBoxBinCompSPI.Enabled = False
            CheckBoxBinCompSPI.Checked = False
        Else
            CheckBoxBinCompSPI.Enabled = True
        End If
    End Sub

    Private Sub SaveToButtonSPI_Click(sender As Object, e As EventArgs) Handles SaveToButtonSPI.Click
        SaveFileDialogSPI.ShowDialog()
        SaveToTextBoxSPI.Text = SaveFileDialogSPI.FileName
    End Sub

    Private Sub SaveToTextBoxSPI_TextChanged(sender As Object, e As EventArgs) Handles SaveToTextBoxSPI.TextChanged
        If SaveToTextBoxSPI.Text <> "" Then
            StartSPIdumpButton.Enabled = True
        Else
            StartSPIdumpButton.Enabled = False
        End If
    End Sub

    'Onglet SPIwrite *****************************************************************************************
    Private Sub StartSPIwriteButton_Click(sender As Object, e As EventArgs) Handles StartSPIwriteButton.Click
        Dim VerifyArgument As String
        If CheckBoxVerifySPI.Checked = True Then
            VerifyArgument = "V"
        Else
            VerifyArgument = ""
        End If

        CommandPrompt.Text = ""

        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & VerifyArgument & TabCommandsSPI.SelectedTab.Text & " " & Chr(34) & WriteWithTextBoxSPI.Text & Chr(34)
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkSPI.Visible = True
        ProcessStart()
    End Sub

    Private Sub WriteWithButtonSPI_Click(sender As Object, e As EventArgs) Handles WriteWithButtonSPI.Click
        OpenFileDumpSPI.ShowDialog()
        WriteWithTextBoxSPI.Text = OpenFileDumpSPI.FileName
    End Sub

    Private Sub WriteWithTextBoxSPI_TextChanged(sender As Object, e As EventArgs) Handles WriteWithTextBoxSPI.TextChanged
        If WriteWithTextBoxSPI.Text <> "" Then
            StartSPIwriteButton.Enabled = True
        Else
            StartSPIwriteButton.Enabled = False
        End If
    End Sub

    'Onglet SPIerasechip *****************************************************************************************
    Private Sub StartSPIerasechipButton_Click(sender As Object, e As EventArgs) Handles StartSPIerasechipButton.Click
        CommandPrompt.Text = ""
        MyProcess = New Process
        MyProcess.EnableRaisingEvents = True
        With MyProcess.StartInfo
            .FileName = "COMMANDS.BAT"
            .Arguments = TabControl1.SelectedTab.Text & TabCommandsSPI.SelectedTab.Text
            .UseShellExecute = False
            .CreateNoWindow = True
            .RedirectStandardInput = True
            .RedirectStandardOutput = True
            .RedirectStandardError = True
        End With
        TeensyBlinkSPI.Visible = True
        ProcessStart()
    End Sub

    'load NORway.hex ********************************************************************************************
    Private Sub TeensyPicNOR_Click(sender As Object, e As EventArgs) Handles TeensyPicNOR.Click

        OpenHexNOR.ShowDialog()

        If OpenHexNOR.FileName <> "" Then

            CommandPrompt.Text = ""
            MyProcess = New Process
            MyProcess.EnableRaisingEvents = True
            With MyProcess.StartInfo
                .FileName = "COMMANDS.BAT"
                .Arguments = "TeensyLoad" & " " & Chr(34) & OpenHexNOR.FileName & Chr(34)
                .UseShellExecute = False
                .CreateNoWindow = True
                .RedirectStandardInput = True
                .RedirectStandardOutput = True
                .RedirectStandardError = True
            End With
            TeensyBlinkNOR.Visible = True
            ProcessStart()

        End If

    End Sub

    'load NANDway.hex ********************************************************************************************
    Private Sub TeensyPicNAND_Click(sender As Object, e As EventArgs) Handles TeensyPicNAND.Click

        OpenHexNAND.ShowDialog()

        If OpenHexNAND.FileName <> "" Then

            CommandPrompt.Text = ""
            MyProcess = New Process
            MyProcess.EnableRaisingEvents = True
            With MyProcess.StartInfo
                .FileName = "COMMANDS.BAT"
                .Arguments = "TeensyLoad" & " " & Chr(34) & OpenHexNAND.FileName & Chr(34)
                .UseShellExecute = False
                .CreateNoWindow = True
                .RedirectStandardInput = True
                .RedirectStandardOutput = True
                .RedirectStandardError = True
            End With
            TeensyBlinkNAND.Visible = True
            ProcessStart()

        End If

    End Sub

    'load SPIway.hex ********************************************************************************************
    Private Sub TeensyPicSPI_Click(sender As Object, e As EventArgs) Handles TeensyPicSPI.Click

        OpenHexSPI.ShowDialog()

        If OpenHexSPI.FileName <> "" Then

            CommandPrompt.Text = ""
            MyProcess = New Process
            MyProcess.EnableRaisingEvents = True
            With MyProcess.StartInfo
                .FileName = "COMMANDS.BAT"
                .Arguments = "TeensyLoad" & " " & Chr(34) & OpenHexSPI.FileName & Chr(34)
                .UseShellExecute = False
                .CreateNoWindow = True
                .RedirectStandardInput = True
                .RedirectStandardOutput = True
                .RedirectStandardError = True
            End With
            TeensyBlinkSPI.Visible = True
            ProcessStart()

        End If

    End Sub

End Class

