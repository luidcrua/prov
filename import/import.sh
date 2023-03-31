#!/bin/bash
DATET=$(date +%y%m%d%H%M%S)

# Params
# Domain(s)
# Path
# Entity (OPTIONAL)

while getopts d:p:s:y:e:i:c: flag
do
    case "${flag}" in
        d) DOMAIN=${OPTARG};;
        p) EXCEL_PATH=${OPTARG};;
        s) STAGING=${OPTARG};;
		y) DO_IT=${OPTARG};;
		e) ENTITY=${OPTARG};;
		i) INVITES=${OPTARG};;
		c) CHALLENGE_ID=${OPTARG};;
        \?) echo "Invalid option $OPTARG" >&2
        exit 1
        ;;
    esac
done

if [ -z ${DOMAIN} ]; then
	# There's no Domain(s)
	echo "***** Missing argument -d Domain(s)"
	exit 0
fi

if [ -z ${EXCEL_PATH} ]; then
	# There's no Path for excel files
	echo "***** Missing argument -p: Path for Excel files"
	exit 0
else
	if [ ! -d "${EXCEL_PATH}" ]; then
		# Path doesn't exist
		echo "***** Directory ${EXCEL_PATH} DOES NOT exist." 
		exit 0
	fi
fi

if [ -z ${STAGING} ]; then
	# No Staging argument
	STAGING=""
else
	# There's a staging argument
	STAGING=" --staging"
fi

if [ -z ${DO_IT} ]; then
	# No DO IT argument
	DO_IT=""
else
	# There's a DO IT argument
	DO_IT=" -y"
fi

if [ -z ${ENTITY} ]; then
	# All entities required
	ENTITIES="entities/wholeEntities"
else
	# There's a specific entity
	ENTITIES="entities/onlyEntity"
	# In case of wanting to import users, needs to import Form
	if [[ "${ENTITY}" == "users" ]]; then
		echo "user_form" > $ENTITIES
		echo $ENTITY >> $ENTITIES 
	else
		echo $ENTITY > $ENTITIES
	fi
fi

if [ -z ${INVITES} ]; then
	# No Send invites argument
	INVITES=""
else
	# There's a send invites argument
	INVITES=" --send-invites ${INVITES}"
fi

if [ -z ${CHALLENGE_ID} ]; then
	# No Default Challenge ID for importing ideas into it
	CHALLENGE_ID=""
else
	# There's a Default Challenge ID for importing ideas into it
	CHALLENGE_ID=" --challenge-id ${CHALLENGE_ID}"
fi

PRIVATE_CHANNEL_NAME='Managers'

# Scripts to handle:
# User form
# Users
# Challenges
# Ideas
# Ratings
# Comments / Notes

while read line; do
	echo "=== IMPORTING.... ${line}"
	# search for command file
	COMMFILE="commands/${line}.txt"
	if test -f "$COMMFILE"; then
		if [[ "${line}" != "user_form" ]]; then
			# check for excel file to exist, avoid user_form which doesn't need an excel file
			if ! test -f "${EXCEL_PATH}${line}.xlsx"; then
				echo "***** There's no Excel file to load for ${line}"
				continue
			fi
		fi
		echo "$COMMFILE and ${EXCEL_PATH}${line}.xlsx exist."

		source $COMMFILE

		# >
		# <
		
		echo $PyCOMM

		#eval $PyCOMM
	else
		echo "***** There's no script to run for ${line}"
	fi
done < $ENTITIES
