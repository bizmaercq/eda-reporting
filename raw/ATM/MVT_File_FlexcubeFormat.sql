Declare
    p_Err_Code  Varchar2(2000);
    p_Err_Param Varchar2(2000);
    p_File_Name Varchar2(2000) := '';
    --    p_File_Path Varchar2(2000) := '';
Begin
    Global.Pr_Init('010', 'FATEKWANA');
    If Not Fn_Settle_File_Read('&p_File_Name', '/home/XAFNFC/GIMAC/ready', p_Err_Code, p_Err_Param)
    Then
        Debug.Pr_Debug('CL', 'Failed');
    End If;
Exception
    When Others Then
        Debug.Pr_Debug('CL', 'In WOT exception');
End;
/