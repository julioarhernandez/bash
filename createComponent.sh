#!/bin/bash

STATIC_PATH="/Users/juliorodriguez/work/projects/oceania/redesign-oci-static/src"
LYSSA_PATH="/Users/juliorodriguez/work/projects/common/oci-lyssa-mocks"

#STATIC PATHS

STATIC_SCRIPTS_MOCKS_PATH="${STATIC_PATH}/scripts/mocks"
STATIC_SCRIPTS_PATH="${STATIC_PATH}/scripts"
STATIC_STYLES_PATH="${STATIC_PATH}/styles"


#LYSSA PATHS
LYSSA_FOLDER="${LYSSA_PATH}/static/oci/api/cms/v1/nclh-template"

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

STATIC_SCRIPT_TEMPLATE="import $ from \"jquery\";\n\n
export default \$(function() {});"

STATIC_STYLE_COMPONENT_TEMPLATE=".cxxx{}"

STATIC_STYLE_COMPONENT_MAIN_TEMPLATE="\n@import \"components/xxx\";"

fileExist(){
  filePath=$1
  if [ -f "$filePath" ]; then
        echo "... File ${filePath} already exist please select another compadre, \n***** MIRA QUE YO TE LO DIGO, PRESTA MAS ATENCION ***** \n"
        exit 1
    else
        echo "... File doesn't exist, Let's keep doing this magic"
    fi
}

createFile(){
  filePath=$1
  content=$2
  echo $content > $filePath
  echo "... Created ${filePath}"
}

appendContent(){
  filePath=$1
  content=$2
  echo "${content}" >> $filePath
}

appendContentCat(){
  filePath=$1
  content=$2
  echo "${content}" >> $filePath
}

replaceToken(){
  template=$1
  string=$2
  echo ${template//xxx/${string}}
}

echo "
*------------------------------------------ \n
* What's the THING you are creating? Component[c] or Module[m]?\n"
#read THING_TYPE
#if [[ $THING_TYPE =~ ^[cC]$ ]];then
#  TYPE='component'
#fi
THING_TYPE="m"
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
#read THING_NUMBER
THING_NUMBER="23333435"
echo "
* So, it's gonna be ${TYPE}: ${ABBR_TYPE}$THING_NUMBER? \n
----------------------------------------------------------------- \n
Type [y] to confirm or anything else to ABORT if you chickened out\n
-----------------------------------------------------------------\n"
#read confirm
confirm="y"
ELEMENT_NAME=${ABBR_TYPE}$THING_NUMBER
if [[ $confirm =~ ^[Yy]$ ]];then
    echo "LET'S START CREATING STATIC FILES Mijito\n"
    echo "----------------------------------------\n"
    echo "Creating styles SCSS \n"

    # *************************************************
    #
    #   Creating scss
    #
    # *************************************************

    STATIC_FILE="${STATIC_STYLES_PATH}/${TYPES}/_${ELEMENT_NAME}.scss";
    fileExist $STATIC_FILE
    createFile $STATIC_FILE $(replaceToken "$STATIC_STYLE_COMPONENT_TEMPLATE" $THING_NUMBER)

    # *************************************************
    #
    #   appending main.scss styles
    #
    # *************************************************

    MAIN_CSS_FILE="${STATIC_STYLES_PATH}/main.scss"
    appendContent $MAIN_CSS_FILE $(replaceToken "$STATIC_STYLE_COMPONENT_MAIN_TEMPLATE" $THING_NUMBER)
#    sed '/pattern/a some text here' filename


    # *************************************************
    #
    #   creating javascript element (optional)
    #
    # *************************************************
echo "
------------------------------------------------------------------------------------------- \n
Do you need to create a Javascript file too? Type [y] to confirm or anything else to ABORT \n
-------------------------------------------------------------------------------------------\n"
#read confirmJs
confirmJs="y"
  if [[ $confirmJs =~ ^[Yy]$ ]];then
      #Create javascript on mocks
      STATIC_FILE="${STATIC_SCRIPTS_MOCKS_PATH}/${TYPES}/${ELEMENT_NAME}.js";
      fileExist $STATIC_FILE
      echo "... Creating Javascript on ${STATIC_FILE}"
      createFile $STATIC_FILE "$STATIC_SCRIPT_TEMPLATE" $THING_NUMBER
      #Create javascript not in mocks
      STATIC_FILE="${STATIC_SCRIPTS_PATH}/${TYPES}/${ELEMENT_NAME}.js";
      fileExist $STATIC_FILE
      echo "... Creating Javascript on ${STATIC_FILE}"
      createFile $STATIC_FILE "$STATIC_SCRIPT_TEMPLATE" $THING_NUMBER
  fi
fi
    echo "NOW, LET'S START CREATING LYSSA FILES\n"
    echo "--------------------------------\n"
    echo "Creating soy file ${TYPE}: ${ABBR_TYPE}$THING_NUMBER.soy?\n"
    LYSSA_FILE="${LYSSA_FOLDER}/${TYPES}/oceania.${TYPES}.${ELEMENT_NAME}.soy";
    fileExist $LYSSA_FILE
    if [ $TYPE = 'component' ];then
      SOY_TEMPLATE=$LYSSA_COMPONENT_TEMPLATE
    fi
    if [ $TYPE = 'module' ];then
      SOY_TEMPLATE=$LYSSA_MODULE_TEMPLATE
    fi
    replaceToken "$SOY_TEMPLATE" $THING_NUMBER
    createFile $LYSSA_FILE replaceToken "$SOY_TEMPLATE" $THING_NUMBER)