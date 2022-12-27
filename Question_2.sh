echo "================================================"
echo "List all files in the current directory, sorts the output, remove file extensions: "
ls | sort | cut -f 1 -d '.' 

echo "================================================"
echo "List only show .txt files: "
ls | egrep '\.txt$'

echo "================================================"
echo "List files and folders that have been created within 1 day: "
ls | find . -maxdepth 1 -mtime -1
