#!/bin/bash

GUIDE_COUNT_PER_PAGE=50
PROJECT_STATIC_ROOT_PATH="/work/projects/oceania/redesign-oci-static"
PROJECT_LYSSA_ROOT_PATH="/work/projects/common/oci-lyssa-mocks"

STATIC_PATH="${HOME}${PROJECT_STATIC_ROOT_PATH}/src"
LYSSA_PATH="${HOME}${PROJECT_LYSSA_ROOT_PATH}"

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
    <DEFLINK>
    <DEFTITLE>
    <DEFDROPDOWN>
    <DEFIMAGE>

    <!-- cxxx -->
    <div class=\"cxxx{if \$class} {\$class}{/if}\">
      <div class=\"cxxx_header\">
        <CALLTITLE>
      </div>
      <div class=\"cxxx_body\">
        <CALLLINK>
        <CALLDROPDOWN>
        <CALLIMAGE>
      </div>
      <div class=\"cxxx_footer\">

      </div>
    </div>
{/template}"

LYSSA_MODULE_TEMPLATE="{namespace oceania.modules}

{template .mxxx}
    {@param? class: string}
    <DEFLINK>
    <DEFTITLE>
    <DEFDROPDOWN>
    <DEFIMAGE>

    <!-- mxxx -->
    <section class=\"mxxx{if \$class} {\$class}{/if}\">
      <div class=\"mxxx_header\">
        <CALLTITLE>
      </div>
      <div class=\"mxxx_body\">
        <CALLLINK>
        <CALLDROPDOWN>
        <CALLIMAGE>
      </div>
      <div class=\"mxxx_aside\">

      </div>
      <div class=\"mxxx_footer\">

      </div>
    </section>
{/template}"

STATIC_SCRIPT_TEMPLATE="import $ from \"jquery\";\n\n
export default \$(function() {});"

STATIC_STYLE_COMPONENT_TEMPLATE=".xxx{}"

STATIC_STYLE_MAIN_TEMPLATE="@import \"E/xxx\";"

# *****************************************************
#
#  Params definition and templates
#
# *****************************************************

#####  LINK ######

PARAM_TEMPLATE_LINK_DEFINITION_TOKEN="<DEFLINK>"
PARAM_TEMPLATE_LINK_DEFINITION="{@param? link: [aria: string, text: string, href: string, title: string, class: string]}"
PARAM_TEMPLATE_LINK_CALL_TOKEN="<CALLLINK>"
PARAM_TEMPLATE_LINK_CALL="{call oceania.partials.link}
          {param  link: [
              'class': \$link.class,
              'href': \$link.href,
              'title': \$link.title,
              'aria': \$link.aria,
              'text': \$link.text,
              'attrs': null
          ]/}
        {/call}"

#####  DROPDOWNS ######


PARAM_TEMPLATE_DROPDOWN_DEFINITION_TOKEN="<DEFDROPDOWN>"
PARAM_TEMPLATE_DROPDOWN_DEFINITION="{@param? dropdown: [
        class: string,
        defaultSelection: [
            text: string,
            title: string,
            aria: string,
            href: string
        ],
        options: list<[href: string, title: string, aria: string, text: string]>
    ]}"
PARAM_TEMPLATE_DROPDOWN_CALL_TOKEN="<CALLDROPDOWN>"
PARAM_TEMPLATE_DROPDOWN_CALL=" {call oceania.partials.form.dropdown}
            {param class: \$dropdown.class /}
            {param defaultSelection: [
                'text': \$dropdown.defaultSelection.text,
                'aria': \$dropdown.defaultSelection.aria,
                'title': \$dropdown.defaultSelection.title,
                'href': \$dropdown.defaultSelection.href
            ] /}
            {param options: \$dropdown.options /}
        {/call}"

#####  IMAGES ######

PARAM_TEMPLATE_IMAGE_DEFINITION_TOKEN="<DEFIMAGE>"
PARAM_TEMPLATE_IMAGE_DEFINITION="{@param? image: [desktopAlt: string, desktopSrc: string, tabletAlt: null|string, tabletSrc: null|string, mobileAlt: null|string, mobileSrc: null|string]|null}"
PARAM_TEMPLATE_IMAGE_CALL_TOKEN="<CALLIMAGE>"
PARAM_TEMPLATE_IMAGE_CALL="{call oceania.components.c16}
             {param media:'image' /}
             {param imageItem: \$image /}
         {/call}"

#####  TITLE ######

PARAM_TEMPLATE_TITLE_DEFINITION_TOKEN="<DEFTITLE>"
PARAM_TEMPLATE_TITLE_DEFINITION="{@param? title: string}
    {@param? titleHtag: string}
    {@param? titleClass: string}"
PARAM_TEMPLATE_TITLE_CALL_TOKEN="<CALLTITLE>"
PARAM_TEMPLATE_TITLE_CALL="{call oceania.partials.title}
              {param title: \$title /}
              {param titleHtag: \$titleHtag /}
              {param titleClass: \$titleClass /}
          {/call}"

# *****************************************************
#
# Helper functions
#
# *****************************************************

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

replaceToken2(){
  template=$1
  string=$2
  token=$3
  echo "${template//$token/${string}}"
}
replaceParam(){
  name=$1
  template=$2
  included=$3
  PARAM_TEMPLATE_DEFINITION="PARAM_TEMPLATE_${name}_DEFINITION"
  PARAM_TEMPLATE_DEFINITION_TOKEN="PARAM_TEMPLATE_${name}_DEFINITION_TOKEN"
  PARAM_TEMPLATE_CALL="PARAM_TEMPLATE_${name}_CALL"
  PARAM_TEMPLATE_CALL_TOKEN="PARAM_TEMPLATE_${name}_CALL_TOKEN"
  if [[ "$included" == "true" ]];then
    REPLACED_CONTENT=$(replaceToken2 "${template}" "${!PARAM_TEMPLATE_DEFINITION}" "${!PARAM_TEMPLATE_DEFINITION_TOKEN}")
    REPLACED_CONTENT=$(replaceToken2 "${REPLACED_CONTENT}" "${!PARAM_TEMPLATE_CALL}" "${!PARAM_TEMPLATE_CALL_TOKEN}")
  else
    REPLACED_CONTENT=$(replaceToken2 "${template}" "" "${!PARAM_TEMPLATE_DEFINITION_TOKEN}")
    REPLACED_CONTENT=$(replaceToken2 "${REPLACED_CONTENT}" "" "${!PARAM_TEMPLATE_CALL_TOKEN}")
  fi
#  echo "$REPLACED_CONTENT"
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
    REPLACED_CONTENT=$(replaceToken "$STATIC_STYLE_COMPONENT_TEMPLATE" $ELEMENT_ABBR)
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
    divider

    # ***************
    # REPLACE LINKS
    # ***************

    echo "------------------------------------------------------------------------------------------- \n
    Do you need to use a LINK in this ${TYPE}? [y or !@#$%]  \n
    -------------------------------------------------------------------------------------------\n"
     read confirmLink
#    confirmGuide="y"
    if [[ $confirmLink =~ ^[Yy]$ ]];then
      included="true"
    else
      included="false"
    fi
    replaceParam "LINK" "$REPLACED_CONTENT" $included

    # ***************
    # REPLACE DROPDOWN
    # ***************

    echo "------------------------------------------------------------------------------------------- \n
    Do you need to use a DROPDOWN in this ${TYPE}? [y or !@#$%]  \n
    -------------------------------------------------------------------------------------------\n"
     read confirmDrop
#    confirmGuide="y"
    if [[ $confirmDrop =~ ^[Yy]$ ]];then
      included="true"
    else
      included="false"
    fi
    replaceParam "DROPDOWN" "$REPLACED_CONTENT" $included

    # ***************
    # REPLACE IMAGE
    # ***************

    echo "------------------------------------------------------------------------------------------- \n
    Do you need to use a IMAGE in this ${TYPE}? [y or !@#$%]  \n
    -------------------------------------------------------------------------------------------\n"
     read confirmImg
#    confirmGuide="y"
    if [[ $confirmImg =~ ^[Yy]$ ]];then
      included="true"
    else
      included="false"
    fi
    replaceParam "IMAGE" "$REPLACED_CONTENT" $included

    # ***************
    # REPLACE TITLE
    # ***************

    echo "------------------------------------------------------------------------------------------- \n
    Do you need to use a TITLE in this ${TYPE}? [y or !@#$%]  \n
    -------------------------------------------------------------------------------------------\n"
     read confirmTitle
#    confirmGuide="y"
    if [[ $confirmTitle =~ ^[Yy]$ ]];then
      included="true"
    else
      included="false"
    fi
    replaceParam "TITLE" "$REPLACED_CONTENT" $included

#    echo $REPLACED_CONTENT
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

    echo "*********************   DONE  *********************"


