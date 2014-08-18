Imports System.Reflection
Imports System.IO

Module Utilities
    Public Sub SaveToDisk(ByVal resourceName As String, ByVal fileName As String)
        ' Get a reference to the running application.
        Dim assy As [Assembly] = [Assembly].GetExecutingAssembly()

        ' Loop through each resource, looking for the image name (case-insensitive).
        For Each resource As String In assy.GetManifestResourceNames()
            If resource.ToLower().IndexOf(resourceName.ToLower) <> -1 Then
                ' Get the embedded file from the assembly as a MemoryStream.
                Using resourceStream As System.IO.Stream = assy.GetManifestResourceStream(resource)
                    If resourceStream IsNot Nothing Then
                        Using reader As New BinaryReader(resourceStream)
                            ' Read the bytes from the input stream.
                            Dim buffer() As Byte = reader.ReadBytes(CInt(resourceStream.Length))
                            Using outputStream As New FileStream(fileName, FileMode.Create)
                                Using writer As New BinaryWriter(outputStream)
                                    ' Write the bytes to the output stream.
                                    writer.Write(buffer)
                                End Using
                            End Using
                        End Using
                    End If
                End Using
                Exit For
            End If
        Next resource
    End Sub

    Public Sub RunCommandCom(command As String, arguments As String)
        Dim p As Process = New Process()
        Dim pi As ProcessStartInfo = New ProcessStartInfo()
        pi.Arguments = arguments
        pi.FileName = command
        p.StartInfo = pi
        p.Start()

        MainForm.TabCommandsNOR.Enabled = False
        MainForm.TabCommandsNAND.Enabled = False
        MainForm.TabCommandsSPI.Enabled = False
        MainForm.StartNORinfoButton.Text = "WAIT..."
        MainForm.StartNORdumpButton.Text = "WAIT..."
        MainForm.StartNORwriteButton.Text = "WAIT..."
        MainForm.StartNORverifyButton.Text = "WAIT..."
        MainForm.StartNORreleaseButton.Text = "WAIT..."
        MainForm.StartNORerasechipButton.Text = "WAIT..."
        MainForm.StartNANDinfoButton.Text = "WAIT..."
        MainForm.StartNANDdumpButton.Text = "WAIT..."
        MainForm.StartNANDwriteButton.Text = "WAIT..."
        MainForm.StartNANDbbButton.Text = "WAIT..."
        MainForm.StartSPIinfoButton.Text = "WAIT..."
        MainForm.StartSPIdumpButton.Text = "WAIT..."
        MainForm.StartSPIwriteButton.Text = "WAIT..."
        MainForm.StartSPIerasechipButton.Text = "WAIT..."

        Do While Not p.HasExited
        Loop

        MainForm.TabCommandsNOR.Enabled = True
        MainForm.TabCommandsNAND.Enabled = True
        MainForm.TabCommandsSPI.Enabled = True
        MainForm.TeensyBlinkNOR.Visible = False
        MainForm.TeensyBlinkNAND.Visible = False
        MainForm.TeensyBlinkSPI.Visible = False
        MainForm.StartNORinfoButton.Text = "START"
        MainForm.StartNORdumpButton.Text = "START"
        MainForm.StartNORwriteButton.Text = "START"
        MainForm.StartNORverifyButton.Text = "START"
        MainForm.StartNORreleaseButton.Text = "START"
        MainForm.StartNORerasechipButton.Text = "START"
        MainForm.StartNANDinfoButton.Text = "START"
        MainForm.StartNANDdumpButton.Text = "START"
        MainForm.StartNANDwriteButton.Text = "START"
        MainForm.StartNANDbbButton.Text = "START"
        MainForm.StartSPIinfoButton.Text = "START"
        MainForm.StartSPIdumpButton.Text = "START"
        MainForm.StartSPIwriteButton.Text = "START"
        MainForm.StartSPIerasechipButton.Text = "START"

    End Sub
End Module
