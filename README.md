# Steps

- Clone the repo
`$ git clone https://github.com/julioarhernandez/bash.git`

- Copy local cloned files to /usr/local/bin
`$ cp . -rf /usr/local/bin/`

- Run bash script
`$ sh createComponent.sh`


## Troubleshooting and customizations

##### Folder paths

Make sure this is the folder structure you have in your local repository:

`static - /work/projects/oceania/redesign-oci-static`
`lyssa - /work/projects/common/oci-lyssa-mocks`

If this is not your folder structure you can edit in createComponent.sh the variables:

`PROJECT_STATIC_ROOT_PATH`
`PROJECT_LYSSA_ROOT_PATH`


------------



##### Guide pagination

If your guide pages are not **by default** paginated at 50 per page you can change that in variable name:

`GUIDE_COUNT_PER_PAGE`


------------



##### Execution permission
In case it fails remember to add execution permission to the **createComponent.sh** script.
`chmod +x script.sh`


------------


##### Customize component content
In the **component** folder you can find the files used as template. 