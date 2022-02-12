Declare
    Stage Sttm_Branch.End_Of_Input%Type := 'T';
Begin
    Global.Pr_Init('010', 'FATEKWANA');
    If Not Gipks_Gi_Service.Fn_Gidprsif(Global.Current_Branch, Stage)
    Then
        Debug.Pr_Debug('CL', 'Failed in generation');
    End If;
Exception
    When Others Then
        Debug.Pr_Debug('CL', 'Failed in in exception WOT');
End;
/