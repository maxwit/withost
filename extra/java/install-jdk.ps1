if ($args.count -ne 1) {
	echo "usage: install-jdk <JDK PATH>!";
	exit(1);
}

$JAVA_HOME=$args[0];

if (Test-Path "$JAVA_HOME\bin\javac.exe") {

} else {
	echo "invalid path: '$JAVA_HOME'!";
	exit 1;
}

[Environment]::SetEnvironmentVariable("JAVA_HOME", $JAVA_HOME, "User");
[Environment]::SetEnvironmentVariable("CLASSPATH", ".;%JAVA_HOME%\lib;%JAVA_HOME%\jre\lib", "User");
[Environment]::SetEnvironmentVariable("PATH", "%JAVA_HOME%\bin", "User");
#$PATH = [Environment]::GetEnvironmentVariable("PATH", "User");
#echo $PATH;

echo "JDK successfully installed to $JAVA_HOME!";