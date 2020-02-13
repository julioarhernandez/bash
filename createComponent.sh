#!/bin/bash

GUIDE_COUNT_PER_PAGE=50

STATIC_PATH="/Users/juliorodriguez/work/projects/oceania/redesign-oci-static/src"
LYSSA_PATH="/Users/juliorodriguez/work/projects/common/oci-lyssa-mocks"

#STATIC PATHS

STATIC_SCRIPTS_MOCKS_PATH="${STATIC_PATH}/scripts/mocks"
STATIC_SCRIPTS_PATH="${STATIC_PATH}/scripts"
STATIC_STYLES_PATH="${STATIC_PATH}/styles"


#LYSSA PATHS
LYSSA_FOLDER="${LYSSA_PATH}/static/oci/api/cms/v1/nclh-template"
LYSSA_GUIDE_PATH="${LYSSA_FOLDER}/guide"
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

    <!-- mxxx -->
    <section class=\"mxxx{if \$class} {\$class}{/if}\">

    </section>
{/template}"

STATIC_SCRIPT_TEMPLATE="import $ from \"jquery\";\n\n
export default \$(function() {});"

STATIC_STYLE_COMPONENT_TEMPLATE=".Exxx{}"

STATIC_STYLE_MAIN_TEMPLATE="@import \"E/xxx\";"


PARAM_TEMPLATE_LINK=""
PARAM_TEMPLATE_BUTTON=""
PARAM_TEMPLATE_TITLE=""
PARAM_TEMPLATE_IMAGE=""


fileExist(){
  filePath=$1
  if [ -f "$filePath" ]; then
        echo "... File ${filePath} already exist please select another compadre, \n***** MIRA QUE YO TE LO DIGO, PRESTA MAS ATENCION ***** \n"
        exit 1
    else
        echo "... Creating files ..."
    fi
}

fileExistForWriting(){
  filePath=$1
  if [ -f "$filePath" ]; then
        echo "... File ${filePath} exist."
    else
        echo "... File ${filePath} doesn't exist. Please, create this file before"
        exit 1
    fi
}

createFile(){
  filePath=$1
  content=$2
  echo "${content}" > $filePath
  echo "... Created ${filePath}"
}

appendContent(){
  filePath=$1
  content=$2
  echo "${content}" >> $filePath
}

replaceToken(){
  template=$1
  string=$2
  echo "${template//xxx/${string}}"
}
replaceElement(){
  template=$1
  string=$2
  echo ${template//E/${string}}
}

floatDivisionCeiling(){
  number1=$1
  number2=$2
  echo "if ( ${number1}%${number2} ) ${number1}/${number2}+1 else ${number1}/${number2}" | bc
}

zeroPad(){
  number=$1
  printf "%02d" $number
}

divider(){
  echo "
*----------------------------------------------------------
*----------------------------------------------------------"
}
bold=$(tput bold)
normal=$(tput sgr0)

addSuffix(){
  filename=$1
  number=$2
  zeroPadded=$(zeroPad $number)
  #remove 01 as we are not starting at 01
  if [[ $zeroPadded -eq "01" ]]
  then
    echo "oceania.guide.${filename}.soy"
  else
    echo "oceania.guide.${filename}-${zeroPadded}.soy"
  fi
}

echo "

 _                          _
| |                        | |
| |      __ _  ____ _   _  | |     _   _  ___  ___   __ _
| |     / _  ||_  /| | | | | |    | | | |/ __|/ __| / _  |
| |____| (_| | / / | |_| | | |____| |_| |\__ \\__ \| (_| |
|______|\__,_|/___| \__, | |______|\__, ||___/|___/ \__,_|
                     __/ |          __/ |
                    |___/          |___/


"
divider
echo "* What's the THING you are creating? \n* Component[c] or Module[m]?\n"
read THING_TYPE
if [[ $THING_TYPE =~ ^[cC]$ ]];then
  TYPE='component'
fi
#THING_TYPE="c"
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

divider
echo "
* What's the ${bold}${TYPE}${normal} number?\n* Just a number please, no characters:\n"
read THING_NUMBER
#THING_NUMBER="136"
ELEMENT_ABBR=${ABBR_TYPE}$THING_NUMBER
divider
echo "* Do you mean a  ${TYPE}: ${ELEMENT_ABBR}? \n
* Type [y or !@#$%]\n"

read confirm
#confirm="y"
ELEMENT_NAME=${ABBR_TYPE}$THING_NUMBER
if [[ $confirm =~ ^[Yy]$ ]];then
    divider
    echo "Ok, got it\n"
    echo "----------------------------------------\n"
    echo "Creating styles SCSS \n"

    # *************************************************
    #
    #   Creating scss
    #
    # *************************************************

    STATIC_FILE="${STATIC_STYLES_PATH}/${TYPES}/_${ELEMENT_NAME}.scss";
    fileExist $STATIC_FILE
    REPLACED_ELEMENT=$(replaceElement "$STATIC_STYLE_COMPONENT_TEMPLATE" $TYPES)
    REPLACED_CONTENT=$(replaceToken "$REPLACED_ELEMENT" $ELEMENT_ABBR)
    createFile $STATIC_FILE "$REPLACED_CONTENT"

    # *************************************************
    #
    #   appending main.scss styles
    #
    # *************************************************

    MAIN_CSS_FILE="${STATIC_STYLES_PATH}/main.scss"
    REPLACED_ELEMENT=$(replaceElement "$STATIC_STYLE_MAIN_TEMPLATE" $TYPES)
    REPLACED_CONTENT=$(replaceToken "$REPLACED_ELEMENT" $ELEMENT_ABBR)
    appendContent $MAIN_CSS_FILE "$REPLACED_CONTENT"

    # *************************************************
    #
    #   creating javascript element (optional)
    #
    # *************************************************
divider
echo "Do you need to create a Javascript file too? [y or !@#$%] \n"
read confirmJs
#confirmJs="y"
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

    # *************************************************
    #
    #   creating Lyssa Component/Module file
    #
    # *************************************************


    echo "NOW, LET'S START CREATING LYSSA FILES\n"
    echo "--------------------------------\n"
    echo "Creating soy file ${TYPE}: ${ABBR_TYPE}$THING_NUMBER.soy?\n"

    LYSSA_FILE="${LYSSA_FOLDER}/${TYPES}/oceania.${TYPES}.${ELEMENT_NAME}.soy";
    fileExist $LYSSA_FILE
    if [ $TYPE = 'component' ];then
      SOY_TEMPLATE=${LYSSA_COMPONENT_TEMPLATE}
    fi
    if [ $TYPE = 'module' ];then
      SOY_TEMPLATE=${LYSSA_MODULE_TEMPLATE}
    fi
    REPLACED_CONTENT=$(replaceToken "$SOY_TEMPLATE" $THING_NUMBER)
    createFile $LYSSA_FILE "$REPLACED_CONTENT"

    # *************************************************
    #
    #   adding to guide (optional)
    #
    # *************************************************
    echo "
    ------------------------------------------------------------------------------------------- \n
    Do you need to add the ${TYPE} to the guide? [y or !@#$%]  \n
    -------------------------------------------------------------------------------------------\n"
    read confirmGuide
#    confirmGuide="y"
    if [[ $confirmGuide =~ ^[Yy]$ ]];then
      #Build guide target file from Element Number
      GUIDE_PAGE=$(addSuffix $TYPES $(floatDivisionCeiling $THING_NUMBER $GUIDE_COUNT_PER_PAGE))
      CURRENT_GUIDE_PAGE_PATH="${LYSSA_GUIDE_PATH}/${GUIDE_PAGE}"
      fileExistForWriting $CURRENT_GUIDE_PAGE_PATH
      echo "\n... Adding ${ELEMENT_ABBR} to guide\n"
      #add component/module to guide
      TEMPLATE_GUIDE_COMPONENTS="<!-- ARTICLE BODY -->\\
                  <div class=\"guideArticle_body\">\\
                      <div class=\"guideDivider\">\\
                          <div class=\"row\">\\
                              <div class=\"col-md\">\\
                                  {call oceania.partials.ribbon}\\
                                      {param ribbon: [\\
                                        'text': '${ELEMENT_ABBR}'\\
                                      ] \/}\\
                                  {\/call}\\
                              <\/div>\\
                          <\/div>\\
                      <\/div>\\
                      <div class=\"guideBlock\">\\
                          <div class=\"row\">\\
                              <div class=\"col-md\">\\
                                  <div class=\"guideComponents\">\\
                                      {call oceania.components.${ELEMENT_ABBR}\}\\
                                          {param class: null \/}\\
                                      {\/call}\\
                                  <\/div>\\
                              <\/div>\\
                          <\/div>\\
                      <\/div>\\
                  <\/div>\\
\\
                <!-- BOTTOM DIVIDER -->"

      TEMPLATE_GUIDE_MODULES="<!-- ARTICLE BODY -->\\
                  <div class=\"guideArticle_body\">\\
                      <div class=\"guideDivider\">\\
                          <div class=\"row\">\\
                              <div class=\"col-md\">\\
                                  {call oceania.partials.ribbon}\\
                                      {param ribbon: [\\
                                        'text': '${ELEMENT_ABBR}'\\
                                      ] \/}\\
                                  {\/call}\\
                              <\/div>\\
                          <\/div>\\
                      <\/div>\\
                      <div class=\"guideBlock\">\\
                          <div class=\"row\">\\
                              <div class=\"col-md\">\\
                                  <div class=\"guideComponents\">\\
                                      {call oceania.modules.${ELEMENT_ABBR} data=\"\$${ELEMENT_ABBR}\" \/}\\
                                  <\/div>\\
                              <\/div>\\
                          <\/div>\\
                      <\/div>\\
                  <\/div>\\
\\
                <!-- BOTTOM DIVIDER -->"
       if [ $TYPE = 'component' ];then
        GUIDE_CONTENT=${TEMPLATE_GUIDE_COMPONENTS}
      fi
      if [ $TYPE = 'module' ];then
        GUIDE_CONTENT=${TEMPLATE_GUIDE_MODULES}
      fi

#      REPLACED_ELEMENT=$(replaceToken "$GUIDE_CONTENT" "$ELEMENT_ABBR")
      sed -i '' -E "s/<!-- BOTTOM DIVIDER -->/$GUIDE_CONTENT/g" $CURRENT_GUIDE_PAGE_PATH
    fi

#createFile(){
#  filePath=$1
#  content=$2
#  echo "${content}" > $filePath
#  echo "... Created ${filePath}"
#}
#replaceToken(){
#  template=$1
#  string=$2
#  echo "${template//xxx/${string}}"
#}
#
#LYSSA_COMPONENT_TEMPLATE="{namespace oceania.components}\n
#{template .cxxx}
#    {@param? class: string}
#
#<!-- cxxx -->
#<div class=\"cxxx{if \$class} {\$class}{/if}\">
#
#</div>
#{/template}"
#
#
#    SOY_TEMPLATE=${LYSSA_COMPONENT_TEMPLATE}
#    REPLACED_CONTENT=$(replaceToken "${SOY_TEMPLATE}" "136")
#    echo "${REPLACED_CONTENT}"
#    rm -f "/Users/juliorodriguez/work/projects/common/oci-lyssa-mocks/static/oci/api/cms/v1/nclh-template/components/oceania.components.c136.soy"
#    createFile "/Users/juliorodriguez/work/projects/common/oci-lyssa-mocks/static/oci/api/cms/v1/nclh-template/components/oceania.components.c136.soy" "${REPLACED_CONTENT}"
#
#
#
