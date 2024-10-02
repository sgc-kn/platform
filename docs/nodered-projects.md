### NodeRed Conventions

- Our instances are named `nr-*.upd-kn.de`. By convention we replace `*` with the name of the dataspace we feed data into. E.g. `nr-mobidata` for dataspace `mobidata`.
- We have a couple of development instances `nr-nodered[0-9]` which we use for development before a flow is deployed to a regularly named instance. These development instances have their own dataspaces following the above naming scheme.
- The flows can access the instance name and dataspace through environment variables.

### NodeRed Project Conventions

- There is one NodeRed project per target dataspace. We call this project `nr-flows-*`. E.g. `nr-flows-mobidata` for the `mobidata` dataspace.
- We track the project in git repositories, one repository per project.
- The repositories are named after their projects.
- The repositories are currently hosted on Github. E.g. https://github.com/sgc-kn/nr-flows-mobidata for the `mobidata` dataspace.
- We intend to run the `nr-flows-XYZ` project on the NodeRed instance `nr-XYZ`. Development may happen elsewhere, in particular on `nr-nodered[0-9]`.
- We encrypt the credentials (`flows_cred.json`). We generate long shared keys (256 bit) and store them in the shared password manager under `Nodered Credentials/nr-flows-XYZ`.

![image](https://github.com/user-attachments/assets/41046938-8e61-4ce9-aa19-c7450159eda0)

### NodeRed Instance Settings

- We set the git username to the nodered instance url. E.g. `nr-nodered3.udp-kn.de`. 
- We set the git email to `datenplattform@konstanz.de`.

![image](https://github.com/user-attachments/assets/dcbfd613-2d2d-468e-9999-2e1c6c336087)

### SSH Keys

- We create one SSH key per project/instance combination.
- We add the SSH keys as deploy keys to the project's GitHub repository.
- On the NodeRed instance, we name the (private) SSH keys after the project.
- On the Github repository, we name the (public) SSH keys after the nodered instance.

![image](https://github.com/user-attachments/assets/4dd98cce-7d91-41b8-aaff-cea56aa70599)

### Platform repo integration

- We add the project repository as submodule of the platform repository.
- We use dependabot to track project repository updates in the platform repository.
- Dependabot currently watches all submodules at directories matching `/integrations/**/nodered`.
