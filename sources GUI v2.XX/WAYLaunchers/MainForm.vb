Imports System.IO
Imports System.Security.Cryptography
Imports System.Text
Public Class MainForm

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
        SaveToDisk("COMMANDS.EXE", "COMMANDS.EXE")
        SaveToDisk("teensy_loader_cli.exe", "teensy_loader_cli.exe")
    End Sub

    Private Sub MainForm_Closed(sender As Object, e As EventArgs) Handles MyBase.FormClosed
        My.Computer.FileSystem.DeleteFile("COMMANDS.EXE")
        My.Computer.FileSystem.DeleteFile("teensy_loader_cli.exe")
    End Sub

    'Onglet NORinfo *****************************************************************************************
    Private Sub StartNORinfoButton_Click(sender As Object, e As EventArgs) Handles StartNORinfoButton.Click


        TeensyBlinkNOR.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text)

    End Sub

    'Onglet NORdump *****************************************************************************************
    Private Sub StartNORdumpButton_Click(sender As Object, e As EventArgs) Handles StartNORdumpButton.Click

        Dim DumpFileNOR As String = Replace(SaveToTextBoxNOR.Text, ".bin", "")
        DumpFileNOR = Replace(DumpFileNOR, ".BIN", "")


        TeensyBlinkNOR.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text & " " & Chr(34) & DumpFileNOR & Chr(34) & " " & "NUL" & " " & NumericUpDownDumpsNOR.Value & " " & CheckBoxBinCompNOR.Checked)

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
        If SaveFileDialogNOR.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
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

        TeensyBlinkNOR.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & VerifyArgument & TabCommandsNOR.SelectedTab.Text & WordArgument & " " & Chr(34) & WriteWithTextBoxNOR.Text & Chr(34) & " NUL NUL " & CheckBoxPFWwriteNOR.Checked)

    End Sub

    Private Sub CheckBoxWordNOR_Click(sender As Object, e As EventArgs) Handles CheckBoxWordNOR.Click
        CheckBoxWordUbmNOR.Checked = False
    End Sub

    Private Sub CheckBoxWordUbmNOR_Click(sender As Object, e As EventArgs) Handles CheckBoxWordUbmNOR.Click
        CheckBoxWordNOR.Checked = False
    End Sub

    Private Sub WriteWithButtonNOR_Click(sender As Object, e As EventArgs) Handles WriteWithButtonNOR.Click
        If OpenFileDumpNOR.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
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

        TeensyBlinkNOR.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text & " " & Chr(34) & VerifyWithTextBoxNOR.Text & Chr(34) & " NUL NUL " & CheckBoxPFWwriteNOR.Checked)

    End Sub

    Private Sub VerifyWithButtonNOR_Click(sender As Object, e As EventArgs) Handles VerifyWithButtonNOR.Click
        If OpenFileVerifyNOR.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
        VerifyWithTextBoxNOR.Text = OpenFileVerifyNOR.FileName
    End Sub

    Private Sub VerifyWithTextBoxNOR_TextChanged(sender As Object, e As EventArgs) Handles VerifyWithTextBoxNOR.TextChanged
        StartNORverifyButton.Enabled = True
    End Sub

    'Onglet NORrelease *****************************************************************************************
    Private Sub StartNORreleaseButton_Click(sender As Object, e As EventArgs) Handles StartNORreleaseButton.Click


        TeensyBlinkNOR.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text)

    End Sub

    'Onglet NORerasechip *****************************************************************************************
    Private Sub StartNORerasechipButton_Click(sender As Object, e As EventArgs) Handles StartNORerasechipButton.Click


        TeensyBlinkNOR.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNOR.SelectedTab.Text)

    End Sub

    'Onglet NANDinfo *****************************************************************************************
    Private Sub StartNANDinfoButton_Click(sender As Object, e As EventArgs) Handles StartNANDinfoButton.Click


        TeensyBlinkNAND.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNAND.SelectedTab.Text)

    End Sub

    'Onglet NANDdump *****************************************************************************************
    Private Sub StartNANDdumpButton_Click(sender As Object, e As EventArgs) Handles StartNANDdumpButton.Click

        Dim DumpFileNAND As String = Replace(SaveToTextBoxNAND.Text, ".bin", "")
        DumpFileNAND = Replace(DumpFileNAND, ".BIN", "")


        TeensyBlinkNAND.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNAND.SelectedTab.Text & " " & Chr(34) & DumpFileNAND & Chr(34) & " " & "NUL" & " " & NumericUpDownDumpsNAND.Value & " " & CheckBoxBinCompNAND.Checked)

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
        If SaveFileDialogNAND.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
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


        TeensyBlinkNAND.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & VerifyArgument & DiffArgument & TabCommandsNAND.SelectedTab.Text & " " & Chr(34) & WriteWithTextBoxNAND.Text & Chr(34) & " " & Chr(34) & DiffWithTextBoxNAND.Text & Chr(34))

    End Sub

    Private Sub WriteWithButtonNAND_Click(sender As Object, e As EventArgs) Handles WriteWithButtonNAND.Click
        If OpenFileDumpNAND.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
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
        If OpenFileDiffNAND.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
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


        TeensyBlinkNAND.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsNAND.SelectedTab.Text & " " & Chr(34) & BBwithTextBoxNAND.Text & Chr(34))

    End Sub

    Private Sub BBwithButtonNAND_Click(sender As Object, e As EventArgs) Handles BBwithButtonNAND.Click
        If OpenFileBBNAND.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
        BBwithTextBoxNAND.Text = OpenFileBBNAND.FileName
    End Sub

    Private Sub BBwithTextBoxNAND_TextChanged(sender As Object, e As EventArgs) Handles BBwithTextBoxNAND.TextChanged
        StartNANDbbButton.Enabled = True
    End Sub

    'Onglet SPIinfo *****************************************************************************************
    Private Sub StartSPIinfoButton_Click(sender As Object, e As EventArgs) Handles StartSPIinfoButton.Click


        TeensyBlinkSPI.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsSPI.SelectedTab.Text)

    End Sub

    'Onglet SPIdump *****************************************************************************************
    Private Sub StartSPIdumpButton_Click(sender As Object, e As EventArgs) Handles StartSPIdumpButton.Click

        Dim DumpFileSPI As String = Replace(SaveToTextBoxSPI.Text, ".bin", "")
        DumpFileSPI = Replace(DumpFileSPI, ".BIN", "")


        TeensyBlinkSPI.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsSPI.SelectedTab.Text & " " & Chr(34) & DumpFileSPI & Chr(34) & " " & "NUL" & " " & NumericUpDownDumpsSPI.Value & " " & CheckBoxBinCompSPI.Checked)

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
        If SaveFileDialogSPI.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
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


        TeensyBlinkSPI.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & VerifyArgument & TabCommandsSPI.SelectedTab.Text & " " & Chr(34) & WriteWithTextBoxSPI.Text & Chr(34))

    End Sub

    Private Sub WriteWithButtonSPI_Click(sender As Object, e As EventArgs) Handles WriteWithButtonSPI.Click
        If OpenFileDumpSPI.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If
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


        TeensyBlinkSPI.Visible = True
        RunCommandCom("COMMANDS.EXE", TabControl1.SelectedTab.Text & TabCommandsSPI.SelectedTab.Text)

    End Sub

    'load NORway.hex ********************************************************************************************
    Private Sub TeensyPicNOR_Click(sender As Object, e As EventArgs) Handles TeensyPicNOR.Click

        If OpenHexNOR.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If

        If OpenHexNOR.FileName <> "" Then


            TeensyBlinkNOR.Visible = True
            RunCommandCom("COMMANDS.EXE", "TeensyLoad" & " " & Chr(34) & OpenHexNOR.FileName & Chr(34))

        End If

    End Sub

    'load NANDway.hex ********************************************************************************************
    Private Sub TeensyPicNAND_Click(sender As Object, e As EventArgs) Handles TeensyPicNAND.Click

        If OpenHexNAND.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If

        If OpenHexNAND.FileName <> "" Then


            TeensyBlinkNAND.Visible = True
            RunCommandCom("COMMANDS.EXE", "TeensyLoad" & " " & Chr(34) & OpenHexNAND.FileName & Chr(34))

        End If

    End Sub

    'load SPIway.hex ********************************************************************************************
    Private Sub TeensyPicSPI_Click(sender As Object, e As EventArgs) Handles TeensyPicSPI.Click

        If OpenHexSPI.ShowDialog(Me) <> Windows.Forms.DialogResult.OK Then
            Exit Sub
        End If

        If OpenHexSPI.FileName <> "" Then


            TeensyBlinkSPI.Visible = True
            RunCommandCom("COMMANDS.EXE", "TeensyLoad" & " " & Chr(34) & OpenHexSPI.FileName & Chr(34))

        End If

    End Sub

    Private Sub TabNORwrite_Click(sender As Object, e As EventArgs) Handles TabNORwrite.Paint

        If System.IO.File.Exists("NORway.py") Then
            Dim RD As FileStream = New FileStream("NORway.py", FileMode.Open, FileAccess.Read, FileShare.Read, 8192)
            Dim md5 As MD5CryptoServiceProvider = New MD5CryptoServiceProvider
            md5.ComputeHash(RD)
            RD.Close()
            Dim hash As Byte() = md5.Hash
            Dim SB As StringBuilder = New StringBuilder
            Dim b As Byte
            For Each b In hash
                SB.Append(String.Format("{0:x2}", b))
            Next
            If SB.ToString() = "37cd558bc2c89b61f5ba9a04827366a9" Then
                CheckBoxPFWwriteNOR.Enabled = True
            End If
        End If

    End Sub

    Private Sub TabNORverify_Click(sender As Object, e As EventArgs) Handles TabNORverify.Paint

        If System.IO.File.Exists("NORway.py") Then
            Dim RD As FileStream = New FileStream("NORway.py", FileMode.Open, FileAccess.Read, FileShare.Read, 8192)
            Dim md5 As MD5CryptoServiceProvider = New MD5CryptoServiceProvider
            md5.ComputeHash(RD)
            RD.Close()
            Dim hash As Byte() = md5.Hash
            Dim SB As StringBuilder = New StringBuilder
            Dim b As Byte
            For Each b In hash
                SB.Append(String.Format("{0:x2}", b))
            Next
            If SB.ToString() = "37cd558bc2c89b61f5ba9a04827366a9" Then
                CheckBoxPFWverifyNOR.Enabled = True
            End If
        End If

    End Sub
End Class

