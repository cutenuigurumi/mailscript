#!/bin/bash

domain_list="list.txt"
tmp_mailing_lists="tmp_mailing_list.txt"
tmp_mailing_list_members="tmp_mailing_lists_members.txt"
datetime=`date "+%Y%m%d_%H%M%S"`
topline="DisPlayName,Alias,PrimarySmtpAddress,Members,GroupType"
members=""

#pre-processing
rm -f ${result_lists}
cd /home/ebara/


cat ${domain_list} |  while read domain
do
  #add domain name to result csv.
  filename="${domain}.csv"
  touch ${filename}
  echo ${topline} > ${filename}

  #outputs mailing list, which belong to the domain.
  /usr/local/mailman/bin/list_lists -bV $domain > ${tmp_mailing_lists}
  echo "${domain}"

  #debug code
  #echo "Do:/usr/local/mailman/bin/list_lists -bV $line "

  cat ${tmp_mailing_lists} | while read mailing_list
  do
    #outputs member list, which belong to the  mailing list.

    
    #debug code
    #echo "Do: /usr/local/mailman/bin/list_members ${mailing_list}"
    /usr/local/mailman/bin/list_members ${mailing_list} > ${tmp_mailing_list_members}
echo ${tmp_mailing_list_members}
    cat ${tmp_mailing_list_members} | while read member
    do
      members="${members};${member}"
#     echo ${members}
    done
#  echo "${members}"
  echo "${mailing_list}@${domain},${mailing_list},${mailing_list}@${domain},${members},Distribution" >> ${filename}

  done

done

rm -f ${tmp_mailing_lists} ${tmp_mailing_list_members}

