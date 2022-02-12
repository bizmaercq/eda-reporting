	
   Set fs = CreateObject("Scripting.FileSystemObject")     
   
 
   Set shell = CreateObject("WScript.Shell") 	
 

   Do While (1)
 
    If  not fs.FolderExists("B:") then
	  shell.run "cmd /C SUBST B: \\172.20.50.31\Balsiege Administrateur /user:1234",1
	end if

	
	If  not fs.FileExists("C:\BALAGENCE\OUT\*.env") then
	  shell.run "cmd /C move C:\BALAGENCE\OUT\ENV\*.env B:\IN\SI\",1
	end if
   	
	Wscript.sleep(20000)
  
   Loop


