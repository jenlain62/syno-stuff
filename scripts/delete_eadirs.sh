cd /volume1
find . -name @eaDir -print | while read n;
do
 echo $n 
 rm -rf "$n" 
done
