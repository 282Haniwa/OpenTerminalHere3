on open dropedItems
	repeat with anItem in dropedItems
		set aDirectory to get POSIX path of anItem
		if not isDirectory(anItem) then -- anItemがディレクトリでない時それを含むディレクトリを指定する
			tell application "Finder"
				set aParentFolder to (container of anItem) as alias
				set aDirectory to get POSIX path of aParentFolder
			end tell
		end if
		openDirectoryOnTerminal(aDirectory)
	end repeat
end open

on run
	tell application "Finder"
		try
			tell Finder window 1
				set aTarget to target
				set aFolder to aTarget as alias
			end tell
		on error number errorNumber
			display alert "対象となるFinderウィンドウが見つからないので、デスクトップをTerminalのカレントディレクトリとします。"
			set aFolder to (path to desktop folder)
		end try
	end tell
	set aDirectory to get POSIX path of aFolder
	openDirectoryOnTerminal(aDirectory)
end run

on isDirectory(anItem)
	set isFolder to (folder of (info for anItem))
	set isPackageFolder to (package folder of (info for anItem))
	if isFolder and not isPackageFolder then return true
	return false
end isDirectory

on openDirectoryOnTerminal(aDirectory)
	tell application "Terminal"
		do script with command "cd �"" & aDirectory & "�"; clear; pwd"
		activate me
		tell application "System Events"
			set aProcess to get process "Terminal"
		end tell
		tell aProcess
			set frontmost to true
		end tell
	end tell
end openDirectoryOnTerminal
