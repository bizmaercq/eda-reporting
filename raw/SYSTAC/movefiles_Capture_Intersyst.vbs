	
   Set fs = CreateObject("Scripting.FileSystemObject")     
   
 
   Set shell = CreateObject("WScript.Shell") 	
 

   Do While (1)
 
    If  not fs.FolderExists("B:") then
	  shell.run "cmd /C SUBST Z: \\172.20.50.54\Balagence Administrateur /user:Eclearing@nfc1",1
	end if

	
	If  not fs.FileExists("C:\BALAGENCE\OUT\*.env") then
	  shell.run "cmd /C copy B:\out\capture\*.data Z:\IN\DATA\",1
	end if
   	
	Wscript.sleep(20000)
  
   Loop


