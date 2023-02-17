ls -r *.md | foreach {
    echo $_.FullName
    echo $_.DirectoryName
    echo $_.Name
    echo $_.BaseName
    cd $_.DirectoryName
    $d = "{0}\{1}.docx" -f $_.DirectoryName,$_.BaseName
    echo $d
    pandoc.exe -s $_.FullName -o $d
}