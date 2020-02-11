#!/bin/bash

STATIC_PATH="~/work/projects/oceania/redesign-oci-static/src"
LYSSA_PATH="~/work/projects/common/oci-lyssa-mocks"

#STATIC PATHS

STATIC_SCRIPTS_MOCKS_PATH="${STATIC_PATH}/scripts/mocks"
STATIC_SCRIPTS_PATH="${STATIC_PATH}/scripts/"
STATIC_STYLES_PATH="${STATIC_PATH}/styles/"


#LYSSA PATHS
LYSSA_COMPONENTS_FOLDER="{$LYSSA_PATH}/static/oci/api/cms/v1/nclh-template/components/"
LYSSA_MODULES_FOLDER="{$LYSSA_PATH}/static/oci/api/cms/v1/nclh-template/modules/"
STATIC_COMPONENTS_FOLDER="{$STATIC_PATH}/static/oci/api/cms/v1/nclh-template/components/"
STATIC_MODULES_FOLDER="{$STATIC_PATH}/static/oci/api/cms/v1/nclh-template/modules/"

LYSSA_COMPONENT_TEMPLATE="{namespace oceania.components}

{template .cxxx}
    {@param? class: string}

    <!-- cxxx -->
    <div class=\"cxxx{if \$class} {\$class}{/if}\">

    </div>
{/template}"

LYSSA_MODULE_TEMPLATE="{namespace oceania.modules}

{template .mxxx}
    {@param? class: string}

    <!-- cxxx -->
    <section class=\"cxxx{if \$class} {\$class}{/if}\">

    </section>
{/template}"

STATIC_SCRIPT_COMPONENT_TEMPLATE="import $ from 'jquery';

export default \$(function() {});"

STATIC_STYLE_COMPONENT_TEMPLATE=".cxxx{}"

fileExist(){
  filePath=$1
  fileName=$2
  if [ -f $filePath ]; then
        echo "...File doesn't exist, Let's make it"
    else
        echo "... File c$2.scss already exist please select another compadre, \n***** MIRA QUE YO TE LO DIGO, PRESTA MAS ATENCION ***** \n"
        exit 1
    fi
}

echo "
*------------------------------------------ \n
* What's the THING you are creating? Component[c] or Module[m]?\n"
read THING_TYPE
#if [[ $THING_TYPE =~ ^[cC]$ ]];then
#  TYPE='component'
#fi
case $THING_TYPE in
  [cC])
    TYPES='components'
    TYPE='component'
    ABBR_TYPE='c'
    ;;
  [mM])
    TYPES='modules'
    TYPE='module'
    ABBR_TYPE='m'
    ;;
  *)
    echo "Invalid Input"
    exit 1
    ;;
esac

echo "Your are creating a ${TYPE}"

echo "
*------------------------------------------ \n
* What's the ${TYPE} number? Just a number please, no characters:\n"
read THING_NUMBER
echo "
* So, it's gonna be ${TYPE}: ${ABBR_TYPE}$THING_NUMBER? \n
----------------------------------------------------------------- \n
Type [y] to confirm or anything else to ABORT if you chickened out\n
-----------------------------------------------------------------\n"

read confirm
if [[ $confirm =~ ^[Yy]$ ]];then
    echo "LET'S START CREATING STATIC FILES Mijito\n"
    echo "----------------------------------------\n"
    echo "Creating styles SCSS \n"
    STATIC_FILE="${STATIC_PATH}c$THING_NUMBER.scss";
    MOCK_FILE=$1;
    # make sure the file doesn't exits'
    fileExist STATIC_FILE THING_NUMBER

fi


#echo $STATIC_FILE