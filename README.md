# Bash_Error_Handling
A scriptlet that shows how I handle bash errors

# Usage
You can either add the required lines at the top of your script or you can redirect the output toward a file that is captured.

`bad_command ABC XYZ`<BR>
 `bad_command ABC XYZ 2> $ERROR`

# Output
<code>$ ./error2.sh<BR>
./error.sh: line 82: bad_command: command not found
Jun 16 13:17:20 Error1: Command [bad_command ABC XYZ], line 82:, exited [code 127, Command not found]
Jun 16 13:17:20 Error2: Command [bad_command ABC XYZ 2> $ERROR] ./error2.sh: line 83: bad_command: command not found
foo</code>
