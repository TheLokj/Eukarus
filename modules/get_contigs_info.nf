// Get the contigs ID and length
process GET_CONTIGS_INFO {
  label 'light'

  input:
  val contigsPath

  output:
  path "output.get_contigs_info"

  script:
  """
  awk '
    BEGIN {
        l=0
        split(\$0,header," ");
        prevId = header[1];
    } 
    /^>/{if (l!="") 
        split(\$0,header," ");
        print prevId, l;
        l=0 ;
        prevId = header[1];
        next
    }
    {l+=length(\$0)}
    END {
    print header[1], l}' $contigsPath | tr -d ">" | sed "1d" > output.get_contigs_info
  """
}
