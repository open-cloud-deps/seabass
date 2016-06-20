use strict;
use warnings;


my $RESOURCES = $ARGV[0];

#first we wait for the resource servers to get ready. 
my $upcount = 0;

while ($upcount - 1 < $RESOURCES  ) {
  print "waiting for resources to get ready...";
  my $rstring = `docker exec -i icom ilsresc`;
  my @uparray = split("\n",$rstring);
  $upcount = scalar @uparray;
}



# open the csv
open (IN, "psparsed.csv");

while(<IN>) {
  chomp $_;
  my @rowvals = split(",", $_);
  
  # format of a row in this csv is 
  # <container type>,<container ID>,<container name>
  
  # we only want to deal with resource servers. 
  if ($rowvals[0] =~ /irs/)
  {
   # if we are here it means the current row is a resource server.
   # using the CID and the container name, we will rename resource using iadmin modresc.

    my $oldname = $rowvals[1] . 'Resource';
    my $rsno    = (split("_",$rowvals[2]))[2];
    my $newname = 'SBRS_'.$rsno;

    print "renaming $oldname to $newname\n\n"; 
    print `echo y | docker exec -i icom  iadmin modresc $oldname name $newname`;
}
}

close IN;
exit;

