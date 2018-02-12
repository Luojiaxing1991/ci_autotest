Sub writeOutData()
    Dim result As String
    Dim nR1 As Integer
    Dim nCBlank As Integer
    nCBlank = 0
    nR1 = 8
    result = ""
    Do
        'Len(Sheets("Test Case").Cells(nR1, 12).Text)
        If Sheets("Test Case").Cells(nR1, 5).Text = "" Then
            nCBlank = nCBlank + 1
        Else
            'MsgBox VarType(Sheets("Test Case").Cells(nR1, 1))
            result = result & Sheets("Test Case").Cells(nR1, 1).Text & Chr(9)
            result = result & Sheets("Test Case").Cells(nR1, 2).Text & Chr(9)
            result = result & Sheets("Test Case").Cells(nR1, 3).Text & Chr(9)
            result = result & Sheets("Test Case").Cells(nR1, 4).Text & Chr(9)
            result = result & Sheets("Test Case").Cells(nR1, 5).Text & Chr(9)
            result = result & Sheets("Test Case").Cells(nR1, 11).Text & Chr(9)
            result = result & Sheets("Test Case").Cells(nR1, 12).Text & Chr(9)
            result = result & Sheets("Test Case").Cells(nR1, 13).Text & Chr(9)
            result = result & Chr(10)
        End If
        nR1 = nR1 + 1
    Loop While nCBlank < 5
    Open ThisWorkbook.Path & "\test_case.txt" For Binary As #1
    Put #1, , result
    Close #1
    MsgBox "OutPut Success!"
End Sub
