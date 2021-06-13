#!/bin/bash
function uploadItem {
	aws s3 cp . s3://${S3_BACKUP_BUCKET} --storage-class DEEP_ARCHIVE --recursive \
	--exclude "Mangas/Vagabond/*"
}

function canRemoveItem {
	[ ${1} != "./Mangas" ]
}

function removeItem {
	for filename in ${1}/*; do
		if [ -d "${filename}" ] && [ -n "$(ls -A "${filename}" 2> /dev/null)" ] && canRemoveItem "${filename}"; then
		        removeItem "${filename}";
		elif [ ! -d "${filename}" ]; then
			rm "${filename}"
		else
			echo "nothing to remove in ${filename}"
		fi
	done
}

function main {
	echo -e "Uploading to s3 \n";
	
	uploadItem;
	
	if [ $? -eq 0 ]
	then
		echo -e "Deleting saved item \n";
		removeItem .
	else
		echo -e "Upload failed \n";
	fi

	echo -e "\n";
	echo -e "\n";
	echo "Done, don't forget to update the exclude list ! :)";
}

main;
