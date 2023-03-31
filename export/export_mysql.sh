#!/bin/bash
DATET=$(date +%y%m%d%H%M%S)

source conf.sh

# Params
# ID organisation id
# Entity (OPTIONAL)

while getopts o:e:c: flag
do
    case "${flag}" in
        o) ORG_ID=${OPTARG};;
		e) ENTITY=${OPTARG};;
		c) SKIP_COL=${OPTARG};;
        \?) echo "Invalid option $OPTARG" >&2
        exit 1
        ;;
    esac
done

if [ -z ${ORG_ID} ]; then
	# There's no Organisation(s) ID(s)
	echo "***** Missing Organisation(s) ID(s)"
	exit 0
fi

if [ -z ${ENTITY} ]; then
	# All entities required
	ENTITIES="entities/wholeEntities"
else
	# There's a specific entity
	ENTITIES="entities/onlyEntity"
	echo $ENTITY > $ENTITIES
fi


if [ -z ${SKIP_COL} ]; then
	# There's no skip column needed
	SKIP_COL=""
else
	SKIP_COL=" --skip-column-names"
fi

# Queries to handle:
# Users
# Challenges
# Ideas
# Ratings
# Comments / Notes

echo $DATET

while read line; do
	echo "=== EXPORTING.... ${line}"
	# search for query file
	QUERYFILE="queries/${line}.txt"
	if test -f "$QUERYFILE"; then
		echo "$QUERYFILE exists."
		if [[ "${line}" == *"attachments"* ]]; then
			SKIP_COL=" --skip-column-names"
		fi

		source $QUERYFILE

		OUTPUTFILE="output/${line}.csv"
		XLSFILE="output/${line}.xlsx"

		# >
		# <
		#MyCOMM="mysql -u $MyUSER -p$MyPSWD -h $MyHOST $MyDB -e \"${MyQUERY}\" -B --skip-column-names > ${OUTPUTFILE}"
		MyCOMM="mysql -u $MyUSER -p$MyPSWD -h $MyHOST $MyDB -e \"${MyQUERY}\" -B ${SKIP_COL} | sed 's/\"/\"\"/g;s/\t/\",\"/g;s/^/\"/;s/$/\"/;s/\x0b//g' > ${OUTPUTFILE}"

		eval $MyCOMM
		# Convert to XLS
		CONCOMM="ssconvert ${OUTPUTFILE} ${XLSFILE}"
		
		echo "+ converting to xlsx..."
		eval $CONCOMM
	else
		echo "***** There's no query file for ${line}"
	fi
done < $ENTITIES

