#!/bin/bash

lock_file=/tmp/.mirror-clouddata

ibs_mirror='ibs-mirror.prv.suse.net'

if [ -f $lock_file ]; then
    echo "process is running"
    exit 1
fi

echo "locked $$" > $lock_file

rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Products/SUSE-CAASP/3.0/x86_64/product/" ./dist/ibs/SUSE/Products/SUSE-CAASP/3.0/x86_64/product &
rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Updates/SUSE-CAASP/3.0/x86_64/update/" ./dist/ibs/SUSE/Updates/SUSE-CAASP/3.0/x86_64/update &
rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Products/Storage/5/x86_64/product/" ./repos/x86_64/SUSE-Enterprise-Storage-5-Pool &
rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Updates/Storage/5/x86_64/update/" ./repos/x86_64/SUSE-Enterprise-Storage-5-Updates &
rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Products/SLE-SERVER/12-SP3/x86_64/product/" ./repos/x86_64/SLES12-SP3-Pool &
rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Updates/SLE-SERVER/12-SP3/x86_64/update/" ./repos/x86_64/SLES12-SP3-Updates &
rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Products/SLE-SDK/12-SP3/x86_64/product/" ./repos/x86_64/SLE12-SP3-SDK-Pool &
rsync -rtlH --safe-links --delete-after "rsync://${ibs_mirror}/distibs/SUSE/Updates/SLE-SDK/12-SP3/x86_64/update/" ./repos/x86_64/SLE12-SP3-SDK-Updates &

wait

chmod -R +r ./dist
chmod -R +r ./repos

rm $lock_file
