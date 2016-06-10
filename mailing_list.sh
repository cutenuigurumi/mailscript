#!/bin/bash

domain_list="list.txt"
tmp_mailing_lists="tmp_mailing_list.txt"
tmp_mailing_list_members="tmp_mailing_lists_members.txt"
output=",,"
newline="\n"
datetime=`date "+%Y%m%d_%H%M%S"`
result_lists="result_${datetime}.csv"
topline="domain, mailinglist, member"

#pre-processing
rm -f ${result_lists}
cd /home/ebara/

echo ${topline} >> ${result_lists}

cat ${domain_list} |  while read line
do
  #add domain name to result csv.
  echo "${line}" >> ${result_lists}
  #outputs mailing list, which belong to the domain.
  /usr/local/mailman/bin/list_lists -bV $line > ${tmp_mailing_lists}

  #debug code
  #echo "Do:/usr/local/mailman/bin/list_lists -bV $line "

  cat ${tmp_mailing_lists} | while read mailing_list
  do
    #outputs member list, which belong to the  mailing list.
    echo ", ${mailing_list}" >> ${result_lists}
    
    #debug code
    #echo "Do: /usr/local/mailman/bin/list_members ${mailing_list}"
    /usr/local/mailman/bin/list_members ${mailing_list} > ${tmp_mailing_list_members}
    cat ${tmp_mailing_list_members} | while read member
    do
      echo "${output}${member}" >> ${result_lists}
    done

  done

done

rm -f ${tmp_mailing_lists} ${tmp_mailing_list_members}

