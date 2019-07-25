#!/usr/bin/perl
#

use strict;
use warnings;
use Spreadsheet::Read qw(ReadData);
use Encode;
use File::Copy;
 
my $book = ReadData ('');
my %hash = ();
my $temp_generate ={};
my $output_foldername = {};
my $output_filename = {};
my $xml_template = ('C:/Users/x217854/Software/xls.to.xml.script/telus_ingest_template.xml');
my $temp_providerID 			= {};
my $temp_asset_name             = {};
my $temp_providerName           = {};
my $temp_assetID	            = {};
my $temp_package_assetID        = {};
my $temp_title                  = {};
my $temp_reducedTitle           = {};
my $temp_summary                = {};
my $temp_shortSummary           = {};
my $temp_Director_fname         = {};
my $temp_Director_lname         = {};
my $temp_Producer_fname         = {};
my $temp_Actor1_fname           = {};
my $temp_Actor1_lname           = {};
my $temp_Actor2_fname           = {};
my $temp_Actor2_lname           = {};
my $temp_Actor3_fname           = {};
my $temp_Actor3_lname           = {};
my $temp_Actor4_fname           = {};
my $temp_Actor4_lname           = {};
my $temp_Actor5_fname           = {};
my $temp_Actor5_lname           = {};
my $temp_studio                 = {};
my $temp_licensingWindowStart   = {};
my $temp_licensingWindowEnd     = {};
my $temp_availabilityWindowStart= {};
my $temp_availabilityWindowEnd  = {};
my $temp_feature_assetID        = {};
my $temp_feature_content        = {};
my $temp_poster_assetID         = {};
my $temp_poster_content         = {};
 
 
# Print a message.
print "Hello, World!\n";


#locating the most recent file in input folder
my $dir = "C:/Users/x217854/Software/xls.to.xml.script/input_file/";
my $d = shift;
opendir(D, "$dir") || die "Can't open directory  $!\n";
    my @list = readdir(D);
    my @sorted_list = sort @list;
closedir(D);
my $src_file = $sorted_list[-1];


#reading spreadsheet
my $file_location = $dir . $src_file;
$book = ReadData ($file_location)   || die "Can't read input file. Ending program. $!\n" ;



#parse spreadsheet and store as hash
my @rows = Spreadsheet::Read::rows($book->[1]);
foreach my $i (1 .. scalar @rows) {
    foreach my $j (1 .. scalar @{$rows[$i-1]}) {
        #say chr(64+$i) . " $j " . ($rows[$i-1][$j-1] // '');
       
	 $hash{ $i }{$j} = ($rows[$i-1][$j-1] // ''); 
     $hash{ $i }{$j} = encode("utf8", $hash{ $i }{$j});
       # print $hash{ $i }{$j};        
    }
}


foreach my $outter (2 .. keys %hash) {
        #read single row of spreadsheet
        $temp_generate 					= $hash{$outter}{1};
        $temp_providerID 				= $hash{$outter}{2};
		$temp_providerName              = $hash{$outter}{3};
		$temp_studio                    = $hash{$outter}{4};
		$temp_assetID    		        = $hash{$outter}{5};
		$temp_title                     = $hash{$outter}{6};
		$temp_summary                   = $hash{$outter}{7};
		$temp_shortSummary              = $hash{$outter}{8};
		$temp_licensingWindowStart      = $hash{$outter}{9};
		$temp_licensingWindowEnd        = $hash{$outter}{10};

        
				$temp_asset_name = $temp_title ;
				$temp_asset_name =~ s/[^a-zA-Z0-9,]/_/g;
				$temp_reducedTitle = $temp_title ;
				$temp_package_assetID = $temp_assetID . "_package";
				$temp_feature_assetID = $temp_assetID . "_feature";
				$temp_poster_assetID = $temp_assetID . "_poster";
				$temp_shortSummary = $temp_summary;
				$temp_Producer_fname = $temp_studio;
				$temp_availabilityWindowStart = $temp_licensingWindowStart; 
				$temp_availabilityWindowEnd = $temp_licensingWindowEnd;
        
       
        
        # if ($len_asset_01 == 5 && $len_asset_02 == 5 && $len_asset_03 == 5 && $len_asset_04 == 5 && $len_asset_05 == 5 && $len_asset_06 == 5 ) {
        #$assets_valid = "YES";} 
        #else { $assets_valid = "NO";}
        
 
        
        
    if ($temp_generate eq "YES" ) {
        
         #if ($assets_valid eq "YES") { 

        #create the XML file from template
        #$sani_category_title = sanitize("$temp_category_title", alpha => 1);  
        #$temp_provider_id_01 = sanitize("$temp_provider_id_01", alpha => 1); 
        
        
        #$output_foldername = $date . "/" ;
        
		#mkdir  "archived_files/archive_output_files/" . $output_foldername;
        #$output_foldername = $date ."/".  $sani_category_title . "." . $date ;
		$output_foldername = $temp_providerID;
        mkdir $output_foldername;
        
		
		#####
		#$output_filename = "archived_files/archive_output_files/" . $output_foldername ."/" . $date . "." . $sani_category_title .  ".xml"; #
		$output_filename = $output_foldername . "/" . $temp_providerID . "_" . $temp_asset_name .  ".xml"; #
        $xml_template = ('C:/Users/x217854/Software/xls.to.xml.script/telus_ingest_template.v2.xml');
		copy($xml_template, $output_filename) or die "Copy failed: $!";
        #system("cp $xml_template $output_filename") ; # or warn "Warn:Can't Copy File $xml_template " ;
		#####
	
	
        #print $temp_provider_id . $xml_template;
      
            #replace tags in template with stored values
			
			rename($output_filename, $output_filename.'.bak');
			open(IN, '<'.$output_filename.'.bak') or die $!;
			open(OUT, '>'.$output_filename) or die $!;
			while(<IN>)
			{
				$_ =~  	s/__providerID__/$temp_providerID/g;
				$_ =~   s/__providerName__/$temp_providerName/g;
				
				$_ =~   s/__asset_name__/$temp_asset_name/g;
				$_ =~   s/__title__/$temp_title/g;
				$_ =~   s/__reducedTitle__/$temp_reducedTitle/g;

				$_ =~   s/__package_assetID__/$temp_package_assetID/g;
				$_ =~   s/__feature_assetID__/$temp_feature_assetID/g;
				$_ =~   s/__poster_assetID__/$temp_poster_assetID/g;				
				
				$_ =~   s/__summary__/$temp_summary/g;
				$_ =~   s/__shortSummary__/$temp_shortSummary/g;				
				
				$_ =~   s/__Producer_fname__/$temp_Producer_fname/g;
				$_ =~   s/__studio__/$temp_studio/g;
				
				$_ =~   s/__licensingWindowStart__/$temp_licensingWindowStart/g;
				$_ =~   s/__licensingWindowEnd__/$temp_licensingWindowEnd/g;
				$_ =~   s/__availabilityWindowStart__/$temp_availabilityWindowStart/g;
				$_ =~   s/__availabilityWindowEnd__/$temp_availabilityWindowEnd/g;
				
				#$_ =~   s/__feature_content__/$temp_feature_content/g;
				#$_ =~   s/__poster_content__/$temp_poster_content/g;
				
				#$_ =~   s/__Director_fname__/$temp_Director_fname/g;
				#$_ =~   s/__Director_lname__/$temp_Director_lname/g;
				#$_ =~   s/__Actor1_fname__/$temp_Actor1_fname/g;
				#$_ =~   s/__Actor1_lname__/$temp_Actor1_lname/g;
				#$_ =~   s/__Actor2_fname__/$temp_Actor2_fname/g;
				#$_ =~   s/__Actor2_lname__/$temp_Actor2_lname/g;
				#$_ =~   s/__Actor3_fname__/$temp_Actor3_fname/g;
				#$_ =~   s/__Actor3_lname__/$temp_Actor3_lname/g;
				#$_ =~   s/__Actor4_fname__/$temp_Actor4_fname/g;
				#$_ =~   s/__Actor4_lname__/$temp_Actor4_lname/g;
				#$_ =~   s/__Actor5_fname__/$temp_Actor5_fname/g;
				#$_ =~   s/__Actor5_lname__/$temp_Actor5_lname/g;		
				print OUT $_;
			}
			
			
			close(IN);
			close(OUT);
			unlink $output_filename.'.bak' or warn "Could not unlink";
            

        
        
        print "\n\nCreating: ".  $output_filename ;
        #print "\nAssets 01:" . $sani_asset_01;
        #print " 02:" .  $sani_asset_02;
        #print " 03:" .  $sani_asset_03;
        #print " 04:" .  $sani_asset_04;
        #print " 05:" .  $sani_asset_05;
        #print " 06:" . $sani_asset_06;
        #print "\nAssets valid:" . $assets_valid;
        
        
        
		#}#valid
        #        else {
        #        print "\nInvalid input on $temp_category_title. Ending program. \n ";
        #        exit}
    }

}




